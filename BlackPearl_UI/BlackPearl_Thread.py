# File:		BlackPearl_Thread.py
# Author: 	Lei Kuang
# Date:		8th August 2020
# @ Imperial College London

# ----------------------------------------------------------------
# System Import
# ----------------------------------------------------------------
from PyQt5.QtCore import pyqtSignal, QThread
import numpy as np
import time
import os
import cv2
import matplotlib.pyplot as plt
import threading

# ----------------------------------------------------------------
# FT601
# ----------------------------------------------------------------
import _ftd3xx_win32 as _ft
import ftd3xx
from ftd3xx_defines import *
from ctypes import *

# ----------------------------------------------------------------
# BlackPearl
# ----------------------------------------------------------------
from BlackPearl_Func import *
from BlackPearl_Chip import *

class Readout(QThread):
    done_s   = pyqtSignal(str)
    
    offset_en  = False
    offset_clr = False
    
    data_size = SIZE_PROFILE['10 MHz']

    def __init__(self, serial, plot, parent=None):
        super(Readout, self).__init__(parent)
        self.serial_obj = serial
        self.plot_obj   = plot
        self.plot_busy  = False

    def run(self):
        # Reset readout system -------------------------------------------------------------------------------------------------
        self.serial_obj.execute_cmd("set_nrst 0")
        time.sleep(0.5)
        self.serial_obj.execute_cmd("set_nrst 1")
        time.sleep(0.5)

        # Power on chip --------------------------------------------------------------------------------------------------------
        self.serial_obj.execute_cmd("set_vdd2_en 1")
        time.sleep(0.5)
        self.serial_obj.execute_cmd("set_vdd1_en 1")
        self.serial_obj.execute_cmd("set_avdd_en 1")
        time.sleep(2)
        #self.serial_obj.execute_cmd("power_on")
        
        # FT601Q ---------------------------------------------------------------------------------------------------------------
        # - Check connected devices
        numDevices = ftd3xx.createDeviceInfoList()
        if(numDevices==0):
            print("FT601 not connected !")
            return
        # - Open the first device (index 0)
        self.usb_obj = ftd3xx.create(0, _ft.FT_OPEN_BY_INDEX)
        self.usb_obj.setPipeTimeout(0x82, 0)
        # - Set stream pipe
        self.usb_obj.setStreamPipe(0x82, self.data_size)

        # Main Loop ------------------------------------------------------------------------------------------------------------
        # - init
        self.offset = np.zeros((128, 128))
        self.av_list = []
        self.px_list = []

        self.run = True
        while(self.run):
            data = self.usb_obj.readPipeEx(0x82, self.data_size, raw=True)
            print('%.16f' % time.time())
            num = data['bytesTransferred']
            data = data['bytes']
            #print(num, data[0], data[-1])
            threading.Thread(target=self.save_and_plot, args=(data, )).start()

        self.usb_obj.close()
        
        #self.serial_obj.execute_cmd("power_off")
        # ----------------------------------------------------------------------------------------------------------------------
        self.done_s.emit(self.file_path)

    def save_and_plot(self, data):
        data = np.frombuffer(data, dtype=np.uint8)
        
        # Save -----------------------------------------------------------------------------------------------------------------
        if(self.save):
            data.astype('uint8').tofile(self.file_path + '\F_%s.bin' % get_date_time(2))

        # Visualization --------------------------------------------------------------------------------------------------------
        if(self.plot_busy!=True):
            self.plot_busy = True
            
            data = data[0:128*128]
            data = np.array(data).astype('uint8')
            
            # - Transpose due to column readout
            img = np.array(data).reshape(128, 128).transpose()
            self.av_list.append(np.average(data))
            self.px_list.append(data[self.col*127 + self.row]) # Col & Row for picking pixels from the data stream
            
            # - Processing
            if(self.offset_en):
                self.offset_en = False
                self.offset = img - 128
            if(self.offset_clr):
                self.offset_clr = False
                self.offset = np.zeros((128, 128))

            # - Draw
            self.plot_obj.plot_3d(img - self.offset)
            self.plot_obj.plot_2d(img)
            self.plot_obj.plot_1d_av(self.av_list)
            self.plot_obj.plot_1d_px(self.px_list)
            self.plot_obj.drawnow()
            # End --------------------------------------------------------------------------------------------------------------
            self.plot_busy = False
        
    def pixel(self, row, col):
        self.row = row
        self.col = col

    def stop(self):
        self.run = False
        
    def config(self, file_path,  save):
        self.file_path = file_path
        self.save = save

class Concatenation(QThread):
    status_s    = None
    update_s    = pyqtSignal(int)
    msgbox_s    = None
    done_s      = pyqtSignal(bool)

    file_path   = None
    file_list   = None
    
    def __init__(self, parent=None):
        super(Concatenation, self).__init__(parent)

    def run(self):
        # Init
        file_len  = len(self.file_list)
        
        cnt_1KB = 0
        cnt_1GB = 0

        # Write
        fw = open(self.file_path + '/' + 'all_%s.bin' % cnt_1GB, 'ab')
        
        # Read
        for n in range(0, file_len):
            # - Read file and delete
            id = self.file_path + '/' + self.file_list[n]
            fr = open(id, 'rb')
            data = fr.read()
            fr.close()
            os. remove(id)
            # - Append
            fw.write(data)
            
            # - Create new file every 1GB
            cnt_1KB = cnt_1KB + (len(data) >> 10)
            
            print(len(data), len(data)>>10, cnt_1KB, )
            
            if(cnt_1KB==1024*1024):
                cnt_1KB = 0
                cnt_1GB = cnt_1GB + 1
                fw.close()
                fw = open(self.file_path + '/' + 'all_%s.bin' % cnt_1GB, 'ab')
            # - Update progress bar
            self.update_s.emit(int(n*100/(file_len-1)))
        fw.close()
        
    def config(self, file_path,  file_list):
        self.file_path = file_path
        self.file_list = file_list

class Replay(QThread):
    update_s = pyqtSignal(int)
    done_s   = pyqtSignal(bool)

    def __init__(self, plot, parent=None):
        super(Replay, self).__init__(parent)
        self.plot_obj   = plot

    def run(self):
        # Init
        self.av_list = []
        self.px_list = []
        self.run = True
        
        star_size = (self.frame_start-1) * 16 * 1024
        read_size = self.frame_step * 16 * 1024 # 16KB

        end_size  = (self.frame_end - self.frame_start) * 16 * 1024
        left_size = end_size
        
        write_size = 0
        
        # Extract
        if(self.frame_ext):
            folder_path = os.path.dirname(self.file_path)
            try:
                fw = open(folder_path + '/extract/' + 'MATLAB_%s.bin' % get_date_time(), 'ab')
            except:
                os.mkdir(folder_path + '/extract/')
                fw = open(folder_path + '/extract/' + 'MATLAB_%s.bin' % get_date_time(), 'ab')
                
        if(self.frame_mp4):
            frame_list = []

        for file_name in self.file_list:
            # Get size
            file_path = self.file_path + '/' + file_name
            file_size = os.path.getsize(file_path)

            '''print("File Size %d" % file_size)
            print("Star Size %d" % star_size)
            print("Read Size %d" % read_size)'''
            
            # Check if next file
            if(file_size < star_size):
                star_size = star_size - file_size
                continue
                
            # Read file
            fr = open(file_path, 'rb')
            # - Start Index
            if(star_size!=0):
                fr.read(star_size)
                file_size = file_size - star_size
                star_size = 0
            
            while(file_size >= read_size):
                if(not self.run):
                    break

                data = fr.read(read_size)
                file_size = file_size - read_size
                left_size  = left_size - read_size
                
                if(self.frame_ext):
                    fw.write(data[0:128*128])
                    write_size = write_size + 16384
                elif(self.frame_mp4):
                    data  = data[0:128*128]
                    frame = np.frombuffer(data, dtype=np.uint8)
                    frame = frame.reshape(128, 128)
                    
                    #cmap = plt.get_cmap('gist_rainbow')
                    cmap = plt.get_cmap('gist_gray')
                    frame = plt.cm.ScalarMappable(cmap=cmap).to_rgba(frame)[:, :, 2::-1] 
                    frame = (frame*255).astype(np.uint8)
                    frame_list.append(frame)
                    
                else:
                    self.replay(data)
 
                if(left_size <=0):
                    break
            
                # Update progress
                pro = 1 - left_size / end_size
                self.update_s.emit(100 if pro > 1 else int(pro*100))
                    
            if(left_size <=0):
                break

        if(self.frame_ext):
            fw.close()
        if(self.frame_mp4):
            folder_path = os.path.dirname(self.file_path)  + '/mp4'
            try:
                os.mkdir(folder_path)
            except:
                pass

            mp4 = cv2.VideoWriter(folder_path + '/%s.mp4' % get_date_time(),
                                       cv2.VideoWriter_fourcc(*'MP4V'),
                                       60, 
                                       (128, 128))

            for frame in frame_list:
                mp4.write(frame)
            mp4.release()
            
            os.startfile(folder_path)
            
        self.update_s.emit(100)
        self.done_s.emit(True)
        
    def replay(self, data):

        data = data[0:128*128]
        data = np.frombuffer(data, dtype=np.uint8)

        # - Transpose due to column readout
        img = np.array(data).reshape(128, 128).transpose()
        self.av_list.append(np.average(data))
        self.px_list.append(data[self.col*127 + self.row]) # Col & Row for picking pixels from the data stream
        
        # - Draw
        self.plot_obj.plot_3d(img)
        self.plot_obj.plot_2d(img)
        self.plot_obj.plot_1d_av(self.av_list)
        self.plot_obj.plot_1d_px(self.px_list)
        self.plot_obj.drawnow()

    def pixel(self, row, col):
        self.row = row
        self.col = col

    def stop(self):
        self.run = False
        
    def config(self, file_path,  file_list, frame_start, frame_end, frame_step,  frame_ext, frame_mp4):
        self.file_path   = file_path
        self.file_list   = file_list
        self.frame_start = frame_start
        self.frame_end   = frame_end
        self.frame_step  = frame_step
        self.frame_ext   = frame_ext
        self.frame_mp4   = frame_mp4
