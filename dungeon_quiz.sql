-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 16-11-2026 a las 20:42:27
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `dungeon_quiz`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
  `id_categoria` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`id_categoria`, `nombre`, `descripcion`) VALUES
(1, 'Mitología', 'Dioses, criaturas y leyendas mitológicas'),
(2, 'Programación', 'Lenguajes, algoritmos y lógica de programación'),
(3, 'Videojuegos', 'Videojuegos, personajes y consolas'),
(4, 'Ciencias', 'Ciencia, alquimia, pociones y experimentos'),
(5, 'Informática', 'Computadoras, hardware, software y tecnología');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jugador`
--

CREATE TABLE `jugador` (
  `id_jugador` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `nivel` int(11) NOT NULL DEFAULT 1,
  `vida_actual` int(11) NOT NULL DEFAULT 100,
  `experiencia` int(11) NOT NULL DEFAULT 0
) ;

--
-- Volcado de datos para la tabla `jugador`
--

INSERT INTO `jugador` (`id_jugador`, `nombre`, `nivel`, `vida_actual`, `experiencia`) VALUES
(1, 'Guerrero01', 5, 0, 485),
(2, 'Mago01', 1, 100, 0),
(3, 'Arquero01', 1, 100, 50);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `monstruo`
--

CREATE TABLE `monstruo` (
  `id_monstruo` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `dificultad` enum('FACIL','MEDIO','DIFICIL') NOT NULL,
  `vida_base` int(11) NOT NULL
) ;

--
-- Volcado de datos para la tabla `monstruo`
--

INSERT INTO `monstruo` (`id_monstruo`, `nombre`, `dificultad`, `vida_base`) VALUES
(1, 'Slime', 'FACIL', 30),
(2, 'Goblin', 'FACIL', 40),
(3, 'Orco', 'MEDIO', 70),
(4, 'Esqueleto', 'MEDIO', 60),
(5, 'Troll', 'DIFICIL', 100),
(6, 'Dragon', 'DIFICIL', 120);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `monstruo_partida`
--

CREATE TABLE `monstruo_partida` (
  `id_partida` int(11) NOT NULL,
  `orden` int(11) NOT NULL,
  `id_monstruo` int(11) NOT NULL,
  `vida_restante` int(11) NOT NULL,
  `fue_derrotado` tinyint(1) NOT NULL DEFAULT 0
) ;

--
-- Volcado de datos para la tabla `monstruo_partida`
--

INSERT INTO `monstruo_partida` (`id_partida`, `orden`, `id_monstruo`, `vida_restante`, `fue_derrotado`) VALUES
(5, 1, 5, 100, 0),
(5, 2, 2, 40, 0),
(5, 3, 1, 30, 0),
(6, 1, 5, 0, 1),
(6, 2, 1, 30, 0),
(6, 3, 3, 70, 0),
(7, 1, 1, 0, 1),
(7, 2, 6, 0, 1),
(7, 3, 2, 40, 0),
(8, 1, 3, 0, 1),
(8, 2, 5, 0, 1),
(8, 3, 1, 0, 1),
(9, 1, 5, 100, 0),
(9, 2, 2, 40, 0),
(9, 3, 1, 30, 0),
(10, 1, 3, 0, 1),
(10, 2, 6, 0, 1),
(10, 3, 1, 0, 1),
(11, 1, 5, 0, 1),
(11, 2, 6, 0, 1),
(11, 3, 2, 0, 1),
(12, 1, 1, 0, 1),
(12, 2, 3, 0, 1),
(12, 3, 2, 0, 1),
(13, 1, 6, 120, 0),
(13, 2, 4, 60, 0),
(13, 3, 1, 30, 0),
(14, 1, 1, 30, 0),
(14, 2, 4, 60, 0),
(14, 3, 6, 120, 0),
(15, 1, 1, 0, 1),
(15, 2, 4, 0, 1),
(15, 3, 6, 0, 1),
(16, 1, 2, 0, 1),
(16, 2, 5, 0, 1),
(16, 3, 3, 70, 0),
(17, 1, 5, 0, 1),
(17, 2, 1, 0, 1),
(17, 3, 3, 10, 0),
(18, 1, 5, 0, 1),
(18, 2, 6, 120, 0),
(18, 3, 1, 30, 0),
(19, 1, 6, 0, 1),
(19, 2, 2, 40, 0),
(19, 3, 4, 60, 0),
(20, 1, 5, 0, 1),
(20, 2, 6, 120, 0),
(20, 3, 1, 30, 0),
(21, 1, 4, 0, 1),
(21, 2, 2, 40, 0),
(21, 3, 1, 30, 0),
(22, 1, 4, 0, 1),
(22, 2, 2, 40, 0),
(22, 3, 1, 30, 0),
(23, 1, 3, 0, 1),
(23, 2, 5, 100, 0),
(23, 3, 2, 40, 0),
(24, 1, 2, 40, 0),
(24, 2, 3, 70, 0),
(24, 3, 4, 60, 0),
(25, 1, 3, 70, 0),
(25, 2, 1, 30, 0),
(25, 3, 6, 120, 0),
(26, 1, 4, 60, 0),
(26, 2, 3, 70, 0),
(26, 3, 5, 100, 0),
(27, 1, 5, 100, 0),
(27, 2, 6, 120, 0),
(27, 3, 2, 40, 0),
(28, 1, 5, 100, 0),
(28, 2, 2, 40, 0),
(28, 3, 3, 70, 0),
(29, 1, 6, 120, 0),
(29, 2, 3, 70, 0),
(29, 3, 2, 40, 0),
(30, 1, 6, 120, 0),
(30, 2, 3, 70, 0),
(30, 3, 4, 60, 0),
(31, 1, 5, 100, 0),
(31, 2, 1, 30, 0),
(31, 3, 6, 120, 0),
(32, 1, 3, 70, 0),
(32, 2, 6, 120, 0),
(32, 3, 1, 30, 0),
(33, 1, 1, 30, 0),
(33, 2, 6, 120, 0),
(33, 3, 3, 70, 0),
(34, 1, 1, 30, 0),
(34, 2, 3, 70, 0),
(34, 3, 4, 60, 0),
(35, 1, 6, 120, 0),
(35, 2, 1, 30, 0),
(35, 3, 5, 100, 0),
(36, 1, 2, 40, 0),
(36, 2, 3, 70, 0),
(36, 3, 4, 60, 0),
(37, 1, 5, 100, 0),
(37, 2, 3, 70, 0),
(37, 3, 6, 120, 0),
(38, 1, 3, 70, 0),
(38, 2, 4, 60, 0),
(38, 3, 6, 120, 0),
(39, 1, 4, 0, 1),
(39, 2, 3, 0, 1),
(39, 3, 5, 0, 1),
(40, 1, 2, 40, 0),
(40, 2, 6, 120, 0),
(40, 3, 5, 100, 0),
(41, 1, 4, 60, 0),
(41, 2, 1, 30, 0),
(41, 3, 5, 100, 0),
(42, 1, 4, 60, 0),
(42, 2, 2, 40, 0),
(42, 3, 1, 30, 0),
(43, 1, 2, 40, 0),
(43, 2, 4, 60, 0),
(43, 3, 5, 100, 0),
(44, 1, 4, 0, 1),
(44, 2, 2, 0, 1),
(44, 3, 5, 0, 1),
(45, 1, 1, 30, 0),
(45, 2, 6, 120, 0),
(45, 3, 4, 60, 0),
(46, 1, 3, 40, 0),
(46, 2, 1, 30, 0),
(46, 3, 2, 40, 0),
(47, 1, 1, 0, 1),
(47, 2, 2, 40, 0),
(47, 3, 5, 100, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `opcion`
--

CREATE TABLE `opcion` (
  `id_opcion` int(11) NOT NULL,
  `id_pregunta` int(11) NOT NULL,
  `texto` varchar(255) NOT NULL,
  `es_correcta` tinyint(1) NOT NULL DEFAULT 0
) ;

--
-- Volcado de datos para la tabla `opcion`
--

INSERT INTO `opcion` (`id_opcion`, `id_pregunta`, `texto`, `es_correcta`) VALUES
(1, 1, 'Thor', 1),
(2, 1, 'Odin', 0),
(3, 1, 'Loki', 0),
(4, 1, 'Freyr', 0),
(5, 2, 'Esfinge', 0),
(6, 2, 'Medusa', 1),
(7, 2, 'Quimera', 0),
(8, 2, 'Hidra', 0),
(9, 3, 'Minotauro', 0),
(10, 3, 'Cerbero', 1),
(11, 3, 'Pegaso', 0),
(12, 3, 'Hades', 0),
(13, 4, 'Zeus', 0),
(14, 4, 'Ares', 0),
(15, 4, 'Poseidón', 1),
(16, 4, 'Apolo', 0),
(17, 5, 'Heracles', 0),
(18, 5, 'Aquiles', 0),
(19, 5, 'Perseo', 0),
(20, 5, 'Teseo', 1),
(21, 6, 'Pila', 1),
(22, 6, 'Cola', 0),
(23, 6, 'Lista', 0),
(24, 6, 'Árbol', 0),
(25, 7, 'if', 0),
(26, 7, 'while', 1),
(27, 7, 'switch', 0),
(28, 7, 'break', 0),
(29, 8, '==', 1),
(30, 8, '=', 0),
(31, 8, '!=', 0),
(32, 8, '>=', 0),
(33, 9, 'Una función que se llama a sí misma', 1),
(34, 9, 'Una función que nunca termina', 0),
(35, 9, 'Una variable global', 0),
(36, 9, 'Una función sin parámetros', 0),
(37, 10, 'if / else', 1),
(38, 10, 'while', 0),
(39, 10, 'printf', 0),
(40, 10, 'return', 0),
(41, 11, 'Link', 1),
(42, 11, 'Zelda', 0),
(43, 11, 'Ganondorf', 0),
(44, 11, 'Epona', 0),
(45, 12, 'Sony', 1),
(46, 12, 'Nintendo', 0),
(47, 12, 'Microsoft', 0),
(48, 12, 'Sega', 0),
(49, 13, 'Luigi', 1),
(50, 13, 'Wario', 0),
(51, 13, 'Yoshi', 0),
(52, 13, 'Toad', 0),
(53, 14, 'Minecraft', 1),
(54, 14, 'Terraria', 0),
(55, 14, 'Roblox', 0),
(56, 14, 'Fortnite', 0),
(57, 15, 'FromSoftware', 1),
(58, 15, 'Bandai Namco', 0),
(59, 15, 'Capcom', 0),
(60, 15, 'Square Enix', 0),
(61, 16, 'H2O', 1),
(62, 16, 'CO2', 0),
(63, 16, 'O2', 0),
(64, 16, 'NaCl', 0),
(65, 17, 'Oxígeno', 1),
(66, 17, 'Nitrógeno', 0),
(67, 17, 'Dióxido de carbono', 0),
(68, 17, 'Hidrógeno', 0),
(69, 18, 'Oro', 1),
(70, 18, 'Plata', 0),
(71, 18, 'Hierro', 0),
(72, 18, 'Cobre', 0),
(73, 19, 'Fotosíntesis', 1),
(74, 19, 'Respiración', 0),
(75, 19, 'Fermentación', 0),
(76, 19, 'Evaporación', 0),
(77, 20, 'Escala de pH', 1),
(78, 20, 'Escala de Richter', 0),
(79, 20, 'Escala Celsius', 0),
(80, 20, 'Escala Kelvin', 0),
(81, 21, 'Procesador (CPU)', 1),
(82, 21, 'Memoria RAM', 0),
(83, 21, 'Placa de video', 0),
(84, 21, 'Disco SSD', 0),
(85, 22, 'Memoria de acceso aleatorio', 1),
(86, 22, 'Memoria de solo lectura', 0),
(87, 22, 'Unidad de almacenamiento', 0),
(88, 22, 'Procesador de datos', 0),
(89, 23, 'Placa de red', 1),
(90, 23, 'Placa de video', 0),
(91, 23, 'Placa de sonido', 0),
(92, 23, 'Fuente de alimentación', 0),
(93, 24, 'RAM', 1),
(94, 24, 'ROM', 0),
(95, 24, 'SSD', 0),
(96, 24, 'HDD', 0),
(97, 25, 'Binario', 1),
(98, 25, 'Decimal', 0),
(99, 25, 'Hexadecimal', 0),
(100, 25, 'Octal', 0),
(101, 26, 'Ra', 0),
(102, 26, 'Anubis', 1),
(103, 26, 'Horus', 0),
(104, 26, 'Osiris', 0),
(105, 27, 'Yggdrasil', 1),
(106, 27, 'Valhalla', 0),
(107, 27, 'Midgard', 0),
(108, 27, 'Asgard', 0),
(109, 28, 'Hera', 0),
(110, 28, 'Artemisa', 0),
(111, 28, 'Deméter', 1),
(112, 28, 'Afrodita', 0),
(113, 29, 'Oni', 0),
(114, 29, 'Kitsune', 1),
(115, 29, 'Tengu', 0),
(116, 29, 'Kappa', 0),
(117, 30, 'Hammurabi', 0),
(118, 30, 'Nabucodonosor', 0),
(119, 30, 'Gilgamesh', 1),
(120, 30, 'Sargón', 0),
(121, 31, '1', 0),
(122, 31, '0', 1),
(123, 31, '-1', 0),
(124, 31, '2', 0),
(125, 32, 'continue', 0),
(126, 32, 'return', 0),
(127, 32, 'break', 1),
(128, 32, 'switch', 0),
(129, 33, 'int', 0),
(130, 33, 'float', 0),
(131, 33, 'char', 1),
(132, 33, 'double', 0),
(133, 34, '#include', 1),
(134, 34, '#define', 0),
(135, 34, 'import', 0),
(136, 34, 'using', 0),
(137, 35, 'length', 0),
(138, 35, 'sizeof', 1),
(139, 35, 'size', 0),
(140, 35, 'count', 0),
(141, 36, 'Jill Valentine', 0),
(142, 36, 'Lara Croft', 1),
(143, 36, 'Ellie', 0),
(144, 36, 'Samus Aran', 0),
(145, 37, 'Eliminar bloques formando líneas completas', 1),
(146, 37, 'Derrotar enemigos', 0),
(147, 37, 'Construir una ciudad', 0),
(148, 37, 'Encontrar tesoros', 0),
(149, 38, 'Alyx', 0),
(150, 38, 'Chell', 1),
(151, 38, 'Faith', 0),
(152, 38, 'Clementine', 0),
(153, 39, 'Game Freak', 1),
(154, 39, 'Ubisoft', 0),
(155, 39, 'Capcom', 0),
(156, 39, 'Bethesda', 0),
(157, 40, 'Shigeru Miyamoto', 0),
(158, 40, 'Hideo Kojima', 0),
(159, 40, 'Alexey Pajitnov', 1),
(160, 40, 'John Carmack', 0),
(161, 41, '3', 0),
(162, 41, '5', 0),
(163, 41, '7', 1),
(164, 41, '10', 0),
(165, 42, '50 °C', 0),
(166, 42, '75 °C', 0),
(167, 42, '100 °C', 1),
(168, 42, '150 °C', 0),
(169, 43, 'Marte', 0),
(170, 43, 'Saturno', 1),
(171, 43, 'Venus', 0),
(172, 43, 'Mercurio', 0),
(173, 44, 'Año luz', 1),
(174, 44, 'Kilogramo', 0),
(175, 44, 'Newton', 0),
(176, 44, 'Pascal', 0),
(177, 45, 'Ribosoma', 0),
(178, 45, 'Mitocondria', 1),
(179, 45, 'Lisosoma', 0),
(180, 45, 'Núcleo', 0),
(181, 46, 'Solid State Drive', 1),
(182, 46, 'System Storage Device', 0),
(183, 46, 'Software Security Disk', 0),
(184, 46, 'Secure System Data', 0),
(185, 47, 'Proteger la computadora de virus', 0),
(186, 47, 'Traducir nombres de dominio a direcciones IP', 1),
(187, 47, 'Aumentar la memoria RAM', 0),
(188, 47, 'Comprimir archivos', 0),
(189, 48, 'VGA', 0),
(190, 48, 'PS/2', 0),
(191, 48, 'HDMI', 1),
(192, 48, 'RJ-11', 0),
(193, 49, 'Una interfaz de red', 1),
(194, 49, 'Un archivo ejecutable', 0),
(195, 49, 'Una página web', 0),
(196, 49, 'Una cuenta de usuario', 0),
(197, 50, 'Overclocking', 0),
(198, 50, 'Phishing', 1),
(199, 50, 'Formateo', 0),
(200, 50, 'Streaming', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `partida`
--

CREATE TABLE `partida` (
  `id_partida` int(11) NOT NULL,
  `id_jugador` int(11) NOT NULL,
  `fecha_inicio` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_fin` datetime DEFAULT NULL,
  `puntaje` int(11) NOT NULL DEFAULT 0,
  `resultado` enum('EN_CURSO','VICTORIA','DERROTA') NOT NULL DEFAULT 'EN_CURSO'
) ;

--
-- Volcado de datos para la tabla `partida`
--

INSERT INTO `partida` (`id_partida`, `id_jugador`, `fecha_inicio`, `fecha_fin`, `puntaje`, `resultado`) VALUES
(4, 2, '2026-11-14 18:49:20', NULL, 0, 'EN_CURSO'),
(5, 1, '2026-11-14 18:56:21', NULL, 0, 'EN_CURSO'),
(6, 1, '2026-11-14 19:18:47', NULL, 40, 'EN_CURSO'),
(7, 1, '2026-11-14 19:27:09', NULL, 50, 'EN_CURSO'),
(8, 3, '2026-11-14 19:48:17', '2026-11-14 19:48:29', 80, 'VICTORIA'),
(9, 1, '2026-11-14 19:49:59', NULL, 0, 'EN_CURSO'),
(10, 1, '2026-11-14 19:53:44', '2026-11-14 19:55:22', 80, 'VICTORIA'),
(11, 3, '2026-11-14 20:02:37', '2026-11-14 20:03:48', 100, 'VICTORIA'),
(12, 1, '2026-11-14 20:20:31', '2026-11-14 20:20:48', 60, 'VICTORIA'),
(13, 1, '2026-11-14 20:22:36', '2026-11-14 20:22:39', 0, 'DERROTA'),
(14, 1, '2026-11-14 20:22:46', '2026-11-14 20:22:51', 0, 'DERROTA'),
(15, 1, '2026-11-14 20:27:05', '2026-11-14 20:27:20', 70, 'VICTORIA'),
(16, 1, '2026-11-14 21:05:03', NULL, 60, 'EN_CURSO'),
(17, 1, '2026-11-15 14:41:08', '2026-11-15 14:42:49', 70, 'DERROTA'),
(18, 1, '2026-11-15 14:46:48', NULL, 40, 'EN_CURSO'),
(19, 1, '2026-11-15 15:02:50', NULL, 40, 'EN_CURSO'),
(20, 1, '2026-11-15 15:07:25', NULL, 40, 'EN_CURSO'),
(21, 1, '2026-11-15 15:08:37', NULL, 20, 'EN_CURSO'),
(22, 1, '2026-11-15 15:09:53', NULL, 20, 'EN_CURSO'),
(23, 1, '2026-11-15 15:14:41', NULL, 30, 'EN_CURSO'),
(24, 1, '2026-11-15 15:17:42', NULL, 0, 'EN_CURSO'),
(25, 3, '2026-11-15 15:20:03', NULL, 0, 'EN_CURSO'),
(26, 1, '2026-11-15 15:38:51', NULL, 0, 'EN_CURSO'),
(27, 1, '2026-11-15 15:41:17', NULL, 0, 'EN_CURSO'),
(28, 1, '2026-11-15 15:50:40', NULL, 0, 'EN_CURSO'),
(29, 1, '2026-11-15 16:00:21', NULL, 0, 'EN_CURSO'),
(30, 1, '2026-11-15 16:06:19', NULL, 0, 'EN_CURSO'),
(31, 1, '2026-11-15 16:07:15', NULL, 0, 'EN_CURSO'),
(32, 1, '2026-11-15 16:19:08', NULL, 0, 'EN_CURSO'),
(33, 1, '2026-11-15 16:25:23', NULL, 0, 'EN_CURSO'),
(34, 1, '2026-11-15 16:32:27', NULL, 0, 'EN_CURSO'),
(35, 1, '2026-11-15 16:34:02', NULL, 0, 'EN_CURSO'),
(36, 1, '2026-11-15 17:01:49', NULL, 0, 'EN_CURSO'),
(37, 1, '2026-11-15 17:12:26', NULL, 0, 'EN_CURSO'),
(38, 1, '2026-11-15 17:16:27', NULL, 0, 'EN_CURSO'),
(39, 1, '2026-11-15 17:20:57', '2026-11-15 17:22:31', 90, 'VICTORIA'),
(40, 2, '2026-11-15 17:26:23', NULL, 0, 'EN_CURSO'),
(41, 1, '2026-11-15 18:39:54', NULL, 0, 'EN_CURSO'),
(42, 1, '2026-11-15 18:41:24', NULL, 0, 'EN_CURSO'),
(43, 1, '2026-11-15 18:41:29', NULL, 0, 'EN_CURSO'),
(44, 1, '2026-11-15 18:48:22', '2026-11-15 18:52:04', 80, 'VICTORIA'),
(45, 1, '2026-11-15 19:06:27', NULL, 0, 'EN_CURSO'),
(46, 1, '2026-11-15 19:10:33', '2026-11-15 19:11:01', 10, 'DERROTA'),
(47, 1, '2026-11-15 21:17:44', '2026-11-15 21:17:57', 10, 'DERROTA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pregunta`
--

CREATE TABLE `pregunta` (
  `id_pregunta` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `enunciado` varchar(500) NOT NULL,
  `dificultad` enum('FACIL','MEDIO','DIFICIL') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pregunta`
--

INSERT INTO `pregunta` (`id_pregunta`, `id_categoria`, `enunciado`, `dificultad`) VALUES
(1, 1, '¿Quién era el dios del trueno en la mitología nórdica?', 'FACIL'),
(2, 1, '¿Qué criatura mitológica tenía serpientes en lugar de cabello?', 'MEDIO'),
(3, 1, '¿Cómo se llamaba el perro de tres cabezas que custodiaba el inframundo griego?', 'DIFICIL'),
(4, 1, '¿Quién era el dios griego del mar?', 'FACIL'),
(5, 1, '¿Qué héroe griego derrotó al Minotauro?', 'MEDIO'),
(6, 2, '¿Qué estructura de datos sigue el principio LIFO?', 'FACIL'),
(7, 2, '¿Qué instrucción permite repetir un bloque de código mientras una condición sea verdadera?', 'FACIL'),
(8, 2, '¿Qué símbolo se utiliza habitualmente para comparar igualdad en C?', 'MEDIO'),
(9, 2, '¿Qué es una función recursiva?', 'DIFICIL'),
(10, 2, '¿Qué estructura de control permite elegir entre diferentes caminos según una condición?', 'MEDIO'),
(11, 3, '¿Cómo se llama el protagonista de la saga The Legend of Zelda?', 'FACIL'),
(12, 3, '¿Qué empresa creó la consola PlayStation?', 'FACIL'),
(13, 3, '¿Cómo se llama el hermano de Mario en los videojuegos de Nintendo?', 'FACIL'),
(14, 3, '¿En qué videojuego aparece el personaje Creeper?', 'MEDIO'),
(15, 3, '¿Qué compañía desarrolló el videojuego Elden Ring?', 'DIFICIL'),
(16, 4, '¿Cuál es la fórmula química del agua?', 'FACIL'),
(17, 4, '¿Qué gas necesitan los seres humanos para respirar?', 'FACIL'),
(18, 4, '¿Qué elemento químico tiene el símbolo Au?', 'MEDIO'),
(19, 4, '¿Cómo se llama el proceso por el cual las plantas producen su alimento usando luz solar?', 'MEDIO'),
(20, 4, '¿Qué escala se utiliza habitualmente para medir la acidez o alcalinidad de una sustancia?', 'DIFICIL'),
(21, 5, '¿Qué componente de la computadora se conoce como el cerebro del equipo?', 'FACIL'),
(22, 5, '¿Qué significa RAM?', 'FACIL'),
(23, 5, '¿Qué dispositivo permite conectar una computadora a una red?', 'MEDIO'),
(24, 5, '¿Qué tipo de memoria pierde su contenido cuando se corta la energía?', 'MEDIO'),
(25, 5, '¿Qué sistema numérico utiliza únicamente los dígitos 0 y 1?', 'DIFICIL'),
(26, 1, '¿Qué dios egipcio era representado con cabeza de chacal?', 'FACIL'),
(27, 1, '¿Cómo se llamaba el árbol que conectaba los nueve mundos de la mitología nórdica?', 'MEDIO'),
(28, 1, '¿Quién era la diosa griega de la agricultura y las cosechas?', 'FACIL'),
(29, 1, '¿Qué criatura de la mitología japonesa suele representarse como un zorro sobrenatural?', 'MEDIO'),
(30, 1, '¿Qué rey mesopotámico protagoniza una de las epopeyas más antiguas de la humanidad?', 'DIFICIL'),
(31, 2, '¿Desde qué número comienza normalmente el índice de un arreglo en C?', 'FACIL'),
(32, 2, '¿Qué instrucción se utiliza para salir inmediatamente de un ciclo?', 'FACIL'),
(33, 2, '¿Qué tipo de dato se utiliza para almacenar un carácter en C?', 'FACIL'),
(34, 2, '¿Qué directiva permite incorporar bibliotecas en un programa C?', 'MEDIO'),
(35, 2, '¿Qué operador permite obtener el tamaño en bytes de una variable en C?', 'DIFICIL'),
(36, 3, '¿Cómo se llama la protagonista de la saga Tomb Raider?', 'FACIL'),
(37, 3, '¿Cuál es el objetivo principal del videojuego Tetris?', 'FACIL'),
(38, 3, '¿Cómo se llama la protagonista jugable de Portal?', 'MEDIO'),
(39, 3, '¿Qué estudio desarrolló la saga Pokémon?', 'MEDIO'),
(40, 3, '¿Quién creó originalmente el videojuego Tetris?', 'DIFICIL'),
(41, 4, '¿Cuál es el valor de pH considerado neutro?', 'FACIL'),
(42, 4, '¿A qué temperatura hierve el agua al nivel del mar?', 'FACIL'),
(43, 4, '¿Qué planeta es conocido por sus grandes anillos visibles?', 'FACIL'),
(44, 4, '¿Qué unidad se utiliza para medir la distancia que recorre la luz en un año?', 'MEDIO'),
(45, 4, '¿Qué orgánulo celular está relacionado principalmente con la producción de energía?', 'DIFICIL'),
(46, 5, '¿Qué significa la sigla SSD?', 'FACIL'),
(47, 5, '¿Qué función cumple un servidor DNS?', 'MEDIO'),
(48, 5, '¿Qué tipo de conexión transmite audio y video digital mediante un mismo cable?', 'FACIL'),
(49, 5, '¿Qué identifica una dirección MAC?', 'MEDIO'),
(50, 5, '¿Cómo se denomina el engaño que busca obtener contraseñas mediante mensajes o sitios falsos?', 'DIFICIL');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pregunta_partida`
--

CREATE TABLE `pregunta_partida` (
  `id_partida` int(11) NOT NULL,
  `id_pregunta` int(11) NOT NULL,
  `id_opcion_elegida` int(11) DEFAULT NULL,
  `fecha_hora` datetime NOT NULL DEFAULT current_timestamp(),
  `fue_correcta` tinyint(1) DEFAULT NULL,
  `tiempo_segundos` int(11) DEFAULT NULL,
  `danio_causado` int(11) NOT NULL DEFAULT 0
) ;

--
-- Volcado de datos para la tabla `pregunta_partida`
--

INSERT INTO `pregunta_partida` (`id_partida`, `id_pregunta`, `id_opcion_elegida`, `fecha_hora`, `fue_correcta`, `tiempo_segundos`, `danio_causado`) VALUES
(6, 11, 43, '2026-11-14 19:20:25', 0, NULL, 0),
(6, 14, 53, '2026-11-14 19:19:18', 1, NULL, 10),
(6, 20, 77, '2026-11-14 19:18:57', 1, NULL, 30),
(6, 23, 89, '2026-11-14 19:19:05', 1, NULL, 30),
(6, 25, 97, '2026-11-14 19:19:12', 1, NULL, 30),
(7, 6, 21, '2026-11-14 19:27:38', 1, NULL, 30),
(7, 12, 45, '2026-11-14 19:27:30', 1, NULL, 30),
(7, 15, 60, '2026-11-14 19:27:46', 0, NULL, 0),
(7, 18, 69, '2026-11-14 19:28:38', 1, NULL, 30),
(7, 19, 73, '2026-11-14 19:27:42', 1, NULL, 30),
(7, 24, 93, '2026-11-14 19:28:34', 1, NULL, 30),
(8, 1, 1, '2026-11-14 19:48:24', 1, NULL, 10),
(8, 5, 17, '2026-11-14 19:48:23', 0, NULL, 0),
(8, 9, 33, '2026-11-14 19:48:27', 1, NULL, 30),
(8, 13, 49, '2026-11-14 19:48:26', 1, NULL, 30),
(8, 17, 65, '2026-11-14 19:48:20', 1, NULL, 30),
(8, 18, 69, '2026-11-14 19:48:28', 1, NULL, 10),
(8, 19, 73, '2026-11-14 19:48:29', 1, NULL, 30),
(8, 22, 85, '2026-11-14 19:48:25', 1, NULL, 30),
(8, 23, 89, '2026-11-14 19:48:21', 1, NULL, 30),
(10, 2, 6, '2026-11-14 19:55:22', 1, NULL, 30),
(10, 4, 13, '2026-11-14 19:53:47', 0, NULL, 0),
(10, 5, 17, '2026-11-14 19:53:47', 0, NULL, 0),
(10, 8, 29, '2026-11-14 19:55:11', 1, NULL, 30),
(10, 10, 37, '2026-11-14 19:55:09', 1, NULL, 30),
(10, 14, 53, '2026-11-14 19:53:52', 1, NULL, 10),
(10, 18, 69, '2026-11-14 19:53:48', 1, NULL, 30),
(10, 20, 77, '2026-11-14 19:55:16', 1, NULL, 30),
(10, 23, 89, '2026-11-14 19:55:07', 1, NULL, 30),
(10, 25, 97, '2026-11-14 19:53:49', 1, NULL, 30),
(11, 5, 17, '2026-11-14 20:02:42', 0, NULL, 0),
(11, 7, 25, '2026-11-14 20:03:33', 0, NULL, 0),
(11, 11, 41, '2026-11-14 20:03:15', 1, NULL, 30),
(11, 12, 45, '2026-11-14 20:02:44', 1, NULL, 30),
(11, 13, 49, '2026-11-14 20:02:45', 1, NULL, 30),
(11, 14, 53, '2026-11-14 20:03:45', 1, NULL, 30),
(11, 16, 61, '2026-11-14 20:03:38', 1, NULL, 30),
(11, 18, 69, '2026-11-14 20:02:39', 1, NULL, 30),
(11, 21, 81, '2026-11-14 20:02:47', 1, NULL, 10),
(11, 22, 85, '2026-11-14 20:03:26', 1, NULL, 30),
(11, 23, 89, '2026-11-14 20:03:35', 1, NULL, 30),
(11, 25, 97, '2026-11-14 20:03:48', 1, NULL, 10),
(12, 13, 49, '2026-11-14 20:20:38', 1, NULL, 30),
(12, 15, 57, '2026-11-14 20:20:42', 1, NULL, 10),
(12, 16, 61, '2026-11-14 20:20:47', 1, NULL, 30),
(12, 17, 65, '2026-11-14 20:20:48', 1, NULL, 10),
(12, 22, 85, '2026-11-14 20:20:40', 1, NULL, 30),
(12, 25, 97, '2026-11-14 20:20:34', 1, NULL, 30),
(13, 2, 5, '2026-11-14 20:22:39', 0, NULL, 0),
(14, 4, 13, '2026-11-14 20:22:51', 0, NULL, 0),
(15, 1, 1, '2026-11-14 20:27:11', 1, NULL, 30),
(15, 3, 9, '2026-11-14 20:27:17', 0, NULL, 0),
(15, 4, 13, '2026-11-14 20:27:15', 0, NULL, 0),
(15, 6, 21, '2026-11-14 20:27:16', 1, NULL, 30),
(15, 9, 33, '2026-11-14 20:27:20', 1, NULL, 30),
(15, 11, 41, '2026-11-14 20:27:18', 1, NULL, 30),
(15, 12, 45, '2026-11-14 20:27:20', 1, NULL, 30),
(15, 13, 49, '2026-11-14 20:27:09', 1, NULL, 30),
(15, 24, 93, '2026-11-14 20:27:12', 1, NULL, 30),
(16, 4, 15, '2026-11-14 21:08:20', 1, 4, 30),
(16, 11, 41, '2026-11-14 21:08:15', 1, 6, 30),
(16, 14, 53, '2026-11-14 21:08:09', 1, 10, 30),
(16, 16, 61, '2026-11-14 21:05:39', 1, 7, 10),
(16, 18, 72, '2026-11-14 21:08:41', 0, 13, 0),
(16, 20, 77, '2026-11-14 21:05:32', 1, 29, 30),
(16, 25, 97, '2026-11-14 21:08:24', 1, 4, 10),
(17, 6, 23, '2026-11-15 14:42:42', 0, 5, 0),
(17, 7, 25, '2026-11-15 14:41:43', 0, 10, 0),
(17, 8, 31, '2026-11-15 14:42:11', 0, 9, 0),
(17, 10, 39, '2026-11-15 14:42:49', 0, 7, 0),
(17, 11, 42, '2026-11-15 14:42:25', 0, 4, 0),
(17, 16, 61, '2026-11-15 14:41:32', 1, 3, 30),
(17, 17, 65, '2026-11-15 14:42:31', 1, 5, 30),
(17, 21, 81, '2026-11-15 14:41:51', 1, 7, 10),
(17, 22, 85, '2026-11-15 14:42:36', 1, 5, 30),
(17, 23, 89, '2026-11-15 14:41:20', 1, 11, 30),
(17, 24, 93, '2026-11-15 14:41:29', 1, 8, 30),
(17, 25, 97, '2026-11-15 14:42:19', 1, 7, 30),
(18, 10, 37, '2026-11-15 14:50:48', 1, NULL, 10),
(18, 16, 61, '2026-11-15 14:50:27', 1, NULL, 30),
(18, 17, 65, '2026-11-15 14:50:33', 1, NULL, 30),
(18, 23, 89, '2026-11-15 14:50:42', 1, NULL, 30),
(19, 1, 1, '2026-11-15 15:04:32', 1, NULL, 30),
(19, 2, 5, '2026-11-15 15:04:31', 0, NULL, 0),
(19, 10, 37, '2026-11-15 15:04:22', 1, NULL, 30),
(19, 16, 61, '2026-11-15 15:04:30', 1, NULL, 30),
(19, 19, 73, '2026-11-15 15:04:29', 1, NULL, 30),
(20, 3, 10, '2026-11-15 15:07:33', 1, NULL, 30),
(20, 12, 45, '2026-11-15 15:07:37', 1, NULL, 30),
(20, 17, 65, '2026-11-15 15:07:43', 1, NULL, 10),
(20, 22, 85, '2026-11-15 15:07:40', 1, NULL, 30),
(21, 6, 21, '2026-11-15 15:08:40', 1, NULL, 30),
(21, 10, 37, '2026-11-15 15:08:40', 1, NULL, 30),
(22, 2, 5, '2026-11-15 15:09:56', 0, NULL, 0),
(22, 13, 49, '2026-11-15 15:09:58', 1, NULL, 30),
(22, 25, 97, '2026-11-15 15:09:57', 1, NULL, 30),
(23, 9, 33, '2026-11-15 15:14:45', 1, NULL, 10),
(23, 20, 77, '2026-11-15 15:14:43', 1, NULL, 30),
(23, 23, 89, '2026-11-15 15:14:44', 1, NULL, 30),
(39, 2, 6, '2026-11-15 17:21:45', 1, 6, 30),
(39, 3, 10, '2026-11-15 17:21:09', 1, 12, 30),
(39, 5, 17, '2026-11-15 17:21:39', 0, 4, 0),
(39, 7, 25, '2026-11-15 17:22:19', 0, 9, 0),
(39, 8, 31, '2026-11-15 17:21:58', 0, 3, 0),
(39, 9, 33, '2026-11-15 17:22:04', 1, 5, 30),
(39, 11, 41, '2026-11-15 17:22:31', 1, 5, 10),
(39, 13, 49, '2026-11-15 17:21:15', 1, 5, 30),
(39, 14, 53, '2026-11-15 17:21:50', 1, 4, 10),
(39, 17, 67, '2026-11-15 17:21:27', 0, 7, 0),
(39, 21, 81, '2026-11-15 17:22:10', 1, 5, 30),
(39, 23, 89, '2026-11-15 17:22:25', 1, 5, 30),
(39, 24, 93, '2026-11-15 17:21:34', 1, 7, 30),
(44, 2, 6, '2026-11-15 18:51:44', 1, 7, 30),
(44, 4, 15, '2026-11-15 18:52:04', 1, 6, 10),
(44, 8, 31, '2026-11-15 18:51:52', 0, 2, 0),
(44, 10, 37, '2026-11-15 18:50:49', 1, 6, 30),
(44, 12, 45, '2026-11-15 18:51:57', 1, 5, 30),
(44, 13, 49, '2026-11-15 18:51:49', 1, 5, 30),
(44, 14, 53, '2026-11-15 18:49:40', 1, 9, 30),
(44, 16, 61, '2026-11-15 18:49:31', 0, 69, 0),
(44, 19, 73, '2026-11-15 18:51:37', 0, 37, 0),
(44, 21, 81, '2026-11-15 18:49:46', 1, 5, 30),
(44, 23, 89, '2026-11-15 18:50:42', 0, 51, 0),
(44, 25, 97, '2026-11-15 18:50:55', 1, 5, 10),
(46, 3, 11, '2026-11-15 19:10:59', 0, 1, 0),
(46, 4, 14, '2026-11-15 19:10:57', 0, 1, 0),
(46, 15, 59, '2026-11-15 19:10:58', 0, 0, 0),
(46, 18, 71, '2026-11-15 19:11:01', 0, 1, 0),
(46, 20, 77, '2026-11-15 19:10:57', 1, 0, 30),
(46, 24, 95, '2026-11-15 19:10:55', 0, 22, 0),
(47, 3, 9, '2026-11-15 21:17:53', 0, 1, 0),
(47, 4, 16, '2026-11-15 21:17:57', 0, 0, 0),
(47, 8, 31, '2026-11-15 21:17:55', 0, 1, 0),
(47, 10, 37, '2026-11-15 21:17:49', 1, 5, 30),
(47, 17, 67, '2026-11-15 21:17:52', 0, 1, 0),
(47, 18, 70, '2026-11-15 21:17:56', 0, 0, 0);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_preguntas_juego`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_preguntas_juego` (
`id_pregunta` int(11)
,`enunciado` varchar(500)
,`dificultad` enum('FACIL','MEDIO','DIFICIL')
,`categoria` varchar(50)
,`id_opcion` int(11)
,`opcion` varchar(255)
,`es_correcta` tinyint(1)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_preguntas_juego`
--
DROP TABLE IF EXISTS `vista_preguntas_juego`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_preguntas_juego`  AS SELECT `p`.`id_pregunta` AS `id_pregunta`, `p`.`enunciado` AS `enunciado`, `p`.`dificultad` AS `dificultad`, `c`.`nombre` AS `categoria`, `o`.`id_opcion` AS `id_opcion`, `o`.`texto` AS `opcion`, `o`.`es_correcta` AS `es_correcta` FROM ((`pregunta` `p` join `categoria` `c` on(`p`.`id_categoria` = `c`.`id_categoria`)) join `opcion` `o` on(`p`.`id_pregunta` = `o`.`id_pregunta`)) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`id_categoria`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `jugador`
--
ALTER TABLE `jugador`
  ADD PRIMARY KEY (`id_jugador`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `monstruo`
--
ALTER TABLE `monstruo`
  ADD PRIMARY KEY (`id_monstruo`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `monstruo_partida`
--
ALTER TABLE `monstruo_partida`
  ADD PRIMARY KEY (`id_partida`,`orden`),
  ADD UNIQUE KEY `uq_monstruo_partida` (`id_partida`,`id_monstruo`),
  ADD KEY `fk_mp_monstruo` (`id_monstruo`);

--
-- Indices de la tabla `opcion`
--
ALTER TABLE `opcion`
  ADD PRIMARY KEY (`id_opcion`),
  ADD UNIQUE KEY `uq_opcion_pregunta` (`id_opcion`,`id_pregunta`),
  ADD KEY `fk_opcion_pregunta` (`id_pregunta`);

--
-- Indices de la tabla `partida`
--
ALTER TABLE `partida`
  ADD PRIMARY KEY (`id_partida`),
  ADD KEY `fk_partida_jugador` (`id_jugador`);

--
-- Indices de la tabla `pregunta`
--
ALTER TABLE `pregunta`
  ADD PRIMARY KEY (`id_pregunta`),
  ADD KEY `fk_pregunta_categoria` (`id_categoria`);

--
-- Indices de la tabla `pregunta_partida`
--
ALTER TABLE `pregunta_partida`
  ADD PRIMARY KEY (`id_partida`,`id_pregunta`),
  ADD KEY `fk_pp_pregunta` (`id_pregunta`),
  ADD KEY `fk_pp_opcion` (`id_opcion_elegida`,`id_pregunta`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `id_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `jugador`
--
ALTER TABLE `jugador`
  MODIFY `id_jugador` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `monstruo`
--
ALTER TABLE `monstruo`
  MODIFY `id_monstruo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `opcion`
--
ALTER TABLE `opcion`
  MODIFY `id_opcion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `partida`
--
ALTER TABLE `partida`
  MODIFY `id_partida` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pregunta`
--
ALTER TABLE `pregunta`
  MODIFY `id_pregunta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `monstruo_partida`
--
ALTER TABLE `monstruo_partida`
  ADD CONSTRAINT `fk_mp_monstruo` FOREIGN KEY (`id_monstruo`) REFERENCES `monstruo` (`id_monstruo`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_mp_partida` FOREIGN KEY (`id_partida`) REFERENCES `partida` (`id_partida`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `opcion`
--
ALTER TABLE `opcion`
  ADD CONSTRAINT `fk_opcion_pregunta` FOREIGN KEY (`id_pregunta`) REFERENCES `pregunta` (`id_pregunta`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `partida`
--
ALTER TABLE `partida`
  ADD CONSTRAINT `fk_partida_jugador` FOREIGN KEY (`id_jugador`) REFERENCES `jugador` (`id_jugador`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `pregunta`
--
ALTER TABLE `pregunta`
  ADD CONSTRAINT `fk_pregunta_categoria` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `pregunta_partida`
--
ALTER TABLE `pregunta_partida`
  ADD CONSTRAINT `fk_pp_opcion` FOREIGN KEY (`id_opcion_elegida`,`id_pregunta`) REFERENCES `opcion` (`id_opcion`, `id_pregunta`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pp_partida` FOREIGN KEY (`id_partida`) REFERENCES `partida` (`id_partida`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pp_pregunta` FOREIGN KEY (`id_pregunta`) REFERENCES `pregunta` (`id_pregunta`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
