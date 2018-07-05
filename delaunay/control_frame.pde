/*
  
  Ventana de control

*/
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
      .setPosition(get_pixel_from_column(2, 0), get_pixel_from_column(18, 0))
      .setColor(color(20))
      .setFont(createFont("Arial", 22));
    label_render_off = cp5.addTextlabel("render_off")
      .setText("OFF")
      .setPosition(get_pixel_from_column(8, 10), get_pixel_from_column(18, 0))
      .setColor(color(20))
      .setFont(createFont("Arial", 22));
    toogle_render = cp5.addToggle("render")
      .setPosition(get_pixel_from_column(2, 0), get_pixel_from_column(19, 0))
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
  
  

  void change_image_path(String image_path) {
    label_file_name.setText("Imagen: " + image_path);
  }
  
  void render(boolean theFlag) {
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
