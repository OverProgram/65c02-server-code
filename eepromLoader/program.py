import load
import read
import json
import sys
from eeprom import EEPROM


def main():
    with open(sys.argv[1], 'rb') as f:
        raw_data = f.read()
        if len(raw_data) != EEPROM.MAX_ADDRESS:
            print("Invalid file length! Expected " + str(EEPROM.MAX_ADDRESS) + " got " + str(len(raw_data)))
        else:
            with open('config.json') as config:
                config_json = json.loads(config.read())
                eeprom_ports = EEPROM(config_json['A'], config_json['IO'],
                                      config_json['CE'], config_json['WE'], config_json['OE'])
                print("Writing data to eeprom...")
                load.load(raw_data, eeprom_ports)

                print("Verifying write...")
                verify_data = read.read(eeprom_ports)
                for i in range(EEPROM.MAX_ADDRESS):
                    if raw_data[i] != verify_data[i]:
                        print('There was a problem at byte ' + str(i) + ': Expected value was ' + str(raw_data[i]) +
                              ' but the value read was ' + str(verify_data[i]))
                        break
                    if i % 1000 == 0:
                        print("Im at the " + str(i) + " byte already!")


if __name__ == '__main__':
    main()
