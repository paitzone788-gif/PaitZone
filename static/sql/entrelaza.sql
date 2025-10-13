-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Oct 13, 2025 at 02:59 AM
-- Server version: 8.0.43
-- PHP Version: 7.4.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `entrelaza`
--

-- --------------------------------------------------------

--
-- Table structure for table `carreras`
--

CREATE TABLE `carreras` (
  `id` int NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `carreras`
--

INSERT INTO `carreras` (`id`, `nombre`) VALUES
(1, 'Administración'),
(3, 'Biotecnología'),
(4, 'Energías alternas'),
(2, 'Gestión aduanal'),
(6, 'Informática'),
(7, 'Procesos de manufactura competitiva'),
(5, 'Telecomunicaciones');

-- --------------------------------------------------------

--
-- Table structure for table `equipos`
--

CREATE TABLE `equipos` (
  `id` int NOT NULL,
  `nombre_proyecto` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `asesor` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `max_integrantes` int NOT NULL,
  `creador_id` int NOT NULL,
  `privacidad` enum('publico','privado') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'publico',
  `privado` tinyint(1) NOT NULL DEFAULT '1',
  `turno` enum('Matutino','Vespertino') COLLATE utf8mb4_unicode_ci DEFAULT 'Matutino'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `equipos`
--

INSERT INTO `equipos` (`id`, `nombre_proyecto`, `descripcion`, `asesor`, `max_integrantes`, `creador_id`, `privacidad`, `privado`, `turno`) VALUES
(91, 'CACHETES HIJO DE PERRA ', 'ajklsndaskjdbnajk', 'adanta claudia', 5, 447, 'privado', 1, 'Matutino'),
(92, 'CACHETES HIJO DE PERRA original', 'asdnaskljdbaskhjldbaslhjkbdashjdbasbdasjbdasjbdasjbdasbdaksbdakjasdnaskljdbaskhjldbaslhjkbdashjdbasbdasjbdasjbdasjbdasbdaksbdakjasdnaskljdbaskhjldbaslhjkbdashjdbasbdasjbdasjbdasjbdasbdaksbdakjasdnaskljdbaskhjldbaslhjkbdashjdbasbdasjbdasjbdasjbdasbdaksbdakjasdnaskljdbaskhjldbaslhjkbdashjdbasbdasjbdasjbdasjbdasbdaksbdakjasdnaskljdbaskhjldbaslhjkbdashjdbasbdasjbdasjbdasjbdasbdaksbdakjasdnaskljdbaskhjldbaslhjkbdashjdbasbdasjbdasjbdasjbdasbdaksbdakjasdnaskljdbaskhjldbaslhjkbdashjdbasbdasjbdasjbdasjbdasbdaksbdakjasdnaskljdbaskhjldbaslhjkbdashjdbasbdasjbdasjbdasjbdasbdaksbdakjasdnaskljdbaskhjldbaslhjkbdashjdbasbdasjbdasjbdasjbdasbdaksbdakjasdnaskljdbaskhjldbaslhjkbdashjdbasbdasjbdasjbdasjbdasbdaksbdakjasdnaskljdbaskhjldbaslhjkbdashjdbasbdasjbdasjbdasjbdasbdaksbdakjasdnaskljdbaskhjldbaslhjkbdashjdbasbdasjbdasjbdasjbdasbdaksbdakj', 'claudia chochil', 5, 450, 'privado', 1, 'Vespertino');

-- --------------------------------------------------------

--
-- Table structure for table `equipo_carreras`
--

CREATE TABLE `equipo_carreras` (
  `id` int NOT NULL,
  `equipo_id` int NOT NULL,
  `carrera_id` int NOT NULL,
  `cantidad` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `equipo_carreras`
--

INSERT INTO `equipo_carreras` (`id`, `equipo_id`, `carrera_id`, `cantidad`) VALUES
(182, 91, 1, 0),
(183, 91, 4, 0),
(184, 91, 2, 0),
(185, 91, 6, 0),
(186, 92, 1, 1),
(187, 92, 4, 1),
(188, 92, 2, 1),
(189, 92, 6, 1),
(190, 92, 5, 1);

-- --------------------------------------------------------

--
-- Table structure for table `equipo_integrantes`
--

CREATE TABLE `equipo_integrantes` (
  `id` int NOT NULL,
  `equipo_id` int NOT NULL,
  `usuario_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `equipo_integrantes`
--

INSERT INTO `equipo_integrantes` (`id`, `equipo_id`, `usuario_id`) VALUES
(216, 91, 397),
(220, 91, 447),
(219, 91, 451),
(217, 92, 450),
(218, 92, 452);

-- --------------------------------------------------------

--
-- Table structure for table `integrantes_equipo`
--

CREATE TABLE `integrantes_equipo` (
  `id` int NOT NULL,
  `equipo_id` int NOT NULL,
  `nombre_completo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notificaciones`
--

CREATE TABLE `notificaciones` (
  `id` int NOT NULL,
  `usuario_id` int NOT NULL,
  `mensaje` varchar(255) NOT NULL,
  `tipo` enum('solicitud','respuesta') NOT NULL,
  `leida` tinyint(1) DEFAULT '0',
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `notificaciones`
--

INSERT INTO `notificaciones` (`id`, `usuario_id`, `mensaje`, `tipo`, `leida`, `fecha`) VALUES
(3, 397, 'Tu solicitud para unirte al equipo ha sido aceptada.', 'respuesta', 1, '2025-10-11 19:53:08'),
(4, 397, 'Tu solicitud para unirte al equipo ha sido rechazada.', 'respuesta', 1, '2025-10-11 19:53:14'),
(5, 397, 'Tu solicitud para unirte al equipo ha sido rechazada.', 'respuesta', 1, '2025-10-11 19:54:38'),
(6, 397, 'Tu solicitud para unirte al equipo ha sido rechazada.', 'respuesta', 1, '2025-10-11 19:54:41'),
(7, 397, 'Tu solicitud para unirte al equipo ha sido rechazada.', 'respuesta', 1, '2025-10-11 19:55:00'),
(8, 397, 'Tu solicitud para unirte al equipo ha sido rechazada.', 'respuesta', 1, '2025-10-11 19:57:02'),
(9, 397, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue rechazada', 'respuesta', 1, '2025-10-11 20:30:50'),
(10, 397, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue aceptada', 'respuesta', 1, '2025-10-11 20:30:54'),
(11, 397, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue rechazada', 'respuesta', 1, '2025-10-11 20:31:05'),
(26, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue aceptada', 'respuesta', 1, '2025-10-11 22:18:56'),
(28, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue rechazada', 'respuesta', 1, '2025-10-11 22:26:24'),
(30, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue rechazada', 'respuesta', 1, '2025-10-11 22:27:37'),
(32, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue rechazada', 'respuesta', 1, '2025-10-11 22:34:43'),
(33, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue rechazada', 'respuesta', 1, '2025-10-11 22:34:44'),
(34, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue rechazada', 'respuesta', 1, '2025-10-11 22:34:44'),
(35, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue aceptada', 'respuesta', 1, '2025-10-11 22:34:46'),
(37, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue aceptada', 'respuesta', 1, '2025-10-11 22:35:50'),
(38, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue rechazada', 'respuesta', 1, '2025-10-11 22:35:52'),
(39, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue rechazada', 'respuesta', 1, '2025-10-11 22:35:52'),
(40, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue rechazada', 'respuesta', 1, '2025-10-11 22:35:53'),
(42, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue aceptada', 'respuesta', 1, '2025-10-11 22:40:49'),
(44, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue aceptada', 'respuesta', 1, '2025-10-11 22:45:44'),
(46, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue aceptada', 'respuesta', 1, '2025-10-11 22:47:14'),
(48, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue aceptada', 'respuesta', 1, '2025-10-11 22:51:01'),
(50, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue aceptada', 'respuesta', 1, '2025-10-11 22:57:21'),
(52, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue aceptada', 'respuesta', 1, '2025-10-11 23:01:02'),
(54, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue rechazada', 'respuesta', 1, '2025-10-11 23:24:55'),
(55, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue rechazada', 'respuesta', 1, '2025-10-11 23:24:55'),
(56, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue rechazada', 'respuesta', 1, '2025-10-11 23:24:56'),
(57, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue aceptada', 'respuesta', 1, '2025-10-11 23:24:59'),
(59, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue rechazada', 'respuesta', 1, '2025-10-11 23:32:38'),
(61, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue aceptada', 'respuesta', 1, '2025-10-11 23:33:22'),
(63, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue rechazada', 'respuesta', 1, '2025-10-11 23:35:12'),
(64, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue rechazada ❌.', 'respuesta', 1, '2025-10-11 23:35:12'),
(66, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue aceptada', 'respuesta', 1, '2025-10-11 23:35:59'),
(68, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue rechazada', 'respuesta', 1, '2025-10-11 23:37:39'),
(70, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue rechazada', 'respuesta', 1, '2025-10-11 23:39:15'),
(72, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA 7\' fue aceptada', 'respuesta', 1, '2025-10-11 23:40:26'),
(83, 442, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue rechazada', 'respuesta', 1, '2025-10-12 00:00:58'),
(84, 397, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue rechazada', 'respuesta', 1, '2025-10-12 00:00:59'),
(85, 442, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue rechazada', 'respuesta', 1, '2025-10-12 00:01:03'),
(86, 397, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue rechazada', 'respuesta', 1, '2025-10-12 00:01:04'),
(87, 442, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue rechazada', 'respuesta', 1, '2025-10-12 00:01:05'),
(88, 397, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue rechazada', 'respuesta', 1, '2025-10-12 00:01:06'),
(89, 442, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue rechazada', 'respuesta', 1, '2025-10-12 00:01:07'),
(90, 397, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue rechazada', 'respuesta', 1, '2025-10-12 00:01:08'),
(91, 442, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue rechazada', 'respuesta', 1, '2025-10-12 00:01:09'),
(92, 397, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue rechazada', 'respuesta', 1, '2025-10-12 00:01:11'),
(95, 397, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue rechazada', 'respuesta', 1, '2025-10-12 00:10:18'),
(96, 442, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue rechazada', 'respuesta', 1, '2025-10-12 00:10:20'),
(97, 397, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue rechazada', 'respuesta', 1, '2025-10-12 00:10:20'),
(100, 442, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue rechazada', 'respuesta', 1, '2025-10-12 00:11:32'),
(101, 397, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue rechazada', 'respuesta', 1, '2025-10-12 00:11:33'),
(104, 397, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue rechazada', 'respuesta', 1, '2025-10-12 00:20:51'),
(105, 397, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue rechazada', 'respuesta', 1, '2025-10-12 00:20:52'),
(108, 397, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue aceptada', 'respuesta', 1, '2025-10-12 00:21:54'),
(112, 397, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue aceptada.', 'respuesta', 1, '2025-10-12 00:26:44'),
(113, 442, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue aceptada.', 'respuesta', 1, '2025-10-12 00:26:51'),
(116, 442, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue aceptada.', 'respuesta', 1, '2025-10-12 00:41:10'),
(117, 397, 'Tu solicitud para unirte al equipo \'Alexis leandro cuevas \' fue aceptada.', 'respuesta', 1, '2025-10-12 00:41:12'),
(120, 397, 'Tu solicitud para unirte al equipo \'Claudia shembaum\' fue aceptada.', 'respuesta', 1, '2025-10-12 00:44:19'),
(131, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA \' fue rechazada', 'respuesta', 1, '2025-10-12 22:01:41'),
(134, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA \' fue aceptada.', 'respuesta', 1, '2025-10-12 22:05:38'),
(138, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA \' fue aceptada.', 'respuesta', 1, '2025-10-12 22:56:18'),
(142, 442, 'Rechazaste una solicitud para tu equipo \'CACHETES HIJO DE PERRA \'', 'respuesta', 1, '2025-10-13 00:09:39'),
(145, 442, 'Rechazaste una solicitud para tu equipo \'CACHETES HIJO DE PERRA \'', 'respuesta', 1, '2025-10-13 00:11:18'),
(148, 397, '¡Felicidades! Fuiste aceptado en el equipo \'CACHETES HIJO DE PERRA \'', 'respuesta', 0, '2025-10-13 02:16:51'),
(149, 442, 'Aceptaste a un usuario en tu equipo \'CACHETES HIJO DE PERRA \'', 'respuesta', 1, '2025-10-13 02:16:51'),
(152, 452, '¡Felicidades! Fuiste aceptado en el equipo \'CACHETES HIJO DE PERRA original\'', 'respuesta', 0, '2025-10-13 02:24:18'),
(153, 450, 'Aceptaste a un usuario en tu equipo \'CACHETES HIJO DE PERRA original\'', 'respuesta', 1, '2025-10-13 02:24:18'),
(154, 442, ' ROBERTO MOISES CANTOR CEJA ha solicitado unirse a tu equipo \'CACHETES HIJO DE PERRA \'', 'solicitud', 1, '2025-10-13 02:43:03'),
(155, 442, 'ATZIRI CITLALI GUADALUPE HERNANDEZ GARCIA desea volver a unirse a tu equipo \'CACHETES HIJO DE PERRA \' después de haberse salido.', 'solicitud', 1, '2025-10-13 02:43:42'),
(156, 451, '¡Felicidades! Fuiste aceptado en el equipo \'CACHETES HIJO DE PERRA \'', 'respuesta', 0, '2025-10-13 02:43:54'),
(157, 442, 'Aceptaste a un usuario en tu equipo \'CACHETES HIJO DE PERRA \'', 'respuesta', 1, '2025-10-13 02:43:54'),
(158, 447, '¡Felicidades! Fuiste aceptado en el equipo \'CACHETES HIJO DE PERRA \'', 'respuesta', 0, '2025-10-13 02:43:55'),
(159, 442, 'Aceptaste a un usuario en tu equipo \'CACHETES HIJO DE PERRA \'', 'respuesta', 1, '2025-10-13 02:43:55'),
(160, 447, 'Claudia shembaum ha solicitado unirse a tu equipo \'CACHETES HIJO DE PERRA \'', 'solicitud', 0, '2025-10-13 02:58:15');

-- --------------------------------------------------------

--
-- Table structure for table `solicitudes`
--

CREATE TABLE `solicitudes` (
  `solicitud_id` int NOT NULL,
  `usuario_id` int NOT NULL,
  `equipo_id` int NOT NULL,
  `estado` enum('pendiente','aceptada','rechazada') DEFAULT 'pendiente',
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `solicitudes`
--

INSERT INTO `solicitudes` (`solicitud_id`, `usuario_id`, `equipo_id`, `estado`, `fecha`) VALUES
(66, 397, 91, 'aceptada', '2025-10-13 02:16:27'),
(68, 452, 92, 'aceptada', '2025-10-13 02:23:33'),
(69, 447, 91, 'aceptada', '2025-10-13 02:43:03'),
(70, 451, 91, 'aceptada', '2025-10-13 02:43:42'),
(71, 442, 91, 'pendiente', '2025-10-13 02:58:15');

-- --------------------------------------------------------

--
-- Table structure for table `solicitudes_equipo`
--

CREATE TABLE `solicitudes_equipo` (
  `id` int NOT NULL,
  `usuario_id` int NOT NULL,
  `equipo_id` int NOT NULL,
  `estado` enum('pendiente','aceptada','rechazada') DEFAULT 'pendiente',
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int NOT NULL,
  `nombre_completo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `carrera` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `correo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contrasena` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'user',
  `grado` varchar(2) NOT NULL DEFAULT '',
  `grupo` varchar(2) NOT NULL DEFAULT '',
  `descripcion` text,
  `turno` enum('Matutino','Vespertino') DEFAULT 'Matutino'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre_completo`, `carrera`, `codigo`, `correo`, `telefono`, `contrasena`, `role`, `grado`, `grupo`, `descripcion`, `turno`) VALUES
(23, 'Administrador', 'Administración', 'admin001', 'admin@entrelaza.com', '0000000000', 'pbkdf2:sha256:1000000$L5LcO6fdXSvc94Kx$87ba4f605378059ff31ad8bc3bd5d4aedc37d160d55e81991d778a0392a44fe2', 'admin', '', '', NULL, 'Matutino'),
(397, 'Jose alfonso garcia jimenez', 'Informática', '8281812', 'josealfonso@alumnos.udg.mx', '192839012', 'pbkdf2:sha256:1000000$5xiVEjmwTq4uYL7J$1808692fd153bb9de9f79af76aa912ebaa8bee910556d59f0336ee26e40e64e3', 'user', '6', 'B', 'QUE ROLLO PHONK \r\ncachetes hijo de perra', 'Matutino'),
(442, 'Claudia shembaum', 'Informática', '1232131234', 'claudia111@alumnos.udg.mx', '9023091326', 'pbkdf2:sha256:1000000$LC3lmCgf3wRPX3rg$f50649c43d83cd0dd9f8418af674376df5150f81173a8ef0d5e3e9828d81d3a9', 'user', '6', 'B', NULL, 'Matutino'),
(447, ' ROBERTO MOISES CANTOR CEJA', 'Informática', '123401231', 'roberto1001@alumnos.udg.mx', '9290209021', 'pbkdf2:sha256:1000000$9U3REOjnsaPU7Ohw$7fe13ec2853936e06283bfe89c332b2a8e6e05928f7adf189de5a949f790592d', 'user', '6', 'A', 'QUE ROLLO PHONK CACHETES HIJO DE PERRA\r\nSEAN SERIO SIERVOS', 'Matutino'),
(448, 'ALEJANDRA JOSSELIN AYALA VIZCAINO', 'Informática', '1231312344', 'alejandra022@alumnos.udg.mx', '902309139101', 'pbkdf2:sha256:1000000$4Sckm2iUTULgf0pN$041bb2a1835918fd74c5b9962444e8e63242b7014062fb6deb7236a2030a4740', 'user', '6', 'A', NULL, 'Vespertino'),
(449, ' ANGEL MARTIN CHAVEZ VENEGAS', 'Informática', '1234511', 'angel1001@alumnos.udg.mx', '9023091323121', 'pbkdf2:sha256:1000000$3qdmwo7Nk2nXqsf0$2a3a7fefdb08462cd07f6358a83ab8d94030ba02eae284d0c7fe4f442a122716', 'user', '6', 'A', NULL, 'Vespertino'),
(450, ' DIEGO GUILLERMO GONZALEZ FRANCO', 'Informática', '1234011122', 'diego1001@alumnos.udg.mx', '1231231231212', 'pbkdf2:sha256:1000000$ehTZ9IH4FiH2KAuq$741c50b49d1408d3ee8eb36ff9afb978bc79b98042f8d5c5c5df62f30f32eecb', 'user', '6', 'A', NULL, 'Vespertino'),
(451, 'ATZIRI CITLALI GUADALUPE HERNANDEZ GARCIA', 'Administración', '1234019191', 'atiziri1001@alumnos.udg.mx', '90237370011', 'pbkdf2:sha256:1000000$9Pc28qlHVaV0Iia4$7a5faef2b3cca7bc871022f08282cccc9318adb865a81be47578619adb909b73', 'user', '6', 'A', NULL, 'Matutino'),
(452, ' ANTONY ALBERTO LOERA CARRILLO', 'Informática', '12340100112', 'antony1001@alumnos.udg.mx', '90237399112', 'pbkdf2:sha256:1000000$nP2hnBAuOzIRpmQ5$d7f4de43875c1d2250cd291dee30dad0cd5b9781192cd5a694a8698d23a170b9', 'user', '6', 'B', NULL, 'Vespertino');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `carreras`
--
ALTER TABLE `carreras`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indexes for table `equipos`
--
ALTER TABLE `equipos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `creador_id` (`creador_id`);

--
-- Indexes for table `equipo_carreras`
--
ALTER TABLE `equipo_carreras`
  ADD PRIMARY KEY (`id`),
  ADD KEY `equipo_id` (`equipo_id`),
  ADD KEY `carrera_id` (`carrera_id`);

--
-- Indexes for table `equipo_integrantes`
--
ALTER TABLE `equipo_integrantes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `equipo_id` (`equipo_id`,`usuario_id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indexes for table `integrantes_equipo`
--
ALTER TABLE `integrantes_equipo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `equipo_id` (`equipo_id`);

--
-- Indexes for table `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indexes for table `solicitudes`
--
ALTER TABLE `solicitudes`
  ADD PRIMARY KEY (`solicitud_id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `equipo_id` (`equipo_id`);

--
-- Indexes for table `solicitudes_equipo`
--
ALTER TABLE `solicitudes_equipo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `equipo_id` (`equipo_id`);

--
-- Indexes for table `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD UNIQUE KEY `correo` (`correo`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `carreras`
--
ALTER TABLE `carreras`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `equipos`
--
ALTER TABLE `equipos`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=93;

--
-- AUTO_INCREMENT for table `equipo_carreras`
--
ALTER TABLE `equipo_carreras`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=191;

--
-- AUTO_INCREMENT for table `equipo_integrantes`
--
ALTER TABLE `equipo_integrantes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=221;

--
-- AUTO_INCREMENT for table `integrantes_equipo`
--
ALTER TABLE `integrantes_equipo`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `notificaciones`
--
ALTER TABLE `notificaciones`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=161;

--
-- AUTO_INCREMENT for table `solicitudes`
--
ALTER TABLE `solicitudes`
  MODIFY `solicitud_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT for table `solicitudes_equipo`
--
ALTER TABLE `solicitudes_equipo`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=453;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `equipos`
--
ALTER TABLE `equipos`
  ADD CONSTRAINT `equipos_ibfk_1` FOREIGN KEY (`creador_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `equipo_carreras`
--
ALTER TABLE `equipo_carreras`
  ADD CONSTRAINT `equipo_carreras_ibfk_1` FOREIGN KEY (`equipo_id`) REFERENCES `equipos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `equipo_carreras_ibfk_2` FOREIGN KEY (`carrera_id`) REFERENCES `carreras` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `equipo_integrantes`
--
ALTER TABLE `equipo_integrantes`
  ADD CONSTRAINT `equipo_integrantes_ibfk_1` FOREIGN KEY (`equipo_id`) REFERENCES `equipos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `equipo_integrantes_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `integrantes_equipo`
--
ALTER TABLE `integrantes_equipo`
  ADD CONSTRAINT `integrantes_equipo_ibfk_1` FOREIGN KEY (`equipo_id`) REFERENCES `equipos` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD CONSTRAINT `notificaciones_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `solicitudes`
--
ALTER TABLE `solicitudes`
  ADD CONSTRAINT `solicitudes_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `solicitudes_ibfk_2` FOREIGN KEY (`equipo_id`) REFERENCES `equipos` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `solicitudes_equipo`
--
ALTER TABLE `solicitudes_equipo`
  ADD CONSTRAINT `solicitudes_equipo_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `solicitudes_equipo_ibfk_2` FOREIGN KEY (`equipo_id`) REFERENCES `equipos` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
