# File:		BlackPearl_Plot.py
# Author: 	Lei Kuang
# Date:		25th August 2020
# @ Imperial College London

import matplotlib
matplotlib.use("Qt5Agg")

from matplotlib import gridspec
from mpl_toolkits.axes_grid1 import make_axes_locatable
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.figure import Figure
from mpl_toolkits.mplot3d import Axes3D

from PyQt5.QtWidgets import QMainWindow, QSizePolicy

import numpy as np

class BlackPearl_Plot(QMainWindow):
    
    def __init__(self):
        super().__init__()
        
        # Window settings
        self.setWindowTitle('BlackPearl Plot')
        #self.setGeometry(250, 200, 540, 540)
        self.setFixedSize(500, 1000)

        # Matplotlib instance
        self.canvas = PlotCanvas(self)
        self.canvas.move(0, 0)

    def drawnow(self):
        self.canvas.draw()

    def plot_3d(self, data):
        self.canvas.plot_3d(data)

    # Plot 2D Image
    def plot_2d(self, data):
        self.canvas.plot_2d(data)

    # Plot 1D Curve
    def plot_1d_av(self, data):
        self.canvas.plot_1d_av(data)

    def plot_1d_px(self, data):
        self.canvas.plot_1d_px(data)

class PlotCanvas(FigureCanvas):

    def __init__(self, parent=None):
        self.figure = Figure(figsize=(5, 10), dpi=100)
        FigureCanvas.__init__(self, self.figure)
        self.setParent(parent)

        FigureCanvas.setSizePolicy(self, QSizePolicy.Expanding, QSizePolicy.Expanding)
        FigureCanvas.updateGeometry(self)

        self.grid = gridspec.GridSpec(16, 24, hspace=1)

        # 3D Plot --------------------------------------------------------------------------------------------------------------
        self.x = np.arange(0, 128)
        self.y = np.arange(0, 128)
        (self.x, self.y) = np.meshgrid(self.x, self.y)

        self.ax_3d = self.figure.add_subplot(self.grid[0:5, 1:-1], projection='3d')
        self.ax_3d.set_title("3D Imaging", pad=25)

        self.data_3d = np.zeros(128*128).reshape(128, 128)
        self.fig_3d =   self.ax_3d.plot_surface(  self.x, self.y, 
                                                  self.data_3d,
                                                  #cmap=plt.get_cmap('hsv'),
                                                  cmap='gist_rainbow', 
                                                  #extent=[0,  77,  0, 55], 
                                                  vmin=0, vmax=255 )
        self.ax_3d.set_xlabel("Column")
        self.ax_3d.set_ylabel("Row")
        self.ax_3d.view_init(35, 30)
        self.ax_3d.set_zlim(0, 255)

        # - Colorbar
        self.figure.colorbar(self.fig_3d, orientation='vertical')
        
        # 2D Plot --------------------------------------------------------------------------------------------------------------
        self.ax_2d = self.figure.add_subplot(self.grid[6:10, 1:-1])
        self.ax_2d.set_title("2D Grayscale Imaging")
        self.data_2d = np.zeros(128*128).reshape(128, 128)
        self.fig_2d =   self.ax_2d.imshow(  self.data_2d,
                                            #cmap=plt.get_cmap('hsv'),
                                            cmap='gray', 
                                            interpolation='none',
                                            #extent=[0,  77,  0, 55], 
                                            vmin=0,  vmax=255 )
        self.ax_2d.set_xlabel("Column")
        self.ax_2d.set_ylabel("Row")

        # - Colorbar
        divider = make_axes_locatable(self.ax_2d)
        cax = divider.append_axes("right", size="5%", pad=0.1)
        self.figure.colorbar(self.fig_2d,  orientation='vertical', cax=cax)

        # 1D Plot --------------------------------------------------------------------------------------------------------------
        # Average
        self.ax_1d_av = self.figure.add_subplot(self.grid[11:13, 1:-1])
        self.ax_1d_av.set_title("Average Readout")
        self.ax_1d_av.set_xlim(0, 1)
        self.ax_1d_av.set_ylim(0, 1)
        self.ax_1d_av.set_xlabel("Sample")

        [self.fig_1d_av] = self.ax_1d_av.plot([0], 'b-')
        
        # Pixel
        self.ax_1d_px = self.figure.add_subplot(self.grid[14:16, 1:-1])
        self.ax_1d_px.set_title("Pixel Readout")
        self.ax_1d_px.set_xlim(0, 1)
        self.ax_1d_px.set_ylim(0, 1)
        self.ax_1d_px.set_xlabel("Sample")

        [self.fig_1d_px] = self.ax_1d_px.plot([0], 'b-')
        
        self.draw()

    # --------------------------------------------------------------------------------------------------------------------------
    # Plot 3D Image
    def plot_3d(self, data):
        self.fig_3d.remove()
        self.data_3d = data
        
        self.fig_3d  = self.ax_3d.plot_surface( self.x, self.y, 
                                                self.data_3d,
                                                cmap='gist_rainbow', 
                                                #extent=[0,  77,  0, 55], 
                                                vmin=0, vmax=255 )

    # Plot 2D Image
    def plot_2d(self, data):
        self.fig_2d.remove()
        self.data_2d = data
        
        self.fig_2d = self.ax_2d.imshow(    self.data_2d,
                                            #cmap=plt.get_cmap('hsv'),
                                            cmap='gray', 
                                            interpolation='none',
                                            #extent=[0,  77,  0, 55], 
                                            vmin=140,  vmax=255 )

    # Plot 1D Curve
    def plot_1d_av(self, data):
        self.fig_1d_av.remove()
        
        self.data_1d_av = np.array(data)
        x_len = len(self.data_1d_av)
        self.ax_1d_av.set_xlim(0, x_len)
        self.ax_1d_av.set_ylim(int(min(self.data_1d_av) - 1), 1 + int(max(self.data_1d_av) + 1))

        [self.fig_1d_av] = self.ax_1d_av.plot(self.data_1d_av, 'b-')
        
    def plot_1d_px(self, data):
        self.fig_1d_px.remove()
        
        self.data_1d_px = np.array(data)
        x_len = len(self.data_1d_px)

        self.ax_1d_px.set_xlim(0, x_len)
        self.ax_1d_px.set_ylim(int(min(self.data_1d_px) - 1), 1 + int(max(self.data_1d_px) + 1))

        [self.fig_1d_px] = self.ax_1d_px.plot(self.data_1d_px, 'b-')

    # Save plot to .png
    def save_image(self, path):
        self.figure.savefig(path)

# Testbench
if __name__ == '__main__':
    import sys
    from PyQt5.QtWidgets import QApplication
    app = QApplication(sys.argv)
    ui = BlackPearl_Plot()
    ui.show()
    sys.exit(app.exec_())
