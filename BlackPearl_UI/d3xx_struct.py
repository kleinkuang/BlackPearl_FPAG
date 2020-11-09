# File:    d3xx_struct.py
# Author:  Lei Kuang
# Date:    1st of April 2020
# @ Imperial College London

from ctypes import *
from ctypes.wintypes import *

STRING    = c_char_p
USHORT    = c_ushort
SHORT     = c_short
UCHAR     = c_ubyte
WCHAR     = c_wchar
LPBYTE    = POINTER(c_ubyte)
CHAR      = c_char
LPBOOL    = POINTER(c_int)
PUCHAR    = POINTER(c_ubyte)
PCHAR     = STRING
PVOID     = c_void_p
INT       = c_int
LPTSTR    = STRING
LPDWORD   = POINTER(DWORD)
LPWORD    = POINTER(WORD)
PULONG    = POINTER(ULONG)
LPVOID    = PVOID
VOID      = None
ULONGLONG = c_ulonglong
FT_HANDLE = PVOID
FT_STATUS = ULONG
FT_DEVICE = ULONG

class FT_DEVICE_LIST_INFO_NODE(Structure):
    pass
FT_DEVICE_LIST_INFO_NODE._fields_ = \
[
    ('Flags',        ULONG),
    ('Type',         ULONG),
    ('ID',           ULONG),
    ('LocId',        DWORD),
    ('SerialNumber', c_char * 16),
    ('Description',  c_char * 32),
    ('ftHandle',     FT_HANDLE),
]

if __name__ == "__main__":
    ptDest = FT_DEVICE_LIST_INFO_NODE()
    print(ptDest._fields_[0])
