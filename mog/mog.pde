Table deptTable, issueTable;
int numYears, numIssues;
int xOffset = 100;
int yOffset = 140;
int dotsize = 20;
PFont big, small;
Map<String, Float> deptX = new HashMap();
Map<String, Float> deptY = new HashMap();
color colors[];

void setup() {
  size(1200, 650);
  background(255);
  fill(0);
  noStroke();
  smooth();
  big = createFont("Helvetica-Bold", 24);
  small = createFont("Helvetica-Bold", 12);
  deptTable = new Table("aao_short.txt");
  issueTable = new Table("issues.txt");
  numYears = deptTable.getRowCount();
  numIssues = issueTable.getRowCount();
  colors = new color[numIssues];
  loadColors(numIssues);
  println(numYears+" years, "+numIssues+" issues");
  //noLoop();
}

void loadColors(int numColors) {
  for (int i=0; i<numColors; i++) {
    //colors[i] = color(random(255), random(255), random(255));
    //float frac = float(i)/numColors*230;
    //colors[i] = color(frac,frac,frac);
    colorMode(HSB, numColors+3); //+3 reduces looping
    colors[i] = color(i, 50, 30);
    colorMode(RGB, 255);
  }
}

void draw() {
  background(255);
  //draw title
  fill(0);
  textFont(big);
  textAlign(LEFT);
  text("Machinery of Government 1901-2012", 10, 30);

  //draw departments across years
  for (int nyear = 0; nyear < numYears; nyear++) {
    //extract
    String syear = deptTable.getString(nyear, 0);
    String sdepts = deptTable.getString(nyear, 1);
    String[] adepts = split(sdepts, ", ");

    //set x-position:
    //row 0 at xOffset, row rowCount at width-xOffset, others evenly spaced
    Float xFrac = float(nyear)/(numYears - 1);
    Float x = xOffset + xFrac*(width-2*xOffset);

    //draw year label and number of depts label
    fill(0);
    textFont(big);
    textAlign(CENTER);
    text(syear, x, yOffset - 20);
    text(adepts.length, x, height - 10);

    //set y-positions by looping through depts, but between offset and height-50
    for (int dept = 0; dept < adepts.length; dept++) {
      Float yFrac = float(dept)/(adepts.length - 1);
      Float y = yOffset + yFrac*(height-yOffset-50);
      fill(0);
      noStroke();
      ellipse(x, y, dotsize, dotsize);
      textAlign(LEFT);
      textFont(small);
      text(adepts[dept], x + dotsize, y + 5);

      //store location in hashmap for reference by issues
      deptX.put(adepts[dept]+"-"+syear, x);
      deptY.put(adepts[dept]+"-"+syear, y);
    }
  }

  //draw issue lines
  for (int nissue = 0; nissue < numIssues; nissue++) {
    //extract
    String issue = issueTable.getString(nissue, 0);
    String sIssueDepts = issueTable.getString(nissue, 1);
    String[] aIssueDepts = split(sIssueDepts, ", ");

    //draw issue dot
    fill(colors[nissue]);
    noStroke();
    float xDot = 20+nissue*1.5*dotsize;
    float yDot = yOffset - 80;
    //if mouse close to dot, highlight dot and line, and draw label
    if (dist(xDot, yDot, mouseX, mouseY) < 10) {
      ellipse(xDot, yDot, dotsize, dotsize);
      rect(xDot - 5, yDot + 20, textWidth(issue)+10, 20);  
      triangle(xDot-5, yDot+20, xDot+5, yDot+20, xDot, yDot+dotsize/2);
      fill(255);
      text(issue, xDot, yDot+35);
      stroke(0);
      strokeWeight(5.0);
    } 
    else {
      noStroke();
      ellipse(xDot, yDot, dotsize, dotsize);
      strokeWeight(1.0);
    }

    //go through years and draw a line between each department having issue
    noFill();
    stroke(colors[nissue]);

    for (int id = 0; id<aIssueDepts.length; id++) {
      println(aIssueDepts[id]);
      float xid = deptX.get(aIssueDepts[id]);
      float yid = deptY.get(aIssueDepts[id]);
      if (id == 0) {
        beginShape(); 
        curveVertex(xid, yid);
        curveVertex(xid, yid); // add another as control point
      } 
      else if (id == aIssueDepts.length-1) {
        curveVertex(xid, yid);
        curveVertex(xid, yid); // add another as control point
        endShape();
      } 
      else {
        curveVertex(xid, yid); // just add as normal
      }
    }
  }
}

