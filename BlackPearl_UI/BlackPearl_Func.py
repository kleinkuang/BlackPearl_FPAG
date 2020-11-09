# File:		BlackPearl_Func.py
# Author: 	Lei Kuang
# Date:		25th August 2020
# @ Imperial College London

import datetime
import struct

# ----------------------------------------------------------------
# Date Inforamtion
# ----------------------------------------------------------------
# Get current date and time, e.g., '20200224' -> 2020 Feb 24
def get_date(fraction = 0):
    return datetime.datetime.now().isoformat().replace('-','').replace(':','')[0:8]

# Get current date and time, e.g., '20200224T141323'
def get_date_time(fraction = 0):
    return datetime.datetime.now().isoformat().replace('-','').replace(':','')[0:(15 + (0 if fraction==0 else (1 + fraction)))]
