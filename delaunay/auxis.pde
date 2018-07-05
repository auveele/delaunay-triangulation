
/*
  GUARDAMOS PDF
 */
void save_pdf() {
  if (rendering == true) noLoop();
  beginRecord(PDF, get_file_name(".pdf"));
  int x, y;
  color c;
  for (Triangle2D t : vor.getTriangles ()) {
    t.computeCentroid();
    x = int(constrain(t.centroid.x, 0, img.width  - 1));
    y = int(constrain(t.centroid.y, 0, img.height - 1));
    c = img.get(x, y);

    fill(c);
    noStroke();
    triangle(t.a.x, t.a.y, t.b.x, t.b.y, t.c.x, t.c.y);
  }
  endRecord();
  println("PDF guardado.");
  if (rendering == true) loop();
}

/*
  GUARDAMOS PNG
 */
void save_png() {
  if (rendering == true) { 
    noLoop();
  }
  saveFrame(get_file_name(".png"));
  println("PNG guardado.");
  if (rendering == true) { 
    loop();
  }
}

/*
  INICIAMOS RENDER
 */
void render_on() {
  rendering = true;
  loop();
}

/*
  STOP RENDER
 */
void render_off() {
  rendering = false;
  noLoop();
}

/*
  DEVUELVE EL NOMBRE DE ARCHIVO CON LA FECHA
 */
static final String get_file_name(final String ext) {
  return "../exports/" + file_name + "-" + year() + nf(month(), 2) + nf(day(), 2) +
    nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2) + ext;
}
