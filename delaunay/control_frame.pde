/*
  
 Ventana de control
 
 */
class ControlFrame extends PApplet {

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
  Toggle toogle_render;
  Bang bang_save_pdf;
  Bang bang_save_png;
  Toggle toggle_mode;
  Toggle toggle_render;

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
    Button bt_load_image = cp5.addButton("load_image")
      .setLabel("CARGAMOS IMAGEN ...")
      .setPosition(get_pixel_from_column(2, 0), get_pixel_from_column(3, 0))
      .setSize(get_pixel_from_column(8, 0), get_pixel_from_column(1, 0));

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
      MODE
     */
    toggle_render = cp5.addToggle("render_mode")
      .plugTo(parent, "render_mode")
      .setPosition(get_pixel_from_column(4, 0), get_pixel_from_column(8, 0))
      .setSize(get_pixel_from_column(4, 0), get_pixel_from_column(1, 0))
      .setMode(ControlP5.SWITCH)
      .setValue(false);

    /*
      BOTÓN RENDER
     */
    label_render_on = cp5.addTextlabel("render_on")
      .setText("RENDER")
      .setPosition(get_pixel_from_column(2, 0), get_pixel_from_column(16, 0))
      .setColor(color(20))
      .setFont(createFont("Arial", 22));
    label_render_off = cp5.addTextlabel("render_off")
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
  }

  /*
    EVENTO - BOTÓN CARGAR IMAGEN
   */
  void load_image() {
    parent.selectInput("Select an image to process...", "fileSelected");
  }
  // AL CARGAR IMAGEN MODIFICAMOS LABEL
  void change_image_path(String image_path) {
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
    rendering = true;
    if (theFlag == true) {
      render_on();
      label_render_off.setText("ON");
    } else {
      render_off();
      label_render_off.setText("OFF");
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
    UTILIDAD COLUMNAS
   */
  int get_pixel_from_column(int column, int offset) {
    return (column * pxls_column) + offset;
  }

  void draw() {
    // background(190);
    background(255);
  }
}
