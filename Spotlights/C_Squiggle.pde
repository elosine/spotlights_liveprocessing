// DECLARE/INITIALIZE CLASS SET
SquiggleSet squigglez = new SquiggleSet();

class Squiggle {
  int ix, x, y, w, h, density;
  String cl;

  float l, r, t, b, m, c;
  PGraphics buf;
  PImage img;
  float curvePointX = 0; 
  float curvePointY = 0;
  float x1, y1, addx, addy;
  
  int anigo = 0;
  int anifreq = 5;
  int aflo=1;
  int afhi=5;

  Squiggle(int aix, int ax, int ay, int aw, int ah, int adensity, String acl) {
    ix = aix;
    x = ax;
    y = ay;
    w = aw;
    h = ah;
    density = adensity;
    cl = acl;

    buf = createGraphics(w+10, h+10, JAVA2D);
    m = w/2.0;
    c = h/2.0;
    x1 = m;
    y1 = c;

    render();
  }

  void render() {
    buf.beginDraw();
    buf.background(0);
    buf.smooth();
    buf.noFill();
    buf.strokeWeight(2);
    buf.stroke(clr.get(cl));

    for (int j=0; j<int (random (2, density+2)); j++) {
      buf.beginShape();
      buf.curveVertex(x1, y1);
      buf.curveVertex(x1, y1);
      for (int i = 0; i < int (random (3, 13)); i++) {
        if (x1<m) addx = random(w/2);
        else addx = random( (w/2) * -1 );
        if (y1<c) addy = random(h/2);
        else addy = random( -h/2 );
        curvePointX = constrain( x1 + addx, m-(w/2.0)+10, m+(w/2.0) );
        curvePointY = constrain( y1 + addy, c-(h/2.0)+10, c+(h/2.0) );
        buf.curveVertex(curvePointX, curvePointY);
      }
      buf.curveVertex(curvePointX, curvePointY);
      buf.endShape();
      x1 = curvePointX;
      y1 = curvePointY;
    }
    glow(3, 3, buf);

    buf.fill(0);
    buf.noStroke();
    buf.noFill();
    buf.stroke(0, 255, 0);
    buf.rectMode(CENTER);
    buf.endDraw();

    img = buf.get(0, 0, buf.width, buf.height);
  }
  void drw(PGraphics rbuf) {
    if(anigo==1) if(frameCount%anifreq==0){
      anifreq = int(random(aflo, afhi)); 
      render();
    }
    rbuf.image(img, x, y);
  }
}

class SquiggleSet {
  ArrayList<Squiggle> cset = new ArrayList<Squiggle>();

  // Make Instance Method //
  void mk(int ix, int x, int y, int w, int h, int dens, String cl) {
    cset.add( new Squiggle(ix, x, y, w, h, dens, cl) );
  } //end mk method

  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Squiggle inst = cset.get(i);
      if (inst.ix == ix) {
        cset.remove(i);
        break;
      }
    }
  } //End rmv method

  // Draw Set Method //
  void drw(PGraphics rbuf) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Squiggle inst = cset.get(i);
      inst.drw(rbuf);
    }
  }//end drw method

  // Animate Method //
  void animate(int ix, int go, int aflo, int afhi) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Squiggle inst = cset.get(i);
      if(inst.ix == ix){
        inst.aflo = aflo;
        inst.afhi = afhi;
        inst.anigo = go;
      }
    }
  }//end animate method


  //
  //
}

