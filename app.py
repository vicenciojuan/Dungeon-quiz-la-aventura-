"""
Dungeon Quiz - todo en un solo archivo.

  PARTE 1: configuración del juego (reglas y valores)
  PARTE 2: apartado VISUAL (CSS y componentes)
  PARTE 3: apartado FUNCIONAL (base de datos y lógica)

Ejecutar con:  streamlit run app.py
"""
import base64
import html
import time
import unicodedata
from functools import lru_cache
from pathlib import Path

import mysql.connector
import streamlit as st

st.set_page_config(
    page_title="Dungeon Quiz",
    page_icon="⚔️",
    layout="centered"
)

# ############################################################
# PARTE 1: CONFIGURACION DEL JUEGO
# ############################################################

RECOMPENSA_VICTORIA = 50
XP_POR_DIFICULTAD = {"FACIL": 15, "MEDIO": 25, "DIFICIL": 40}   # XP por monstruo derrotado
XP_POR_NIVEL = 100
VIDA_INICIAL = 100
PUNTOS_ACIERTO = 10
DANIO_ACIERTO = 30      # daño que recibe el monstruo
DANIO_FALLO = 20        # daño que recibe el héroe
TOP_RANKING = 5         # la consigna pide el top 5
TIEMPO_PREGUNTA = 30    # segundos; poné None para desactivar el límite

PISOS = ["LA ENTRADA", "CATACUMBAS", "EL ABISMO"]

# Fondo de la página: "mazmorra", "noche", "lava" o "bosque".
# Si existe assets/fondo_pagina.png (o .jpg/.webp), se usa esa imagen en su lugar.
FONDO_PAGINA = "mazmorra"


# ############################################################
# PARTE 2: APARTADO VISUAL
# (solo cómo se ve; no toca la base de datos)
# ############################################################

# Recursos gráficos
BASE = Path(__file__).resolve().parent         # carpeta donde está app.py
CARPETA_MONSTRUOS = BASE / "assets" / "monstruos"   # goblin.png, slime.png...
FONDO_ESCENA = BASE / "assets" / "fondo.png"        # opcional
EMOJI_FALLBACK = {
    "slime": "🟢", "goblin": "👺", "orco": "👹",
    "esqueleto": "💀", "troll": "🧌", "dragon": "🐉",
}

# =====================================
# CSS
# =====================================

CSS = """
<style>
@import url('https://fonts.googleapis.com/css2?family=Press+Start+2P&family=VT323&display=swap');

:root {
    --fondo: #0d0a10;
    --panel: #14122e;
    --panel-2: #1c1840;
    --borde: #a48a56;
    --borde-suave: #5e5238;
    --texto: #eee5cf;
    --apagado: #a39dba;
    --oro: #e5c77d;
    --vida: #c0392b;
    --xp: #d9a07a;
}

.stApp {
    background:
        radial-gradient(ellipse at center, rgba(55,43,35,0.35), transparent 75%),
        repeating-linear-gradient(90deg, #100e0d 0px, #100e0d 3px, #15110f 3px, #15110f 6px);
    color: var(--texto);
}
.stApp, .stApp p, .stApp label, .stApp li {
    font-family: 'VT323', monospace;
    font-size: 22px;
    color: var(--texto);
}

header[data-testid="stHeader"] { background: rgba(10, 8, 8, 0.95); }
.stMainBlockContainer, .block-container { max-width: 760px; padding-top: 2rem; }
img { image-rendering: pixelated; }
.escena img { image-rendering: auto; }

h1 {
    font-family: 'Press Start 2P', monospace !important;
    color: var(--oro) !important;
    text-align: center;
    font-size: 26px !important;
    text-shadow: 3px 3px #542d16;
    line-height: 1.8 !important;
}
h2, h3 {
    font-family: 'Press Start 2P', monospace !important;
    color: var(--oro) !important;
    font-size: 14px !important;
    line-height: 1.8 !important;
}

[data-testid="stVerticalBlockBorderWrapper"] {
    background: rgba(20, 15, 24, 0.94);
    border: 2px solid var(--borde);
    border-radius: 3px;
}

/* ---------- Botones (también las opciones A/B/C/D) ---------- */
.stButton > button {
    background: var(--panel-2);
    color: var(--texto);
    border: 3px solid var(--borde-suave);
    border-radius: 0;
    min-height: 56px;
    height: auto;
    padding: .7rem 1rem;
    justify-content: flex-start;
    text-align: left;
    transition: 0.1s;
}
.stButton > button p {
    font-family: 'Press Start 2P', monospace;
    font-size: 11px;
    line-height: 1.6;
    white-space: normal;
}
.stButton > button:hover {
    background: #2a2358;
    border-color: var(--oro);
    color: #ffffff;
}
.stButton > button:focus-visible { outline: 3px solid var(--xp); outline-offset: 2px; }
.stButton > button:active { background: var(--xp); color: #000; }

/* ---------- Selectbox y lista desplegable (sin fondo blanco) ---------- */
div[data-baseweb="select"] > div {
    background: var(--panel);
    border: 3px solid var(--borde);
    border-radius: 0;
}
div[data-baseweb="select"] * { color: var(--texto) !important; }
div[data-baseweb="popover"], div[data-baseweb="popover"] ul {
    background: var(--panel) !important;
    border: 2px solid var(--borde);
    border-radius: 0;
}
div[data-baseweb="popover"] li { background: var(--panel) !important; }
div[data-baseweb="popover"] li:hover { background: var(--panel-2) !important; }

hr { border-color: var(--borde) !important; }
.stAlert { background: var(--panel); border: 2px solid var(--borde); border-radius: 0; }

/* ---------- Barras ---------- */
.barra { flex: 1; height: 14px; background: #000; border: 2px solid var(--borde-suave); }
.barra .relleno { height: 100%; }
.barra .vida { background: var(--vida); }
.barra .xp { background: var(--xp); }

/* ---------- Tarjeta del héroe ---------- */
.heroe { background: var(--panel); border: 3px solid var(--borde); padding: 1rem 1.2rem; margin: .5rem 0 1rem; }
.heroe .fila { display: flex; align-items: center; gap: .7rem; margin: .45rem 0; }
.heroe .nombre { font-family: 'Press Start 2P', monospace; font-size: 12px; color: var(--oro); flex: 1; }
.heroe .etq { font-family: 'Press Start 2P', monospace; font-size: 10px; width: 2.2rem; }
.heroe .num { min-width: 5.5rem; text-align: right; }
.heroe .nota { color: var(--apagado); font-size: 20px; }

/* ---------- Escena del monstruo ---------- */
.escena {
    text-align: center; padding: 1.2rem 1rem 1rem; border: 3px solid var(--borde-suave);
    background:
        radial-gradient(ellipse at 12% 40%, rgba(230,130,40,.35), transparent 35%),
        radial-gradient(ellipse at 88% 40%, rgba(230,130,40,.35), transparent 35%),
        linear-gradient(#1a1410, #0b0912);
    background-size: cover; background-position: center;
}
.escena .piso { font-family: 'Press Start 2P', monospace; font-size: 10px; color: var(--apagado); margin-bottom: .8rem; }
.escena img { height: 260px; max-width: 100%; object-fit: contain; }
.escena .emoji { font-size: 8rem; line-height: 1.3; }
.escena .hp { display: flex; align-items: center; gap: .7rem; max-width: 440px; margin: .8rem auto 0; }
.escena .hp span { font-family: 'Press Start 2P', monospace; font-size: 10px; white-space: nowrap; }

/* ---------- Pregunta ---------- */
.quien { text-align: center; font-family: 'Press Start 2P', monospace; font-size: 12px; margin: 1rem 0 .6rem; }
.pregunta {
    background: var(--panel); border: 3px solid var(--borde);
    box-shadow: inset 0 0 0 2px var(--fondo);
    padding: 1.2rem 1.4rem; text-align: center;
    font-family: 'Press Start 2P', monospace; font-size: 13px; line-height: 1.9;
}
.meta { text-align: center; color: var(--apagado); margin: .5rem 0 0; }

/* ---------- Barra de tiempo ---------- */
.tiempo { height: 14px; border: 2px solid var(--borde-suave); background: #000; margin: 1rem 0; }
.tiempo > div { height: 100%; width: 100%; background: var(--xp); }
@keyframes vaciar { from { width: 100%; } to { width: 0%; } }

/* ---------- Selección de personaje ---------- */
.personaje { background: var(--panel); border: 3px solid var(--borde-suave);
             padding: 1rem .5rem .8rem; text-align: center; margin-bottom: .5rem; }
.personaje.elegido { border-color: var(--oro); background: #1c1840;
             box-shadow: 0 0 0 3px rgba(229,199,125,.3), 0 0 18px rgba(229,199,125,.35); }
.personaje img { height: 150px; max-width: 100%; object-fit: contain; image-rendering: auto; }
.personaje .emoji { font-size: 5rem; line-height: 1.6; }
.personaje .nombre { font-family: 'Press Start 2P', monospace; font-size: 11px; color: var(--oro); margin-top: .6rem; }
.personaje .nivel { font-size: 20px; color: var(--apagado); }
.stButton > button:disabled { border-color: var(--oro); color: var(--oro); opacity: 1; }
[class*="st-key-elegir_"] button { justify-content: center; text-align: center; }

/* ---------- Mensajes (reemplazan st.success / st.error) ---------- */
.msg { background: var(--panel); border: 3px solid var(--borde); padding: .85rem 1rem; margin: .6rem 0;
       font-family: 'Press Start 2P', monospace; font-size: 11px; line-height: 1.8; color: var(--texto); }
.msg { overflow-wrap: anywhere; }
.msg.ok { border-color: #5fa05a; color: #b9e5a8; }
.msg.error { border-color: #c0392b; color: #f2b1a8; }
.msg.logro { border-color: var(--oro); color: var(--oro); }

/* ---------- Tablas ---------- */
table.dq { width: 100%; border-collapse: collapse; background: var(--panel); border: 3px solid var(--borde); }
table.dq th { font-family: 'Press Start 2P', monospace; font-size: 9px; text-align: left; padding: .7rem .6rem; color: var(--apagado); border-bottom: 2px solid var(--borde-suave); }
table.dq td { padding: .45rem .6rem; border-bottom: 1px solid #241f40; }
table.dq tr:last-child td { border-bottom: 0; }

@media (prefers-reduced-motion: reduce) { .tiempo > div { animation: none !important; } }
@media (max-width: 600px) {
    h1 { font-size: 16px !important; }
    .escena img { height: 200px; }
    .pregunta { font-size: 11px; }
}
</style>
"""


FONDOS = {
    # piedra de mazmorra: baldosas con viñeta
    "mazmorra": """
        radial-gradient(ellipse at center, rgba(0,0,0,0) 0%, rgba(0,0,0,.7) 100%),
        linear-gradient(rgba(0,0,0,.45) 2px, transparent 2px) 0 0 / 80px 40px,
        linear-gradient(90deg, rgba(0,0,0,.45) 2px, transparent 2px) 0 0 / 80px 40px,
        #1c1713""",
    # cielo nocturno violeta con estrellas
    "noche": """
        radial-gradient(2px 2px at 20px 30px, rgba(255,255,255,.8), transparent) 0 0 / 200px 130px,
        radial-gradient(2px 2px at 90px 85px, rgba(255,255,255,.6), transparent) 0 0 / 200px 130px,
        radial-gradient(1px 1px at 150px 20px, rgba(255,255,255,.9), transparent) 0 0 / 200px 130px,
        radial-gradient(1px 1px at 60px 110px, rgba(255,255,255,.7), transparent) 0 0 / 200px 130px,
        linear-gradient(#08051a, #1d1042)""",
    # cámara de lava: brillo rojizo desde abajo
    "lava": """
        radial-gradient(ellipse at 50% 115%, rgba(255,90,20,.5), transparent 60%),
        linear-gradient(#0d0505, #1d0907)""",
    # bosque oscuro: luz verdosa desde arriba
    "bosque": """
        radial-gradient(ellipse at 50% -10%, rgba(90,170,100,.3), transparent 60%),
        linear-gradient(#06110a, #0f2116)""",
}


def _css_fondo():
    """CSS del fondo de la página: imagen propia si existe, si no el tema elegido."""
    for ext in ("png", "jpg", "jpeg", "webp"):
        ruta = BASE / "assets" / f"fondo_pagina.{ext}"
        if ruta.exists():
            tipo = "jpeg" if ext in ("jpg", "jpeg") else ext
            fondo = (
                "linear-gradient(rgba(8,6,10,.72), rgba(8,6,10,.72)), "
                f"url(data:image/{tipo};base64,{_b64(str(ruta))}) center / cover no-repeat fixed"
            )
            break
    else:
        fondo = FONDOS.get(FONDO_PAGINA, FONDOS["mazmorra"])
    return f"<style>.stApp {{ background: {fondo} !important; background-attachment: fixed !important; }}</style>"


def aplicar_estilo():
    st.markdown(CSS, unsafe_allow_html=True)
    st.markdown(_css_fondo(), unsafe_allow_html=True)


# =====================================
# HELPERS VISUALES
# =====================================

def esc(valor):
    return html.escape(str(valor))


def mensaje(tipo, texto):
    """tipo: ok, error, logro o info."""
    st.markdown(f'<div class="msg {tipo}">{esc(texto)}</div>', unsafe_allow_html=True)


def barra(pct, clase):
    pct = max(0, min(100, pct))
    return (
        f'<div class="barra"><div class="relleno {clase}" '
        f'style="width:{pct}%"></div></div>'
    )


def tarjeta_heroe(nombre, nivel, experiencia, vida, vida_max, xp_por_nivel, puntaje=None):
    xp_del_nivel = experiencia % xp_por_nivel
    xp_faltante = xp_por_nivel - xp_del_nivel
    fila_puntaje = ""
    if puntaje is not None:
        fila_puntaje = (
            f'<div class="fila"><span class="etq">PTS</span>'
            f'<span class="num" style="text-align:left">{puntaje}</span></div>'
        )
    st.markdown(
        f'<div class="heroe">'
        f'<div class="fila"><span class="nombre">{esc(nombre)}</span>'
        f'<span class="pixel">NIVEL {nivel}</span></div>'
        f'<div class="fila"><span class="etq">HP</span>'
        f'{barra(vida * 100 / vida_max, "vida")}'
        f'<span class="num">{vida}/{vida_max}</span></div>'
        f'<div class="fila"><span class="etq">XP</span>'
        f'{barra(xp_del_nivel * 100 / xp_por_nivel, "xp")}'
        f'<span class="num">{xp_del_nivel}/{xp_por_nivel}</span></div>'
        f'{fila_puntaje}'
        f'<div class="nota">Te faltan {xp_faltante} XP para el nivel {nivel + 1}.</div>'
        f'</div>',
        unsafe_allow_html=True
    )


@lru_cache(maxsize=None)
def _b64(ruta):
    return base64.b64encode(Path(ruta).read_bytes()).decode()


def _normalizar(texto):
    """Minúsculas, sin tildes, espacios como _ y sin extensiones repetidas."""
    texto = unicodedata.normalize("NFKD", texto).encode("ascii", "ignore").decode().lower()
    texto = texto.strip().replace(" ", "_")
    cambio = True
    while cambio:
        cambio = False
        for ext in (".png", ".jpg", ".jpeg", ".webp"):
            if texto.endswith(ext):
                texto = texto[: -len(ext)]
                cambio = True
    return texto


def _buscar_imagen(nombre):
    """Busca la imagen del monstruo sin importar mayúsculas, tildes ni extensión."""
    clave = _normalizar(nombre)
    if CARPETA_MONSTRUOS.is_dir():
        for archivo in CARPETA_MONSTRUOS.iterdir():
            if archivo.is_file() and _normalizar(archivo.name) == clave:
                return archivo
    return None


def sprite_html(nombre):
    clave = _normalizar(nombre)
    archivo = _buscar_imagen(nombre)
    if archivo is not None:
        tipo = "jpeg" if archivo.suffix.lower() in (".jpg", ".jpeg") else archivo.suffix.lower().lstrip(".")
        return f'<img alt="{esc(nombre)}" src="data:image/{tipo};base64,{_b64(str(archivo))}">'
    return f'<div class="emoji">{EMOJI_FALLBACK.get(clave, "👾")}</div>'


CARPETA_PERSONAJES = BASE / "assets" / "personajes"   # guerrero.png, mago.png, arquero.png
EMOJI_PERSONAJE = {"guerrero": "🛡️", "mago": "🧙", "arquero": "🏹"}


def _clase(nombre):
    """'Guerrero01' -> 'guerrero'."""
    return _normalizar(nombre).rstrip("0123456789_")


def _buscar_personaje(nombre):
    """Busca assets/personajes/<nombre>.png y, si no está, <clase>.png (guerrero, mago...)."""
    if CARPETA_PERSONAJES.is_dir():
        for clave in (_normalizar(nombre), _clase(nombre)):
            for archivo in CARPETA_PERSONAJES.iterdir():
                if archivo.is_file() and _normalizar(archivo.name) == clave:
                    return archivo
    return None


def tarjeta_personaje(nombre, nivel, elegido):
    archivo = _buscar_personaje(nombre)
    if archivo is not None:
        tipo = "jpeg" if archivo.suffix.lower() in (".jpg", ".jpeg") else archivo.suffix.lower().lstrip(".")
        imagen = f'<img alt="{esc(nombre)}" src="data:image/{tipo};base64,{_b64(str(archivo))}">'
    else:
        imagen = f'<div class="emoji">{EMOJI_PERSONAJE.get(_clase(nombre), "🧍")}</div>'
    clase = "personaje elegido" if elegido else "personaje"
    st.markdown(
        f'<div class="{clase}">{imagen}'
        f'<div class="nombre">{esc(nombre)}</div>'
        f'<div class="nivel">NIVEL {nivel}</div></div>',
        unsafe_allow_html=True
    )


def escena_monstruo(orden, nombre_piso, nombre, vida_restante, vida_base):
    pct = vida_restante * 100 / vida_base if vida_base else 0
    estilo = ""
    if FONDO_ESCENA.exists():
        estilo = (
            f' style="background-image:url(data:image/png;base64,'
            f'{_b64(str(FONDO_ESCENA))})"'
        )
    st.markdown(
        f'<div class="escena"{estilo}>'
        f'<div class="piso">PISO {orden} · {esc(nombre_piso)}</div>'
        f'{sprite_html(nombre)}'
        f'<div class="hp"><span>{esc(nombre.upper())}</span>'
        f'{barra(pct, "vida")}'
        f'<span>{vida_restante}/{vida_base}</span></div>'
        f'</div>',
        unsafe_allow_html=True
    )


def tabla_html(columnas, filas):
    cabecera = "".join(f"<th>{esc(c)}</th>" for c in columnas)
    cuerpo = "".join(
        "<tr>" + "".join(f"<td>{esc(v)}</td>" for v in fila) + "</tr>"
        for fila in filas
    )
    st.markdown(
        f'<table class="dq"><thead><tr>{cabecera}</tr></thead>'
        f'<tbody>{cuerpo}</tbody></table>',
        unsafe_allow_html=True
    )


# =====================================
# PREGUNTA, TIEMPO Y OPCIONES
# =====================================

def mostrar_pregunta(nombre_monstruo, enunciado, categoria, dificultad):
    st.markdown(
        f'<div class="quien">{esc(nombre_monstruo)} pregunta:</div>'
        f'<div class="pregunta">{esc(enunciado)}</div>'
        f'<div class="meta">{esc(categoria)} · {esc(dificultad)}</div>',
        unsafe_allow_html=True
    )


def barra_tiempo(segundos, uid):
    """Barra naranja que se vacía. Es solo visual: el límite real se valida en app.py."""
    if not segundos:
        st.write("")
        return
    st.markdown(
        f'<div class="tiempo" id="t{uid}">'
        f'<div style="animation: vaciar {segundos}s linear forwards"></div>'
        f'</div>',
        unsafe_allow_html=True
    )


def mostrar_opciones(opciones, uid):
    """opciones = [(id_opcion, texto, es_correcta), ...] en una grilla 2 x 2.
    Devuelve la opción elegida o None si todavía no hizo clic."""
    letras = "ABCD"
    elegida = None

    for inicio in range(0, len(opciones), 2):

        columnas = st.columns(2)

        for desplazamiento, columna in enumerate(columnas):

            i = inicio + desplazamiento

            if i < len(opciones):

                with columna:

                    if st.button(
                        f"{letras[i]}  {opciones[i][1]}",
                        key=f"op_{uid}_{i}",
                        use_container_width=True
                    ):
                        elegida = opciones[i]

    return elegida

aplicar_estilo()


# ############################################################
# PARTE 3: APARTADO FUNCIONAL
# (base de datos, reglas y flujo del juego)
# ############################################################

# =====================================
# CONEXION A MYSQL
# =====================================

def conectar():
    return mysql.connector.connect(
        host="localhost",
        port=3306,
        user="root",
        password="",
        database="dungeon_quiz"
    )


# =====================================
# OBTENER PREGUNTA
# =====================================

def obtener_pregunta(cursor, id_partida):

    cursor.execute("""
        SELECT
            p.id_pregunta,
            p.enunciado,
            p.dificultad,
            c.nombre AS categoria
        FROM pregunta p
        INNER JOIN categoria c
            ON p.id_categoria = c.id_categoria
        WHERE NOT EXISTS (
            SELECT 1
            FROM pregunta_partida pp
            WHERE pp.id_partida = %s
              AND pp.id_pregunta = p.id_pregunta
        )
        ORDER BY RAND()
        LIMIT 1
    """, (id_partida,))

    pregunta = cursor.fetchone()

    if pregunta is None:
        return None

    # Las opciones se mezclan para que la correcta no quede siempre primera
    cursor.execute("""
        SELECT id_opcion, texto, es_correcta
        FROM opcion
        WHERE id_pregunta = %s
        ORDER BY RAND()
    """, (pregunta[0],))

    opciones = cursor.fetchall()

    return {
        "id": pregunta[0],
        "enunciado": pregunta[1],
        "dificultad": pregunta[2],
        "categoria": pregunta[3],
        "opciones": opciones
    }


# =====================================
# HISTORIAL DE PARTIDAS
# =====================================

def mostrar_historial():

    st.divider()
    st.subheader("📜 HISTORIAL DE PARTIDAS")

    conexion = conectar()
    cursor = conexion.cursor()

    cursor.execute("""
        SELECT
            j.nombre AS jugador,
            COUNT(p.id_partida) AS partidas,
            COALESCE(SUM(p.resultado = 'VICTORIA'), 0) AS victorias,
            COALESCE(SUM(p.resultado = 'DERROTA'), 0) AS derrotas,
            COALESCE(MAX(p.puntaje), 0) AS mejor_puntaje
        FROM jugador j
        LEFT JOIN partida p
            ON j.id_jugador = p.id_jugador
        GROUP BY j.id_jugador, j.nombre
        ORDER BY mejor_puntaje DESC
    """)

    historial = cursor.fetchall()

    cursor.close()
    conexion.close()

    tabla_html(
        ["Jugador", "Partidas", "Victorias", "Derrotas", "Mejor puntaje"],
        [(f[0], int(f[1]), int(f[2]), int(f[3]), int(f[4])) for f in historial]
    )


# =====================================
# RANKING (LEADERBOARD)
# =====================================

def mostrar_ranking():

    st.divider()
    st.subheader(f"🏆 RANKING DE LOS {TOP_RANKING} MEJORES")

    conexion = conectar()
    cursor = conexion.cursor()

    cursor.execute("""
        SELECT
            j.nombre,
            COALESCE(MAX(p.puntaje), 0) AS mejor_puntaje
        FROM jugador j
        LEFT JOIN partida p
            ON j.id_jugador = p.id_jugador
            AND p.resultado IN ('VICTORIA', 'DERROTA')
        GROUP BY j.id_jugador, j.nombre
        ORDER BY mejor_puntaje DESC, j.nombre ASC
        LIMIT %s
    """, (TOP_RANKING,))

    resultados = cursor.fetchall()

    cursor.close()
    conexion.close()

    medallas = {1: "🥇 1°", 2: "🥈 2°", 3: "🥉 3°"}

    if resultados:
        tabla_html(
            ["Posición", "Jugador", "Mejor puntaje"],
            [
                (medallas.get(pos, f"{pos}°"), fila[0], int(fila[1]))
                for pos, fila in enumerate(resultados, start=1)
            ]
        )
    else:
        mensaje("info", "Todavía no hay jugadores registrados.")


# =====================================
# PROCESAR UNA RESPUESTA
# =====================================

def procesar_respuesta(id_partida, pregunta, monstruo, opcion):

    orden = monstruo[0]
    nombre_monstruo = monstruo[1]
    vida_monstruo = monstruo[2]

    tiempo = int(time.time() - st.session_state.get("inicio_pregunta", time.time()))
    agotado = bool(TIEMPO_PREGUNTA) and tiempo > TIEMPO_PREGUNTA + 2
    es_correcta = bool(opcion[2]) and not agotado

    conexion = conectar()
    cursor = conexion.cursor()

    try:

        if es_correcta:
            danio = min(DANIO_ACIERTO, vida_monstruo)
            nueva_vida_monstruo = vida_monstruo - danio
            nueva_vida_jugador = st.session_state.vida_jugador
            nuevo_puntaje = st.session_state.puntaje + PUNTOS_ACIERTO
        else:
            danio = 0
            nueva_vida_monstruo = vida_monstruo
            nueva_vida_jugador = max(0, st.session_state.vida_jugador - DANIO_FALLO)
            nuevo_puntaje = st.session_state.puntaje

        cursor.execute("""
            INSERT INTO pregunta_partida (
                id_partida,
                id_pregunta,
                id_opcion_elegida,
                fue_correcta,
                tiempo_segundos,
                danio_causado
            )
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (
            id_partida,
            pregunta["id"],
            opcion[0],
            es_correcta,
            tiempo,
            danio
        ))

        if es_correcta:
            cursor.execute("""
                UPDATE monstruo_partida
                SET vida_restante = %s,
                    fue_derrotado = %s
                WHERE id_partida = %s
                  AND orden = %s
            """, (
                nueva_vida_monstruo,
                nueva_vida_monstruo == 0,
                id_partida,
                orden
            ))

        cursor.execute("""
            UPDATE jugador
            SET vida_actual = %s
            WHERE id_jugador = %s
        """, (nueva_vida_jugador, st.session_state.id_jugador))

        cursor.execute("""
            UPDATE partida
            SET puntaje = %s
            WHERE id_partida = %s
        """, (nuevo_puntaje, id_partida))

        resultado = None

        if nueva_vida_jugador <= 0:
            resultado = "DERROTA"
        else:
            cursor.execute("""
                SELECT COUNT(*)
                FROM monstruo_partida
                WHERE id_partida = %s
                  AND fue_derrotado = 0
            """, (id_partida,))

            if cursor.fetchone()[0] == 0:
                resultado = "VICTORIA"

        if resultado is not None:
            cursor.execute("""
                UPDATE partida
                SET resultado = %s,
                    fecha_fin = CURRENT_TIMESTAMP
                WHERE id_partida = %s
            """, (resultado, id_partida))

        # XP POR MONSTRUO DERROTADO + RECOMPENSA DE VICTORIA

        xp_ganada = 0

        if es_correcta and nueva_vida_monstruo == 0:
            xp_ganada += XP_POR_DIFICULTAD.get(monstruo[4], 20)

        if resultado == "VICTORIA":
            xp_ganada += RECOMPENSA_VICTORIA

        if xp_ganada > 0:

            cursor.execute("""
                SELECT experiencia
                FROM jugador
                WHERE id_jugador = %s
            """, (st.session_state.id_jugador,))

            nueva_experiencia = cursor.fetchone()[0] + xp_ganada
            nuevo_nivel = max(
                st.session_state.nivel,
                (nueva_experiencia // XP_POR_NIVEL) + 1
            )

            cursor.execute("""
                UPDATE jugador
                SET experiencia = %s,
                    nivel = %s
                WHERE id_jugador = %s
            """, (nueva_experiencia, nuevo_nivel, st.session_state.id_jugador))

        else:
            nueva_experiencia = st.session_state.experiencia
            nuevo_nivel = st.session_state.nivel

        conexion.commit()

        subio_nivel = nuevo_nivel > st.session_state.nivel

        st.session_state.vida_jugador = nueva_vida_jugador
        st.session_state.puntaje = nuevo_puntaje
        st.session_state.experiencia = nueva_experiencia
        st.session_state.nivel = nuevo_nivel
        st.session_state.pregunta_actual = None
        st.session_state.resultado = resultado

        if es_correcta and nueva_vida_monstruo == 0:
            st.session_state.monstruo_derrotado = nombre_monstruo

        # Los mensajes se muestran en la próxima pantalla (antes se perdían por el rerun)
        mensajes = []

        if es_correcta:
            mensajes.append(("ok", f"¡CORRECTO! Le hiciste {danio} de daño a {nombre_monstruo}."))
        elif agotado:
            mensajes.append(("error", f"¡TIEMPO AGOTADO! Perdiste {DANIO_FALLO} HP."))
        else:
            mensajes.append(("error", f"¡RESPUESTA INCORRECTA! Perdiste {DANIO_FALLO} HP."))

        if xp_ganada:
            mensajes.append(("logro", f"+{xp_ganada} XP"))

        if subio_nivel:
            mensajes.append(("logro", f"¡SUBISTE AL NIVEL {nuevo_nivel}!"))

        st.session_state.feedback = mensajes

    except mysql.connector.Error:

        conexion.rollback()
        raise

    finally:

        cursor.close()
        conexion.close()


# =====================================
# PANTALLA PRINCIPAL
# =====================================

st.title("⚔️ DUNGEON QUIZ")

st.markdown(
    "<center>⚔️ PREPARATE PARA ENTRAR A LA MAZMORRA ⚔️</center>",
    unsafe_allow_html=True
)

st.write("")


try:

    # =================================
    # SELECCION DE PERSONAJE
    # =================================

    if "id_partida" not in st.session_state:

        conexion = conectar()
        cursor = conexion.cursor()

        cursor.execute("""
            SELECT
                id_jugador,
                nombre,
                nivel,
                vida_actual,
                experiencia
            FROM jugador
            ORDER BY id_jugador
        """)

        jugadores = cursor.fetchall()

        cursor.close()
        conexion.close()

        if not jugadores:
            mensaje("info", "No hay jugadores registrados.")
            st.stop()

        st.subheader("🛡️ ELEGÍ TU PERSONAJE")

        ids = [j[0] for j in jugadores]

        if st.session_state.get("seleccion") not in ids:
            st.session_state.seleccion = ids[0]

        for inicio in range(0, len(jugadores), 3):

            columnas = st.columns(3)

            for columna, j in zip(columnas, jugadores[inicio:inicio + 3]):

                with columna:

                    es_elegido = (j[0] == st.session_state.seleccion)

                    tarjeta_personaje(j[1], j[2], es_elegido)

                    if st.button(
                        "✔ ELEGIDO" if es_elegido else "ELEGIR",
                        key=f"elegir_{j[0]}",
                        disabled=es_elegido,
                        use_container_width=True
                    ):
                        st.session_state.seleccion = j[0]
                        st.rerun()

        jugador = next(j for j in jugadores if j[0] == st.session_state.seleccion)

        # Aviso de diagnóstico: aparece solo si falta alguna imagen de personaje
        sin_imagen = [j[1] for j in jugadores if _buscar_personaje(j[1]) is None]

        if sin_imagen:
            existe = CARPETA_PERSONAJES.is_dir()
            archivos = [f.name for f in CARPETA_PERSONAJES.iterdir()] if existe else []
            mensaje(
                "info",
                f"Sin imagen para: {', '.join(sin_imagen)}. "
                f"Busco en: {CARPETA_PERSONAJES} "
                f"({'la carpeta existe' if existe else 'la carpeta NO existe'}). "
                f"Archivos que veo ahí: {', '.join(archivos) if archivos else 'ninguno'}."
            )

        tarjeta_heroe(
            jugador[1], jugador[2], jugador[4],
            VIDA_INICIAL, VIDA_INICIAL, XP_POR_NIVEL
        )

        if st.button(
            "⚔️ COMENZAR AVENTURA",
            use_container_width=True
        ):

            conexion = conectar()
            cursor = conexion.cursor()

            try:

                cursor.execute("""
                    UPDATE jugador
                    SET vida_actual = %s
                    WHERE id_jugador = %s
                """, (VIDA_INICIAL, jugador[0]))

                cursor.execute("""
                    INSERT INTO partida
                    (id_jugador, puntaje, resultado)
                    VALUES (%s, 0, 'EN_CURSO')
                """, (jugador[0],))

                id_partida = cursor.lastrowid

                cursor.execute("""
                    SELECT id_monstruo, nombre, vida_base
                    FROM monstruo
                    ORDER BY RAND()
                    LIMIT 3
                """)

                monstruos = cursor.fetchall()

                for orden, monstruo in enumerate(monstruos, start=1):

                    cursor.execute("""
                        INSERT INTO monstruo_partida
                        (id_partida, orden, id_monstruo, vida_restante)
                        VALUES (%s, %s, %s, %s)
                    """, (
                        id_partida,
                        orden,
                        monstruo[0],
                        monstruo[2]
                    ))

                conexion.commit()

                st.session_state.id_partida = id_partida
                st.session_state.id_jugador = jugador[0]
                st.session_state.jugador = jugador[1]
                st.session_state.vida_jugador = VIDA_INICIAL
                st.session_state.nivel = jugador[2]
                st.session_state.experiencia = jugador[4]
                st.session_state.puntaje = 0
                st.session_state.pregunta_actual = None
                st.session_state.resultado = None
                st.session_state.monstruo_derrotado = None

            except mysql.connector.Error:

                conexion.rollback()
                raise

            finally:

                cursor.close()
                conexion.close()

            st.rerun()

        # HISTORIAL Y RANKING

        mostrar_historial()
        mostrar_ranking()


    # =================================
    # SISTEMA DE COMBATE
    # =================================

    if "id_partida" in st.session_state:

        id_partida = st.session_state.id_partida

        conexion = conectar()
        cursor = conexion.cursor()

        cursor.execute("""
            SELECT
                mp.orden,
                m.nombre,
                mp.vida_restante,
                m.vida_base,
                m.dificultad
            FROM monstruo_partida mp
            INNER JOIN monstruo m
                ON mp.id_monstruo = m.id_monstruo
            WHERE mp.id_partida = %s
              AND mp.fue_derrotado = 0
            ORDER BY mp.orden
            LIMIT 1
        """, (id_partida,))

        monstruo = cursor.fetchone()

        cursor.execute("""
            SELECT resultado, puntaje
            FROM partida
            WHERE id_partida = %s
        """, (id_partida,))

        datos_partida = cursor.fetchone()

        if "vida_jugador" not in st.session_state:

            cursor.execute("""
                SELECT vida_actual
                FROM jugador
                WHERE id_jugador = %s
            """, (st.session_state.id_jugador,))

            st.session_state.vida_jugador = cursor.fetchone()[0]

        if "experiencia" not in st.session_state:

            cursor.execute("""
                SELECT experiencia
                FROM jugador
                WHERE id_jugador = %s
            """, (st.session_state.id_jugador,))

            st.session_state.experiencia = cursor.fetchone()[0]

        if "nivel" not in st.session_state:

            cursor.execute("""
                SELECT nivel
                FROM jugador
                WHERE id_jugador = %s
            """, (st.session_state.id_jugador,))

            st.session_state.nivel = cursor.fetchone()[0]

        if "puntaje" not in st.session_state:
            st.session_state.puntaje = datos_partida[1]

        if "pregunta_actual" not in st.session_state:
            st.session_state.pregunta_actual = None

        if "monstruo_derrotado" not in st.session_state:
            st.session_state.monstruo_derrotado = None

        if datos_partida[0] != "EN_CURSO":
            st.session_state.resultado = datos_partida[0]

        cursor.close()
        conexion.close()

        st.divider()

        # MENSAJE DE LA RESPUESTA ANTERIOR

        feedback = st.session_state.pop("feedback", None)

        for tipo, texto in (feedback or []):
            mensaje(tipo, texto)

        # ESTADO DEL HEROE

        tarjeta_heroe(
            st.session_state.jugador,
            st.session_state.nivel,
            st.session_state.experiencia,
            st.session_state.vida_jugador,
            VIDA_INICIAL,
            XP_POR_NIVEL,
            st.session_state.puntaje
        )

        # MONSTRUO DERROTADO

        if st.session_state.monstruo_derrotado is not None:

            mensaje(
                "logro",
                f"🏆 ¡DERROTASTE A {st.session_state.monstruo_derrotado}!"
            )

            st.write(
                "Un enemigo menos en tu camino. "
                "Preparáte para el siguiente combate."
            )

            if st.button(
                "⚔️ CONTINUAR",
                key="continuar_despues_monstruo"
            ):

                st.session_state.monstruo_derrotado = None
                st.rerun()

        # VICTORIA O DERROTA

        elif st.session_state.resultado is not None:

            if st.session_state.resultado == "VICTORIA":

                mensaje(
                    "logro",
                    "🏆 ¡VICTORIA! DERROTASTE A TODOS LOS MONSTRUOS."
                )

                st.balloons()

                mensaje(
                    "logro",
                    f"🎁 ¡RECIBISTE {RECOMPENSA_VICTORIA} XP DE RECOMPENSA!"
                )

            else:

                mensaje("error", "💀 ¡DERROTA! TE QUEDASTE SIN VIDA.")

            st.write(f"**PUNTAJE FINAL:** {st.session_state.puntaje}")

            st.write(
                f"**EXPERIENCIA TOTAL:** "
                f"{st.session_state.experiencia} XP"
            )

            if st.button("🔄 JUGAR OTRA VEZ"):

                claves_partida = [
                    "id_partida",
                    "id_jugador",
                    "jugador",
                    "vida_jugador",
                    "nivel",
                    "experiencia",
                    "puntaje",
                    "pregunta_actual",
                    "resultado",
                    "monstruo_derrotado",
                    "inicio_pregunta",
                    "feedback"
                ]

                for clave in claves_partida:

                    if clave in st.session_state:
                        del st.session_state[clave]

                st.rerun()

        elif monstruo is None:

            conexion = conectar()
            cursor = conexion.cursor()

            cursor.execute("""
                UPDATE partida
                SET resultado = 'VICTORIA',
                    fecha_fin = CURRENT_TIMESTAMP
                WHERE id_partida = %s
            """, (id_partida,))

            conexion.commit()

            cursor.close()
            conexion.close()

            st.session_state.resultado = "VICTORIA"
            st.rerun()

        else:

            # ESCENA DEL MONSTRUO

            escena_monstruo(
                monstruo[0],
                PISOS[(monstruo[0] - 1) % len(PISOS)],
                monstruo[1],
                monstruo[2],
                monstruo[3]
            )

            if st.session_state.pregunta_actual is None:

                conexion = conectar()
                cursor = conexion.cursor()

                pregunta = obtener_pregunta(cursor, id_partida)

                cursor.close()
                conexion.close()

                st.session_state.pregunta_actual = pregunta
                st.session_state.inicio_pregunta = time.time()

            pregunta = st.session_state.pregunta_actual

            if pregunta is None:

                mensaje("info", "NO QUEDAN PREGUNTAS DISPONIBLES.")

            else:

                mostrar_pregunta(
                    monstruo[1],
                    pregunta["enunciado"],
                    pregunta["categoria"],
                    pregunta["dificultad"]
                )

                barra_tiempo(TIEMPO_PREGUNTA, pregunta["id"])

                elegida = mostrar_opciones(pregunta["opciones"], pregunta["id"])

                if elegida is not None:

                    procesar_respuesta(id_partida, pregunta, monstruo, elegida)
                    st.rerun()


except mysql.connector.Error as error:

    mensaje("error", f"ERROR DE CONEXIÓN: {error}")
