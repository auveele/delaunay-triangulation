/*
  PULSACIÓN DE TECLAS
*/
void keyPressed() {
  switch(key) {
  case 'd': 
    t.render_on();
    break;
  case 'c':
    t.cubism(16, 0.02);
    // loop();
    break;
  case 'r': 
    t.recording = !t.recording; 
    break;
  case 'o':
    save_png();
    break;
  case 'p': 
    save_pdf();    
    break;
  }
}


/*
  GUARDAMOS PDF
 */
void save_pdf() {
  if (t.rendering == true) stop();
  beginRecord(PDF, get_file_name(".pdf"));
  int x, y;
  color c;
  for (Triangle2D tri : t.vor.getTriangles ()) {
    tri.computeCentroid();
    x = int(constrain(tri.centroid.x, 0, t.img.width  - 1));
    y = int(constrain(tri.centroid.y, 0, t.img.height - 1));
    c = t.img.get(x, y);

    fill(c);
    noStroke();
    triangle(tri.a.x, tri.a.y, tri.b.x, tri.b.y, tri.c.x, tri.c.y);
  }
  endRecord();
  println("PDF guardado.");
  if (t.rendering == true) start();
}

/*
  GUARDAMOS PNG 
 */
void save_png() {
  if (t.rendering == true) stop();
  saveFrame(get_file_name(".png"));
  println("PNG guardado.");
  if (t.rendering == true) start();
}

/*
  DEVUELVE EL NOMBRE DE ARCHIVO CON LA FECHA
 */
static final String get_file_name(final String ext) {
  return "../exports/" + file_name + "-" + year() + nf(month(), 2) + nf(day(), 2) +
    nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2) + ext;
}
