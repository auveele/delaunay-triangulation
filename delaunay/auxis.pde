
/*
  GUARDAMOS PDF
*/
void save_pdf() {
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
}

/*
  GUARDAMOS PNG
*/
void save_png() {
  saveFrame(get_file_name(".png"));
  println("PNG guardado.");
}

/*
  DEVUELVE EL NOMBRE DE ARCHIVO CON LA FECHA
*/
static final String get_file_name(final String ext) {
  return "../exports/" + file_name + "-" + year() + nf(month(), 2) + nf(day(), 2) +
    nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2) + ext;
}
