import processing.serial.*;

int i = 0;

int record = 0;
int puntuacion = 0;

Serial myPort;  //Objeto de clase serial
int valActual = 0;  //Datos recibidos por el Puerto serial

int posXSub = 0; //Posición X del submarino
int posYSub = 250; //Posición Y del submarino
int posXFondo1 = 0;
int posYFondo1 = 0;
int posXFondo2 = 1000;
int posYFondo2 = 0;
int posXEnemigo1 = 500;
int posYEnemigo1 = 200;
int posXEnemigo2 = 1000;
int posYEnemigo2 = 400;

boolean recogida = false;

PImage titulo;
PImage fondo1;
PImage fondo2;
PImage submarino;
PImage enemigo;
PImage enemigo2;

//Inicialización de la ventana y el puerto serie
void setup(){
  size(500, 500);
  
  titulo = loadImage("titulo.png");
 
  fondo1 = loadImage("fondo.png");
  fondo2 = loadImage("fondo.png");
  submarino = loadImage("submarino.png");
  enemigo = loadImage("enemigo.png");
  enemigo2 = loadImage("enemigo2.png");
  
  String portName = Serial.list()[0]; 
  myPort = new Serial(this, portName, 9600);
}


void draw(){
  print(i);
  switch(i){
    case 0:
     image(titulo, 0, 0, 500, 500);
     textSize(40);
     fill(0,0,0);
     text(""+record,290, 457);
     break;
    case 1:
     image(fondo1, posXFondo1, posYFondo1, 1000, 500);
     image(fondo2, posXFondo2, posYFondo2, 1000, 500); 
     image(submarino, posXSub, posYSub, 125, 125);
     image(enemigo, posXEnemigo1, posYEnemigo1, 200, 100);
     image(enemigo2, posXEnemigo2, posYEnemigo2, 200, 100);
     
     String sensorValue = myPort.readStringUntil('\n');
      
     if ( sensorValue!=null){  //If data is available,  
      valActual = int(trim(sensorValue));  //Lo guarda en val  
      } 
     //println(valActual); //Lo muestra por consola
     
     //Desplazamiento del fondo
     posXFondo1 = desplazaFondo(posXFondo1);
     posXFondo2 = desplazaFondo(posXFondo2);
     
     //Movimiento personaje principal
     if (valActual > 200){
      posYSub = posYSub - 5; 
     } else if(valActual > 125){
       posYSub = posYSub - 2;
     } else if(valActual > 75){
       posYSub = posYSub + 2;
     } else {
       posYSub = posYSub + 5;
     }
     
     //Movimiento Enemigos
     if(posXEnemigo1 < -200){
       posYEnemigo1 = (int)random(10, 400);
       posXEnemigo1 = 700;
     } else {
       posXEnemigo1 = posXEnemigo1 - 4;
     }
     
     if(posXEnemigo2 < -200){
       posYEnemigo2 = (int)random(10, 400);
       posXEnemigo2 = 700;
     } else {
       posXEnemigo2 = posXEnemigo2 - 4;
     }
     
     //Al chocar con el enemigo del tipo 1
     if (((posXSub>=posXEnemigo1 && posXSub<=posXEnemigo1+200)  || (posXSub+125>=posXEnemigo1 && posXSub+125<=posXEnemigo1+200)) && ((posYSub>=posYEnemigo1 && posYSub<=posYEnemigo1+100)  || (posYSub+125>=posYEnemigo1 && posYSub+125<=posYEnemigo1+100))){
      if(record < puntuacion) {
        record = puntuacion;
      }  
      posXSub = 0; //Posición X del submarino
      posYSub = 250; //Posición Y del submarino
      posXFondo1 = 0;
      posYFondo1 = 0;
      posXFondo2 = 1000;
      posYFondo2 = 0;
      posXEnemigo1 = 500;
      posYEnemigo1 = 200;
      posXEnemigo2 = 1000;
      posYEnemigo2 = 200;
      i = 0;
     }
     
     //Al chocar con el enemigo del tipo 2
     if (((posXSub>=posXEnemigo2 && posXSub<=posXEnemigo2+200)  || (posXSub+125>=posXEnemigo2 && posXSub+125<=posXEnemigo2+200)) && ((posYSub>=posYEnemigo2 && posYSub<=posYEnemigo2+100)  || (posYSub+125>=posYEnemigo2 && posYSub+125<=posYEnemigo2+100))){
      if(record < puntuacion) {
        record = puntuacion;
      }  
      posXSub = 0; //Posición X del submarino
      posYSub = 250; //Posición Y del submarino
      posXFondo1 = 0;
      posYFondo1 = 0;
      posXFondo2 = 1000;
      posYFondo2 = 0;
      posXEnemigo1 = 500;
      posYEnemigo1 = 200;
      posXEnemigo2 = 1000;
      posYEnemigo2 = 200;
      i = 0;
     }
     
    
     //Movimiento moneda
     
     
     //Al chocar con una moneda
      if(!recogida){
        puntuacion++;
        recogida = true;
      }
     
     
     break;
  }
}

void mousePressed(){
  if (i == 0){
    i = 1;
  }
}

int desplazaFondo(int posX){
  if (posX > -1000){
    //print(posX);
    return posX-1;
  } else {
    return 1000;
  }
}
