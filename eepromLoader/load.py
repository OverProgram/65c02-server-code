import sys
import json
from eeprom import EEPROM

IO_PORTS = []
A_PORTS = []
CE_PORT = None
WE_PORT = None
OE_PORT = None


def chunks(lst, size):
    for i in range(0, len(lst), size):
        yield lst[i:i + size]


def load(raw_data, eeprom):
    current_address = 0
    for byte in raw_data:
        eeprom.write_byte(current_address, byte)
        while eeprom.is_writing():
            pass
        current_address += 1


if __name__ == '__main__':
    with open('config.json') as config:
        config_json = json.loads(config.read())
        eeprom_ports = EEPROM(config_json['A'], config_json['IO'],
                              config_json['CE'], config_json['WE'], config_json['OE'])
        with open(sys.argv[1], 'rb') as f:
            load(f.read(), eeprom_ports)
        eeprom_ports.close()
