#!/usr/bin/python

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# 
                                                        
# ###########################################################################
# title           : PE Compilation timestamp anomaly checker
# name            : pe_compile_ts_anomalies.py
# description     : This script checks the compilation timestamp from pe files.
#                   Creates a csv output with: the name of the file,
#                   the compilation timestamp and a value indicating if the
#                   timestamp is normal or anomalous.
#                   Compilation timestamps are in UTC.
# notes           : This script is based on pescanner.py (Michael Ligh) to 
#                 : check only compilation timestamps and use it in the triage
#                   of malware incidents
# author          : Cristina Roura
# date            : 2014 03 31
# version         : 0.1
# usage           : python pe_compile_ts_anomalies.py <file|directory>
# requirements    : pefile
# ###########################################################################

import time
import os, sys

try:
    import pefile
except ImportError:
    print 'pefile not installed, see http://code.google.com/p/pefile/'
    sys.exit()

def timestamp_check(pe):
    anomaly = ""
    time_now = time.time()
    time_date_stamp = pe.FILE_HEADER.TimeDateStamp
    time_stamp = time.strftime("%m/%d/%Y %H:%M:%S", time.gmtime(time_date_stamp))

    #Check timestamp anomalies
    if (time_date_stamp == 0):
        anomaly = "zero/invalid"
    elif (time_date_stamp < 946684800): # 01/01/2000
        anomaly = "too old"
    elif (time_date_stamp > time_now):
        anomaly = "future time"
    elif (time_date_stamp < time_now and time_date_stamp >= 946684800):
        anomaly = "normal"
    else:
        anomaly = "zero/invalid"
    return time_stamp,anomaly

if __name__ == "__main__":
        
    if len(sys.argv) != 2:
      print "Usage: %s <file|directory>\n" % (sys.argv[0])
      sys.exit()
      
    object = sys.argv[1]
    files  = []
    
    if os.path.isdir(object):
        for root, dirs, filenames in os.walk(object):
            for name in filenames:
                files.append(os.path.join(root, name))
    elif os.path.isfile(object):
        files.append(object)
    else:
        print "You must supply a file or directory!"
        sys.exit()
   
    print "filename,timestamp(M/D/Y H:M:S),timezone,anomaly" 
    for file in files:
	out = []
	try:
		FILE = open(file, "rb")
		data = FILE.read()
		FILE.close()
        except:
            continue

        if data == None or len(data) == 0:
            out.append("Cannot read %s (maybe empty?)" % file)
            out.append("")
            continue
                
        try:
            pe = pefile.PE(data=data, fast_load=True)
	    time_stamp,anomaly = timestamp_check(pe)
	    print file + "," + time_stamp + ",UTC," + anomaly
        except:
            out.append("Cannot parse %s (maybe not PE?)" % file)
            out.append("")
            continue
