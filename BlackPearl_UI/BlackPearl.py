# File:		BlackPearl.py
# Author: 	Lei Kuang
# Date:		25th August 2020
# @ Imperial College London

# ----------------------------------------------------------------
# UI Import
# ----------------------------------------------------------------
# Essential
from Ui_BlackPearl import Ui_MainWindow
from PyQt5.QtWidgets    import QMainWindow, QApplication
from PyQt5.QtCore       import pyqtSlot, pyqtSignal
from PyQt5.QtWidgets    import QMessageBox, QFileDialog, QCompleter
#from PyQt5.QtWidgets    import QInputDialog, QLineEdit
from PyQt5.QtGui        import QTextCursor

# ----------------------------------------------------------------
# System Import
# ----------------------------------------------------------------
import os

# ----------------------------------------------------------------
# User Import
# ----------------------------------------------------------------
from BlackPearl_Cmd import *
from BlackPearl_Plot import *
from BlackPearl_Chip import *
from BlackPearl_Func import *
from BlackPearl_Thread import *

class BlackPearl_Dialog(QMainWindow, Ui_MainWindow):
    # Signal
    serial_status   = pyqtSignal(bool)
    console_s       = pyqtSignal(str)
    msgbox_error_s  = pyqtSignal(str)
    msgbox_info_s   = pyqtSignal(str)
    
    # Variable
    serial_obj      = None                   # Instance of Serial
    serial_name     = [None, 'Refresh']      # List of serial com port
    serial_port     = None

    def __init__(self, parent=None):
        super(BlackPearl_Dialog, self).__init__(parent)
        self.setupUi(self)
        
        # UI ------------------------------------------------------------------------------------------------------------------
        self.plot_obj = BlackPearl_Plot()
        self.plot_obj.show()
        
        self.ui_set_color_green(self.rt_readout_pushButton)
        self.ui_set_color_green(self.rt_offset_pushButton)
        self.ui_set_color_green(self.replay_pushButton)
        

        # Shared System signals ------------------------------------------------------------------------------------------------
        self.serial_status  .connect(self.ui_set_serial_status)
        self.console_s      .connect(self.ui_print)
        self.msgbox_error_s .connect(self.ui_send_error)
        self.msgbox_info_s  .connect(self.ui_send_info)
        
        # Auto complete user command -------------------------------------------------------------------------------------------
        self.user_cmd_lineEdit.setCompleter(QCompleter(command_list, self.user_cmd_lineEdit))
        
        # Serial ---------------------------------------------------------------------------------------------------------------
        self.serial_obj           = Debug_Command()
        self.serial_obj.status_s  = self.serial_status
        self.serial_obj.console_s = self.console_s
        self.serial_obj.msgbox_s  = self.msgbox_error_s
        
        # ---------------------------------------------------------------------------------------------------------------READOUT
        # Readout --------------------------------------------------------------------------------------------------------------
        self.readout_rt = Readout(self.serial_obj, self.plot_obj)
        self.readout_rt.done_s.connect(self.rt_readout_done)
        
        # Concatenation --------------------------------------------------------------------------------------------------------
        self.concatenation_t = Concatenation()
        self.concatenation_t.update_s.connect(self.console_set_progress)
        
        # Replay ---------------------------------------------------------------------------------------------------------------
        self.replay_t = Replay(self.plot_obj)
        self.replay_t.update_s.connect(self.console_set_progress)
        self.replay_t.done_s.connect(self.replay_done)
        
        # Init -----------------------------------------------------------------------------------------------------------------
        #self.on_serial_port_comboBox_activated(1) # Refresh serial port
        #self.on_serial_port_comboBox_activated(0) # Connect first serial port
        # Thread
        self.readout_rt.pixel(63, 63)
        self.replay_t.pixel(63, 63)

    def closeEvent(self, event):
        if(not self.ui_send_question('Are you sure to quit ?')):
            event.ignore()
        else:
            self.serial_obj.close_serial()
            
    # ==========================================================================================================================
    # UI - System I/O
    # ==========================================================================================================================
    # Read User input, accept --------------------------------------------------------------------------------------------------
    # - 1) Dec: '123'
    # - 2) Hex: '0xFF'
    # - 3) Bin: '0b100'
    def str2num(self, str):
        try:
            return int(str, 0)
        except:
            self.ui_send_error("Invalid Input: %s" % str)
            raise ValueError
    
    # Set the color of ui items such as pushbutton -----------------------------------------------------------------------------
    def ui_set_color_red(self, ui_obj):
        ui_obj.setStyleSheet("background-color: #FF0000")
    
    def ui_set_color_green(self, ui_obj):
        ui_obj.setStyleSheet("background-color: #00FF00")
        
    def ui_set_color_gray(self, ui_obj):
        ui_obj.setStyleSheet("background-color: #E1E1E1")
    
    # UI status ----------------------------------------------------------------------------------------------------------------
    # - True: Busy
    # - False: Idle
    def ui_set_serial_status(self, status):
        self.serial_status_title_label.setText('Busy' if status else 'Idle')
        self.ui_set_color_red(self.serial_status_title_label) if status else \
        self.ui_set_color_green(self.serial_status_title_label)

    def ui_get_serial_status(self):
        return False if self.serial_status_title_label.text()=='Idle' else True

    # UI message box -----------------------------------------------------------------------------------------------------------
    def ui_send_question(self, msg):
        box = QMessageBox()
        box.setStyleSheet('QMessageBox {font: 9pt "Consolas"}')
        return (QMessageBox.question(box, "Question", msg, QMessageBox.Yes | QMessageBox.No) == QMessageBox.Yes)

    def ui_send_error(self, msg):
        box = QMessageBox()
        box.setStyleSheet('QMessageBox {font: 9pt "Consolas"}')
        QMessageBox.critical(box, "Error", msg, QMessageBox.Ok)

    def ui_send_warning(self, msg):
        box = QMessageBox()
        box.setStyleSheet('QMessageBox {font: 9pt "Consolas"}')
        QMessageBox.warning(box, "Warning", msg, QMessageBox.Ok)
        
    def ui_send_info(self, msg):
        box = QMessageBox()
        box.setStyleSheet('QMessageBox {font: 9pt "Consolas"}')
        QMessageBox.information(box, "Information", msg, QMessageBox.Ok)
    
    # UI file dialog -----------------------------------------------------------------------------------------------------------
    def ui_select_file(self, path_init='C:/'):
        return QFileDialog.getOpenFileName(self, "Select File", path_init)
        
    def ui_select_folder(self, path_init='C:/'):
        return QFileDialog.getExistingDirectory(self, "Select Folder", path_init)
        
    # ==========================================================================================================================
    # UI - File and Folder
    # ==========================================================================================================================
    # List files and folders under the folder path -----------------------------------------------------------------------------------
    def list_folder(self, folder_path):
        try:
            folder_list = os.listdir(folder_path)
        except:
            self.ui_send_error("Invalid folder path !")
            raise SystemError
        return folder_list
    
    # Check folder existence and create ----------------------------------------------------------------------------------------------
    def create_folder_if_not_existed(self, folder_path, folder_name, ask = False):
        try:
            folder_list = self.list_folder(folder_path)
        except:
            if(self.ui_send_question("Would you like to create folder %s ?" % folder_path)):
                try:
                    os.mkdir(folder_path)
                    folder_list = self.list_folder(folder_path)
                except:
                    self.ui_send_error("Invalid path for folder creation'%s'" % folder_path)
                    raise IOError
            else:
                raise IOError
                
        if(folder_name in folder_list):
            if(ask):
                if(not self.ui_send_question("Folder '%s' already existed !\nAre you sure to overwrite ?" % folder_name)):
                    raise SystemError
        else:
            try:
                os.mkdir(folder_path + '/' + folder_name)
            except:
                self.ui_send_error("Invalid folder name: %s\nMust not contain space and \\ / : * ? \" < > |" % folder_name)
                raise IOError
    
    # Experiment folder --------------------------------------------------------------------------------------------------------
    def get_exp_folder_name(self):
        chip_id     = self.rt_chip_id_spinBox.value()
        exp_id      = self.rt_exp_id_spinBox.value()
        chip_freq   = self.chip_frequency_comboBox.currentText().replace(' ',  '')
        user_com    = self.rt_user_com_lineEdit.text()
        
        folder_name = 'D%s_C%s_E%s_F%s' % (get_date(), str(chip_id).zfill(2), str(exp_id).zfill(2), str(chip_freq).zfill(6))
        if(user_com!=''):
            for n in range(len(user_com)):
                chr = user_com[n]
                if(not (chr.isdigit() or chr.isalpha() or chr=='_')):
                    self.send_error("Only alphabet, digital and underscore are allowed for user comment !")
                    raise SystemError
            folder_name = folder_name + '_U_' + user_com
        return folder_name
        
    # ==========================================================================================================================
    # UI Frame - Console 
    # ==========================================================================================================================
    def ui_print(self, msg):
        self.console_textEdit.moveCursor(QTextCursor.End)
        self.console_textEdit.insertPlainText(msg)
        self.console_textEdit.moveCursor(QTextCursor.End)

    def console_set_progress(self, value):
        self.console_progressBar.setValue(value)
        
    @pyqtSlot()
    def on_console_clear_pushButton_clicked(self):
        self.console_textEdit.clear()
        
    @pyqtSlot()
    def on_user_cmd_pushButton_clicked(self):
        try:
            user_cmd = self.user_cmd_lineEdit.text()
            self.user_cmd_lineEdit.clear()
            self.ui_print(">> %s\n" % user_cmd)
            self.serial_obj.execute_cmd(user_cmd)
        except:
            pass
            
    # ==========================================================================================================================
    # UI Frame - System 
    # ==========================================================================================================================

    @pyqtSlot(int)
    def on_serial_port_comboBox_activated(self, index):
        if(self.serial_obj.is_connected()):
            self.serial_obj.close_serial()
        
        if(len(self.serial_name)==index+1):
            # Scan serial port
            (self.serial_name, self.serial_port) = self.serial_obj.list_serial()
            self.serial_name.append('Refresh')
            self.serial_port_comboBox.clear()
            self.serial_port_comboBox.addItems(self.serial_name)
            self.serial_port_comboBox.setCurrentIndex(len(self.serial_name)-1)
        else:
            self.serial_obj.open_serial(self.serial_port[index])
            self.serial_obj.clear()
            if(not self.serial_obj.execute_cmd('get_version')):
                ui.send_error('Error: Invalid Serial Port')
                self.serial_port_comboBox.setCurrentIndex(len(self.serial_name)-1)
            else:
                self.serial_port_comboBox.setCurrentIndex(index)
                freq_index = self.serial_obj.execute_cmd('get_freq_index')
                self.chip_frequency_comboBox.setCurrentIndex(freq_index)
                delay = self.serial_obj.execute_cmd('get_delay')
                self.chip_delay_spinBox.setValue(delay)

    # ==========================================================================================================================
    # UI Frame - Chip Profile
    # ==========================================================================================================================
    def update_dac_ui(self, config):
        [rst, y, iv, ota, int] = config
        self.dac_rst_spinBox.setValue(rst)
        self.dac_y_spinBox.setValue(y)
        self.dac_iv_spinBox.setValue(iv)
        self.dac_ota_spinBox.setValue(ota)
        self.dac_int_spinBox.setValue(int)
    
    @pyqtSlot(int)
    def on_chip_id_comboBox_activated(self, index):
        chip_id    = index
        chip_freq  = self.chip_frequency_comboBox.currentText()
        self.rt_chip_id_spinBox.setValue(chip_id)
        
        dac_config = DAC_PROFILE[chip_id][chip_freq]
        self.update_dac_ui(dac_config)
        
    @pyqtSlot(int)
    def on_chip_frequency_comboBox_currentIndexChanged(self, index):
        chip_id    = self.chip_id_comboBox.currentIndex()
        chip_freq  = self.chip_frequency_comboBox.currentText()
        
        dac_config = DAC_PROFILE[chip_id][chip_freq]
        self.update_dac_ui(dac_config)
        
        delay = DELAY_PROFILE[chip_freq]
        self.chip_delay_spinBox.setValue(delay)
        
        self.serial_obj.execute_cmd('set_freq_index %s' % index)
        self.readout_rt.data_size = SIZE_PROFILE[chip_freq]

    @pyqtSlot(int)
    def on_chip_delay_spinBox_valueChanged(self, p0):
        self.serial_obj.execute_cmd("set_delay %s" % p0)
        
    @pyqtSlot()
    def on_dac_reset_pushButton_clicked(self):
        chip_id    = self.chip_id_comboBox.currentIndex()
        chip_freq  = self.chip_frequency_comboBox.currentText()
        
        dac_config = DAC_PROFILE[chip_id][chip_freq]
        self.update_dac_ui(dac_config)
        
    @pyqtSlot()
    def on_dac_read_pushButton_clicked(self):
        vol = self.serial_obj.execute_cmd("get_dac_rst")
        self.dac_rst_spinBox.setValue(vol)
        vol = self.serial_obj.execute_cmd("get_dac_y")
        self.dac_y_spinBox.setValue(vol)
        vol = self.serial_obj.execute_cmd("get_dac_iv")
        self.dac_iv_spinBox.setValue(vol)
        vol = self.serial_obj.execute_cmd("get_dac_ota")
        self.dac_ota_spinBox.setValue(vol)
        vol = self.serial_obj.execute_cmd("get_dac_int")
        self.dac_int_spinBox.setValue(vol)
        
    @pyqtSlot()
    def on_dac_write_pushButton_clicked(self):
        vol = self.dac_rst_spinBox.value()
        self.serial_obj.execute_cmd("set_dac_rst %d" % vol)
        
        vol = self.dac_y_spinBox.value()
        self.serial_obj.execute_cmd("set_dac_y %d" % vol)
        
        vol = self.dac_iv_spinBox.value()
        self.serial_obj.execute_cmd("set_dac_iv %d" % vol)
        
        vol = self.dac_ota_spinBox.value()
        self.serial_obj.execute_cmd("set_dac_ota %d" % vol)
        
        vol = self.dac_int_spinBox.value()
        self.serial_obj.execute_cmd("set_dac_int %d" % vol)

    # ==========================================================================================================================
    # UI Frame - Real-time Frame Acquisition
    # ==========================================================================================================================  
    @pyqtSlot()
    def on_rt_path_toolButton_clicked(self):
        init_path   = self.rt_path_lineEdit.text()
        folder_path = self.ui_select_folder(init_path)
        self.rt_path_lineEdit.setText(folder_path if folder_path else init_path)
    
    def rt_readout_done(self, file_path):
        # Reset readout system
        self.serial_obj.execute_cmd("set_nrst 0")
        time.sleep(0.5)
        self.serial_obj.execute_cmd("set_nrst 1")
        time.sleep(0.5)
        # Power off chip
        #self.serial_obj.execute_cmd("set_avdd_en 0")
        #self.serial_obj.execute_cmd("set_vdd1_en 0")
        #time.sleep(0.5)
        #self.serial_obj.execute_cmd("set_vdd2_en 0")

        # Update UI
        #self.ui_send_info("End of Readout")
        self.rt_readout_pushButton.setText('Readout')
        self.ui_set_color_green(self.rt_readout_pushButton)
        self.concatenation_path_lineEdit.setText(file_path)
        self.replay_path_lineEdit.setText(file_path)

    @pyqtSlot()
    def on_rt_readout_pushButton_clicked(self):
        try:
            if(self.rt_readout_pushButton.text()=='Readout'):
                # Check if save files
                save = self.rt_save_checkBox.isChecked()
                # Get configuration
                if(save):
                    # Check if experiment folder exists
                    folder_path = self.rt_path_lineEdit.text()
                    folder_name = self.get_exp_folder_name()
                    self.create_folder_if_not_existed(folder_path, folder_name, ask=True)
                    # Folder path for readout files
                    file_path   = folder_path + '/' + folder_name
                # Configure readout thread and start
                self.readout_rt.config(file_path if save else None, save)
                self.readout_rt.start()
                
                self.rt_readout_pushButton.setText('Running')
                self.ui_set_color_red(self.rt_readout_pushButton)
            else:
                if(self.ui_send_question('Are you sure to stop Readout ?')):
                    self.readout_rt.stop()
        except:
            pass
            
    @pyqtSlot(bool)  
    def on_rt_debug_checkBox_clicked(self, checked):
        self.serial_obj.execute_cmd('set_mode %s' % (1 if checked else 0))
        
    @pyqtSlot()
    def on_rt_offset_pushButton_clicked(self):
        if(self.rt_offset_pushButton.text()=='Offset'):
            self.ui_set_color_red(self.rt_offset_pushButton)
            self.rt_offset_pushButton.setText('Raw')
            self.readout_rt.offset_en = True
        else:
            self.ui_set_color_green(self.rt_offset_pushButton)
            self.rt_offset_pushButton.setText('Offset')
            self.readout_rt.offset_clr = True
            
    @pyqtSlot(int)
    def on_rt_row_spinBox_valueChanged(self, p0):
        row = p0
        col = self.rt_col_spinBox.value()
        self.readout_rt.pixel(row, col)
        self.replay_t.pixel(row, col)
        
    @pyqtSlot(int)
    def on_rt_col_spinBox_valueChanged(self, p0):
        col = p0
        row = self.rt_row_spinBox.value()
        self.readout_rt.pixel(row, col)
        self.replay_t.pixel(row, col)
        
    
    @pyqtSlot()
    def on_rt_off_pushButton_clicked(self):
        # Power off chip
        self.serial_obj.execute_cmd("set_avdd_en 0")
        self.serial_obj.execute_cmd("set_vdd1_en 0")
        time.sleep(0.1)
        self.serial_obj.execute_cmd("set_vdd2_en 0")
        
    # ==========================================================================================================================
    # UI Frame - Processing
    # ==========================================================================================================================  
    @pyqtSlot()
    def on_concatenation_path_toolButton_clicked(self):
        init_path   = self.concatenation_path_lineEdit.text()
        folder_path = self.ui_select_folder(init_path)
        self.concatenation_path_lineEdit.setText(folder_path if folder_path else init_path)
        
    @pyqtSlot()
    def on_concatenation_pushButton_clicked(self):
        file_path = self.concatenation_path_lineEdit.text()
        file_list = self.list_folder(file_path)
        file_len  = len(file_list)
        # Check length
        if(file_len==0):
            self.ui_send_error('No files found')
            return
        # Check valid
        for file in file_list:
            if(file[-4:]!='.bin'):
                self.ui_send_error('Invalid file found')
                return
        # Check if all.bin
        if('all' in file_list[0]):
            self.ui_send_error('Concatenation has been done')
            return
        # Start thread
        self.concatenation_t.config(file_path, file_list)
        self.concatenation_t.start()

    # Replay -------------------------------------------------------------------------------------------------------------------
    @pyqtSlot()
    def on_replay_path_toolButton_clicked(self):
        init_path   = self.replay_path_lineEdit.text()
        folder_path = self.ui_select_folder(init_path)
        if(folder_path):
            self.replay_path_lineEdit.setText(folder_path)
            self.replay_file_list = None
            self.replay_frame_len = None
        
    @pyqtSlot()
    def on_replay_start_lineEdit_editingFinished(self):
        val = self.str2num(self.replay_start_lineEdit.text())
        self.replay_start_horizontalSlider.setValue(val)
            
    @pyqtSlot()
    def on_replay_end_lineEdit_editingFinished(self):
        val = self.str2num(self.replay_end_lineEdit.text())
        self.replay_end_horizontalSlider.setValue(val)
        
    @pyqtSlot()
    def on_replay_step_lineEdit_editingFinished(self):
        val = self.str2num(self.replay_step_lineEdit.text())
        self.replay_step_horizontalSlider.setValue(val)
            
    @pyqtSlot(int)
    def on_replay_start_horizontalSlider_valueChanged(self, value):
        end_value = self.replay_end_horizontalSlider.value()
        if(value > end_value):
            self.ui_send_error('Invalid file range ! Start > End')
            self.replay_start_horizontalSlider.setValue(end_value)
            self.replay_start_lineEdit.setText('%d' % end_value)
        else:
            self.replay_start_lineEdit.setText('%d' % value)
            
    @pyqtSlot(int)
    def on_replay_end_horizontalSlider_valueChanged(self, value):
        start_value = self.replay_start_horizontalSlider.value()
        if(value < start_value):
            self.ui_send_error('Invalid file range ! End < Start')
            self.replay_end_horizontalSlider.setValue(start_value)
            self.replay_end_lineEdit.setText('%d' % start_value)
        else:
            self.replay_end_lineEdit.setText('%d' % value)

    @pyqtSlot(int)
    def on_replay_step_horizontalSlider_valueChanged(self, value):
        self.replay_step_lineEdit.setText('%d' % value)
    
    replay_file_list = None
    @pyqtSlot()
    def on_replay_check_pushButton_clicked(self):
        # Init
        self.replay_file_list = None
        # Get file path
        file_path = self.replay_path_lineEdit.text()
        file_list = self.list_folder(file_path)
        # Check if binary data are available and have been concatenated
        cnt_KB = 0
        for file_name in file_list:
            if('.bin' not in file_name):
                self.ui_send_error("No binary files found !")
                return
            elif('all' not in file_name):
                self.ui_send_error("You must concatenate files first !")
                return
            size_KB = os.path.getsize(file_path + '/' + file_name) >> 10
            cnt_KB = cnt_KB + size_KB
        # Check if valid
        # - each frame is 16KB
        if(cnt_KB % 16 !=0 ):
            self.ui_send_error("Invalid data format !")
            return
        frame_len = cnt_KB >> 4
        # Update UI
        self.replay_start_horizontalSlider.setMaximum(frame_len)
        self.replay_start_horizontalSlider.setValue(1)
        self.replay_end_horizontalSlider.setMaximum(frame_len)
        self.replay_end_horizontalSlider.setValue(frame_len)
        self.ui_send_info("%d valid frames found !" % frame_len)
        # End
        self.replay_file_list = file_list
        self.replay_pushButton.setText('Replay')

    def replay_done(self, info):
        #self.ui_send_info('End of Replay')
        checked = self.replay_extract_checkBox.isChecked()
        self.replay_pushButton.setText('Extract' if checked else 'Replay')
        self.ui_set_color_green(self.replay_pushButton)
        
    @pyqtSlot()
    def on_replay_pushButton_clicked(self):
        if(self.replay_pushButton.text()!='Stop'):
            # Check if frames available
            if(self.replay_file_list==None):
                self.ui_send_error("You must check available frames first !")
                return
            # Get configuration
            file_path   = self.replay_path_lineEdit.text()
            frame_start = self.replay_start_horizontalSlider.value()
            frame_end   = self.replay_end_horizontalSlider.value()
            frame_step  = self.str2num(self.replay_step_lineEdit.text())
            frame_ext   = self.replay_extract_checkBox.isChecked()
            frame_mp4   = self.replay_render_checkBox.isChecked()
            # Start thread
            self.replay_t.config(file_path, self.replay_file_list, frame_start, frame_end, frame_step, frame_ext,  frame_mp4)
            self.replay_t.start()
            # Update UI
            self.replay_pushButton.setText('Stop')
            self.ui_set_color_red(self.replay_pushButton)
        else:
            self.replay_t.stop()
            
    @pyqtSlot(bool)
    def on_replay_extract_checkBox_clicked(self, checked):
        self.replay_render_checkBox.setCheckState(False)
        self.replay_pushButton.setText('Extract' if checked else 'Replay')
        
    @pyqtSlot(bool)
    def on_replay_render_checkBox_clicked(self, checked):
        self.replay_extract_checkBox.setCheckState(False)
        self.replay_pushButton.setText('Render' if checked else 'Replay')
        
# ----------------------------------------------------------------
# UI Entrance, same as main.py
# ----------------------------------------------------------------

if __name__ == "__main__":
    import sys
    
    app = QApplication(sys.argv)
    ui = BlackPearl_Dialog()
    ui.show()
    
    sys.exit(app.exec_())
