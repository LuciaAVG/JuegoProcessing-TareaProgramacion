import processing.serial.*;

int i = 0;

int record = 0;
int puntuacion = 0;

Serial myPort;  //Objeto de clase serial
int valActual = 0;  //Datos recibidos por el Puerto serial

int posXPez = 10; //Posición X del submarino
int posYPez = 250; //Posición Y del submarino
int posXFondo1 = 0;
int posYFondo1 = 0;
int posXFondo2 = 1000;
int posYFondo2 = 0;
int posXEnemigo1 = 500;
int posYEnemigo1 = 200;
int posXEnemigo2 = 1000;
int posYEnemigo2 = 400;
int posXEstrella = 800;
int posYEstrella = 300;

boolean recogida = false;

PImage titulo;
PImage tituloAyuda;
PImage fondo1;
PImage fondo2;
PImage pez;
PImage enemigo;
PImage enemigo2;
PImage estrella;

//Inicialización de la ventana y el puerto serie
void setup(){
  size(500, 500);
  
  titulo = loadImage("tituloYAyuda.png");
  tituloAyuda = loadImage("ayuda.png");
 
  fondo1 = loadImage("fondo.png");
  fondo2 = loadImage("fondo.png");
  pez = loadImage("pez.png");
  enemigo = loadImage("enemigo.png");
  enemigo2 = loadImage("enemigo2.png");
  estrella = loadImage("estrella.png");
  
  String portName = Serial.list()[0]; 
  myPort = new Serial(this, portName, 9600);
}


void draw(){
  
  //Cambiar entre pantalla de titulo y juego
  switch(i){
    case -1:
      image(tituloAyuda, 0, 0, 500, 500);
      break;
    case 0:
     image(titulo, 0, 0, 500, 500);
     textSize(40);
     fill(0,0,0);
     text(""+record,290, 457);
     break;
    case 1:
     image(fondo1, posXFondo1, posYFondo1, 1000, 500);
     image(fondo2, posXFondo2, posYFondo2, 1000, 500); 
     image(pez, posXPez, posYPez, 50, 50);
     image(enemigo, posXEnemigo1, posYEnemigo1, 200, 100);
     image(enemigo2, posXEnemigo2, posYEnemigo2, 200, 100);
     image(estrella, posXEstrella, posYEstrella, 50, 50);
     textSize(40);
     fill(0,0,0);
     text(""+puntuacion, 450, 50);
     
     String sensorValue = myPort.readStringUntil('\n');
      
     if ( sensorValue!=null){  //If data is available,  
      valActual = int(trim(sensorValue));  //Lo guarda en val  
      } 
     //println(valActual); //Lo muestra por consola
     
     //Desplazamiento del fondo
     posXFondo1 = desplazaFondo(posXFondo1);
     posXFondo2 = desplazaFondo(posXFondo2);
     
     
     //------------Movimiento personaje principal------------
     //Desplazamiento segun la fuerza recibida por el sensor de fuerza
     if (valActual > 200){
      posYPez = posYPez - 5; 
     } else if(valActual > 125){
       posYPez = posYPez - 2;
     } else if(valActual > 75){
       posYPez = posYPez + 2;
     } else {
       posYPez = posYPez + 5;
     }
     //Limites del desplazamiento en vertical
     if(posYPez < 0) { 
       posYPez = 0;
     }
     if(posYPez >450) { 
       posYPez = 450;
     }
     
     //----------------Movimiento Enemigos----------------
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
     if (((posXPez+25>=posXEnemigo1+50 && posXPez+25<=posXEnemigo1+150)  || (posXPez+75>=posXEnemigo1+50 && posXPez+75<=posXEnemigo1+150)) && ((posYPez+25>=posYEnemigo1+50 && posYPez+25<=posYEnemigo1+150)  || (posYPez+75>=posYEnemigo1+50 && posYPez+75<=posYEnemigo1+150))){
      if(record < puntuacion) {
        record = puntuacion;
      }  
      reinicio();
     }
     
     //Al chocar con el enemigo del tipo 2
     if (((posXPez+25>=posXEnemigo2+50 && posXPez+25<=posXEnemigo2+150)  || (posXPez+75>=posXEnemigo2+50 && posXPez+75<=posXEnemigo2+150)) && ((posYPez+25>=posYEnemigo2+50 && posYPez+25<=posYEnemigo2+150)  || (posYPez+75>=posYEnemigo2+50 && posYPez+75<=posYEnemigo2+150))){
      if(record < puntuacion) {
        record = puntuacion;
      }  
      reinicio();
     }
     
    
     //----------------Movimiento estrella----------------
     if(posXEstrella < -50){
       posYEstrella = (int)random(10, 400);
       posXEstrella = 500;
     } else {
       posXEstrella = posXEstrella - 2;
     }
     
     //Al chocar con una estrella
     if (((posXPez>=posXEstrella && posXPez<=posXEstrella+50)  || (posXPez+50>=posXEstrella && posXPez+50<=posXEstrella+50)) && ((posYPez>=posYEstrella && posYPez<=posYEstrella+50)  || (posYPez+100>=posYEstrella && posYPez+100<=posYEstrella+50))){
       puntuacion++;
       posYEstrella = (int)random(10, 400);
       posXEstrella = 500;
      
     }
     
     
     break;
  }
}

//Hacer click para cambiar entre pantallas del juego
void mousePressed(){  
  if (i == 0){
    if(mouseX>400 && mouseX<500 && mouseY>10 && mouseY<60 ){
      i = -1;
    } else{
      i = 1;
    }
  }
  
  else if (i == -1){
    i = 0;
  }
}

//Desplazamiento del fondo
int desplazaFondo(int posX){
  if (posX > -1000){
    //print(posX);
    return posX-1;
  } else {
    return 1000;
  }
}

void reinicio(){
    posXPez = 0; //Posición X del pez
    posYPez = 250; //Posición Y del pez
    posXFondo1 = 0;
    posYFondo1 = 0;
    posXFondo2 = 1000;
    posYFondo2 = 0;
    posXEnemigo1 = 500;
    posYEnemigo1 = 200;
    posXEnemigo2 = 1000;
    posYEnemigo2 = 200;
    i = 0;
    puntuacion = 0;
}
