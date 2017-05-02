// DECLARE/INITIALIZE CLASS SET
GlowstickSet glowstickz = new GlowstickSet();

/**
 *
 *
 /// PUT IN SETUP ///
 meosc.plug(glowstickz, "mk", "/mkglowstick");
 meosc.plug(glowstickz, "rmv", "/rmvglowstick");
 meosc.plug(glowstickz, "rmvall", "/rmvallglowstick");
 
 /// PUT IN DRAW ///
 glowstickz.drw();
 *
 *
 */


class Glowstick {

  // CONSTRUCTOR VARIALBES //
  int ix, x, y, w, h;
  String cl;

  // CLASS VARIABLES //
  int l, t, r, b, m, c;
  PGraphics buf;
  PImage img;
  int trailAlpha = 70;
  int glowradius = 3;
  int glowamt = 1;
  boolean rendered = false;


  // CONSTRUCTORS //

  /// Constructor 1 ///
  Glowstick(int aix, int ax, int ay, int aw, int ah, String acl) {
    ix = aix;
    x = ax;
    y = ay;
    w = aw;
    h = ah;
    cl = acl;

    //BOUNDING BOX COORDINATES
    l = x;
    t = y;
    r = l+w;
    b = t+h;
    m = l + round(w/2.0);
    c = t + round(h/2.0);

    //Off-Screen Buffer
    buf = createGraphics(w*2, h*2, P3D);
   // buf = createGraphics(500, 500, P3D);
  } //end constructor 1


  //  DRAW METHOD //
  void drw() {
    update();
     image(img, x, y);
  } //End drw



  void update() {
    // RENDER METHOD //
    buf.beginDraw(); //////////////////////////////

    // Background for Trail
    buf.rectMode(CORNER);
    buf.noStroke();
    buf.fill(0, 0, 0, trailAlpha);
    buf.rect(0, 0, w, h);

    // Draw Glow Stick
    buf.fill( clr.get(cl) );
    buf.noStroke();

    buf.pushMatrix();
  //  buf.rectMode(CENTER);
    // buf.rotate(radians(spdeg));
    buf.rect(0, 0, w, h);
    // spdeg+=35;
        glow(glowradius, glowamt, buf);

    buf.popMatrix();


    buf.endDraw(); ///////////////////////////////
    img = buf.get(0, 0, buf.width, buf.height);
  }//End render


  // UPDATE BUFFER METHOD //
  /*
  void update() {
    render();
    img = buf.get(0, 0, buf.width, buf.height);
    rendered = true;
  } //End update
*/

  //// MOUSE METHODS ////

  // Mouse Clicked Method // - When mouse is pressed and then released
  void msclk() {
  }//end msclk method


  // Mouse Pressed Method //
  void msprs() {
  }//end msprs method


  // Mouse Released Method //
  void msrel() {
  }//end msrel method


  // Mouse Moved Method //
  void msmv() {
  }//end msmv method


  // Mouse Dragged Method //
  void msdrg() {
  }//end msdrg method


  // Mouse Wheel Method //
  void mswl() {
  }//end mswl method



  //// KEYBOARD METHODS ////

  // Key Pressed Method //
  void keyprs() {
  }//end keyprs method


  // Key Released Method //
  void keyrel() {
  }//end keyrel method
  //
  //
  //
}  //End class



////////////////////////////////////////////////////////////
/////////////   CLASS SET     //////////////////////////////
////////////////////////////////////////////////////////////

class GlowstickSet {
  ArrayList<Glowstick> cset = new ArrayList<Glowstick>();

  // Make Instance Method //
  void mk(int ix, int x, int y, int w, int h, String cl) {
    cset.add( new Glowstick(ix, x, y, w, h, cl) );
  } //end mk method


  // Remove Instance Method //
  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Glowstick inst = cset.get(i);
      if (inst.ix == ix) {
        cset.remove(i);
        break;
      }
    }
  } //End rmv method


  // Remove All Method //
  void rmvall() {
    cset.clear();
  } //End rmvall method


  // Draw Set Method //
  void drw() {
    for (int i=cset.size ()-1; i>=0; i--) {
      Glowstick inst = cset.get(i);
      inst.drw();
    }
  }//end drw method
  
  
  // Draw Set Method //
  void update() {
    for (int i=cset.size ()-1; i>=0; i--) {
      Glowstick inst = cset.get(i);
      inst.update();
    }
  }//end drw method



  //// CHANGE METHODS ////

  // Change Method //
  void chg(int ix, int var) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Glowstick inst = cset.get(i);
      if (inst.ix == ix) {
        // inst.var = var;
        //Actions or Calculations Here:

        ///////////////////////////////
        break;
      }
    }
  } //End chg method


  //// MOUSE METHODS ////

  // Mouse Clicked Method // - When mouse is pressed and then released
  void msclk() {
    for (int i=cset.size ()-1; i>=0; i--) {
      Glowstick inst = cset.get(i);
      inst.msclk();
    }
  }//end msclk method


  // Mouse Pressed Method //
  void msprs() {
    for (int i=cset.size ()-1; i>=0; i--) {
      Glowstick inst = cset.get(i);
      inst.msprs();
    }
  }//end msprs method


  // Mouse Released Method //
  void msrel() {
    for (int i=cset.size ()-1; i>=0; i--) {
      Glowstick inst = cset.get(i);
      inst.msrel();
    }
  }//end msrel method


  // Mouse Moved Method //
  void msmv() {
    for (int i=cset.size ()-1; i>=0; i--) {
      Glowstick inst = cset.get(i);
      inst.msmv();
    }
  }//end msmv method


  // Mouse Dragged Method //
  void msdrg() {
    for (int i=cset.size ()-1; i>=0; i--) {
      Glowstick inst = cset.get(i);
      inst.msdrg();
    }
  }//end msdrg method


  // Mouse Wheel Method //
  void mswl() {
    for (int i=cset.size ()-1; i>=0; i--) {
      Glowstick inst = cset.get(i);
      inst.mswl();
    }
  }//end mswl method



  //// KEYBOARD METHODS ////

  // Key Pressed Method //
  void keyprs() {
    for (int i=cset.size ()-1; i>=0; i--) {
      Glowstick inst = cset.get(i);
      inst.keyprs();
    }
  }//end keyprs method


  // Key Released Method //
  void keyrel() {
    for (int i=cset.size ()-1; i>=0; i--) {
      Glowstick inst = cset.get(i);
      inst.keyrel();
    }
  }//end keyrel method
  //
  //
} // END CLASS SET CLASS