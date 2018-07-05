import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import toxi.geom.Vec2D; 
import toxi.geom.Vec3D; 
import toxi.geom.Triangle2D; 
import toxi.geom.Polygon2D; 
import toxi.geom.mesh2d.Voronoi; 
import processing.pdf.*; 
import java.util.ArrayList; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class delaunay extends PApplet {










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


/*
  MAIN SETUP
*/
public void setup() {
  cf = new ControlFrame(this, 360, 720, "controlframe");
  surface.setTitle("Vista previa");
  
  maxPoints = 20000;
  nbPoints = maxPoints;
  s = 8;

  // Tamaño inicial
  surface.setSize(500, 300);
  recording = false;
  noLoop();
}

public void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or user canceled");
    exit();
  } else {
    
    String[] file_name = splitTokens(selection.getAbsolutePath(), System.getProperty("file.separator")); 
    
    img = loadImage(selection.getAbsolutePath());
    //println(img.pixels.length);
    int x = img.width;
    int y = img.height;
    surface.setSize(img.width, img.height);

    map     = createGraphics(x, y);
    draw    = createGraphics(x, y);

    outputRatio = 2.0f; 

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
    
    cf.change_image_path(file_name[file_name.length - 1]);
    cf.setLock(cf.cp5.getController("render"), false);   
    //loop();
  }
}

/*
  
*/
public void keyPressed() {
  switch(key) {
  case 'd': 
    println("Injecting...");
    nbPoints = maxPoints;
    loop();
    break;
  case 'c':
    cubism(16, 0.02f);
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

public void draw() {
  if (img == null) { 
    return;
 }
  background(0);  
  int x, y;
  int c, ca, cb, cc;

  draw.beginDraw();
  for (Triangle2D t : vor.getTriangles ()) {
    t.computeCentroid();
    x = PApplet.parseInt(constrain(t.centroid.x, 0, img.width  - 1));
    y = PApplet.parseInt(constrain(t.centroid.y, 0, img.height - 1));
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

/*
  GUARDAMOS PDF
*/
public void save_pdf() {
  beginRecord(PDF, get_file_name("", ".pdf"));
    int x, y;
    int c;
    for (Triangle2D t : vor.getTriangles ()) {
      t.computeCentroid();
      x = PApplet.parseInt(constrain(t.centroid.x, 0, img.width  - 1));
      y = PApplet.parseInt(constrain(t.centroid.y, 0, img.height - 1));
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
public void save_png() {
  saveFrame(get_file_name("", ".png"));
  println("PNG guardado.");
}

/*
  DEVUELVE EL NOMBRE DE ARCHIVO CON LA FECHA
*/
public static final String get_file_name(final String name, final String ext) {
  return "../exports/" + name + "-" + year() + nf(month(), 2) + nf(day(), 2) +
    nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2) + ext;
}
class ControlFrame extends PApplet {

  int pxls_column = 30;
  int w, h;
  PApplet parent;
  ControlP5 cp5;

  Textlabel label_title;
  Textlabel label_file_name;
  Textlabel label_render_on;
  Textlabel label_render_off;
  
  Textlabel label_iterations;
  Slider slider_iterations;
  Toggle toogle_render;

  public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(w, h);
  }

  public void setup() {
    surface.setLocation(10, 10);
    surface.setTitle("Triangulator v0.1");
    cp5 = new ControlP5(this);

    /*
      TITULO
     */
    label_title = cp5.addTextlabel("title")
      .setText("TRIANGULATOR")
      .setPosition(get_pixel_from_column(2, 0), get_pixel_from_column(1, 0))
      .setColor(color(0))
      .setWidth(get_pixel_from_column(8, 0))
      .setHeight(get_pixel_from_column(1, 0))
      .setFont(createFont("Arial", 28));

    /*
      BOTÓN CARGAR IMAGEN
     */
    Button bt_load_image = cp5.addButton("CARGAMOS IMAGEN ...")
      .setPosition(get_pixel_from_column(2, 0), get_pixel_from_column(3, 0))
      .setSize(get_pixel_from_column(8, 0), get_pixel_from_column(1, 0));

    bt_load_image.addCallback(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        switch(theEvent.getAction()) {
          case(ControlP5.ACTION_PRESSED):
          println("start");
          break;
          case(ControlP5.ACTION_RELEASED):
          parent.selectInput("Select an image to process...", "fileSelected");
          println("stop");
          break;
        }
      }
    }
    );

    /*
      NOMBRE FICHERO
     */
    label_file_name = cp5.addTextlabel("file_name")
      .setText("Imagen: ")
      .setPosition(get_pixel_from_column(2, 0), get_pixel_from_column(4, 5))
      .setColor(color(20))
      .setFont(createFont("Arial", 10));
      
    /*
      SLIDER
    */
    label_iterations = cp5.addTextlabel("iterations_lbl")
      .setText("Iteraciones ")
      .setPosition(get_pixel_from_column(2, -5), get_pixel_from_column(5, 15))
      .setColor(color(20))
      .setFont(createFont("Arial", 10));
      
    slider_iterations = cp5.addSlider("iterations")
     .plugTo(parent, "nbPoints")
     .setRange(0, 20000)
     .setValue(5000)
     .setPosition(get_pixel_from_column(2, 0), get_pixel_from_column(6, 0))
     .setSize(get_pixel_from_column(8, 0), get_pixel_from_column(1, 0));


    /*
      BOTÓN RENDER
     */
    label_render_on = cp5.addTextlabel("render_on")
      .setText("RENDER")
      .setPosition(get_pixel_from_column(2, 0), get_pixel_from_column(20, 0))
      .setColor(color(20))
      .setFont(createFont("Arial", 22));
    label_render_off = cp5.addTextlabel("render_off")
      .setText("OFF")
      .setPosition(get_pixel_from_column(8, 10), get_pixel_from_column(20, 0))
      .setColor(color(20))
      .setFont(createFont("Arial", 22));
    toogle_render = cp5.addToggle("render")
      .setPosition(get_pixel_from_column(2, 0), get_pixel_from_column(21, 0))
      .setSize(get_pixel_from_column(8, 0), get_pixel_from_column(2, 0))
      .setMode(ControlP5.SWITCH)
      .setValue(false);
    setLock(cp5.getController("render"), true);
    
    

    /*
    cp5.addToggle("calcular")
     .plugTo(parent, "calcular")
     .setPosition(10, 70)
     .setSize(50, 50)
     .setValue(false);
     
     cp5.addKnob("blend")
     .plugTo(parent, "c3")
     .setPosition(100, 300)
     .setSize(200, 200)
     .setRange(0, 255)
     .setValue(200);
     
     cp5.addNumberbox("color-red")
     .plugTo(parent, "c0")
     .setRange(0, 255)
     .setValue(255)
     .setPosition(100, 10)
     .setSize(100, 20);
     
     cp5.addNumberbox("color-green")
     .plugTo(parent, "c1")
     .setRange(0, 255)
     .setValue(128)
     .setPosition(100, 70)
     .setSize(100, 20);
     
     cp5.addNumberbox("color-blue")
     .plugTo(parent, "c2")
     .setRange(0, 255)
     .setValue(0)
     .setPosition(100, 130)
     .setSize(100, 20);
     
     cp5.addSlider("speed")
     .plugTo(parent, "speed")
     .setRange(0, 0.1)
     .setValue(0.01)
     .setPosition(100, 240)
     .setSize(200, 30);
     */
  }
  
  

  public void change_image_path(String image_path) {
    label_file_name.setText("Imagen: " + image_path);
  }
  
  public void render(boolean theFlag) {
    if (theFlag == true) {
      parent.loop();
      label_render_off.setText("ON");
    } else {
      parent.noLoop();
      label_render_off.setText("OFF");
    }
  }

  /*
    BLOQUEAMOS ELEMENTOS
  */
  public void setLock(Controller theController, boolean theValue) {   
    if (theValue) {
      theController.lock();
      theController.setColorBackground(color(100, 100));
      // theController.setColorForeground(color(100, 100));
    } else {
      theController.unlock();
      theController.setColorBackground(color(1, 45, 90));
      // theController.setColorForeground(color(100, 100));
    }
  }
  
  /*
    UTILIDAD COLUMNAS
  */
  public int get_pixel_from_column(int column, int offset) {
    return (column * pxls_column) + offset;
  }

  public void draw() {
    // background(190);
    background(255);
    
  }
}

public void cubism(int nbPoints, float percent) {
  for (int i = 0; i < nbPoints; ++i) {
    Vec2D v1 = new Vec2D(random(img.width), random(img.height));
    Vec2D v2 = new Vec2D(random(img.width), random(img.height));

    map.beginDraw();
    strokeWeight(s);
    stroke(255);
    line(v1.x, v1.y, v2.x, v2.y);
    map.endDraw();

    for (float p = 0.0f; p < 1.0f; p += percent) {
      vor.addPoint(v1.interpolateTo(v2, p));
    }
  }
}

/*
  RANDOM
*/
public Vec2D maxDInRandom(int nbSamples) {
  draw.loadPixels();
  map.loadPixels();
  Vec2D worst = new Vec2D();
  int bimg, bmap, b;
  bmap = 0;
  int worstIndex = 0;
  Vec3D diff = new Vec3D();
  float worstDiff = 0.0f;
  /* Find the worst pixel error */
  //for (int i = 0; i < draw.pixels.length; ++i) {
  for (int n = 0; n < nbSamples; ++n) {
    int i = PApplet.parseInt(random(draw.pixels.length));
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
public Vec2D findWorstPixel() {
  draw.loadPixels();
  map.loadPixels();
  Vec2D worst = new Vec2D();
  int bimg, bmap, b;
  bmap = 0;
  int worstIndex = 0;
  Vec3D diff = new Vec3D();
  float worstDiff = 0.0f;
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "delaunay" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
