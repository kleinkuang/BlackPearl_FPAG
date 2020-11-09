# File:		BlackPearl_Plot.py
# Author: 	Lei Kuang
# Date:		19th Feb 2020
# @ Imperial College London

# DAC

DELAY_PROFILE = {
    '10 MHz'  : 0, 
    '50 MHz'  : 0,
    '100 MHz' : 1,
    '200 MHz' : 2, 
    '250 MHz' : 3 
}

SIZE_PROFILE = {
    '10 MHz'  : 1024 * 128, 
    '50 MHz'  : 1024 * 1024,
    '100 MHz' : 1024 * 1024 * 2,
    '200 MHz' : 1024 * 1024 * 8, 
    '250 MHz' : 1024 * 1024 * 8 
}

DAC_PROFILE = {

    # chip:{ freq    : [rst, y,    iv,  ota, int]

        0:  {'10 MHz'  : [660, 1200, 800, 900, 892], 
             '50 MHz'  : [660, 1200, 800, 900, 892],
             '100 MHz' : [660, 1200, 800, 900, 892],
             '200 MHz' : [660, 1200, 800, 900, 892],
             '250 MHz' : [660, 1200, 800, 900, 892],  }, 

        1:  {'10 MHz'  : [660, 1201, 800, 900, 892], 
             '50 MHz'  : [660, 1202, 800, 900, 892],
             '100 MHz' : [660, 1203, 800, 900, 892],
             '200 MHz' : [660, 1204, 800, 900, 892],
             '250 MHz' : [660, 1205, 800, 900, 892],  }, 
         
        2:  {'10 MHz'  : [660, 1202, 800, 900, 892], 
             '50 MHz'  : [660, 1203, 800, 900, 892],
             '100 MHz' : [660, 1204, 800, 900, 892],
             '200 MHz' : [660, 1205, 800, 900, 892],
             '250 MHz' : [660, 1206, 800, 900, 892],  }, 
         
        3:  {'10 MHz'  : [660, 1200, 800, 900, 892], 
             '50 MHz'  : [660, 1200, 800, 900, 892],
             '100 MHz' : [660, 1200, 800, 900, 892],
             '200 MHz' : [660, 1200, 800, 900, 892],
             '250 MHz' : [660, 1200, 800, 900, 892],  }, 
            
        4:  {'10 MHz'  : [660, 1200, 800, 900, 892], 
             '50 MHz'  : [660, 1200, 800, 900, 892],
             '100 MHz' : [660, 1200, 800, 900, 892],
             '200 MHz' : [660, 1200, 800, 900, 892],
             '250 MHz' : [660, 1200, 800, 900, 892],  }, 
            
        5:  {'10 MHz'  : [660, 1200, 800, 900, 892], 
             '50 MHz'  : [660, 1200, 800, 900, 892],
             '100 MHz' : [660, 1200, 800, 900, 892],
             '200 MHz' : [660, 1200, 800, 900, 892],
             '250 MHz' : [660, 1200, 800, 900, 892],  }, 
            
        6:  {'10 MHz'  : [660, 1200, 800, 900, 892], 
             '50 MHz'  : [660, 1200, 800, 900, 892],
             '100 MHz' : [660, 1200, 800, 900, 892],
             '200 MHz' : [660, 1200, 800, 900, 892],
             '250 MHz' : [660, 1200, 800, 900, 892],  },
           
        7:  {'10 MHz'  : [660, 1200, 800, 900, 892], 
             '50 MHz'  : [660, 1200, 800, 900, 892],
             '100 MHz' : [660, 1200, 800, 900, 892],
             '200 MHz' : [350, 1150, 850, 900, 850],
             '250 MHz' : [660, 1200, 800, 900, 892],  },
           
        8:  {'10 MHz'  : [660, 1200, 800, 900, 892], 
             '50 MHz'  : [660, 1200, 800, 900, 892],
             '100 MHz' : [660, 1200, 800, 900, 892],
             '200 MHz' : [450, 1200, 900, 900, 870],
             '250 MHz' : [660, 1200, 800, 900, 892],  }, 
            
        9:  {'10 MHz'  : [660, 1200, 800, 900, 892], 
             '50 MHz'  : [660, 1200, 800, 900, 892],
             '100 MHz' : [660, 1200, 800, 900, 892],
             '200 MHz' : [450, 1050, 1000, 900, 872],
             '250 MHz' : [660, 1200, 800, 900, 892],  }, 
            
        10: {'10 MHz'  : [660, 1200, 800, 900, 892], 
             '50 MHz'  : [660, 1200, 800, 900, 892],
             '100 MHz' : [660, 1200, 800, 900, 892],
             '200 MHz' : [450, 1120, 1000, 900, 850],
             '250 MHz' : [660, 1200, 800, 900, 892],  }, 
             
        11: {'10 MHz'  : [660, 1200, 800, 900, 892], 
             '50 MHz'  : [660, 1200, 800, 900, 892],
             '100 MHz' : [660, 1200, 800, 900, 892],
             '200 MHz' : [660, 1200, 800, 900, 892],
             '250 MHz' : [660, 1200, 800, 900, 892],  }, 
             
        12: {'10 MHz'  : [660, 1200, 800, 900, 892], 
             '50 MHz'  : [660, 1200, 800, 900, 892],
             '100 MHz' : [660, 1200, 800, 900, 892],
             '200 MHz' : [660, 1200, 800, 900, 892],
             '250 MHz' : [660, 1200, 800, 900, 892],  }, 
             
        13: {'10 MHz'  : [660, 1200, 800, 900, 892], 
             '50 MHz'  : [660, 1200, 800, 900, 892],
             '100 MHz' : [660, 1200, 800, 900, 892],
             '200 MHz' : [660, 1200, 800, 900, 892],
             '250 MHz' : [660, 1200, 800, 900, 892],  }, 
             
        14: {'10 MHz'  : [660, 1200, 800, 900, 892], 
             '50 MHz'  : [660, 1200, 800, 900, 892],
             '100 MHz' : [660, 1200, 800, 900, 892],
             '200 MHz' : [660, 1200, 800, 900, 892],
             '250 MHz' : [660, 1200, 800, 900, 892],  }, 
             
        15: {'10 MHz'  : [660, 1200, 800, 900, 892], 
             '50 MHz'  : [660, 1200, 800, 900, 892],
             '100 MHz' : [660, 1200, 800, 900, 892],
             '200 MHz' : [660, 1200, 800, 900, 892],
             '250 MHz' : [660, 1200, 800, 900, 892],  }, 
             
        16: {'10 MHz'  : [660, 1200, 800, 900, 892], 
             '50 MHz'  : [660, 1200, 800, 900, 892],
             '100 MHz' : [660, 1200, 800, 900, 892],
             '200 MHz' : [660, 1200, 800, 900, 892],
             '250 MHz' : [660, 1200, 800, 900, 892],  }, 
             
        17: {'10 MHz'  : [660, 1200, 800, 900, 892], 
             '50 MHz'  : [660, 1200, 800, 900, 892],
             '100 MHz' : [660, 1200, 800, 900, 892],
             '200 MHz' : [660, 1200, 800, 900, 892],
             '250 MHz' : [660, 1200, 800, 900, 892],  }, 
             
        18: {'10 MHz'  : [660, 1200, 800, 900, 892], 
             '50 MHz'  : [660, 1200, 800, 900, 892],
             '100 MHz' : [660, 1200, 800, 900, 892],
             '200 MHz' : [660, 1200, 800, 900, 892],
             '250 MHz' : [660, 1200, 800, 900, 892],  }, 
             
        19: {'10 MHz'  : [660, 1200, 800, 900, 892], 
             '50 MHz'  : [660, 1200, 800, 900, 892],
             '100 MHz' : [660, 1200, 800, 900, 892],
             '200 MHz' : [660, 1200, 800, 900, 892],
             '250 MHz' : [660, 1200, 800, 900, 892],  }, 
             
        20: {'10 MHz'  : [660, 1200, 800, 900, 892], 
             '50 MHz'  : [660, 1200, 800, 900, 892],
             '100 MHz' : [660, 1200, 800, 900, 892],
             '200 MHz' : [660, 1200, 800, 900, 892],
             '250 MHz' : [660, 1200, 800, 900, 892],  }, 
}

if __name__ == '__main__':
    print(DAC_PROFILE[0]['200MHz'])