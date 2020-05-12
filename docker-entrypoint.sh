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


function gettemp()
{
  TEMP=$(ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW sdr type Temperature |grep Temp |grep degrees |grep -Po '\d{2}' | tail -2 | awk '{ SUM += $1} END { print SUM/NR }')
  echo $TEMP | cut -d "." -f 1
  echo "$TEMP"
}

# Start by setting the fans to default low level
echo "Info: Current temp: ($CurrentTemp C), activating manual fan speed: 25%"
ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x19

while :
do
  CurrentTemp=$(gettemp)
  
  if [[ $CurrentTemp > $TEMP9 ]]; then
	echo "Critical: Current temp: ($CurrentTemp C) is above $TEMP9 ! Activating dyanmic fan control!"
	ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0xce 0x00 0x16 0x05 0x00 0x00 0x00 0x05 0x00 0x00 0x00 0x00
  fi

  if [[ $CurrentTemp -gt $TEMP8 && $CurrentTemp -le $TEMP9 ]]; then
	echo "Info: Current temp: ($CurrentTemp C), activating manual fan speed: 70%"
	ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x46
  fi
  
  if [[ $CurrentTemp -gt $TEMP7 && $CurrentTemp -le $TEMP8 ]]; then
	echo "Info: Current temp: ($CurrentTemp C), activating manual fan speed: 60%"
	ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x3c
  fi
  
  if [[ $CurrentTemp -gt $TEMP6 && $CurrentTemp -le $TEMP7 ]]; then
	echo "Info: Current temp: ($CurrentTemp C), activating manual fan speed: 50%"
	ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x32
  fi
  
  if [[ $CurrentTemp -gt $TEMP5 && $CurrentTemp -le $TEMP6 ]]; then
	echo "Info: Current temp: ($CurrentTemp C), activating manual fan speed: 40%"
	ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x28
  fi
  
  if [[ $CurrentTemp -gt $TEMP4 && $CurrentTemp -le $TEMP5 ]]; then
	echo "Info: Current temp: ($CurrentTemp C), activating manual fan speed: 35%"
	ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x23
  fi
  
  if [[ $CurrentTemp -gt $TEMP3 && $CurrentTemp -le $TEMP4 ]]; then
	echo "Info: Current temp: ($CurrentTemp C), activating manual fan speed: 30%"
	ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x1e
  fi
  
  if [[ $CurrentTemp -gt $TEMP2 && $CurrentTemp -le $TEMP3 ]]; then
	echo "Info: Current temp: ($CurrentTemp C), activating manual fan speed: 25%"
	ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x19
  fi
  
  if [[ $CurrentTemp -gt $TEMP1 && $CurrentTemp -le $TEMP2 ]]; then
	echo "Info: Current temp: ($CurrentTemp C), activating manual fan speed: 20%"
	ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x14
  fi
  
  if [[ $CurrentTemp -gt $TEMP0 && $CurrentTemp -le $TEMP1 ]]; then
	echo "Info: Current temp: ($CurrentTemp C), activating manual fan speed: 15%"
	ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x0f
  fi
  
  if [[ $CurrentTemp < $TEMP0 ]]; then
	echo "Critical: Current temp: ($CurrentTemp C) is not correct! Activating dyanmic fan control!"
	ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0xce 0x00 0x16 0x05 0x00 0x00 0x00 0x05 0x00 0x00 0x00 0x00
  fi

  sleep 20
done
