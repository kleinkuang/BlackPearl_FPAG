# File:    d3xx_driver.py
# Author:  Lei Kuang
# Date:    1st of April 2020
# @ Imperial College London

# Python Driver for FT601Q
# 2020.04.01 - READ ONLY

# LPDWORD -> Unsigned Long

from ctypes import *
from d3xx_defines import *
from d3xx_struct import *

# C++ .dll
d3xx_lib = WinDLL('./D3XXLibrary_v1.3.0.2/x64/ftd3xx.dll')

# Builds a device information list and returns the number of D3XX devices connected to the system.
def FT_CreateDeviceInfoList(lpdwNumDevs):
    status = d3xx_lib.FT_CreateDeviceInfoList(byref(lpdwNumDevs))
    return status

# Returns a device information list and the number of D3XX devices in the list.
def FT_GetDeviceInfoList(ptDest, lpdwNumDevs):
    status = d3xx_lib.FT_GetDeviceInfoList(byref(ptDest), lpdwNumDevs)
    return status
    
if __name__ == "__main__":
    print()
    # Check number of devices
    lpdwNumDevs = c_ulong()
    status = FT_CreateDeviceInfoList(lpdwNumDevs)
    print("# No of connected devices:\n%d" % lpdwNumDevs.value)
    
    # Get information
    ptDest = FT_DEVICE_LIST_INFO_NODE()
    status = FT_GetDeviceInfoList(ptDest, lpdwNumDevs)
    print("# Device information:\n");
    print("Flags: %d" % ptDest.Flags);
    print("Type: %d" % ptDest.Type);
    print("ID: %d" % ptDest.ID);
    print("LocId: %d" % ptDest.LocId);
    print("SerialNumber: %s" % ptDest.SerialNumber);
    print("Description: %s" % ptDest.Description);
