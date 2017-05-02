/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/5286*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */

// GLOWING

// Martin Schneider
// October 14th, 2009
// k2g2.org


// use the glow function to add radiosity to your animation :)

// r (blur radius) : 1 (1px)  2 (3px) 3 (7px) 4 (15px) ... 8  (255px)
// b (blur amount) : 1 (100%) 2 (75%) 3 (62.5%)        ... 8  (50%)

void glow(int r, int b, PGraphics pg) {
  pg.loadPixels();
  blur(1, pg); // just adding a little smoothness ...
  int[] px = new int[pg.pixels.length];
  arrayCopy(pg.pixels, px);
  blur(r, pg);
  mix(px, b, pg);
  pg.updatePixels();
}

void blur(int dd, PGraphics pg) {
  int[] px = new int[pg.pixels.length]; 
  for (int d=1<<--dd; d>0; d>>=1) {  
    for (int x=0; x<pg.width; x++) for (int y=0; y<pg.height; y++) {

      int p = y*pg.width + x;
      int e = x >= pg.width-d ? 0 : d;
      int w = x >= d ? -d : 0;
      int n = y >= d ? -pg.width*d : 0;
      int s = y >= (pg.height-d) ? 0 : pg.width*d;
      int r = ( r(pg.pixels[p+w]) + r(pg.pixels[p+e]) + r(pg.pixels[p+n]) + r(pg.pixels[p+s]) ) >> 2;
      int g = ( g(pg.pixels[p+w]) + g(pg.pixels[p+e]) + g(pg.pixels[p+n]) + g(pg.pixels[p+s]) ) >> 2;
      int b = ( b(pg.pixels[p+w]) + b(pg.pixels[p+e]) + b(pg.pixels[p+n]) + b(pg.pixels[p+s]) ) >> 2;
      px[p] = 0xff000000 + (r<<16) | (g<<8) | b;

      //Turns black pixels transparent ///
      int tr = r(px[p]);
      int tg = g(px[p]);
      int tb = b(px[p]);
      if (tr==0 && tg==0 && tb==0) px[p] = px[p] &= 0x00FFFFFF;
      /// ///
    }
    arrayCopy(px, pg.pixels);
  }
}

void mix(int[] px, int n, PGraphics pg) {
  for (int i=0; i< pg.pixels.length; i++) {

    int r = (r(pg.pixels[i]) >> 1)  + (r(px[i]) >> 1) + (r(pg.pixels[i]) >> n)  - (r(px[i]) >> n) ;
    int g = (g(pg.pixels[i]) >> 1)  + (g(px[i]) >> 1) + (g(pg.pixels[i]) >> n)  - (g(px[i]) >> n) ;
    int b = (b(pg.pixels[i]) >> 1)  + (b(px[i]) >> 1) + (b(pg.pixels[i]) >> n)  - (b(px[i]) >> n) ;
    pg.pixels[i] =  0xff000000 | (r<<16) | (g<<8) | b;
    int tr = r(pg.pixels[i]);
    int tg = g(pg.pixels[i]);
    int tb = b(pg.pixels[i]);
     /// Turns black pixels transparent ///
    if (tr==0 && tg==0 && tb==0) pg.pixels[i] = pg.pixels[i] &= 0x00FFFFFF;
  }
}

int r(color c) {
  return (c >> 16) & 255;
}
int g(color c) {
  return (c >> 8) & 255;
}
int b(color c) {
  return c & 255;
}