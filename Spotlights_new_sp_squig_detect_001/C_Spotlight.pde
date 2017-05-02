class Spotlight {
  //Constructor Variables
  int ix;
  float startx, starty, size;
  String clrname;

  //Class Variables
  FCircle sl;
  float x, y;
  float bounce = 1.0;
  float velx = 0;
  float vely = 800;
  float damping = 0.0;
  boolean shadowOn = false;
  int bdrwt = 5;
  int timer = 0;
  int blinktime = 5;
  int type = 1;

  float sizedir = 1.0;
  float sawmin, sawmax;
  float sawchgperframe;
  boolean sawon = false;

  float spinnerdeg = 0.0;
  float spinnervel = 50;
  float spinneraccl = -1.2;
  boolean spinner = false;

  PVector gotocurrloc;
  PVector gototarget;
  float gotointerp = 0.0;
  boolean gotoOn = false;
  boolean sendX = true;
  boolean sendY = true;
  String name;
  float r;
  float gotogotime = 0.0;
  float iris = 0.25;
  float dynmaskdia;

  boolean orbit = false;
  float oval = 0.0;
  float ospeed = 0.01;
  float ox, oy;
  float ow = 100.0;
  float oh = 100.0;
  float ocx = 200.0;
  float ocy = 200.0;

  //Constructor 1
  Spotlight(int aix, float astartx, float astarty, float asize, String aclrname) {
    ix = aix;
    startx = astartx;
    starty = astarty;
    size = asize;
    clrname = aclrname;
    name = "spt" + str(ix);
    //println(name);
    r = size/2.0;
    dynmaskdia = ((1.0 - iris)/2.0)*size;

    sl = new FCircle(size);
    sl.setNoStroke();
    sl.setFill(255);  //needs to be white because it is masking
    sl.setPosition(startx, starty);
    sl.setVelocity(velx, vely);
    sl.setRestitution(bounce);
    sl.setDamping(damping);
    sl.setName(name);
    mundo.add(sl);
  } //End Constructor 1



  //Constructor 2 - vely
  Spotlight(int aix, float astartx, float astarty, float asize, String aclrname, float avelx, float avely) {
    ix = aix;
    startx = astartx;
    starty = astarty;
    size = asize;
    clrname = aclrname;
    velx = avelx;
    vely = avely;
    name = "spt" + str(ix);
    r = size/2.0;
    dynmaskdia = ((1.0 - iris)/2.0)*size;

    sl = new FCircle(size);
    sl.setNoStroke();
    sl.setFill(255);  //needs to be white because it is masking
    sl.setPosition(startx, starty);
    sl.setVelocity(velx, vely);
    sl.setRestitution(bounce);
    sl.setDamping(damping);
    sl.setName(name);
    mundo.add(sl);
  } //End Constructor 2 - vely


  void drwShadow() {

    //Size Mod
    if (sawon) {
      if ( sl.getX() > 75 && sl.getX() < width-75 && sl.getY() > 75 && sl.getY() < height-75) {
        if (sawmax>sawmin) {
          if (size>=sawmax) {
            size = sawmin;
          }
        } else {
          if (size<sawmax) {
            size = sawmin;
          }
        }
        // if (frameCount%4 == 0) {
        size = size + sawchgperframe;
        sl.setSize(size);
        // }
      }
    }

    if (spinner) {
      pushMatrix();
      rectMode(CENTER);
      fill(clr.get(clrname));
      noStroke();
      translate(sl.getX(), sl.getY());
      rotate(radians(spinnerdeg));
      rect(0, 0, 2, size);
      rotate(radians(90));
      rect(0, 0, 2, size);
      popMatrix();


      // spinnervel = constrain( (spinnervel += spinneraccl), 0, 50);
      spinnerdeg += spinnervel;
    } else {
    }


    //FOR BLINK TEXTURE
    if (shadowOn) {

      switch(type) {

      case 0:
        fill(clr.get(clrname));
        break;

      case 1:
        fill(clr.get(clrname));
        spinnervel = 100;
        break;
      }


      if (frameCount == timer+blinktime) {
        shadowOn = false;
      }

      //
    } 
    //
    else {
      noFill();
    }


    if (gotoOn) {
      if (millis() >= gotogotime) {
        gotocurrloc.lerp(gototarget, 0.6);
        sl.setPosition(gotocurrloc.x, gotocurrloc.y);
        if (gotocurrloc.dist(gototarget) < 0.5) {
          gotoOn = false;
          sl.setVelocity(0, 0);
          sl.setStatic(false);
        }
      }
    }


    //Send Normalized X
    if (sendX) {
      float xnorm = norm(sl.getX(), 0+r, width-r);
      OscMessage sndx = new OscMessage("/spmsg");
      sndx.add(ix);
      sndx.add("spx"); 
      sndx.add(xnorm);
      meosc.send(sndx, sc);
    }

    //Send Normalized Y
    if (sendY) {
      float ynorm = norm(sl.getY(), height-r, 0.0+r);
      OscMessage sndy = new OscMessage("/spmsg");
      sndy.add(ix);
      sndy.add("spy"); 
      sndy.add(ynorm);
      meosc.send(sndy, sc);
    }

    if (orbit) {
      shadowOn = false;
      ox = sin(oval);
      oy = cos(oval);
      ox *= ow;
      oy *= oh;
      ox += ocx;
      oy += ocy;
      sl.setPosition(ox, oy);
      oval += ospeed;
    } else {
      oval = 0.0;
    }

    x = sl.getX();
    y = sl.getY();

    stroke( clr.get(clrname) );
    strokeWeight(bdrwt);
    ellipseMode(CENTER);
    ellipse(sl.getX(), sl.getY(), size, size);

    /*  USE DIFFERENT SIZE FOR NOW TO DENOTE DYNAMICS AND PUT 'LARGEST SIZE' IN INSTRUCTIONS
     //IRIS EFFECT OVERLAY
     noFill();
     ellipseMode(CENTER);
     stroke( 20 );
     strokeWeight( dynmaskdia );
     ellipse(sl.getX(), sl.getY(), (size*iris)+dynmaskdia, (size*iris)+dynmaskdia);
     */



    //
  } //End Method drwshadow


  void pxCt() {
    // println( numOfColoredPxInCircle(bglayer, int(sl.getX()), int(sl.getY()), int(size/2), 255, 0, 0) );
  } //End Method


  void blink() {
    shadowOn = true;
    blinktime = ceil( 1500.0/sqrt( pow(sl.getVelocityY(), 2) + pow(sl.getVelocityX(), 2) ) );  
    // println(blinktime);
    timer = frameCount;
  } //End Method


  void sizesaw(float minsz, float maxsz, float dur) {
    float range = maxsz - minsz;
    float numframes = dur/secperframe;
    sawchgperframe = range/numframes;
    sawmin = minsz;
    sawmax = maxsz;
    sawon = true;
    // println("classgood");
  } //End Method



  void hit(String name, float pwr) {

    OscMessage onmsg = new OscMessage("/spmsg");
    onmsg.add(ix);//spotlight number
    onmsg.add(name); //name of obsticle hit
    onmsg.add(pwr); //strength of impact;
    meosc.send(onmsg, sc);

    blink();
  } //End Method


  void halt() {
    sl.setStatic(true);
  } //End Method


  void go2(float ax, int ay, float adelay) {
    float delsec = adelay*1000.0;
    gotocurrloc = new PVector(sl.getX(), sl.getY());
    gototarget = new PVector(ax, ay);
    gotogotime = delsec;
    gotoOn = true;
  } //End Method



  void lift(int ay, float adelay) {
    go2(sl.getX(), ay, adelay);
  }





  ////////////////////////////////////////////////////////////////////////
} //End Class



/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
///// CLASS SET CLASS ///////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////

class SpotlightSet {
  ArrayList<Spotlight> clset = new ArrayList<Spotlight>();

  // Make Instance Method //
  void mkinst(int ix, float startx, float starty, float size, String clrname, float velx, float vely) {
    clset.add(new Spotlight(ix, startx, starty, size, clrname, velx, vely));
  } // End mkinst Method

  void drwTopLayer() {
    for (int i=clset.size ()-1; i >= 0; i--) {
      // for(int i=0; i<clset.size(); i++){
      Spotlight inst = clset.get(i);
      inst.drwShadow();
    }
  } //End Method

  void drwbglayer() {
    for (int i=clset.size ()-1; i >= 0; i--) {
      Spotlight inst = clset.get(i);
      inst.pxCt();
    }
  } //End Method

  void rmv(int ix) {
    for (int i=clset.size ()-1; i>=0; i--) {
      Spotlight inst = clset.get(i);
      if (inst.ix == ix) {
        mundo.remove(inst.sl);
        clset.remove(i);
        break;
      }
    }
  } //End rmv method

  void halt(int ix) {
    for (int i=clset.size ()-1; i>=0; i--) {
      Spotlight inst = clset.get(i);
      if (inst.ix == ix) {
        inst.halt();
        break;
      }
    }
  } //End halt method

  void spin(int ix, int on) {
    for (int i=clset.size ()-1; i>=0; i--) {
      Spotlight inst = clset.get(i);
      if (inst.ix == ix) {
        if (on == 1) {
          inst.spinner = true;
          inst.sl.setStatic(true);
          inst.sl.setSensor(true);
        } else {
          inst.spinner = false;
          inst.sl.setStatic(false);
          inst.sl.setSensor(false);
        }
        break;
      }
    }
  } //End spin method

  void haltall(int aonoff) {
    for (int i=clset.size ()-1; i>=0; i--) {
      Spotlight inst = clset.get(i);
      if (aonoff == 1) {
        inst.halt();
      } else {
        inst.sl.setStatic(false);
      }
    }
  } //End halt method

  void go(int ix, float axvel, float ayvel) {
    for (int i=clset.size ()-1; i>=0; i--) {
      Spotlight inst = clset.get(i);
      if (inst.ix == ix) {
        inst.sl.setStatic(false);
        inst.sl.setVelocity(axvel, ayvel);
        break;
      }
    }
  } //End go method

  void goall(float axvel, float ayvel) {
    for (int i=clset.size ()-1; i>=0; i--) {
      Spotlight inst = clset.get(i);
      inst.sl.setStatic(false);
      inst.sl.setVelocity(axvel, ayvel);
    }
  } //End goall method

  void hit(int ix, float x, float y) {
    for (int i=clset.size ()-1; i>=0; i--) {
      Spotlight inst = clset.get(i);
      if (inst.ix == ix) {
        inst.sl.addImpulse(x, y);
        break;
      }
    }
  } //End method

  void push(int ix, float x, float y) {
    for (int i=clset.size ()-1; i>=0; i--) {
      Spotlight inst = clset.get(i);
      if (inst.ix == ix) {
        inst.sl.addForce(x, y);
        break;
      }
    }
  } //End method

  void sizesawon(int ix, float min, float max, float dur) {
    for (int i=clset.size ()-1; i>=0; i--) {
      Spotlight inst = clset.get(i);
      if (inst.ix == ix) {
        //println("setgood");
        inst.sizesaw(min, max, dur);
        break;
      }
    }
  } //End method

  void sizesawoff(int ix) {
    for (int i=clset.size ()-1; i>=0; i--) {
      Spotlight inst = clset.get(i);
      if (inst.ix == ix) {
        inst.sawon=false;
        break;
      }
    }
  } //End method

  void reSize(int ix, float sz) {
    for (int i=clset.size ()-1; i>=0; i--) {
      Spotlight inst = clset.get(i);
      if (inst.ix == ix) {
        inst.sl.setSize(sz);
        inst.size = sz;
        break;
      }
    }
  } //End method




  void go2(int ix, int x, int y, float adelay) {
    for (int i=clset.size ()-1; i>=0; i--) {
      Spotlight inst = clset.get(i);
      if (inst.ix == ix) {
        inst.go2(x, y, adelay);
        break;
      }
    }
  } //End method

  void lift(int ix, int y, float adelay) {
    for (int i=clset.size ()-1; i>=0; i--) {
      Spotlight inst = clset.get(i);
      if (inst.ix == ix) {
        inst.lift(y, adelay);
        break;
      }
    }
  } //End method

  void liftall(int y, float adelay) {
    for (int i=clset.size ()-1; i>=0; i--) {
      Spotlight inst = clset.get(i);
      inst.lift(y, adelay);
    }
  } //End method


  void setvelocity(int ix, float x, float y) {
    for (int i=clset.size ()-1; i>=0; i--) {
      Spotlight inst = clset.get(i);
      if (inst.ix == ix) {
        inst.sl.setVelocity(x, y);
        break;
      }
    }
  } //End method


  void adjvelocity(int ix, float x, float y) {
    for (int i=clset.size ()-1; i>=0; i--) {
      Spotlight inst = clset.get(i);
      float xdirtemp = 1.0;
      float ydirtemp = 1.0;
      if (inst.ix == ix) {
        if (inst.sl.getVelocityX() >= 0) xdirtemp = 1.0; 
        else xdirtemp = -1.0;
        if (inst.sl.getVelocityY() >= 0) ydirtemp = 1.0; 
        else ydirtemp = -1.0;
        inst.sl.adjustVelocity(x*xdirtemp, y*ydirtemp);
        break;
      }
    }
  } //End method


  void setbounce(int ix, float b) {
    for (int i=clset.size ()-1; i>=0; i--) {
      Spotlight inst = clset.get(i);
      if (inst.ix == ix) {
        inst.sl.setRestitution(b);
        break;
      }
    }
  } //End method


  void orbit(int ix, float ospd, float ow, float oh, float ocx, float ocy) {
    for (int i=clset.size ()-1; i>=0; i--) {
      Spotlight inst = clset.get(i);
      if (inst.ix == ix) {
        inst.orbit = true;
        inst.ospeed = ospd;
        inst.ow = ow;
        inst.oh = oh;
        inst.ocx = ocx;
        inst.ocy = ocy;
        inst.sl.setStatic(true);
        inst.sl.setSensor(true);      
        break;
      }
    }
  } //End  method


  void orbitoff(int ix) {
    for (int i=clset.size ()-1; i>=0; i--) {
      Spotlight inst = clset.get(i);
      if (inst.ix == ix) {
        inst.orbit = false;
        inst.sl.setStatic(false);
        inst.sl.setSensor(false); 
        break;
      }
    }
  } //End  method


  void orbitspd(int ix, float spd) {
    for (int i=clset.size ()-1; i>=0; i--) {
      Spotlight inst = clset.get(i);
      if (inst.ix == ix) {
        inst.ospeed = spd;
        break;
      }
    }
  } //End  method




  //////////////////////////////////
} //End Class Set Class


// DECLARE/INITIALIZE CLASS SET
SpotlightSet spots = new SpotlightSet();