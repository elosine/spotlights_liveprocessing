
import fisica.*;
import oscP5.*;
import netP5.*;

FWorld mundo;

PGraphics bglayer;
PGraphics masklayer;

float frmrate = 24;
float secperframe = 1.0/frmrate;

int w = 1066;
int h = 600;

float gravityx = 0.0;
float gravityy = 0.0;

int maskalpha = 11;

OscP5 meosc;
NetAddress sc;

FBox safetyedgeL, safetyedgeR, safetyedgeT, safetyedgeB;

ArcsAndLinesDrawz aldrwset;

ArcsAndLines al;







void setup() {

  size(1066, 600, P2D);
  // frameRate(frmrate);

  al = new ArcsAndLines(65, 4);


  meosc = new OscP5(this, 1231);
  sc = new NetAddress("127.0.0.1", 57120);

  bglayer = createGraphics(w, h, P3D);
  masklayer = createGraphics(w, h, P2D);

  Fisica.init(this);
  mundo = new FWorld();
  mundo.setEdges();
  mundo.setGravity(gravityx, gravityy);

  mundo.top.setName("edg_t");
  mundo.bottom.setName("edg_b");
  mundo.left.setName("edg_l");
  mundo.right.setName("edg_r");


  aldrwset = new ArcsAndLinesDrawz();

  meosc.plug(spots, "mkinst", "/mkspot");
  meosc.plug(spots, "rmv", "/rmvspot");
  meosc.plug(spots, "hit", "/hit");
  meosc.plug(spots, "push", "/push");
  meosc.plug(spots, "sizesawon", "/sawon");
  meosc.plug(spots, "sizesawoff", "/sawoff");
  meosc.plug(spots, "chgSAtype", "/chgShortAttack");
  meosc.plug(spots, "halt", "/haltspot");
  meosc.plug(spots, "haltall", "/haltall");
  meosc.plug(spots, "go2", "/goto");
  meosc.plug(spots, "lift", "/lift");
  meosc.plug(spots, "liftall", "/liftall");
  meosc.plug(spots, "setvelocity", "/setvel");
  meosc.plug(spots, "adjvelocity", "/adjvel");
  meosc.plug(spots, "setbounce", "/setbounce");
  meosc.plug(spots, "go", "/go");
  meosc.plug(spots, "goall", "/goall");
  meosc.plug(spots, "spin", "/spin");
  meosc.plug(spots, "reSize", "/sz");
  meosc.plug(spots, "orbit", "/orbit");
  meosc.plug(spots, "orbitoff", "/orbitoff");
  meosc.plug(spots, "orbitspd", "/orbitspd");

  meosc.plug(setOSticks, "mk", "/mkstick");
  meosc.plug(setOSticks, "rmv", "/rmvstick");

  meosc.plug(this, "setgravity", "/setgravity");

  meosc.plug(squigglez, "mk", "/mksqig");
  meosc.plug(squigglez, "animate", "/anisqig");
  meosc.plug(squigglez, "rmv", "/rmvsqig");

  meosc.plug(aldrwset, "mk", "/mkal");
  meosc.plug(aldrwset, "rmv", "/rmval");
  meosc.plug(aldrwset, "rmvall", "/rmvallal");
  
 meosc.plug(spSqDetectz, "mk", "/mkspSqDetect");
 meosc.plug(spSqDetectz, "rmv", "/rmvspSqDetect");
}



void draw() {
  background(0);

  bglayer.beginDraw(); //////////////////////////////
  bglayer.fill(0, 0, 0, 170);
  bglayer.rectMode(CORNER);
  bglayer.rect(0, 0, width, height);

  squigglez.drw(bglayer);
  aldrwset.drw(bglayer);
  spots.drwbglayer(); //gives pixel ct
  bglayer.endDraw(); ///////////////////////////////


  masklayer.beginDraw(); //////////////////////////////
  masklayer.background(maskalpha, maskalpha, maskalpha);

  mundo.step();
  mundo.draw(masklayer);
  masklayer.endDraw(); ////////////////////////////


  bglayer.mask(masklayer);

  image(bglayer, 0, 0);

  //DETECTION LAYER ////////////////////////////////////
  spSqDetectz.drw();

  //TOP LAYER ////////////////////////////////////
  spots.drwTopLayer();
  setOSticks.drwset();
  //squigglez.drw(g); //'g' is global variable to refer to the man PApplet's PGraphics


  /*
if(millis()>0 && millis()<30000000){
   saveFrame("render-###.tif");
   delay(100);
   */


  //
  //
  //
}//End Draw



void contactResult(FContactResult c) {
  boolean sp1b = false;
  boolean sp2b = false;
  FBody obs = c.getBody1();
  for (int i=spots.clset.size ()-1; i>=0; i--) {
    Spotlight inst = spots.clset.get(i);
    //if body 1 is a spotlight then store spotlight in local variable
    if (c.getBody1() == inst.sl) {
      inst.hit(c.getBody2().getName(), c.getNormalImpulse());
    } 

    if (c.getBody2() == inst.sl) {
      inst.hit(c.getBody1().getName(), c.getNormalImpulse());
    }
  }
}



void setgravity(float gx, float gy) {
  mundo.setGravity(gx, gy);
}


void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.isPlugged()==false) {
    println("### received an osc message.");
    println("### addrpattern\t"+theOscMessage.addrPattern());
    println("### typetag\t"+theOscMessage.typetag());
  }
}



class CrookedLine {
  int x1, y1, x2, y2, numpts;
  float w;
  PVector start, dir, end, pp1;
  PVector[] pts;
  float[] segs;
  PGraphics b;


  CrookedLine(PGraphics argb, int ax1, int ay1, int ax2, int ay2, int anumpts, float aw) {
    b = argb;
    x1 = ax1;
    y1 = ay1;
    x2 = ax2;
    y2 = ay2;
    numpts = anumpts;
    w = aw;

    start = new PVector(x1, y1);
    dir = new PVector(x2, y2);
    end = PVector.add(start, dir);
    pts= new PVector[numpts];

    pp1 = new PVector(dir.y, -dir.x);
    pp1.normalize();
    pp1.mult(w/2.0);

    segs = new float[numpts];
    for (int i=0; i<segs.length; i++) {
      segs[i] = random(0.10, 0.9);
    }
    segs = sort(segs);

    for (int i=0; i<numpts; i++) {
      pts[i] = PVector.add( start, PVector.mult( dir, segs[i] ));
      pts[i] = PVector.add( pts[i], PVector.mult( pp1, random(-1.0, 1.0) ) );
    }
  }

  void drw(float locx, float locy, float deg) {
    b.noFill();
    b.pushMatrix();
    b.translate(locx, locy);
    b.rotate(radians(deg));
    b.beginShape();
    b.curveVertex(start.x, start.y);
    b.curveVertex(start.x, start.y);
    for (int i=0; i<pts.length; i++) {
      b.curveVertex(pts[i].x, pts[i].y);
    }
    b.curveVertex(end.x, end.y);
    b.curveVertex(end.x, end.y);
    b.endShape();

    b.popMatrix();
  }
}










PVector[] dashed(int x1, int y1, int x2, int y2, int steps) {

  PVector[] pts = new PVector[steps+2];
  pts[0] = new PVector(x1, y1);
  pts[pts.length-1] = new PVector(x2, y2);

  for (int i = 1; i <= steps; i++) {
    float x = lerp(x1, x2, i/float(steps)) ;
    float y = lerp(y1, y2, i/float(steps));
    pts[i] = new PVector(x, y);
  }
  return pts;
}