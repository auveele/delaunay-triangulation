
ControlFrame cf;
Triangulator t;

static String[] file_path;  // Nombre de la imagen que cargas
static String file_name;


/*
  MAIN SETUP
 */
void setup() {
  // Instanciamos
  cf = new ControlFrame(this, 360, 720, "controlframe");
  t = new Triangulator();

  // Tamaño inicial
  surface.setTitle("Vista previa");
  surface.setSize(500, 300);
  surface.setLocation(600, 200);
}

/*
  MAIN DRAW
 */
void draw() {
  t.display();
  t.update();
  cf.update();
}
