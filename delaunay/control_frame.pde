/*
  
 Ventana de control
 
 */

import controlP5.*;

public class ControlFrame extends PApplet {
  // Atributos
  int pxls_column = 30;
  int w, h;
  PApplet parent;
  ControlP5 cp5;

  /*
    Declaramos elementos GUI
   */
  Textlabel label_title;
  Textlabel label_file_name;
  Textlabel label_render_on;
  Textlabel label_render_off;
  Textlabel label_iterations;
  Slider slider_iterations;
  Toggle toggle_render;
  Toggle toggle_stroke;
  Bang bang_save_pdf;
  Bang bang_save_png;
  Toggle toggle_mode;
  Toggle toggle_vertex;
  Toggle toggle_fill;

  // Variables
  boolean setup = false;

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
    surface.setLocation(200, 200);
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
    Bang bang_load_image = cp5.addBang("load_image")
      .setTriggerEvent(Bang.RELEASE)
      .setLabel("CARGAMOS IMAGEN ...")
      .setColorLabel(0)
      .setPosition(get_pixel_from_column(2, 0), get_pixel_from_column(3, 0))
      .setSize(get_pixel_from_column(8, 0), get_pixel_from_column(1, 0));

    /*
      NOMBRE FICHERO
     */
    label_file_name = cp5.addTextlabel("file_name")
      .setText("Imagen: ")
      .setPosition(get_pixel_from_column(2, 0), get_pixel_from_column(5, 0))
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
      .plugTo(t, "nbPoints")
      .setRange(0, 20000)
      .setValue(5000)
      .setPosition(get_pixel_from_column(2, 0), get_pixel_from_column(6, 0))
      .setSize(get_pixel_from_column(8, 0), get_pixel_from_column(1, 0));

    /*
      MODE
     */
    toggle_render = cp5.addToggle("render_mode")
      .plugTo(parent, "render_mode")
      .setPosition(get_pixel_from_column(4, 0), get_pixel_from_column(8, 0))
      .setSize(get_pixel_from_column(4, 0), get_pixel_from_column(1, 0))
      .setMode(ControlP5.SWITCH)
      .setValue(false)
      .setLabel("SET MODE: RANDOM / WORST")
      .setColorLabel(0);

    /*
      STROKE
     */
    toggle_stroke = cp5.addToggle("toggle_stroke_value")
      .plugTo(t, "show_stroke_value")
      .setPosition(get_pixel_from_column(3, 0), get_pixel_from_column(10, 0))
      .setSize(get_pixel_from_column(1, 0), get_pixel_from_column(1, 0))
      .setLabel("STROKE")
      .setColorLabel(0)
      .setValue(false);
    /*
      VERTEX
     */
    toggle_vertex = cp5.addToggle("toggle_vertex_value")
      .plugTo(t, "show_vertex_value")
      .setPosition(get_pixel_from_column(5, 0), get_pixel_from_column(10, 0))
      .setSize(get_pixel_from_column(1, 0), get_pixel_from_column(1, 0))
      .setLabel("VERTEX")
      .setColorLabel(0)
      .setValue(false);
    /*
      PINTAMOS TRIANGULOS
     */
    toggle_fill = cp5.addToggle("toggle_fill_value")
      .plugTo(t, "show_fill_value")
      .setPosition(get_pixel_from_column(7, 0), get_pixel_from_column(10, 0))
      .setSize(get_pixel_from_column(1, 0), get_pixel_from_column(1, 0))
      .setLabel("RELLENO")
      .setColorLabel(0)
      .setValue(true);

    /*
      BOTÓN RENDER
     */
    label_render_on = cp5.addTextlabel("lbl_render_on")
      .setText("RENDER")
      .setPosition(get_pixel_from_column(2, 0), get_pixel_from_column(16, 0))
      .setColor(color(20))
      .setFont(createFont("Arial", 22));
    label_render_off = cp5.addTextlabel("lbl_render_off")
      .setText("OFF")
      .setPosition(get_pixel_from_column(8, 10), get_pixel_from_column(16, 0))
      .setColor(color(20))
      .setFont(createFont("Arial", 22));
    toggle_render = cp5.addToggle("render")
      .setPosition(get_pixel_from_column(2, 0), get_pixel_from_column(17, 0))
      .setSize(get_pixel_from_column(8, 0), get_pixel_from_column(2, 0))
      .setMode(ControlP5.SWITCH)
      .setValue(false);
    setLock(cp5.getController("render"), true);

    /*
    BOTÓN GUARDAR PDF
     */
    bang_save_pdf  = cp5.addBang("save_pdf")
      .plugTo(parent, "save_pdf")
      .setPosition(get_pixel_from_column(3, 0), get_pixel_from_column(20, 0))
      .setSize(get_pixel_from_column(2, 0), get_pixel_from_column(2, 0))
      .setTriggerEvent(Bang.RELEASE)
      .setLabel("GUARDAR PDF")
      .setColorLabel(0)
      .setLock(true);

    /*
    BOTÓN GUARDAR PNG
     */
    bang_save_png  = cp5.addBang("save_png")
      .plugTo(parent, "save_png")
      .setPosition(get_pixel_from_column(7, 0), get_pixel_from_column(20, 0))
      .setSize(get_pixel_from_column(2, 0), get_pixel_from_column(2, 0))
      .setTriggerEvent(Bang.RELEASE)
      .setLabel("GUARDAR PNG")
      .setColorLabel(0)
      .setLock(true);
    /*
    FIN SETUP
     */
    setup = true;
  }

  /*
    CARGAMOS IMAGEN
   */
  void load_image() {
    selectInput("Select an image", "imageChosen");
  }
  // COMPROBAMOS IMAGEN CARGADA
  void imageChosen( File f ) {
    if ( f.exists() ) {
      // Pillamos el nombre del fichero de la ruta absoluta
      file_path = splitTokens(f.getAbsolutePath(), System.getProperty("file.separator"));
      file_name = file_path[file_path.length - 1];
      // Pasamosla imagen al triangulator
      t.asign_image(f.getAbsolutePath());
      // Ponemos el nombre de la imagen cargada en el Label
      change_image_path(file_name);
    } else {
      // No existe
      println("Window was closed or user canceled");
      exit();
    }
  }


  // AL CARGAR IMAGEN MODIFICAMOS LABEL
  void change_image_path(String image_path) {
    // Ponemos nombre de la imagen en label
    label_file_name.setText("Imagen: " + image_path);
    // Habilitamos el botón de Render
    toggle_render.setLock(false);
    // Habilitamos el botón de Render
    bang_save_png.setLock(false);
    bang_save_pdf.setLock(false);
  }

  /*
    EVENTO - BOTÓN RENDER
   */
  void render(boolean theFlag) {
    // t.rendering = theFlag;
    if (theFlag == true) {
      t.render_on();
    } else {
      t.render_off();
    }
  }


  /*
    BLOQUEAMOS ELEMENTOS
   */
  void setLock(Controller theController, boolean theValue) {   
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
    UPDATE IN LOOP
   */
  void update() {
    if (setup == false) return;
    // Leemos los nbPoints y asignamos al valor
    slider_iterations.setValue(t.nbPoints);
    // Comprobamos rendering
    if (t.rendering == true) {
      label_render_off.setText("ON");
      // toggle_render.setState(true);
    } else {
      label_render_off.setText("OFF");
      // toggle_render.setState(false);
    }
  }

  /*
    UTILIDAD COLUMNAS
   */
  int get_pixel_from_column(int column, int offset) {
    return (column * pxls_column) + offset;
  }

  /*
    DRAW CONTROL
   */
  void draw() {
    background(255);
  }
}
