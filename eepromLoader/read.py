import json
from eeprom import EEPROM


def read(eeprom, read_range=range(EEPROM.MAX_ADDRESS)):
    data = b''
    for address in read_range:
        data += eeprom.read(address)
    return data


if __name__ == '__main__':
    with open('config.json') as config:
        config_json = json.loads(config.read())
        eeprom_ports = EEPROM(config_json['A'], config_json['IO'],
                              config_json['CE'], config_json['WE'], config_json['OE'])
        print(read(eeprom_ports))
        eeprom_ports.close()

