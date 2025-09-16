-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Sep 07, 2025 at 09:22 PM
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
  `max_integrantes` int NOT NULL,
  `creador_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE equipos
ADD COLUMN asesor varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL AFTER descripcion;

--
-- Dumping data for table `equipos`
--

INSERT INTO `equipos` (`id`, `nombre_proyecto`, `descripcion`, `max_integrantes`, `creador_id`) VALUES
(57, 'Alpha', 'Equipo de prueba Alpha', 5, 404),
(58, 'Beta', 'Equipo de prueba Beta', 5, 435),
(59, 'Gamma', 'Equipo de prueba Gamma', 5, 403),
(60, 'Delta', 'Equipo de prueba Delta', 5, 425),
(61, 'Epsilon', 'Equipo de prueba Epsilon', 5, 432),
(62, 'Zeta', 'Equipo de prueba Zeta', 5, 420),
(63, 'Theta', 'Equipo de prueba Theta', 5, 422),
(64, 'Sigma', 'Equipo de prueba Sigma', 5, 431),
(65, 'Omega', 'Equipo de prueba Omega', 5, 417),
(66, 'Kappa', 'Equipo de prueba Kappa', 5, 422),
(67, 'Phoenix', 'Equipo de prueba Phoenix', 5, 437),
(68, 'Dragon', 'Equipo de prueba Dragon', 5, 437),
(69, 'Leones', 'Equipo de prueba Leones', 5, 435),
(70, 'Tiburones', 'Equipo de prueba Tiburones', 5, 406),
(71, 'Halcones', 'Equipo de prueba Halcones', 5, 422);

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
(90, 57, 5, 0),
(91, 57, 6, 0),
(92, 58, 7, 0),
(93, 58, 1, 0),
(94, 59, 3, 0),
(95, 59, 2, 0),
(96, 60, 3, 0),
(97, 60, 6, 0),
(98, 61, 6, 0),
(99, 62, 6, 0),
(100, 63, 5, 0),
(101, 63, 7, 0),
(102, 65, 1, 0),
(103, 65, 7, 0),
(104, 65, 5, 0),
(105, 66, 1, 0),
(106, 67, 7, 0),
(107, 67, 2, 0),
(108, 67, 3, 0),
(109, 68, 6, 0),
(110, 69, 7, 0),
(111, 70, 6, 0),
(112, 71, 5, 0),
(113, 71, 1, 0);

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
(95, 57, 416),
(96, 57, 430),
(97, 58, 404),
(98, 58, 405),
(99, 59, 430),
(100, 59, 431),
(102, 60, 412),
(101, 60, 415),
(103, 61, 414),
(104, 61, 433),
(106, 62, 416),
(105, 62, 419),
(108, 63, 406),
(107, 63, 425),
(110, 64, 434),
(111, 65, 402),
(112, 65, 435),
(114, 66, 413),
(113, 66, 430),
(116, 67, 410),
(115, 67, 422),
(117, 68, 400),
(118, 68, 428),
(120, 69, 433),
(119, 69, 437),
(147, 70, 397),
(122, 70, 409),
(121, 70, 423),
(123, 71, 409),
(124, 71, 419);

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
  `grupo` varchar(2) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre_completo`, `carrera`, `codigo`, `correo`, `telefono`, `contrasena`, `role`, `grado`, `grupo`) VALUES
(23, 'Administrador', 'Administración', 'admin001', 'admin@entrelaza.com', '0000000000', 'pbkdf2:sha256:1000000$L5LcO6fdXSvc94Kx$87ba4f605378059ff31ad8bc3bd5d4aedc37d160d55e81991d778a0392a44fe2', 'admin', '', ''),
(397, 'Jose alfonso garcia jimenez', 'Informática', '8281812', 'josealfonso@alumnos.udg.mx', '192839012', 'pbkdf2:sha256:1000000$5xiVEjmwTq4uYL7J$1808692fd153bb9de9f79af76aa912ebaa8bee910556d59f0336ee26e40e64e3', 'user', '6', 'B'),
(398, 'Alumno1 Biotecnología', 'Biotecnología', 'B4B', 'alumno1@ejemplo.com', '', 'pbkdf2:sha256:1000000$G5uEaucScrqVqZty$a12d14bee620a9913dbf5cb7f71ad5870caaf884af22995d878247a7f48f0711', 'user', '4', 'B'),
(399, 'Alumno2 Informática', 'Informática', 'I4A', 'alumno2@ejemplo.com', '', 'pbkdf2:sha256:1000000$4dx7KQBcqAwOtkzg$1365b12e33204c7ed4ffcb7edbcf30a49ee533889c68259796d6f773ef8d3b37', 'user', '4', 'A'),
(400, 'Alumno3 Biotecnología', 'Biotecnología', 'B7C', 'alumno3@ejemplo.com', '', 'pbkdf2:sha256:1000000$LjFneqsNtD1G6XyY$f1058aff1c6fa2f733714bb6e2632598edd2f4cfdb89afa0e339cbcde7a72ce2', 'user', '7', 'C'),
(401, 'Alumno4 Procesos de manufactura competitiva', 'Procesos de manufactura competitiva', 'PDM4A', 'alumno4@ejemplo.com', '', 'pbkdf2:sha256:1000000$AWww8LGU95w6K8yX$ed29743dfdad3ba93ea74ad438b09a7fc293ad86d59b106e31d81b6efc6f2ea8', 'user', '4', 'A'),
(402, 'Alumno5 Gestión aduanal', 'Gestión aduanal', 'GA5B', 'alumno5@ejemplo.com', '', 'pbkdf2:sha256:1000000$gYNue73Z5AxJIJ3e$575d901c70f9d12ce6546a7973672cb48cb52667232dc189a106bf623b6e4dd5', 'user', '5', 'B'),
(403, 'Alumno6 Energías alternativas', 'Energías alternativas', 'EA5B', 'alumno6@ejemplo.com', '', 'pbkdf2:sha256:1000000$6SAzzVOwDpoubr3Y$0ebbae7b4ccc012260486c16c28d79e2d3a910e9b950f96118274817fea4aa51', 'user', '5', 'B'),
(404, 'Alumno7 Informática', 'Informática', 'I8C', 'alumno7@ejemplo.com', '', 'pbkdf2:sha256:1000000$q5L9rStMCkO7xVPB$af0191ede9be2e00b21b6b1998c2bd86f48e1d364c1667d5c77a54a16fce8439', 'user', '8', 'C'),
(405, 'Alumno8 Procesos de manufactura competitiva', 'Procesos de manufactura competitiva', 'PDM7C', 'alumno8@ejemplo.com', '', 'pbkdf2:sha256:1000000$o8UUr19O947uGmbp$0cfe7a6d3811e4c1742c1d76b7f583eb67816a7644ea0a6e55c01eeafa2857d9', 'user', '7', 'C'),
(406, 'Alumno9 Administración', 'Administración', 'A4A', 'alumno9@ejemplo.com', '', 'pbkdf2:sha256:1000000$Zy9lL4VVYcvpgAkp$735d77cc66ebe0072929bf73ce98fa6798fb8a24ce9e844de6c469c256cb275f', 'user', '4', 'A'),
(407, 'Alumno10 Biotecnología', 'Biotecnología', 'B6A', 'alumno10@ejemplo.com', '', 'pbkdf2:sha256:1000000$GNhRgM9ZOjKh630Q$e3b30016c08e1fc79fded84b66f314e1acbcb92cf0713162562523946696fd55', 'user', '6', 'A'),
(408, 'Alumno11 Gestión aduanal', 'Gestión aduanal', 'GA5A', 'alumno11@ejemplo.com', '', 'pbkdf2:sha256:1000000$HB0SvXhoZa8xL4R8$938c7ba6f4b79d88c2aa3859136d164347f946f8b67d0d7011b76ed3cd71e32d', 'user', '5', 'A'),
(409, 'Alumno12 Procesos de manufactura competitiva', 'Procesos de manufactura competitiva', 'PDM7A', 'alumno12@ejemplo.com', '', 'pbkdf2:sha256:1000000$AQpuMGyM7xXdszqN$a7d283d124e544b8f76f3c6abf633e4301d775e1402e7f12163bac8792cf3346', 'user', '7', 'A'),
(410, 'Alumno13 Gestión aduanal', 'Gestión aduanal', 'GA6A', 'alumno13@ejemplo.com', '', 'pbkdf2:sha256:1000000$fmzVNErIFx28BFWR$a4c489447876d83f35c6c050ec7f4d35c77b95f89e7057ffd813b0847419a733', 'user', '6', 'A'),
(411, 'Alumno14 Informática', 'Informática', 'I4C', 'alumno14@ejemplo.com', '', 'pbkdf2:sha256:1000000$wcM1lAjbHxoRhbJg$1f98df2373067511caaa832b0963782af5cf73bda866c5142470ca036b5f1ff9', 'user', '4', 'C'),
(412, 'Alumno15 Procesos de manufactura competitiva', 'Procesos de manufactura competitiva', 'PDM8A', 'alumno15@ejemplo.com', '', 'pbkdf2:sha256:1000000$uQVi4O0vClYy8FcE$22fd74a849f95ee71ed0593513604a3c3c5e6cf0182fb1ded3d410349fb72508', 'user', '8', 'A'),
(413, 'Alumno16 Administración', 'Administración', 'A4B', 'alumno16@ejemplo.com', '', 'pbkdf2:sha256:1000000$vAKMzGx8sOm0MOJY$ad57f8913eebbb5daa1b529ef7ed213577dbacd75b7079a6c3f7068cebbc8021', 'user', '4', 'B'),
(414, 'Alumno17 Administración', 'Administración', 'A7B', 'alumno17@ejemplo.com', '', 'pbkdf2:sha256:1000000$nzkYwMOiuWg61ODS$28331c01e0bfb8181fe0bc42e75b272913e7c43dd9d30601ca46ca3724b00253', 'user', '7', 'B'),
(415, 'Alumno18 Informática', 'Informática', 'I7B', 'alumno18@ejemplo.com', '', 'pbkdf2:sha256:1000000$LFsg9tf0N8bniH3K$2648afb8ee1c9e43550e01cff2a731e670a47cbbef830987f44f4af26b0c24b4', 'user', '7', 'B'),
(416, 'Alumno19 Gestión aduanal', 'Gestión aduanal', 'GA4A', 'alumno19@ejemplo.com', '', 'pbkdf2:sha256:1000000$mNX89GVcy0W5QgJ6$e988efdb507e1a34ca935a185fa4a8701785f045db1564343566fab82c22b2c3', 'user', '4', 'A'),
(417, 'Alumno20 Administración', 'Administración', 'A8B', 'alumno20@ejemplo.com', '', 'pbkdf2:sha256:1000000$ZPMExWjF8Wki3fGa$66dbac66668e6bb72d68448b05132008a4fb4dab4dd1798c1fb63c2b3c556d34', 'user', '8', 'B'),
(418, 'Alumno21 Procesos de manufactura competitiva', 'Procesos de manufactura competitiva', 'PDM8B', 'alumno21@ejemplo.com', '', 'pbkdf2:sha256:1000000$gvcBQOCHV8Uy7c4C$5138c97be8f4c33db7246c39dd14e0a34c7a6482163c0a4755fe3f37ac9bc0ac', 'user', '8', 'B'),
(419, 'Alumno22 Biotecnología', 'Biotecnología', 'B7B', 'alumno22@ejemplo.com', '', 'pbkdf2:sha256:1000000$OtZOb3ACbBVt5Siy$9311d0b687a35a9e55266f3cf513cf560bb217dda5ce619932c471679f26129f', 'user', '7', 'B'),
(420, 'Alumno23 Informática', 'Informática', 'I5C', 'alumno23@ejemplo.com', '', 'pbkdf2:sha256:1000000$ASvGRsRvxbBTmphl$47c04b68bb6b6a348829db40aa868edd1a62dc274bff49a1760ce6d2c2759b8b', 'user', '5', 'C'),
(421, 'Alumno24 Energías alternativas', 'Energías alternativas', 'EA5A', 'alumno24@ejemplo.com', '', 'pbkdf2:sha256:1000000$25cI70XsbHgax7Iz$ec04f960d0b7cd8739f65d65c188df2e61e8d3359f8d7cc58efac522973cf585', 'user', '5', 'A'),
(422, 'Alumno26 Energías alternativas', 'Energías alternativas', 'EA4B', 'alumno26@ejemplo.com', '', 'pbkdf2:sha256:1000000$nJxxtyJ9aMZbWYgZ$b703172211371135e4fb8b64998b9d4509676d603c3eceb2814fd68212612ba7', 'user', '4', 'B'),
(423, 'Alumno27 Telecomunicaciones', 'Telecomunicaciones', 'T5A', 'alumno27@ejemplo.com', '', 'pbkdf2:sha256:1000000$tMVKNPVVvgc3dpqb$47ebcbd5545997725e31103c34903d48ed77f570f42762d74bab29427b089c0e', 'user', '5', 'A'),
(424, 'Alumno28 Procesos de manufactura competitiva', 'Procesos de manufactura competitiva', 'PDM3B', 'alumno28@ejemplo.com', '', 'pbkdf2:sha256:1000000$wpuy4LhIBEhIoY4n$1788a7dccb8f5f25e99864b51af55ea64e0f59509d526bcefbb2d4a80efb3031', 'user', '3', 'B'),
(425, 'Alumno29 Telecomunicaciones', 'Telecomunicaciones', 'T6C', 'alumno29@ejemplo.com', '', 'pbkdf2:sha256:1000000$zPMWvPvLTzkQCaUc$850a9af6e144438c384d2fd260fedb80ca23b5466ddd05c11e2feac70c556f1d', 'user', '6', 'C'),
(426, 'Alumno30 Administración', 'Administración', 'A6B', 'alumno30@ejemplo.com', '', 'pbkdf2:sha256:1000000$Itv1LloTXcSB7p2h$5ebf8b4d964727b5b475dccc62d49b361d4ba30fc56849eb7ba3cd65daf16b92', 'user', '6', 'B'),
(427, 'Alumno31 Telecomunicaciones', 'Telecomunicaciones', 'T5B', 'alumno31@ejemplo.com', '', 'pbkdf2:sha256:1000000$VLu5emq1HxT4uMvQ$46f4de38632e23c6718e672e4ade6c65b82958b5c8613df0829635d5486d2f71', 'user', '5', 'B'),
(428, 'Alumno33 Biotecnología', 'Biotecnología', 'B8C', 'alumno33@ejemplo.com', '', 'pbkdf2:sha256:1000000$e66IbXIzix2kmVIe$624b6709f25f33ae613f4e3f0fb7d3d48f3b54ae5a9e4981dfac54262a4da102', 'user', '8', 'C'),
(429, 'Alumno36 Telecomunicaciones', 'Telecomunicaciones', 'T6A', 'alumno36@ejemplo.com', '', 'pbkdf2:sha256:1000000$p48D99lTwmU5HVzM$b1ff7babd4342e036e801bc03c4578b6b2d980a2d3f69de6f0744a984f2c9f88', 'user', '6', 'A'),
(430, 'Alumno39 Procesos de manufactura competitiva', 'Procesos de manufactura competitiva', 'PDM5A', 'alumno39@ejemplo.com', '', 'pbkdf2:sha256:1000000$Z6ZAQdJ2vGAOoAkp$a2bfce0988b5bb4e4764e0e3fd6e04e24431f46a4103cfdb8c777c2410e2690c', 'user', '5', 'A'),
(431, 'Alumno40 Procesos de manufactura competitiva', 'Procesos de manufactura competitiva', 'PDM5B', 'alumno40@ejemplo.com', '', 'pbkdf2:sha256:1000000$Y3S9vXHppmy6Ie93$8aee783c8e9659256e634e5b35f3a512426d25858ef3a706a5d8bb8fa99f422b', 'user', '5', 'B'),
(432, 'Alumno41 Energías alternativas', 'Energías alternativas', 'EA4A', 'alumno41@ejemplo.com', '', 'pbkdf2:sha256:1000000$wecQTuY0X6b3Kb4Q$82f0cbc331aafa6bfd25408c905b30ca5ac64e306afe52abb26c7190ea2923c0', 'user', '4', 'A'),
(433, 'Alumno42 Gestión aduanal', 'Gestión aduanal', 'GA3C', 'alumno42@ejemplo.com', '', 'pbkdf2:sha256:1000000$SIvOHgolddSz7Sys$bc8f5b7f28b7e93da689b099af773918da0e3266fe36b4f9a093d02f44f7ad35', 'user', '3', 'C'),
(434, 'Alumno43 Procesos de manufactura competitiva', 'Procesos de manufactura competitiva', 'PDM4C', 'alumno43@ejemplo.com', '', 'pbkdf2:sha256:1000000$IdnxTNYH5d9q1QUP$cee35ec97fd178143e10d76f5e72828f1272daa4a7ad2bf0776354eb49ad6e74', 'user', '4', 'C'),
(435, 'Alumno44 Telecomunicaciones', 'Telecomunicaciones', 'T7B', 'alumno44@ejemplo.com', '', 'pbkdf2:sha256:1000000$cokDOz6dW6oYFH2c$ddc25eb12c5d1b717209e6d2d6fa4f05ce9cb40d73ed0a48b3f62d6dbd39625a', 'user', '7', 'B'),
(436, 'Alumno47 Energías alternativas', 'Energías alternativas', 'EA8A', 'alumno47@ejemplo.com', '', 'pbkdf2:sha256:1000000$Vj5XzfcRMUTNiEBW$6286b6f57dfd654604c83fc621ba0590fdaa5b586638681b5cbbd4ecbdf6fba2', 'user', '8', 'A'),
(437, 'Alumno50 Administración', 'Administración', 'A8A', 'alumno50@ejemplo.com', '', 'pbkdf2:sha256:1000000$b3ZpDkSFwIYrCvh1$d9090fcd7dd322d1c583d8bea152a1171f4434515c5970e2910654b5c89c9fdf', 'user', '8', 'A'),
(438, 'Diego guillermo gonzales franco', 'Informática', '12312412', 'diego1001@alumnos.udg.mx', '38712398763', 'pbkdf2:sha256:1000000$QcM88zgzOUHs9D2o$142504c85d686329a793590b2a613143b4661267a65b8f0ecea166f0a62120d0', 'user', '6', 'B');

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
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=75;

--
-- AUTO_INCREMENT for table `equipo_carreras`
--
ALTER TABLE `equipo_carreras`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=122;

--
-- AUTO_INCREMENT for table `equipo_integrantes`
--
ALTER TABLE `equipo_integrantes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=148;

--
-- AUTO_INCREMENT for table `integrantes_equipo`
--
ALTER TABLE `integrantes_equipo`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=439;

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
