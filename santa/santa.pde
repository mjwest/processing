import processing.video.*;

Table data;
int numCities = 800;
String[] names = new String[numCities];
String[] countries = new String[numCities];
int[] children = new int[numCities];
int[] neighbours = new int[numCities];
int[][] coords = new int[numCities][2];
int nextLink = 0;
int easternmost = 0;
int opacity = 255;
float travelled = 0;
int visited = 0;
int w = 1000;
int h = 500;
int y = 80;
float pixelsToMm = (TWO_PI*6.378)/w; //converts to Mm i.e. 1000 km
boolean labelShown = false;
ArrayList taken = new ArrayList();
ArrayList searched = new ArrayList();
PFont heading, city, distance;
MovieMaker mm;

void setup() {
  size(w, h);
  smooth();
  mm = new MovieMaker(this,width,height,"test2.mov", 30, MovieMaker.JPEG, MovieMaker.HIGH);
  data = new Table("cities.txt");
  println("Loaded "+data.getRowCount()+" cities");
  generateCoords();
  generateNeighbours();
  ellipseMode(CENTER);
  strokeWeight(1.5);
  stroke(255, 0, 0);
  heading = createFont("GlengaryNF", 50);
  city = createFont("Helvetica-Bold", 20);
  distance = createFont("Helvetica", 15);
  frameRate(50);
      background(255, 0, 0);
    fill(255);
    textAlign(CENTER);
    textFont(heading);
    text("Travelling Santa", width/2, height/2);
    mm.addFrame();
    textAlign(LEFT); 
    background(255);
}

void generateCoords() {
  println("Generating pixel coordinates");
  float easternmostLon = 0.0;
  for (int i=0; i < numCities; i++) {
    //city names
    names[i] = data.getString(i, 0);
    countries[i] = data.getString(i, 1);
    children[i] = round(data.getFloat(i, 2) / 6.0);

    //longitude coordinate
    float degLon = data.getFloat(i, 7);
    if (data.getString(i, 8).equals("E")) {
      coords[i][0] = round(width/2 + width/2*(degLon/180.0));
      if (degLon > easternmostLon) {
        easternmostLon = degLon;
        easternmost = i;
      }
    } 
    else {
      coords[i][0] = round(width/2 - width/2*(degLon/180.0));
    }

    //latitude coordinate
    float degLat = data.getFloat(i, 4);
    if (data.getString(i, 5).equals("N")) {
      coords[i][1] = round(height/2 - height/2*(degLat/90.0));
    } 
    else {
      coords[i][1] = round(height/2 + height/2*(degLat/90.0));
    }
  }
}

void generateNeighbours() {
  println("Generating Santa's flight plan");
  int next = 0;

  //force start  
  //int firstCity = findNeighbour(0); //start at closest city to North Pole
  int firstCity = easternmost; //start at easternmost city, for timezones

  neighbours[0] = firstCity;
  searched.add(0);
  taken.add(0); //don't allow mid-run trips back to workshop
  taken.add(firstCity);
  next = firstCity;

  while (taken.size () < numCities) {
    int store = next;
    next = findNeighbour(next); //find neighbour and use neighbour as next search target
    neighbours[store] = next; //store neighbour
    taken.add(next); //mark neighbour as taken so it cannot become another's neighbour
    searched.add(store);
  }
  println("Flight plan complete");

  //print links
  /*for (int i=0; i<numCities; i++) {
   println(names[i]+ " > "+names[neighbours[i]]);
   }*/
}

int findNeighbour(int i) {
  float minDistance = 10000.0;
  float thisDistance = 0.0;
  int nearest = 0;
  for (int j=0; j < numCities; j++) { 
    if (i == j || taken.contains(j) || searched.contains(j)) { //can't be neighbour to self or existing neighbour
      continue;
    }
    thisDistance = dist(coords[i][0], coords[i][1], coords[j][0], coords[j][1]);
    if (thisDistance < minDistance) {
      minDistance = thisDistance;
      nearest = j;
    }
  }
  return nearest;
}

void draw() {

  if (nextLink >= 0) {
    nextLink = drawNextLink(nextLink);
  } else {
    fill(255);
    noStroke();
    rect(20, 0, 470, 140);
  fill(0);
  textFont(heading);
  text("Travelling Santa", 20, 50);
  textFont(city);
  text("Travels complete!", 20, 80);
  text("Travelled "+round(travelled*pixelsToMm)+ ",000 km", 20, 100);      
  text("Visited "+nfc(visited*10)+" children", 20, 120);
   loadPixels();
  mm.addFrame();
  mm.finish();
  }
  //nextLink = 0;    
  opacity = 255;
  labelShown = false;
  //travelled = 0;
  mm.addFrame();
}

int drawNextLink(int i) {
  fill(255, random(255), random(255), opacity);
  ellipse(coords[i][0], coords[i][1] + y, 10, 10);
  int n = neighbours[i];

  if (dist(mouseX, mouseY, coords[i][0], coords[i][1] + y) < 5 && !labelShown) {
    fill(0);
    textFont(city);
    text(names[i]+", "+countries[i], 20, 80);
    textFont(distance);
    if(i == 0){
      text("Ready to launch!", 20, 100);
    } else {
      text("Travelled "+round(travelled*pixelsToMm)+ ",000 km so far", 20, 100);      
    }

    opacity = 50;
    labelShown = true;
  } 
  fill(255);
  noStroke();
  rect(20, 0, 470, 140);
  fill(0);
  textFont(heading);
  text("Travelling Santa", 20, 50);

  textFont(city);
  text("Now in "+names[i]+", "+countries[i], 20, 80);
  //text("Now in "+countries[i], 20, 80);
  text("Travelled "+round(travelled*pixelsToMm)+ ",000 km", 20, 100);      
  text("Visited "+nfc(visited*10)+" children", 20, 120);
    

  stroke(255, 0, 0, opacity);
  line(coords[i][0], coords[i][1] + y, coords[n][0], coords[n][1] + y);

  travelled += dist(coords[i][0], coords[i][1], coords[n][0], coords[n][1]);
  visited += children[i];

  if (n == 0) {
    return -1;
  } 
  else {  
    return n;
  }
}

void mousePressed()
{
 nextLink = 0;
 background(255); 
 travelled = 0;
 visited = 0;
}

