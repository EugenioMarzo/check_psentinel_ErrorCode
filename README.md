check_psentinel_ErrorCode
=========================

Nagios plugin for check the status code of psentinel


./check_psentinel_ErrorCode.pl --help


Usage: ./check_psentinel_ErrorCode.pl  --port svc1:p1:exit_code,svc2:p2,exit_code   --severity= CRITICAL ||  WARNING || UNKNOWN ...  

Example:  ./check_psentinel_ErrorCode.pl  --port tomcat1:48081:500,tomcat2:48082:500 --severity CRITICAL

