// DECLARE/INITIALIZE CLASS SET
SpSqDetectSet spSqDetectz = new SpSqDetectSet();

/**
 *
 *
 /// PUT IN SETUP ///
 osc.plug(spSqDetectz, "mk", "/mkspSqDetect");
 osc.plug(spSqDetectz, "rmv", "/rmvspSqDetect");
 
 /// PUT IN DRAW ///
 spSqDetectz.drw();
 *
 *
 */


class SpSqDetect {

  // CONSTRUCTOR VARIALBES //
  int ix, spix, sqix;
  // CLASS VARIABLES //
  Spotlight sp;
  Squiggle sq;
  float spl, spr, spt, spb;
  float sql, sqr, sqt, sqb;
  int ct;
  boolean gate = true;

  // CONSTRUCTORS //

  /// Constructor 1 ///
  SpSqDetect(int aix, int aspix, int asqix) {
    ix = aix;
    spix = aspix;
    sqix = asqix;

    //identify spotlight
    for (Spotlight inst : spots.clset) {
      if (spix == inst.ix) {
        sp = inst;
        break;
      }
    }

    //identify squiggle
    for (Squiggle inst : squigglez.cset) {
      if (sqix == inst.ix) {
        sq = inst;
        break;
      }
    }
    //
  } //end constructor 1

  //  DRAW METHOD //
  void drw() {
    spl = sp.x-sp.r;
    spr = sp.x + sp.r;
    spt = sp.y-sp.r;
    spb = sp.y+sp.r;

    sql = sq.l;
    sqr = sq.r;
    sqt = sq.t;
    sqb = sq.b;

    if (spr>=sql && spl<=sqr && spb>=sqt && spt<=sqb) ct=1;
    else ct = 0;

    if (gate) {
      if (ct ==1) {
        meosc.send("/spsqdetect", new Object[]{sq.cl, ct}, sc);
        gate = false;
      }
    }

    if (!gate) {
      if (ct==0) {
        meosc.send("/spsqdetect", new Object[]{sq.cl, ct}, sc);
        gate = true;
      }
    }
  } //End drw
  //
  //
}  //End class

////////////////////////////////////////////////////////////
/////////////   CLASS SET     //////////////////////////////
////////////////////////////////////////////////////////////

class SpSqDetectSet {
  ArrayList<SpSqDetect> cset = new ArrayList<SpSqDetect>();

  // Make Instance Method //
  void mk(int ix, int spix, int sqix) {
    cset.add( new SpSqDetect(ix, spix, sqix) );
  } //end mk method

  // Remove Instance Method //
  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      SpSqDetect inst = cset.get(i);
      if (inst.ix == ix) {
        cset.remove(i);
        break;
      }
    }
  } //End rmv method

  // Draw Set Method //
  void drw() {
    for (int i=cset.size ()-1; i>=0; i--) {
      SpSqDetect inst = cset.get(i);
      inst.drw();
    }
  }//end drw method
  //
  //
} // END CLASS SET CLASS