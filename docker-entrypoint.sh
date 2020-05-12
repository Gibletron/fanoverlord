#!/bin/bash
# ----------------------------------------------------------------------------------
# Every 20 seconds this script checks the temperature reported by the ambient temperature sensor,
# and if deemed too high sends the raw IPMI command to adjust the fan speed on the R720 server.
#
#
# Requires:
# ipmitool – apt-get install ipmitool
# ----------------------------------------------------------------------------------
# Set the state of Emergency (is it too hot or not)
EMERGENCY=false

# IPMI SETTINGS:
# DEFAULT IP: 192.168.0.120
IPMIHOST=${IPMIHOST} # <IP Address of the iDRAC on the Server>
IPMIUSER=${IPMIUSER} # <User for the iDRAC>
IPMIPW=${IPMIPW} # <Password for the iDRAC

# TEMPERATURE
# Change this to the temperature in celcius you are comfortable with.
# If the temperature goes above the set degrees it will send raw IPMI command to enable dynamic fan control
# According to iDRAC Min Warning is 42C and Failure (shutdown) is 47C
TEMPoff=15
TEMP0=20
TEMP1=25
TEMP2=30
TEMP3=35
TEMP4=40
TEMP5=45
TEMP6=50
TEMP7=55
TEMP8=60
TEMP9=65



# Last Octal controls values to know
# Query Fan speeds
# ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW sdr type fan
#
# Fan Power Percentages
# 0x00 = 0%
# 0x64 = 100%
#
# R610 RPM values
# 0b = 2280 RPM
# 0e = 2640 RPM
# 0f = 2760 RPM
# 10 = 3000 RPM
# 1a = 4800 RPM
# 20 = 5880 RPM
# 30 = 8880 RPM
# 50 = 14640 RPM


function temp8-fan()
{
  echo "Info: Activating manual fan speeds (3000 RPM)"
  ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
  ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x46
}

function temp7-fan()
{
  echo "Info: Activating manual fan speeds (3000 RPM)"
  ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
  ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x3c
}

function temp6-fan()
{
  echo "Info: Activating manual fan speeds (3000 RPM)"
  ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
  ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x32
}

function temp5-fan()
{
  echo "Info: Activating manual fan speeds (3000 RPM)"
  ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
  ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x28
}

function temp4-fan()
{
  echo "Info: Activating manual fan speeds (3000 RPM)"
  ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
  ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x23
}

function temp3-fan()
{
  echo "Info: Activating manual fan speeds (3000 RPM)"
  ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
  ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x1e
}

function temp2-fan()
{
  echo "Info: Activating manual fan speeds (3000 RPM)"
  ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
  ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x19
}

function temp1-fan()
{
  echo "Info: Activating manual fan speeds (3000 RPM)"
  ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
  ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x14
}

function temp0-fan()
{
  echo "Info: Activating manual fan speeds (3000 RPM)"
  ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
  ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x0f
}


# Auto-controled
function FanAuto()
{
  echo "Info: Dynamic fan control Active ($CurrentTemp C)"
  ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0xce 0x00 0x16 0x05 0x00 0x00 0x00 0x05 0x00 0x00 0x00 0x00
}

function gettemp()
{
  TEMP=$(ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW sdr type Temperature |grep Temp |grep degrees |grep -Po '\d{2}' | tail -2 | awk '{ SUM += $1} END { print SUM/NR }')
  echo "$TEMP"
}

# Start by setting the fans to default low level
echo "Info: Activating manual fan speeds (2280 RPM)"
ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x0f

while :
do
  CurrentTemp=$(gettemp)
  if [[ $CurrentTemp > $TEMP9 ]]; then
    EMERGENCY=true
    FanAuto
  fi

  if [[ $CurrentTemp < $TEMP8 ]]; then
    EMERGENCY=false
    temp8-fan
  fi
  
  if [[ $CurrentTemp < $TEMP7 ]]; then
    EMERGENCY=false
    temp7-fan
  fi
  
  if [[ $CurrentTemp < $TEMP6 ]]; then
    EMERGENCY=false
    temp6-fan
  fi
  
  if [[ $CurrentTemp < $TEMP5 ]]; then
    EMERGENCY=false
    temp5-fan
  fi
  
  if [[ $CurrentTemp < $TEMP4 ]]; then
    EMERGENCY=false
    temp4-fan
  fi
  
  if [[ $CurrentTemp < $TEMP3 ]]; then
    EMERGENCY=false
    temp3-fan
  fi
  
  if [[ $CurrentTemp < $TEMP2 ]]; then
    EMERGENCY=false
    temp2-fan
  fi
  
  if [[ $CurrentTemp < $TEMP1 ]]; then
    EMERGENCY=false
    temp1-fan
  fi
  
  if [[ $CurrentTemp < $TEMP0 ]]; then
    EMERGENCY=false
    temp0-fan
  fi
  
  if [[ $CurrentTemp < $TEMPoff ]]; then
    EMERGENCY=true
    FanAuto
  fi


  sleep 20
done
