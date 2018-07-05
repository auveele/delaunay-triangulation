
void cubism(int nbPoints, float percent) {
  println("C");
  for (int i = 0; i < nbPoints; ++i) {
    Vec2D v1 = new Vec2D(random(img.width), random(img.height));
    Vec2D v2 = new Vec2D(random(img.width), random(img.height));

    map.beginDraw();
    strokeWeight(s);
    stroke(255);
    line(v1.x, v1.y, v2.x, v2.y);
    map.endDraw();

    for (float p = 0.0; p < 1.0; p += percent) {
      vor.addPoint(v1.interpolateTo(v2, p));
    }
  }
  println("Fin");
}

/*
  RANDOM
*/
Vec2D maxDInRandom(int nbSamples) {
  draw.loadPixels();
  map.loadPixels();
  Vec2D worst = new Vec2D();
  int bimg, bmap, b;
  bmap = 0;
  int worstIndex = 0;
  Vec3D diff = new Vec3D();
  float worstDiff = 0.0;
  /* Find the worst pixel error */
  //for (int i = 0; i < draw.pixels.length; ++i) {
  for (int n = 0; n < nbSamples; ++n) {
    int i = int(random(draw.pixels.length));
    bimg = img.pixels[i];
    bmap = map.pixels[i];
    b    = draw.pixels[i];
    diff.x = red(bimg) - red(b);
    diff.y = green(bimg) - green(b);
    diff.z = blue(bimg) - blue(b);
    if (diff.magSquared() > worstDiff && brightness(bmap) < 10) {
      worstDiff = diff.magSquared();
      worstIndex = i;
    }
  }
  worst.x = worstIndex % img.width;
  worst.y = (worstIndex - worst.x) / img.width;

  return worst;
}

/*
  PIXEL CHUNGO
*/
Vec2D findWorstPixel() {
  draw.loadPixels();
  map.loadPixels();
  Vec2D worst = new Vec2D();
  int bimg, bmap, b;
  bmap = 0;
  int worstIndex = 0;
  Vec3D diff = new Vec3D();
  float worstDiff = 0.0;
  /* Find the worst pixel error */
  for (int i = 0; i < draw.pixels.length; ++i) {
    bimg = img.pixels[i];
    bmap = map.pixels[i];
    b    = draw.pixels[i];
    diff.x = red(bimg) - red(b);
    diff.y = green(bimg) - green(b);
    diff.z = blue(bimg) - blue(b);
    if (diff.magSquared() > worstDiff && brightness(bmap) < 10) {
      worstDiff = diff.magSquared();
      worstIndex = i;
    }
  }
  worst.x = worstIndex % img.width;
  worst.y = (worstIndex - worst.x) / img.width;

  return worst;
}
