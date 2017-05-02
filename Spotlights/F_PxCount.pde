int numOfColoredPxInCircle(PGraphics gbuf, int cx, int cy, int radius, int r, int g, int b) {
  int ct = 0;

  int x1 = cx - radius;
  int x2 = cx + radius;
  int y1 = cy - radius;
  int y2 = cy + radius;
  gbuf.loadPixels();
  for (int i=y1; i<=y2; i++) {
    for (int j=x1; j<=x2; j++) {
      float l = dist(j, i, cx, cy);
      if (l <= radius) {
        color pxclr =   gbuf.pixels[i*gbuf.width+j];
        float pr = red(pxclr);
        float pg = green(pxclr);
        float pb = blue(pxclr);
        if (pr==r && pg==g && pb==b) {
          ct++;
        }
      }
    }
  }
  return ct;
}

