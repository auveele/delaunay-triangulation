class ControlFrame extends PApplet {

  int w, h;
  PApplet parent;
  ControlP5 cp5;
  
  Textlabel label_file_name;

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
    cp5 = new ControlP5(this);
    
    /*
      TITULO
    */
    Textlabel label_title = cp5.addTextlabel("title","TRIANGULATOR",100,10);
    label_title.setColor(color(0));
    
    /*
      BOTÓN CARGAR IMAGEN
    */
    Button bt_load_image = cp5.addButton("CARGAMOS IMAGEN GUAPACA")
       .setPosition(10, 10)
       .setSize(100, 50);
       
    bt_load_image.addCallback(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        switch(theEvent.getAction()) {
          case(ControlP5.ACTION_PRESSED):
            parent.selectInput("Select an image to process...", "fileSelected");
            println("start");
            break;
          case(ControlP5.ACTION_RELEASED):
            println("stop");
            break;
        }
      }
    });
    
    /*
      NOMBRE FICHERO
    */
    label_file_name = cp5.addTextlabel("file_name","Imagen: ",10,10);
    label_file_name.setColor(color(255));
    
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

  void draw() {
    // background(190);
    background(255);
  }
}
