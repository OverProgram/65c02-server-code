#!/usr/bin/env python3
from eeprom import EEPROM
import RPi.GPIO as GPIO
import json, time, sys

GPIO.setmode(GPIO.BCM)
with open("config.json") as f:
	try:
		config_data = json.loads(f.read())
		eeprom = EEPROM(config_data['A'], config_data['IO'], ce_port=config_data['CE'], we_port=config_data['WE'], oe_port=config_data['OE'])

		with open(sys.argv[1], 'rb') as f:
			raw_data = f.read()
			for i, byte in enumerate(raw_data):
				print('Writing byte number {}'.format(i), end='\r')
				eeprom.write(byte, i)
			print()
			print('Verifiying write...')
			for i, byte in enumerate(raw_data):
				print('Verifying byte number {}'.format(i), end='\r')
				verify_byte = eeprom.read(i)
				if verify_byte != byte:
					print('There was a problem at byte {}: expected {} but got {}'.format(i, byte, verify_byte))
					break
	finally:
		GPIO.cleanup()
		print()
