EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:sbb
LIBS:anritsu
LIBS:dx_module
LIBS:relay-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "12v Power Relay Controller"
Date "05-Sep-2016"
Rev "1.0"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L ATTINY13-P IC1
U 1 1 57CD5964
P 1950 1450
F 0 "IC1" H 1150 1850 50  0000 C CNN
F 1 "ATTINY13-P" H 2600 1050 50  0000 C CNN
F 2 "Housings_DIP:DIP-8_W7.62mm_LongPads" H 2600 1450 50  0000 C CIN
F 3 "" H 1150 1800 50  0000 C CNN
	1    1950 1450
	-1   0    0    1   
$EndComp
$Comp
L BC548 Q1
U 1 1 57CD5B0D
P 5250 1950
F 0 "Q1" H 5450 2025 50  0000 L CNN
F 1 "BC548" H 5450 1950 50  0000 L CNN
F 2 "TO_SOT_Packages_THT:TO-92_Rugged" H 5450 1875 50  0000 L CIN
F 3 "" H 5250 1950 50  0000 L CNN
	1    5250 1950
	1    0    0    -1  
$EndComp
$Comp
L BC548 Q2
U 1 1 57CD5B90
P 5250 4100
F 0 "Q2" H 5450 4175 50  0000 L CNN
F 1 "BC548" H 5450 4100 50  0000 L CNN
F 2 "TO_SOT_Packages_THT:TO-92_Rugged" H 5450 4025 50  0000 L CIN
F 3 "" H 5250 4100 50  0000 L CNN
	1    5250 4100
	1    0    0    -1  
$EndComp
$Comp
L GNDD #PWR01
U 1 1 57CD5BEB
P 5350 2250
F 0 "#PWR01" H 5350 2000 50  0001 C CNN
F 1 "GNDD" H 5350 2100 50  0000 C CNN
F 2 "" H 5350 2250 50  0000 C CNN
F 3 "" H 5350 2250 50  0000 C CNN
	1    5350 2250
	1    0    0    -1  
$EndComp
$Comp
L GNDD #PWR02
U 1 1 57CD5C09
P 950 1200
F 0 "#PWR02" H 950 950 50  0001 C CNN
F 1 "GNDD" H 950 1050 50  0000 C CNN
F 2 "" H 950 1200 50  0000 C CNN
F 3 "" H 950 1200 50  0000 C CNN
	1    950  1200
	1    0    0    -1  
$EndComp
$Comp
L +5VD #PWR03
U 1 1 57CD5C27
P 950 1700
F 0 "#PWR03" H 950 1550 50  0001 C CNN
F 1 "+5VD" H 950 1840 50  0000 C CNN
F 2 "" H 950 1700 50  0000 C CNN
F 3 "" H 950 1700 50  0000 C CNN
	1    950  1700
	1    0    0    -1  
$EndComp
$Comp
L D D2
U 1 1 57CD5C96
P 5350 1250
F 0 "D2" H 5350 1350 50  0000 C CNN
F 1 "D" H 5350 1150 50  0000 C CNN
F 2 "Discret:D5" H 5350 1250 50  0000 C CNN
F 3 "" H 5350 1250 50  0000 C CNN
	1    5350 1250
	0    1    1    0   
$EndComp
$Comp
L D D3
U 1 1 57CD5D55
P 5350 3350
F 0 "D3" H 5350 3450 50  0000 C CNN
F 1 "D" H 5350 3250 50  0000 C CNN
F 2 "Discret:D5" H 5350 3350 50  0000 C CNN
F 3 "" H 5350 3350 50  0000 C CNN
	1    5350 3350
	0    1    1    0   
$EndComp
$Comp
L R R4
U 1 1 57CD5E94
P 4900 1600
F 0 "R4" V 4980 1600 50  0000 C CNN
F 1 "5K6" V 4900 1600 50  0000 C CNN
F 2 "Resistors_SMD:R_1206_HandSoldering" V 4830 1600 50  0000 C CNN
F 3 "" H 4900 1600 50  0000 C CNN
	1    4900 1600
	1    0    0    -1  
$EndComp
$Comp
L R R5
U 1 1 57CD6015
P 4800 3500
F 0 "R5" V 4880 3500 50  0000 C CNN
F 1 "5K6" V 4800 3500 50  0000 C CNN
F 2 "Resistors_SMD:R_1206_HandSoldering" V 4730 3500 50  0000 C CNN
F 3 "" H 4800 3500 50  0000 C CNN
	1    4800 3500
	-1   0    0    1   
$EndComp
$Comp
L R R2
U 1 1 57CD65B6
P 4450 1850
F 0 "R2" V 4530 1850 50  0000 C CNN
F 1 "1M" V 4450 1850 50  0000 C CNN
F 2 "Resistors_SMD:R_1206_HandSoldering" V 4380 1850 50  0000 C CNN
F 3 "" H 4450 1850 50  0000 C CNN
	1    4450 1850
	1    0    0    -1  
$EndComp
$Comp
L R R3
U 1 1 57CD6643
P 4450 2250
F 0 "R3" V 4530 2250 50  0000 C CNN
F 1 "330K" V 4450 2250 50  0000 C CNN
F 2 "Resistors_SMD:R_1206_HandSoldering" V 4380 2250 50  0000 C CNN
F 3 "" H 4450 2250 50  0000 C CNN
	1    4450 2250
	1    0    0    -1  
$EndComp
$Comp
L +12V #PWR04
U 1 1 57CD66EF
P 4450 1700
F 0 "#PWR04" H 4450 1550 50  0001 C CNN
F 1 "+12V" H 4450 1840 50  0000 C CNN
F 2 "" H 4450 1700 50  0000 C CNN
F 3 "" H 4450 1700 50  0000 C CNN
	1    4450 1700
	1    0    0    -1  
$EndComp
$Comp
L C C1
U 1 1 57CD674F
P 4200 2250
F 0 "C1" H 4225 2350 50  0000 L CNN
F 1 "22uF" H 4225 2150 50  0000 L CNN
F 2 "Capacitors_Tantalum_SMD:TantalC_SizeC_EIA-6032_HandSoldering" H 4238 2100 50  0000 C CNN
F 3 "" H 4200 2250 50  0000 C CNN
	1    4200 2250
	1    0    0    -1  
$EndComp
$Comp
L GNDD #PWR05
U 1 1 57CD68E3
P 4450 2500
F 0 "#PWR05" H 4450 2250 50  0001 C CNN
F 1 "GNDD" H 4450 2350 50  0000 C CNN
F 2 "" H 4450 2500 50  0000 C CNN
F 3 "" H 4450 2500 50  0000 C CNN
	1    4450 2500
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X02 P1
U 1 1 57CD6FD9
P 1250 5000
F 0 "P1" H 1250 5150 50  0000 C CNN
F 1 "CONN_01X02" V 1350 5000 50  0000 C CNN
F 2 "Connect:bornier2" H 1250 5000 50  0000 C CNN
F 3 "" H 1250 5000 50  0000 C CNN
	1    1250 5000
	-1   0    0    1   
$EndComp
$Comp
L C C2
U 1 1 57CD720D
P 2250 5200
F 0 "C2" H 2275 5300 50  0000 L CNN
F 1 "22uF" H 2275 5100 50  0000 L CNN
F 2 "Capacitors_Tantalum_SMD:TantalC_SizeC_EIA-6032_HandSoldering" H 2288 5050 50  0000 C CNN
F 3 "" H 2250 5200 50  0000 C CNN
	1    2250 5200
	1    0    0    -1  
$EndComp
$Comp
L C C3
U 1 1 57CD728E
P 3350 5200
F 0 "C3" H 3375 5300 50  0000 L CNN
F 1 "22uF" H 3375 5100 50  0000 L CNN
F 2 "Capacitors_Tantalum_SMD:TantalC_SizeC_EIA-6032_HandSoldering" H 3388 5050 50  0000 C CNN
F 3 "" H 3350 5200 50  0000 C CNN
	1    3350 5200
	1    0    0    -1  
$EndComp
$Comp
L +5VD #PWR06
U 1 1 57CD74DA
P 3350 4950
F 0 "#PWR06" H 3350 4800 50  0001 C CNN
F 1 "+5VD" H 3350 5090 50  0000 C CNN
F 2 "" H 3350 4950 50  0000 C CNN
F 3 "" H 3350 4950 50  0000 C CNN
	1    3350 4950
	1    0    0    -1  
$EndComp
$Comp
L +12V #PWR07
U 1 1 57CD7D1E
P 2250 4950
F 0 "#PWR07" H 2250 4800 50  0001 C CNN
F 1 "+12V" H 2250 5090 50  0000 C CNN
F 2 "" H 2250 4950 50  0000 C CNN
F 3 "" H 2250 4950 50  0000 C CNN
	1    2250 4950
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 57CD849A
P 3800 1800
F 0 "R1" V 3880 1800 50  0000 C CNN
F 1 "1K" V 3800 1800 50  0000 C CNN
F 2 "Resistors_SMD:R_1206_HandSoldering" V 3730 1800 50  0000 C CNN
F 3 "" H 3800 1800 50  0000 C CNN
	1    3800 1800
	1    0    0    -1  
$EndComp
$Comp
L LED D1
U 1 1 57CD84F1
P 3800 2200
F 0 "D1" H 3800 2300 50  0000 C CNN
F 1 "LED" H 3800 2100 50  0000 C CNN
F 2 "LEDs:LED-5MM" H 3800 2200 50  0000 C CNN
F 3 "" H 3800 2200 50  0000 C CNN
	1    3800 2200
	0    -1   -1   0   
$EndComp
$Comp
L SW_PUSH SW1
U 1 1 57CD8623
P 3400 2050
F 0 "SW1" H 3550 2160 50  0000 C CNN
F 1 "SW_PUSH" H 3400 1970 50  0000 C CNN
F 2 "Buttons_Switches_ThroughHole:SW_PUSH-12mm" H 3400 2050 50  0000 C CNN
F 3 "" H 3400 2050 50  0000 C CNN
	1    3400 2050
	0    -1   -1   0   
$EndComp
$Comp
L CONN_02X20 P2
U 1 1 57CD8E0F
P 10050 2200
F 0 "P2" H 10050 3250 50  0000 C CNN
F 1 "CONN_02X20" V 10050 2200 50  0000 C CNN
F 2 "Connect:IDC_Header_Straight_40pins" H 10050 1250 50  0000 C CNN
F 3 "" H 10050 1250 50  0000 C CNN
	1    10050 2200
	1    0    0    -1  
$EndComp
$Comp
L +12V #PWR08
U 1 1 57CD90B3
P 6000 2850
F 0 "#PWR08" H 6000 2700 50  0001 C CNN
F 1 "+12V" H 6000 2990 50  0000 C CNN
F 2 "" H 6000 2850 50  0000 C CNN
F 3 "" H 6000 2850 50  0000 C CNN
	1    6000 2850
	1    0    0    -1  
$EndComp
$Comp
L +12V #PWR09
U 1 1 57CD90EF
P 6000 750
F 0 "#PWR09" H 6000 600 50  0001 C CNN
F 1 "+12V" H 6000 890 50  0000 C CNN
F 2 "" H 6000 750 50  0000 C CNN
F 3 "" H 6000 750 50  0000 C CNN
	1    6000 750 
	1    0    0    -1  
$EndComp
$Comp
L GNDD #PWR010
U 1 1 57CD9222
P 5350 4350
F 0 "#PWR010" H 5350 4100 50  0001 C CNN
F 1 "GNDD" H 5350 4200 50  0000 C CNN
F 2 "" H 5350 4350 50  0000 C CNN
F 3 "" H 5350 4350 50  0000 C CNN
	1    5350 4350
	1    0    0    -1  
$EndComp
Wire Wire Line
	5350 3500 5350 3900
Wire Wire Line
	6000 3600 6000 3650
Wire Wire Line
	6000 3650 5350 3650
Connection ~ 5350 3650
Wire Wire Line
	5350 1400 5350 1750
Wire Wire Line
	6000 1500 6000 1550
Wire Wire Line
	6000 1550 5350 1550
Connection ~ 5350 1550
Wire Wire Line
	2950 1300 4900 1300
Wire Wire Line
	2950 1400 4800 1400
Wire Wire Line
	4900 1950 5050 1950
Wire Wire Line
	4800 4100 5050 4100
Wire Wire Line
	4450 2000 4450 2100
Wire Wire Line
	4200 2050 4450 2050
Wire Wire Line
	4200 1500 4200 2100
Connection ~ 4450 2050
Wire Wire Line
	4200 2500 4200 2400
Wire Wire Line
	4450 2500 4450 2400
Wire Wire Line
	3400 2500 4450 2500
Wire Wire Line
	4200 1500 2950 1500
Connection ~ 4200 2050
Wire Wire Line
	4800 1400 4800 3350
Wire Wire Line
	4800 3650 4800 4100
Wire Wire Line
	1450 5050 1450 5500
Wire Wire Line
	1450 5500 3350 5500
Wire Wire Line
	3350 5500 3350 5350
Wire Wire Line
	2850 5250 2850 5500
Connection ~ 2850 5500
Wire Wire Line
	2250 5350 2250 5500
Connection ~ 2250 5500
Wire Wire Line
	2450 4950 1450 4950
Wire Wire Line
	2250 5050 2250 4950
Connection ~ 2250 4950
Wire Wire Line
	3350 5050 3350 4950
Wire Wire Line
	3350 4950 3250 4950
Wire Wire Line
	2950 1600 3800 1600
Wire Wire Line
	3800 1600 3800 1650
Wire Wire Line
	3800 1950 3800 2000
Wire Wire Line
	3800 2400 3800 2500
Connection ~ 4200 2500
Wire Wire Line
	2950 1700 3400 1700
Wire Wire Line
	3400 1700 3400 1750
Wire Wire Line
	3400 2350 3400 2500
Connection ~ 3800 2500
Wire Wire Line
	5350 3200 5350 2850
Wire Wire Line
	5350 2850 6000 2850
Wire Wire Line
	6000 2850 6000 3000
Wire Wire Line
	5350 1100 5350 750 
Wire Wire Line
	5350 750  6900 750 
Wire Wire Line
	6000 750  6000 900 
Wire Wire Line
	6900 750  6900 900 
Connection ~ 6000 750 
Wire Wire Line
	5350 4300 5350 4350
Wire Wire Line
	5350 4350 6800 4350
Wire Wire Line
	6800 4350 6800 3600
Wire Wire Line
	4900 1300 4900 1450
Wire Wire Line
	4900 1750 4900 1950
$Comp
L Anritsu RL1
U 1 1 57CDC89B
P 6200 1200
F 0 "RL1" H 7050 1350 50  0000 L CNN
F 1 "Anritsu" H 7050 1250 50  0000 L CNN
F 2 "anritsu:anritsu" H 6200 1200 50  0000 C CNN
F 3 "" H 6200 1200 50  0000 C CNN
	1    6200 1200
	1    0    0    -1  
$EndComp
$Comp
L Anritsu RL2
U 1 1 57CDC8F4
P 6200 3300
F 0 "RL2" H 7050 3450 50  0000 L CNN
F 1 "Anritsu" H 7050 3350 50  0000 L CNN
F 2 "anritsu:anritsu" H 6200 3300 50  0000 C CNN
F 3 "" H 6200 3300 50  0000 C CNN
	1    6200 3300
	1    0    0    -1  
$EndComp
$Comp
L DX_MODULE U2
U 1 1 57CDD423
P 8400 1450
F 0 "U2" H 8900 1900 60  0000 C CNN
F 1 "DX_MODULE" H 8100 1900 60  0000 C CNN
F 2 "dx_module:dx_module" H 8400 1450 60  0001 C CNN
F 3 "" H 8400 1450 60  0001 C CNN
	1    8400 1450
	1    0    0    -1  
$EndComp
Wire Wire Line
	5350 2250 5350 2150
Wire Wire Line
	7750 2200 7750 1500
Connection ~ 5350 2200
Wire Wire Line
	6800 1500 6800 1600
Wire Wire Line
	6800 1600 7500 1600
Wire Wire Line
	7500 1600 7500 1100
Wire Wire Line
	7500 1100 7750 1100
Wire Wire Line
	9050 2200 9050 1500
Connection ~ 7750 2200
Wire Wire Line
	5350 2200 9050 2200
Wire Wire Line
	9050 1100 10400 1100
Wire Wire Line
	10400 1100 10400 1350
Wire Wire Line
	10400 1250 10300 1250
Wire Wire Line
	10400 1350 10300 1350
Connection ~ 10400 1250
Wire Wire Line
	9050 1650 9800 1650
Connection ~ 9050 1650
$Comp
L JUMPER JP1
U 1 1 57CDDF83
P 8400 2650
F 0 "JP1" H 8400 2800 50  0000 C CNN
F 1 "JUMPER" H 8400 2570 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x02" H 8400 2650 50  0000 C CNN
F 3 "" H 8400 2650 50  0000 C CNN
	1    8400 2650
	1    0    0    -1  
$EndComp
Wire Wire Line
	6900 3000 6900 2650
Wire Wire Line
	6900 2650 8100 2650
Wire Wire Line
	8700 2650 9400 2650
Wire Wire Line
	9400 2650 9400 1750
Wire Wire Line
	9400 1750 9800 1750
$Comp
L MC78L05ACP U1
U 1 1 57D0150E
P 2850 5000
F 0 "U1" V 2650 5200 50  0000 C CNN
F 1 "MC78L05ACP" H 2850 5200 50  0000 L CNN
F 2 "TO_SOT_Packages_THT:TO-92_Rugged" H 2850 5100 50  0000 C CIN
F 3 "" H 2850 5000 50  0000 C CNN
	1    2850 5000
	1    0    0    -1  
$EndComp
$EndSCHEMATC
