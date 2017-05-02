class ArcsAndLines {

  int sz, wt;
  PImage[] imgs = new PImage[20];
  PGraphics buf;
  int[] px;
  int bdr = ceil(wt/2);
  CrookedLine [] cls, clsd;
  PVector []dpts;
  PVector []dptsd;


  ArcsAndLines(int argsz, int argwt) {
    sz = argsz;
    wt = argwt;

    buf = createGraphics(sz+wt+1, sz+wt+1, JAVA2D);
    cls = new CrookedLine[7];
    clsd = new CrookedLine[7];
    for (int i=0; i<cls.length; i++) {
      cls[i] = new CrookedLine(buf, 0, 0, 0, sz, ceil(random(4)), 15);
      clsd[i] = new CrookedLine(buf, 0, 0, sz, sz, ceil(random(4)), 17);
    }
    dpts = dashed(0, 0, 0, buf.height, 14);
    dptsd = dashed(0-wt, 0-wt, buf.width+wt, buf.height+wt, 20);

    //Cell 1
    buf.beginDraw();
    buf.smooth();
    buf.noFill();
    buf.stroke(255);
    buf.strokeWeight(wt);
    buf.ellipseMode(CENTER);
    buf.strokeCap(ROUND);
    buf.arc( bdr, sz+bdr, sz*2, sz*2, -HALF_PI, 0 );
    transparency();
    imgs[0] = buf.get(0, 0, buf.width, buf.height);
    fill(0);
    noStroke();
    buf.rect(0, 0, buf.width, buf.height);
    buf.updatePixels();

    //Cell 2
    buf.beginDraw();
    buf.smooth();
    buf.noFill();
    buf.stroke(255);
    buf.strokeWeight(wt);
    buf.ellipseMode(CENTER);
    buf.strokeCap(ROUND);
    buf.arc(bdr, bdr, sz*2, sz*2, 0, HALF_PI);
    transparency();
    imgs[1] = buf.get(0, 0, buf.width, buf.height);
    fill(0);
    noStroke();
    buf.rect(0, 0, buf.width, buf.height);
    buf.updatePixels();

    //Cell 3
    buf.beginDraw();
    buf.smooth();
    buf.noFill();
    buf.stroke(255);
    buf.strokeWeight(wt);
    buf.ellipseMode(CENTER);
    buf.strokeCap(ROUND);
    buf.arc(bdr+sz, bdr, sz*2, sz*2, HALF_PI, PI);
    transparency();
    imgs[2] = buf.get(0, 0, buf.width, buf.height);
    fill(0);
    noStroke();
    buf.rect(0, 0, buf.width, buf.height);
    buf.updatePixels();

    //Cell 4
    buf.beginDraw();
    buf.smooth();
    buf.noFill();
    buf.stroke(255);
    buf.strokeWeight(wt);
    buf.ellipseMode(CENTER);
    buf.strokeCap(ROUND);
    buf.arc(bdr+sz, bdr+sz, sz*2, sz*2, -PI, HALF_PI);
    transparency();
    imgs[3] = buf.get(0, 0, buf.width, buf.height);
    fill(0);
    noStroke();
    buf.rect(0, 0, buf.width, buf.height);
    buf.updatePixels();

    //Cell 5
    buf.beginDraw();
    buf.smooth();
    buf.noFill();
    buf.stroke(255);
    buf.strokeWeight(wt);
    buf.ellipseMode(CENTER);
    buf.strokeCap(ROUND);
    buf.arc(bdr-(sz/2.66667), bdr+(sz/2), sz*2, sz*2, -0.16667*PI, 0.16667*PI);
    transparency();
    imgs[4] = buf.get(0, 0, buf.width, buf.height);
    fill(0);
    noStroke();
    buf.rect(0, 0, buf.width, buf.height);
    buf.updatePixels();

    //Cell 6
    buf.beginDraw();
    buf.smooth();
    buf.noFill();
    buf.stroke(255);
    buf.strokeWeight(wt);
    buf.ellipseMode(CENTER);
    buf.strokeCap(ROUND);
    buf.arc(bdr+(sz/2), bdr-(sz/2.66667), sz*2, sz*2, HALF_PI - (0.16667*PI), HALF_PI + (0.16667*PI) );
    transparency();
    imgs[5] = buf.get(0, 0, buf.width, buf.height);
    fill(0);
    noStroke();
    buf.rect(0, 0, buf.width, buf.height);
    buf.updatePixels();

    //Cell 7
    buf.beginDraw();
    buf.smooth();
    buf.noFill();
    buf.stroke(255);
    buf.strokeWeight(wt);
    buf.ellipseMode(CENTER);
    buf.strokeCap(ROUND);
    buf.arc( bdr+sz+(sz/2.66667), bdr+(sz/2), sz*2, sz*2, PI - (0.16667*PI), PI + (0.16667*PI) );
    transparency();
    imgs[6] = buf.get(0, 0, buf.width, buf.height);
    fill(0);
    noStroke();
    buf.rect(0, 0, buf.width, buf.height);
    buf.updatePixels();

    //Cell 8
    buf.beginDraw();
    buf.smooth();
    buf.noFill();
    buf.stroke(255);
    buf.strokeWeight(wt);
    buf.ellipseMode(CENTER);
    buf.strokeCap(ROUND);
    buf.arc( bdr+(sz/2), bdr+sz+(sz/2.66667), sz*2, sz*2, -HALF_PI - (0.16667*PI), -HALF_PI + (0.16667*PI) );
    transparency();
    imgs[7] = buf.get(0, 0, buf.width, buf.height);
    fill(0);
    noStroke();
    buf.rect(0, 0, buf.width, buf.height);
    buf.updatePixels();

    //Cell 9
    buf.beginDraw();
    buf.smooth();
    buf.noFill();
    buf.stroke(255);
    buf.strokeWeight(wt);
    buf.line( bdr+(sz/2), bdr, bdr+(sz/2), bdr+sz );
    transparency();
    imgs[8] = buf.get(0, 0, buf.width, buf.height);
    fill(0);
    noStroke();
    buf.rect(0, 0, buf.width, buf.height);
    buf.updatePixels();

    //Cell 10
    buf.beginDraw();
    buf.smooth();
    buf.noFill();
    buf.stroke(255);
    buf.strokeWeight(wt);
    buf.line( bdr, bdr+(sz/2), bdr+sz, bdr+(sz/2) );
    transparency();
    imgs[9] = buf.get(0, 0, buf.width, buf.height);
    fill(0);
    noStroke();
    buf.rect(0, 0, buf.width, buf.height);
    buf.updatePixels();

    //Cell 11
    buf.beginDraw();
    buf.smooth();
    buf.noFill();
    buf.stroke(255);
    buf.strokeWeight(wt);
    buf.line( bdr+sz, bdr, bdr, bdr+sz );
    transparency();
    imgs[10] = buf.get(0, 0, buf.width, buf.height);
    fill(0);
    noStroke();
    buf.rect(0, 0, buf.width, buf.height);
    buf.updatePixels();

    //Cell 12
    buf.beginDraw();
    buf.smooth();
    buf.noFill();
    buf.stroke(255);
    buf.strokeWeight(wt);
    buf.line( bdr, bdr, bdr+sz, bdr+sz );
    transparency();
    imgs[11] = buf.get(0, 0, buf.width, buf.height);
    fill(0);
    noStroke();
    buf.rect(0, 0, buf.width, buf.height);
    buf.updatePixels();

    //Cell 13
    buf.beginDraw();
    buf.smooth();
    buf.noFill();
    buf.stroke(255);
    buf.strokeWeight(wt);
    cls[0].drw(bdr+(sz/2), bdr, 0);
    transparency();
    imgs[12] = buf.get(0, 0, buf.width, buf.height);
    fill(0);
    noStroke();
    buf.rect(0, 0, buf.width, buf.height);
    buf.updatePixels();

    //Cell 14
    buf.beginDraw();
    buf.smooth();
    buf.noFill();
    buf.stroke(255);
    buf.strokeWeight(wt);
    cls[1].drw(bdr, bdr+(sz/2.0), -90.0);
    transparency();
    imgs[13] = buf.get(0, 0, buf.width, buf.height);
    fill(0);
    noStroke();
    buf.rect(0, 0, buf.width, buf.height);
    buf.updatePixels();

    //Cell 15
    buf.beginDraw();
    buf.smooth();
    buf.noFill();
    buf.stroke(255);
    buf.strokeWeight(wt);
    clsd[0].drw(bdr+sz, bdr, 90.0);
    transparency();
    imgs[14] = buf.get(0, 0, buf.width, buf.height);
    fill(0);
    noStroke();
    buf.rect(0, 0, buf.width, buf.height);
    buf.updatePixels();

    //Cell 16
    buf.beginDraw();
    buf.smooth();
    buf.noFill();
    buf.stroke(255);
    buf.strokeWeight(wt);
    clsd[3].drw(bdr, bdr, 0.0);
    transparency();
    imgs[15] = buf.get(0, 0, buf.width, buf.height);
    fill(0);
    noStroke();
    buf.rect(0, 0, buf.width, buf.height);
    buf.updatePixels();

    //Cell 17
    buf.beginDraw();
    buf.smooth();
    buf.noFill();
    buf.stroke(255);
    buf.strokeWeight(wt);
    buf.pushMatrix();
    buf.translate(bdr+(sz/2), bdr);
    for (int i=0; i<dpts.length-1; i+=2) {
      buf.line(dpts[i].x, dpts[i].y, dpts[i+1].x, dpts[i+1].y);
    }
    buf.popMatrix();
    transparency();
    imgs[16] = buf.get(0, 0, buf.width, buf.height);
    fill(0);
    noStroke();
    buf.rect(0, 0, buf.width, buf.height);
    buf.updatePixels();

    //Cell 18
    buf.beginDraw();
    buf.smooth();
    buf.noFill();
    buf.stroke(255);
    buf.strokeWeight(wt);
    buf.pushMatrix();
    buf.translate(bdr+sz, bdr+(sz/2));
    buf.rotate(radians(90));
    for (int i=0; i<dpts.length-1; i+=2) {
      buf.line(dpts[i].x, dpts[i].y, dpts[i+1].x, dpts[i+1].y);
    }
    buf.popMatrix();
    transparency();
    imgs[17] = buf.get(0, 0, buf.width, buf.height);
    fill(0);
    noStroke();
    buf.rect(0, 0, buf.width, buf.height);
    buf.updatePixels();

    //Cell 19
    buf.beginDraw();
    buf.smooth();
    buf.noFill();
    buf.stroke(255);
    buf.strokeWeight(wt);
    buf.pushMatrix();
    buf.translate(bdr+sz-(wt*2), bdr+(wt*2));
    buf.rotate(radians(90));
    for (int i=0; i<dpts.length-1; i+=2) {
      buf.line(dptsd[i].x, dptsd[i].y, dptsd[i+1].x, dptsd[i+1].y);
    }
    buf.popMatrix();
    transparency();
    imgs[18] = buf.get(0, 0, buf.width, buf.height);
    fill(0);
    noStroke();
    buf.rect(0, 0, buf.width, buf.height);
    buf.updatePixels();

    //Cell 20
    buf.beginDraw();
    buf.smooth();
    buf.noFill();
    buf.stroke(255);
    buf.strokeWeight(wt);
    buf.pushMatrix();
    buf.translate(bdr+(wt*2), bdr+(wt*2));
    for (int i=0; i<dpts.length-1; i+=2) {
      buf.line(dptsd[i].x, dptsd[i].y, dptsd[i+1].x, dptsd[i+1].y);
    }
    buf.popMatrix();
    transparency();
    imgs[19] = buf.get(0, 0, buf.width, buf.height);
    fill(0);
    noStroke();
    buf.rect(0, 0, buf.width, buf.height);
    buf.updatePixels();



    //
  }// end Constructor

  void transparency() {
    buf.loadPixels();
    px = new int[buf.pixels.length]; 
    for (int x=0; x<buf.width; x++) for (int y=0; y<buf.height; y++) {
      int p = y*buf.width + x;  
      //Turns black pixels transparent ///
      int tr = r(px[p]);
      int tg = g(px[p]);
      int tb = b(px[p]);
      if (tr==0 && tg==0 && tb==0) px[p] = px[p] &= 0x00FFFFFF;
      /// ///
    }
    arrayCopy(px, buf.pixels);
  }

  //
} //end class



