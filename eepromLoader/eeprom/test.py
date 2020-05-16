#!/usr/bin/env python3
from eeprom import EEPROM
import RPi.GPIO as GPIO
import json, time, sys

GPIO.setmode(GPIO.BCM)
with open("config.json") as f:
	try:
		config_data = json.loads(f.read())
		eeprom = EEPROM(config_data['A'], config_data['IO'], ce_port=config_data['CE'], we_port=config_data['WE'], oe_port=config_data['OE'])

		GPIO.output(eeprom.oe, 1)
		input('Testing OE')
		GPIO.output(eeprom.oe, 0)

		GPIO.output(eeprom.we, 1)
		input('Testing WE')
		GPIO.output(eeprom.we, 0)

		GPIO.output(eeprom.ce, 1)
		input('Testing CE')
		GPIO.output(eeprom.ce, 0)

	finally:
		GPIO.cleanup()
		print()
