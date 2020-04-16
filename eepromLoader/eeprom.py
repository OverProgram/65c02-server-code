import gpiozero as gpio
from time import sleep


class EEPROM(gpio.CompositeOutputDevice):

    MAX_ADDRESS = 8191

    def __init__(self, address_ports, data_ports, ce_port, we_port, oe_port):
        address_devices = []
        for address_port in address_ports:
            address_devices.append(gpio.DigitalOutputDevice(address_port))

        data_devices = []
        for data_port in data_ports:
            data_devices.append(gpio.DigitalOutputDevice(data_port))

        super().__init__(address=gpio.CompositeOutputDevice(*address_devices),
                         data=gpio.CompositeOutputDevice(*data_devices),
                         ce=gpio.DigitalOutputDevice(ce_port), we=gpio.DigitalOutputDevice(we_port),
                         oe=gpio.DigitalOutputDevice(oe_port))
        self.sdp_enabled = False

    def read(self, address):
        bit_address = self.to_bit_data(address, 13)
        self.we.on()
        self.address.value = bit_address
        self.oe.off()
        self.ce.off()
        data = self.data.value
        self.ce.on()
        self.oe.on()
        byte_data = 0
        for bit in data:
            if bit == 1:
                byte_data += 1
            byte_data = byte_data << 1
        byte_data = byte_data >> 1
        byte_data = byte_data | (data[len(data)-1] << (len(data)-1))
        return bytes([byte_data])

    def to_bit_data(self, data, length):
        bit_data = []
        for i in range(length):
            bit_data.append(b'\x01' if data & (1 << i) == 1 else b'\0')

        return tuple(bit_data)

    def write_byte(self, address, data, standalone=True):
        self.ce.on()
        self.oe.on()
        bit_data = self.to_bit_data(data, 8)
        bit_address = self.to_bit_data(address, 13)
        self.ce.off()
        self.address.value = bit_address
        self.we.off()
        sleep(50e-9)
        self.data.value = bit_data
        sleep(150e-9)
        self.we.on()
        if standalone:
            self.ce.on()

    def enable_sdp(self):
        if not self.sdp_enabled:
            self.write_byte(0x1555, 0xAA)
            self.write_byte(0x0AAA, 0x55)
            self.write_byte(0x1555, 0xA0)
            self.sdp_enabled = True

    def disable_sdp(self):
        if self.sdp_enabled:
            self.write_byte(0x1555, 0xAA)
            self.write_byte(0x0AAA, 0x55)
            self.write_byte(0x1555, 0x80)
            self.write_byte(0x1555, 0xAA)
            self.write_byte(0x0AAA, 0x55)
            self.write_byte(0x1555, 0x20)
            self.sdp_enabled = False

    def page_write(self, start_address, data):
        if 64 - (start_address & 0b111111) < len(data):
            return False

        if self.sdp_enabled:
            self.disable_sdp()

        current_address = int.from_bytes(start_address, byteorder='big')
        for byte in data:
            self.write_byte(current_address, byte, False)
            current_address += 1

        while self.is_writing():
            pass

        self.enable_sdp()
        return True

    def is_writing(self):
        read_one = self.read(0)
        read_two = self.read(0)
        return ((int.from_bytes(read_one, byteorder='big') & 0b1000000) >> 6) !=\
               ((int.from_bytes(read_two, byteorder='big') & 0b1000000) >> 6)
