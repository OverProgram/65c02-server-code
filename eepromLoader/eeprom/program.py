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

		with open(sys.argv[1], 'rb') as f:
			raw_data = f.read()
			print('Writing...')
			for i, byte in enumerate(raw_data):
				print('Writing byte number {}/{}'.format(i+1, len(raw_data)), end='\r')
				if byte != current_data[i]:
					eeprom.write(byte, i)
					time.sleep(0.1)
			print()
			print('Verifiying write...')
			with open('a.in', 'wb') as out:
				for i, byte in enumerate(raw_data):
					print('Verifying byte number {}/{}'.format(i+1, len(raw_data)), end='\r')
					verify_byte = eeprom.read(i)
					if verify_byte != byte:
						print('There was a problem at byte {}: expected {} but got {}'.format(i, byte, verify_byte))
						break
					out.write(bytes([verify_byte]))
	finally:
		GPIO.cleanup()
		print()
