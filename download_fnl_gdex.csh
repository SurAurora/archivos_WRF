#!/usr/bin/env csh
#
# c-shell script to download selected files from gdex.ucar.edu using Wget
# NOTE: if you want to run under a different shell, make sure you change
#       the 'set' commands according to your shell's syntax
# after you save the file, don't forget to make it executable
#   i.e. - "chmod 755 <name_of_script>"
#
# Experienced Wget Users: add additional command-line flags to 'opts' here
#   Use the -r (--recursive) option with care
#   Do NOT use the -b (--background) option - simultaneous file downloads
#       can cause your data access to be blocked
set opts = "-N"
#
# Check wget version.  Set the --no-check-certificate option 
# if wget version is 1.10 or higher
set v = `wget -V |grep 'GNU Wget ' | cut -d ' ' -f 3`
set a = `echo $v | cut -d '.' -f 1`
set b = `echo $v | cut -d '.' -f 2`
if(100 * $a + $b > 109) then
  set cert_opt = "--no-check-certificate"
else
  set cert_opt = ""
endif

set filelist= ( \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260601_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260601_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260601_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260601_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260602_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260602_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260602_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260602_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260603_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260603_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260603_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260603_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260604_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260604_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260604_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260604_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260605_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260605_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260605_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260605_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260606_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260606_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260606_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260606_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260607_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260607_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260607_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260607_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260608_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260608_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260608_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260608_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260609_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260609_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260609_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260609_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260610_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260610_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260610_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260610_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260611_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260611_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260611_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260611_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260612_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260612_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260612_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260612_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260613_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260613_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260613_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260613_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260614_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260614_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260614_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260614_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260615_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260615_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260615_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260615_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260616_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260616_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260616_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260616_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260617_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260617_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260617_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260617_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260618_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260618_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260618_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260618_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260619_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260619_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260619_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260619_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260620_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260620_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260620_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260620_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260621_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260621_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260621_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260621_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260622_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260622_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260622_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260622_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260623_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260623_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260623_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260623_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260624_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260624_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260624_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260624_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260625_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260625_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260625_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260625_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260626_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260626_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260626_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260626_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260627_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260627_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260627_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260627_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260628_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260628_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260628_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260628_18_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260629_00_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260629_06_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260629_12_00.grib2 \
  https://osdf-director.osg-htc.org/ncar/gdex/d083002/grib2/2026/2026.06/fnl_20260629_18_00.grib2 \
)
while($#filelist > 0)
  set syscmd = "wget $cert_opt $opts $filelist[1]"
  echo "$syscmd ..."
  $syscmd
  shift filelist
end

