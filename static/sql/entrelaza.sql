-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Oct 13, 2025 at 12:16 AM
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
  `privado` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `equipos`
--

INSERT INTO `equipos` (`id`, `nombre_proyecto`, `descripcion`, `asesor`, `max_integrantes`, `creador_id`, `privacidad`, `privado`) VALUES
(91, 'CACHETES HIJO DE PERRA ', 'ajklsndaskjdbnajk', 'adanta claudia', 5, 442, 'privado', 1);

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
(185, 91, 6, 0);

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
(215, 91, 397),
(209, 91, 442),
(211, 91, 445),
(210, 91, 446);

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
(127, 446, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA \' fue aceptada.', 'respuesta', 0, '2025-10-12 20:54:41'),
(128, 445, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA \' fue aceptada.', 'respuesta', 0, '2025-10-12 20:54:43'),
(129, 444, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA \' fue aceptada.', 'respuesta', 1, '2025-10-12 20:54:44'),
(130, 443, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA \' fue aceptada.', 'respuesta', 1, '2025-10-12 20:54:45'),
(131, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA \' fue rechazada', 'respuesta', 1, '2025-10-12 22:01:41'),
(134, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA \' fue aceptada.', 'respuesta', 1, '2025-10-12 22:05:38'),
(135, 443, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA \' fue rechazada', 'respuesta', 1, '2025-10-12 22:10:02'),
(138, 397, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA \' fue aceptada.', 'respuesta', 1, '2025-10-12 22:56:18'),
(139, 443, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA \' fue rechazada', 'respuesta', 1, '2025-10-12 22:56:23'),
(141, 444, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA \' fue rechazada', 'respuesta', 1, '2025-10-13 00:09:39'),
(142, 442, 'Rechazaste una solicitud para tu equipo \'CACHETES HIJO DE PERRA \'', 'respuesta', 1, '2025-10-13 00:09:39'),
(144, 444, 'Tu solicitud para unirte al equipo \'CACHETES HIJO DE PERRA \' fue rechazada', 'respuesta', 1, '2025-10-13 00:11:18'),
(145, 442, 'Rechazaste una solicitud para tu equipo \'CACHETES HIJO DE PERRA \'', 'respuesta', 1, '2025-10-13 00:11:18');

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
(57, 445, 91, 'aceptada', '2025-10-12 20:52:41'),
(58, 446, 91, 'aceptada', '2025-10-12 20:53:39'),
(61, 397, 91, 'aceptada', '2025-10-12 22:55:44'),
(62, 443, 91, 'rechazada', '2025-10-12 22:56:02'),
(64, 444, 91, 'rechazada', '2025-10-13 00:10:37');

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
  `descripcion` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre_completo`, `carrera`, `codigo`, `correo`, `telefono`, `contrasena`, `role`, `grado`, `grupo`, `descripcion`) VALUES
(23, 'Administrador', 'Administración', 'admin001', 'admin@entrelaza.com', '0000000000', 'pbkdf2:sha256:1000000$L5LcO6fdXSvc94Kx$87ba4f605378059ff31ad8bc3bd5d4aedc37d160d55e81991d778a0392a44fe2', 'admin', '', '', NULL),
(397, 'Jose alfonso garcia jimenez', 'Informática', '8281812', 'josealfonso@alumnos.udg.mx', '192839012', 'pbkdf2:sha256:1000000$5xiVEjmwTq4uYL7J$1808692fd153bb9de9f79af76aa912ebaa8bee910556d59f0336ee26e40e64e3', 'user', '6', 'B', 'QUE ROLLO PHONK \r\ncachetes hijo de perra'),
(442, 'Claudia shembaum', 'Informática', '1232131234', 'claudia111@alumnos.udg.mx', '9023091326', 'pbkdf2:sha256:1000000$LC3lmCgf3wRPX3rg$f50649c43d83cd0dd9f8418af674376df5150f81173a8ef0d5e3e9828d81d3a9', 'user', '6', 'B', NULL),
(443, 'Diego guillermo gonzales franco', 'Informática', '8281912', 'diego1001@alumnos.udg.mx', '9023091323', 'pbkdf2:sha256:1000000$jY54rDhdf8SBuO7M$9f51cd581819a64434cf62d3730e40c237a51c9bcc61de3401676494a9657ef2', 'user', '6', 'B', NULL),
(444, 'ANTONY ALBERTO LOERA CARRILLO', 'Informática', '00119922', 'antony1001@alumnos.udg.mx', '1231231232', 'pbkdf2:sha256:1000000$IE8MIdXu9MX00dfR$9f74e8ab119145fa51bfac014661a791e6a198f3e6e7784765ed4c0750194c32', 'user', '6', 'A', NULL),
(445, 'ATZIRI CITLALI GUADALUPE HERNANDEZ GARCIA', 'Administración', '12340091', 'atiziri1001@alumnos.udg.mx', '9023737312', 'pbkdf2:sha256:1000000$ldyWxfn8Ld4HNfCN$12aed1553933069df8266e56eeea6efb008d7c8702dccad6489dc8d67831234a', 'user', '6', 'B', NULL),
(446, ' ANGEL MARTIN CHAVEZ VENEGAS', 'Informática', '11100122', 'martin1001@alumnos.udg.mx', '9023000022', 'pbkdf2:sha256:1000000$7QrjaarRDUdUbChi$d1aee7c764006a861db79bfaef07a7023188780cbfb2789971436d3d043dbfe2', 'user', '6', 'A', NULL);

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
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=92;

--
-- AUTO_INCREMENT for table `equipo_carreras`
--
ALTER TABLE `equipo_carreras`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=186;

--
-- AUTO_INCREMENT for table `equipo_integrantes`
--
ALTER TABLE `equipo_integrantes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=216;

--
-- AUTO_INCREMENT for table `integrantes_equipo`
--
ALTER TABLE `integrantes_equipo`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `notificaciones`
--
ALTER TABLE `notificaciones`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=146;

--
-- AUTO_INCREMENT for table `solicitudes`
--
ALTER TABLE `solicitudes`
  MODIFY `solicitud_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT for table `solicitudes_equipo`
--
ALTER TABLE `solicitudes_equipo`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=447;

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
