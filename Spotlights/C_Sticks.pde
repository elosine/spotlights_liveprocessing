/*
void mousePressed() {
 caja = new FBox(4, 4);
 caja.setStaticBody(true);
 caja.setStroke(255);
 caja.setFill(255);
 caja.setRestitution(0.9);
 mundo.add(caja);
 
 x = mouseX;
 y = mouseY;
 }
 
 void mouseDragged() {
 if (caja == null) {
 return;
 }
 
 float ang = atan2(y - mouseY, x - mouseX);
 caja.setRotation(ang);
 caja.setPosition(x+(mouseX-x)/2.0, y+(mouseY-y)/2.0);
 caja.setWidth(constrain(dist(mouseX, mouseY, x, y),5, width));
 
 }
 */

// DECLARE/INITIALIZE CLASS SET
SticksSet setOSticks = new SticksSet();

class Sticks {
  // CONSTRUCTOR VARIALBES //
  int ix;
  float x, y, w, h;

  // CLASS VARIABLES //
  FBox stick;
  String clrname = "white";
  
  // CONSTRUCTORS //
  Sticks(int aix, float ax, float ay, float aw, float ah) {
    ix = aix;
    x = ax;
    y = ay;
    w = aw;
    h = ah;

    stick = new FBox(w, h);
    stick.setNoStroke();
    stick.setFill( 255 );
    stick.setStaticBody(true); 
    stick.setPosition(x, y);
    stick.setRestitution(0.9);
    mundo.add(stick);
  } //end constructor 1

  //  DRAW METHOD //
  void drw() {
    noStroke();
    fill( clr.get("red") );
    rectMode(CENTER);
    rect(x, y, w, h);
  } //End drw
}  //End class

//// CLASS SET CLASS ////
class SticksSet {
  ArrayList<Sticks> cset = new ArrayList<Sticks>();

  // Make Instance Method //
  void mk(int ix, float x, float y, float w, float h) {
    cset.add( new Sticks(ix, x, y, w, h) );
  } //end mk method

  // Draw Set Method //
  void drwset() {
    for (int i=cset.size()-1; i>=0; i--) {
      Sticks inst = cset.get(i);
      inst.drw();
    }
  } //end dr method

  // Remove Instance Method //
  void rmv(int ix) {
    for (int i=cset.size()-1; i>=0; i--) {
      Sticks inst = cset.get(i);
      if (inst.ix == ix) {
        cset.remove(i);
        mundo.remove(inst.stick);
        break;
      }
    }
  } //End rmv method
} //end class set class

