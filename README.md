

# Triangulator
Poligoniza tu imagen mediante la triangulación de Delaunay.

Permite seleccionar varios métodos de colocar los puntos, incluido desde el ratón.
Exporta la triangulación en PDF y PNG.


## Instrucciones de instalación
- Descarga e instala el IDE de [**Processing 3**](https://processing.org/download/)
- Descarga e instala manualmente la librería [**ToxicLibs**](http://toxiclibs.org/downloads/)
- Desde el IDE de Processing, instala la librería **ControlP5**

## Cómo funciona
1. Carga la imagen a modificar.
2. Asigna el número de iteraciones de la triangulación. (Default: 5000)
3. Puedes ir viendo como quedan las diferentes capas.
    - STROKE - Dibuja el contorno.
    - VERTEX - Dibuja los vértices de los triángulos.
    - FILL - Colorea los triángulos.
    - BACKGROUND - Mostrar fondo.
4. Crea puntos para triangular:
    - Utiliza el render automático.
    - Crea puntos con el ratón y renderiza.
    - Renderiza un poco, saca más puntos con el ratón, renderiza más.
    - Triangula conforme te salga del chorizo.

5. No olvides guardar la imagen.
