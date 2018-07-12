import toxi.geom.Vec2D;
import toxi.geom.Vec3D;
import toxi.geom.Triangle2D;
import toxi.geom.Polygon2D;
import toxi.geom.mesh2d.Voronoi;
import processing.pdf.*;
import java.util.ArrayList;
// import java.util.List<Vec2D>;
// import java.util.List<Vec2D>;

class Triangulator {

  /* General variables */
  ArrayList<Triangle2D> triangles;
  Voronoi vor;

  Vec2D origin, xmax, ymax, bound;
  Vec2D worst;

  // Imágenes
  public PImage img = null;
  PGraphics bg;
  PGraphics map;
  PGraphics draw;

  // Variables de funcionalidad
  boolean recording = false;
  boolean rendering = false;
  boolean drawing = false;
  boolean render_mode;
  boolean show_stroke_value;
  boolean show_vertex_value;
  boolean show_fill_value;


  int nbPoints;
  int maxPoints;

  float vertex_size = 5;
  float stroke_size = 1;
  float outputRatio = 2.0; // creo que es para la Exportación
  PVector position = new PVector(0, 0);// For moving the FBO.


  Triangulator() {
    triangles = new ArrayList<Triangle2D> ();
    vor = new Voronoi ();
  }

  void settings() {
  }

  /*
    CALCULAMOS PUNTOS VORONOID
   */
  void update() {
    if (img == null) return;
    if (rendering == true) {
      if (nbPoints > 0) {
        if (render_mode == false) {
          worst = findWorstPixel();
        } else {
          worst = maxDInRandom(3000);
        }
        // Añadimos punto nuevo
        vor.addPoint(new Vec2D(worst.x, worst.y));
        // Restamos al contador
        --nbPoints;
      } else {
        // No quedan puntos que calcular
        render_off();
      }
    } else {
      // Rendering se pone a False
      println("FIN RENDER");
      cf.toggle_render.setValue(false);
    }
  }

  /*
    PINTAMOS COSAS BONITAS
   */
  void display() {
    // Comprobamos que hayan imágenes
    if (img == null) return;
    if (drawing == false) return;

    draw_background();
    draw_triangles();
    draw_vertex();
  }

  /*
      PINTAMOS FONDO
   */
  void draw_background() {
    bg.beginDraw();
    bg.clear();
    bg.background(img);
    bg.endDraw();
    image(bg, 0, 0);
  }

  /*
      PINTAMOS TRIANGULOS
   */
  void draw_triangles() {
    int x, y;
    color c; //, ca, cb, cc;
    draw.beginDraw();
    draw.clear();
    for (Triangle2D tri : vor.getTriangles ()) {
      tri.computeCentroid();
      x = int(constrain(tri.centroid.x, 0, img.width  - 1));
      y = int(constrain(tri.centroid.y, 0, img.height - 1));
      c = img.get(x, y);
      if (show_fill_value == true) {
        draw.fill(c);
      } else {
        draw.fill(0, 0);
      }
      if (show_stroke_value == false) {
        draw.noStroke();
      } else {
        strokeWeight(stroke_size);
        draw.stroke(0);
      }
      
      draw.triangle(tri.a.x, tri.a.y, tri.b.x, tri.b.y, tri.c.x, tri.c.y);
    }
    draw.endDraw();
    if ((show_fill_value == true) || (show_stroke_value == true)) image(draw, 0, 0);
  }

  /*
      PINTAMOS PUNTOS
   */
  void draw_vertex() {
    map.beginDraw();
    map.clear();
    map.noStroke();
    map.fill(255);
    for (Vec2D w : vor.getSites ()) {
      map.ellipse(w.x, w.y, vertex_size, vertex_size);
      //map.point(worst.x, worst.y);
    }
    map.endDraw();
    if (show_vertex_value == true) image(map, 0, 0);
  }

  /*
   CUBISMO
   */
  void cubism(int nbPoints, float percent) {
    println("C");
    for (int i = 0; i < nbPoints; ++i) {
      Vec2D v1 = new Vec2D(random(img.width), random(img.height));
      Vec2D v2 = new Vec2D(random(img.width), random(img.height));

      map.beginDraw();
      strokeWeight(stroke_size);
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

  /*
    ASIGNAMOS IMAGEN A TRIANGULAR
   */
  void asign_image(String path) {
    img = loadImage(path);

    // Redimensionamos ventana de Vista Previa
    int x = img.width;
    int y = img.height;
    surface.setSize(img.width, img.height);

    bg     = createGraphics(x, y);
    map     = createGraphics(x, y);
    draw    = createGraphics(x, y);

    noStroke();
    // Iniciamos map
    map.beginDraw();
    // map.background(0);
    map.endDraw();

    // Iniciamos draw
    draw.beginDraw();
    draw.background(img);
    draw.endDraw();

    img.loadPixels();
    drawing = true;
  }

  // INICIAMOS RENDER
  void render_on() {
    rendering = true;
    println("START RENDER");
  }
  // STOP RENDER
  void render_off() {
    rendering = false;
    println("STOP RENDER");
  }
}
