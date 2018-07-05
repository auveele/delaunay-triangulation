import toxi.geom.Vec2D;
import toxi.geom.Vec3D;
import toxi.geom.Triangle2D;
import toxi.geom.Polygon2D;
import toxi.geom.mesh2d.Voronoi;
import processing.pdf.*;
import java.util.ArrayList;
import controlP5.*;

/* General variables */
ArrayList<Triangle2D> triangles;
Voronoi vor;
PImage img = null;
int nbPoints;
int maxPoints;
Vec2D origin, xmax, ymax, bound;
float s;

PGraphics map;
PGraphics draw;

float outputRatio;
PVector position = new PVector(0, 0);// For moving the FBO.
Vec2D worst;
boolean recording;

ControlFrame cf;

static String[] file_path;  // Nombre de la imagen que cargas
static String file_name;


/*
  MAIN SETUP
*/
void setup() {
  cf = new ControlFrame(this, 360, 720, "controlframe");
  surface.setTitle("Vista previa");
  
  maxPoints = 20000;
  nbPoints = maxPoints;
  s = 8;

  // Tamaño inicial
  surface.setSize(500, 300);
  surface.setLocation(600, 200);
  recording = false;
  noLoop();
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or user canceled");
    exit();
  } else {
    
    // Pillamos el nombre del fichero de la ruta absoluta
    file_path = splitTokens(selection.getAbsolutePath(), System.getProperty("file.separator"));
    file_name = file_path[file_path.length - 1];
    
    // Cargamos imagen
    img = loadImage(selection.getAbsolutePath());
    // Redimensionamos ventana de Vista Previa
    int x = img.width;
    int y = img.height;
    surface.setSize(img.width, img.height);

    map     = createGraphics(x, y);
    draw    = createGraphics(x, y);

    outputRatio = 2.0; 

    triangles = new ArrayList<Triangle2D> ();
    vor = new Voronoi ();

    noStroke();

    map.beginDraw();
    map.background(0);
    map.endDraw();

    draw.beginDraw();
    draw.background(img);
    draw.endDraw();
   
    img.loadPixels();
    
    // Ponemos el nombre de la imagen cargada en el Label
    cf.change_image_path(file_name);
    // Habilitamos el botón de Render
    cf.setLock(cf.cp5.getController("render"), false);   
    //loop();
  }
}

/*
  
*/
void keyPressed() {
  switch(key) {
  case 'd': 
    println("Injecting...");
    nbPoints = maxPoints;
    loop();
    break;
  case 'c':
    cubism(16, 0.02);
    loop();
    break;
  case 'r': 
    recording = !recording; 
    break;
  case 'o':
    save_png();
    break;
  case 'p': 
    save_pdf();    
    break;
  }
}

void draw() {
  if (img == null) { 
    return;
 }
  background(0);  
  int x, y;
  color c, ca, cb, cc;

  draw.beginDraw();
  for (Triangle2D t : vor.getTriangles ()) {
    t.computeCentroid();
    x = int(constrain(t.centroid.x, 0, img.width  - 1));
    y = int(constrain(t.centroid.y, 0, img.height - 1));
    c = img.get(x, y);
    draw.fill(c);
    draw.noStroke();
    draw.triangle(t.a.x, t.a.y, t.b.x, t.b.y, t.c.x, t.c.y);
  }
  draw.endDraw();

  if (nbPoints > 0) {
    worst = findWorstPixel();
    // worst = maxDInRandom(3000);

    map.beginDraw();
    map.noStroke();
    map.fill(255);
    map.ellipse(worst.x, worst.y, s, s);
    //map.point(worst.x, worst.y);
    map.endDraw();

    vor.addPoint(new Vec2D(worst.x, worst.y));
    
    --nbPoints;
    cf.slider_iterations.setValue(nbPoints);
    
  } else {
    println("done");
    cf.toogle_render.setValue(false);
    noLoop();
  }
  image(draw, 0, 0);
}
