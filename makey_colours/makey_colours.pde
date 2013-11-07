import processing.video.*;

int r, g, b, a;
String direction;
int dir; //counting direction
int inc = 5;  //counting increment
PFont font;
MovieMaker mm;

void setup() {
  size(600, 600);
  smooth();
  mm = new MovieMaker(this,width,height,"makey_colours.mov", 30, MovieMaker.JPEG, MovieMaker.HIGH);
  noStroke();
  background(255);
  font = createFont("Helvetica-Bold", 16);
  textFont(font);
  setBlack();
  //  frameRate(1);
}

void draw() {         
  fill(255, 3);
  rect(0, 0, width, height);

  fill(r, g, b, 255-a);
  ellipse(random(width), random(height), 50, 50);
  printValues();

  mm.addFrame();
}



void keyPressed() {
  if (key == ' ') {
    setBlack();
  } else if(key == 'f'){
     mm.finish();  //export movie
  }
  else if (keyCode == UP) {
    a += dir*inc;
    println("alpha: "+a);
  } 
  else if (keyCode == LEFT) {
    r += dir*inc;
    println("red: "+r);
  } 
  else if (keyCode == DOWN) {
    g += dir*inc;
    println("green: "+g);
  } 
  else if (keyCode == RIGHT) {
    b += dir*inc;
    println("blue: "+b);
  } 
  roundValues();
}

void roundValues() {
  r = max(0, min(r, 255));
  g = max(0, min(g, 255));
  b = max(0, min(b, 255));
  a = max(0, min(a, 255));
}

void printValues() {
  fill(255);
  rect(0, 0, width, 30);
  fill(r, g, b, 255-a);
  rect(width-(width/6), 0, width/6, 30); //draw swatch
  fill(0);
  text("Red: "+r+" | Green: "+g+" | Blue: "+b+" | Trans: "+a+" | Counting "+direction, 10, 20);
}

void setBlack() {
  fill(0); 
  r = 0;
  g = 0;
  b = 0;
  a = 0;
  direction = "up";
  dir = 1;
  println("Back to black");
}

void setWhite() {
  fill(255); 
  r = 255;
  g = 255;
  b = 255;
  a = 255;
  direction = "down";
  dir = -1;
  println("Back to white");
}

void mousePressed() {
  //swap direction of colour change, without resetting values
  if (dir == 1) {
    direction = "down";
    dir = -1;
  } 
  else {
    direction = "up";
    dir = 1;
  }
}

