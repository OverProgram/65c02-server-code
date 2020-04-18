import RPi.GPIO as GPIO
import time


class EEPROM:

	def __init__(self, address_ports, data_ports, ce_port, we_port, oe_port):
		self.address_ports = address_ports
		self.data_ports = data_ports
		self.ce = ce_port
		self.we = we_port
		self.oe = oe_port

		for address in address_ports:
			GPIO.setup(address, GPIO.OUT)
		GPIO.setup(ce_port, GPIO.OUT)
		GPIO.setup(we_port, GPIO.OUT)
		GPIO.setup(oe_port, GPIO.OUT)
		GPIO.output(self.we, 1)
		GPIO.output(self.oe, 1)
		GPIO.output(self.ce, 0)

	def write_to_address(self, value):
		value_bits = self.to_bit_data(value, 13)
#		print('write_to_address ({}): '.format(value), end='')
		for i, address in enumerate(self.address_ports):
#			print('{} '.format(value_bits[i]), end='')
			GPIO.output(address, value_bits[i])
#		print()

	def write_to_data(self, value):
		self.setup_data_write()
#		print('write_to_data ({}): '.format(value), end='')
		value_bits = self.to_bit_data(value, 8)
		for i, data in enumerate(self.data_ports):
#			print('{} '.format(value_bits[i]), end='')
			GPIO.output(data, value_bits[i])
#		print()

	def read_from_data(self):
		self.setup_data_read()
		byte = 0
#		print('read_from_data: ', end='')
		for i, data in enumerate(self.data_ports):
			bit = GPIO.input(data)
#			print('{} '.format(bit), end='')
			byte += (1 << i) * bit
#		print(': ({})'.format(byte))
		return byte


	def setup_data_read(self):
		for data in self.data_ports:
			GPIO.setup(data, GPIO.IN)

	def setup_data_write(self):
		for data in self.data_ports:
			GPIO.setup(data, GPIO.OUT)

	def write(self, data, address):
		GPIO.output(self.oe, 1)
		self.write_to_address(address)
#		GPIO.output(self.we, 0)
#		time.sleep(0.1)
		self.write_to_data(data)
		GPIO.output(self.we, 0)
		time.sleep(0.01)
		GPIO.output(self.we, 1)
		time.sleep(0.01)
		GPIO.output(self.oe, 0)
#		while (self.read(address) & 0x80) != (data & 0x80):
#			pass

	def read(self, address):
		self.write_to_address(address)
#		time.sleep(0.1)
		GPIO.output(self.oe, 0)
#		time.sleep(0.5)
		data = self.read_from_data()
#		GPIO.output(self.oe, 1)
		return data

	@staticmethod
	def to_bit_data(data, length):
		bit_data = []
		for i in range(length):
			bit_data.append(1 if data & (1 << i) != 0 else 0)

		return tuple(bit_data)

