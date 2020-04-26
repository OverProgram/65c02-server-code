#!/usr/bin/env python3
from eeprom import EEPROM
import RPi.GPIO as GPIO
import json, time, sys

GPIO.setmode(GPIO.BCM)
with open("config.json") as f:
	try:
		config_data = json.loads(f.read())
		eeprom = EEPROM(config_data['A'], config_data['IO'], ce_port=config_data['CE'], we_port=config_data['WE'], oe_port=config_data['OE'])

		print('Reading current data...')

		current_data = []
		for i in range(0x1fff):
			current_data.append(eeprom.read(i))

		with open(sys.argv[1], 'wb') as f:
			print('Dumping into file')
			for byte in current_data:
				f.write(bytes([byte]))

	finally:
		GPIO.cleanup()
		print()
