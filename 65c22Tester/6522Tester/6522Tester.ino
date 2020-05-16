#define PHI 12

char DATA[] = {0, 1, 2, 3, 4, 5, 6, 7};
char RS[] = {8, 9, 10, 11};

void pulse() {
  digitalWrite(PHI, LOW);
  delay(10);
  digitalWrite(PHI, HIGH);
  delay(100);
  digitalWrite(PHI, LOW);
}

void setData(char value) {
  char dataWord[8];
  for (int i = 0; i < 8; i++) {
    dataWord[i] = ((value >> i) & 0x01) == 0 ? LOW : HIGH;
  }

  for (int i = 0; i < 8; i++) {
    digitalWrite(DATA[i], dataWord[i]);
  }
}

void setRs(char value) {
  char dataWord[4];
  for (int i = 0; i < 4; i++) {
    dataWord[i] = ((value >> i) & 0x01) == 0 ? LOW : HIGH;
  }

  for (int i = 0; i < 4; i++) {
    digitalWrite(RS[i], dataWord[i]);
  }
}

void cycle(char data, char rs) {
  setRs(rs);
  setData(data);
  pulse();
}

void setup() {
  for (int i = 0; i < 8; i++) {
    pinMode(DATA[i], OUTPUT);
  }
  
  for (int i = 0; i < 4; i++) {
    pinMode(RS[i], OUTPUT);
  }

  pinMode(PHI, OUTPUT);

  cycle(0xff, 0x02);
  cycle(0x00, 0x00);
}

void loop() {
  cycle(0x55, 0x00);
  delay(250);
  cycle(0xaa, 0x00);
  delay(250);
}
