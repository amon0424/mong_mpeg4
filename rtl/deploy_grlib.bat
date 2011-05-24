set GRLIB=..\..\..\grlib-gpl-1.0.22-b4075\
echo grlib = %GRLIB%
copy devices.vhd "%GRLIB%\lib\grlib\amba"
copy leon3mp.vhd "%GRLIB%\designs\leon3-gr-xc3s-1500"
copy leon3mp.vhd "%GRLIB%\designs\leon3-gr-xc3s-1500-sim"
copy leon3mp.vhd "%GRLIB%\designs\leon3-gr-xc3s-1500-ise"
copy libs.txt "%GRLIB%\lib"
xcopy /S nctu "%GRLIB%\lib\nctu"
pause