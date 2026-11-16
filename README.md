[README.md](https://github.com/user-attachments/files/34928674/README.md)
# ⚔️ Dungeon Quiz

Juego de rol y trivia hecho con **Python (Streamlit)** y **MySQL**. Un héroe avanza por una mazmorra enfrentando monstruos: para derrotarlos tiene que responder preguntas guardadas en la base de datos. Si falla, pierde vida.

## Requisitos

- Python 3.9 o superior
- MySQL o MariaDB (por ejemplo, XAMPP)
- Un navegador

## Instalación

### 1. Crear la base de datos
1. Encendé **MySQL** desde XAMPP.
2. Abrí **phpMyAdmin** (`http://localhost/phpmyadmin`).
3. Creá una base llamada **`dungeon_quiz`** (cotejamiento `utf8mb4_general_ci`).
4. Entrá a esa base, elegí **Importar** y seleccioná el archivo `dungeon_quiz.sql`.

### 2. Instalar las dependencias
Desde la carpeta del proyecto:

```
pip install -r requirements.txt
```

### 3. Probar la conexión (opcional)
```
python probar_conexion.py
```
Debe mostrar `¡Conexión exitosa con Dungeon Quiz!`.

### 4. Ejecutar el juego
```
streamlit run app.py
```
Se abre en el navegador, normalmente en `http://localhost:8501`.

## Cómo se juega

1. Elegí un personaje (Guerrero, Mago o Arquero) y tocá **Comenzar aventura**.
2. Cada partida enfrenta a **3 monstruos** elegidos al azar, uno por piso.
3. Respondé la pregunta tocando una de las opciones A/B/C/D. Las preguntas son aleatorias y no se repiten dentro de la partida.
4. **Acierto:** +10 puntos y 30 de daño al monstruo. **Error:** el héroe pierde 20 HP.
5. Tenés **30 segundos** por pregunta; si se acaba el tiempo, cuenta como error.
6. Al derrotar a un monstruo ganás XP (15, 25 o 40 según su dificultad); al ganar la partida, 50 XP extra. Cada 100 XP subís de nivel.
7. Si la vida llega a 0, perdés. El resultado, el puntaje y el historial quedan guardados en la base y alimentan el ranking de los 5 mejores.

## Estructura del proyecto

```
Dungeon quiz/
├── app.py               # juego (interfaz, reglas y acceso a la base)
├── dungeon_quiz.sql     # estructura y datos de la base
├── probar_conexion.py   # prueba rápida de conexión
├── requirements.txt     # dependencias de Python
└── assets/
    ├── fondo_pagina.png # fondo de la página (opcional)
    ├── monstruos/       # slime.png, goblin.png, orco.png, esqueleto.png, troll.png, dragon.png
    └── personajes/      # guerrero.png, mago.png, arquero.png
```

Si falta alguna imagen, el juego igual funciona: muestra un emoji en su lugar.

## Base de datos

Tablas principales: `jugador`, `partida`, `monstruo`, `categoria`, `pregunta`, `opcion`, y dos tablas intermedias con atributos propios: `pregunta_partida` (preguntas presentadas en cada partida) y `monstruo_partida` (monstruos enfrentados). También incluye la vista `vista_preguntas_juego`.

## Configuración

- **Conexión a MySQL:** función `conectar()` en `app.py` (por defecto `localhost`, puerto `3306`, usuario `root`, sin contraseña, base `dungeon_quiz`).
- **Reglas del juego** (daño, XP, vida, tiempo por pregunta, tamaño del ranking): constantes al inicio de `app.py`.
- **Fondo de la página:** variable `FONDO_PAGINA` (`mazmorra`, `noche`, `lava` o `bosque`), o una imagen propia en `assets/fondo_pagina.png`.

## Problemas frecuentes

| Problema | Solución |
|---|---|
| `Can't connect to MySQL server` | Encendé MySQL en XAMPP. |
| `Access denied` | Poné tu contraseña en `conectar()` dentro de `app.py`. |
| `Unknown database 'dungeon_quiz'` | Creá la base e importá `dungeon_quiz.sql` (paso 1). |
| `streamlit` no se reconoce | Ejecutá `python -m streamlit run app.py`. |
| Aparecen emojis en vez de imágenes | Revisá que la carpeta `assets` esté junto a `app.py`; el juego avisa dónde busca. |

## Compartir el juego con un link (opcional)

Con **cloudflared** se puede generar un link público temporal mientras el juego corre en tu PC:

```
cloudflared tunnel --url http://localhost:8501
```
