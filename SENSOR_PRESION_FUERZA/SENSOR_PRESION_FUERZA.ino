int sensor_fuerza= A0;
int lectura;
void setup()
{ 
  Serial.begin(9600);
}

void loop()
{
lectura = analogRead(sensor_fuerza); // La lectura del sensor (Analog 0)
Serial.println(lectura); 
delay(100); //Cien “ms” de espera en cada lectura
}
