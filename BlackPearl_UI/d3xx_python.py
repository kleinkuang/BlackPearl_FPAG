# File:    d3xx_python.py
# Author:  Lei Kuang
# Date:    1st of April 2020
# @ Imperial College London

# Python Driver for FT601Q
# 2020.04.01 - READ ONLY

# LPDWORD -> Unsigned Long

from ctypes import *

d3xx_lib = WinDLL('./D3XXLibrary_v1.3.0.2/x64/ftd3xx.dll')



def FT_CreateDeviceInfoList():
    i = c_ulong()

    status = d3xx_lib.FT_CreateDeviceInfoList(byref(i))
    print(status, i)
    
if __name__ == "__main__":
    print(FT_CreateDeviceInfoList())
