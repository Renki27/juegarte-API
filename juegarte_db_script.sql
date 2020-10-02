-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 03-10-2020 a las 00:02:37
-- Versión del servidor: 10.4.13-MariaDB
-- Versión de PHP: 7.2.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `juegarte_db`
--

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `CREATE_ACCOUNT`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CREATE_ACCOUNT` (IN `p_username` VARCHAR(25), IN `p_password` VARCHAR(255), IN `p_email` VARCHAR(50))  BEGIN
    DECLARE emailExists INT;
    DECLARE userExists INT;
    
	SELECT COUNT(*) INTO emailExists FROM ACCOUNT WHERE ACCOUNT.EMAIL = p_EMAIL;
    SELECT COUNT(*) INTO userExists FROM ACCOUNT WHERE ACCOUNT.USERNAME = p_username;
    IF emailExists = 0 AND userExists = 0 THEN
     INSERT INTO account (username, EMAIL, account.password, POINTS, IMAGE) 
     VALUES (p_username, p_email, p_password, DEFAULT, DEFAULT);
    END IF;
END$$

DROP PROCEDURE IF EXISTS `CREATE_GAME_MODE`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CREATE_GAME_MODE` (IN `p_GM_name` VARCHAR(25), IN `p_instructions` VARCHAR(1000), IN `p_question_time_seconds` INT(3))  BEGIN
     INSERT INTO game (GAME_MODE_NAME, GAME_INSTRUCTIONS, QUESTION_TIME_S) 
     VALUES (p_GM_name, p_instructions, p_question_time_seconds);
END$$

DROP PROCEDURE IF EXISTS `GENERATE_SCRATCH_QUESTION`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GENERATE_SCRATCH_QUESTION` (IN `p_id_game` INT(3), IN `p_question_text` VARCHAR(100), IN `p_question_information` VARCHAR(100), IN `p_question_image` VARCHAR(50), IN `p_option_1` VARCHAR(25), IN `p_option_2` VARCHAR(25), IN `p_option_3` VARCHAR(25), IN `p_option_4` VARCHAR(25), IN `p_answer` VARCHAR(25))  BEGIN
DECLARE id_question INT;
DECLARE image VARCHAR(50);

	CALL INSERT_QUESTION(p_id_game, p_question_text, p_question_information, p_question_image);
    
    select LAST_INSERT_ID() INTO id_question;
    select QUESTION_IMAGE INTO image FROM question WHERE question.ID_QUESTION = id_question;
    
    CALL INSERT_SCRATCH_QUESTION (id_question, p_id_game, p_question_text, p_question_information, image, p_option_1, p_option_2, p_option_3, p_option_4, p_answer);
   
END$$

DROP PROCEDURE IF EXISTS `INSERT_QUESTION`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `INSERT_QUESTION` (IN `p_id_game` INT(3), IN `p_question_text` VARCHAR(100), IN `p_question_information` VARCHAR(100), IN `p_question_image` VARCHAR(50))  BEGIN
     INSERT INTO question (ID_GAME, QUESTION_TEXT, QUESTION_INFORMATION, QUESTION_IMAGE) 
     VALUES (p_id_game, p_question_text, p_question_information, CONCAT("../uploads/", p_question_image));
END$$

DROP PROCEDURE IF EXISTS `INSERT_SCRATCH_QUESTION`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `INSERT_SCRATCH_QUESTION` (IN `p_id_question` INT(3), IN `p_id_game` INT(3), IN `p_question_text` VARCHAR(100), IN `p_question_information` VARCHAR(100), IN `p_question_image` VARCHAR(50), IN `p_option_1` VARCHAR(25), IN `p_option_2` VARCHAR(25), IN `p_option_3` VARCHAR(25), IN `p_option_4` VARCHAR(25), IN `p_answer` VARCHAR(25))  BEGIN
     INSERT INTO q_scratch (ID_QUESTION, ID_GAME, QUESTION_TEXT, QUESTION_INFORMATION, QUESTION_IMAGE, T3_OPTION_Q_1, T3_OPTION_Q_2, T3_OPTION_Q_3, T3_OPTION_Q_4, T3_ANSWER) 
     VALUES (p_id_question, p_id_game, p_question_text, p_question_information, p_question_image, p_option_1, p_option_2, p_option_3, p_option_4, p_answer);
END$$

DROP PROCEDURE IF EXISTS `SELECT_GAME_MODES`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SELECT_GAME_MODES` ()  BEGIN
	SELECT * from game;
END$$

DROP PROCEDURE IF EXISTS `SELECT_USER_BY_USERNAME`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SELECT_USER_BY_USERNAME` (IN `p_username` VARCHAR(25))  BEGIN
    DECLARE userExists VARCHAR(25);

    
	SELECT COUNT(*) INTO userExists FROM ACCOUNT WHERE ACCOUNT.USERNAME = p_username;

    IF userExists = 1 THEN

	SELECT * FROM account WHERE username = p_username;

    END IF;
END$$

DROP PROCEDURE IF EXISTS `VERIFY_USER_EXISTS_EMAIL`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `VERIFY_USER_EXISTS_EMAIL` (IN `p_email` VARCHAR(50))  BEGIN


SELECT COUNT(*) FROM ACCOUNT WHERE ACCOUNT.EMAIL = p_email;


END$$

DROP PROCEDURE IF EXISTS `VERIFY_USER_EXISTS_USERNAME`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `VERIFY_USER_EXISTS_USERNAME` (IN `p_username` VARCHAR(25))  BEGIN
    
	SELECT COUNT(*) FROM ACCOUNT WHERE ACCOUNT.USERNAME = p_username;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `account`
--

DROP TABLE IF EXISTS `account`;
CREATE TABLE `account` (
  `USERNAME` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `EMAIL` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `PASSWORD` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `POINTS` int(5) DEFAULT 0,
  `IMAGE` varchar(50) COLLATE utf8_unicode_ci DEFAULT '../uploads/Avatar.png'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `account`
--

INSERT INTO `account` (`USERNAME`, `EMAIL`, `PASSWORD`, `POINTS`, `IMAGE`) VALUES
('admin', 'admin@admin.com', '$2y$10$L6/nPkQUkj6Xk./buPIFAuTKb6.H3kK013rY1sSRSnXowzZVFT5wC', 0, '../uploads/Avatar.png'),
('admin2', 'admin2@admin.com', '$2y$10$0h89fqJnuLeqE8v8V.avwecvNSrr7uT8nH0Ekc9JqN8daFHbAvVsC', 0, '../uploads/Avatar.png'),
('tester', 'tester@test.com', '$2y$10$uMoZmg4a6/pZBtAaIEvsiOh6X6LzggpQi1sQ2whA5GXFTOMCAv/7q', 0, '../uploads/Avatar.png');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `account_achievement`
--

DROP TABLE IF EXISTS `account_achievement`;
CREATE TABLE `account_achievement` (
  `USERNAME` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `ID_ACHIEVEMENT` int(5) NOT NULL,
  `A_CURRENT_STEP` int(3) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `account_game`
--

DROP TABLE IF EXISTS `account_game`;
CREATE TABLE `account_game` (
  `ID_GAME` int(3) NOT NULL,
  `USERNAME` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `OBTAINED_POINTS` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `achievement`
--

DROP TABLE IF EXISTS `achievement`;
CREATE TABLE `achievement` (
  `ID_ACHIEVEMENT` int(5) NOT NULL,
  `ACHIEVEMENT_TITLE` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `ACHIEVEMENT_DESCRIPTION` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `A_COMPLETED_STEP` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `game`
--

DROP TABLE IF EXISTS `game`;
CREATE TABLE `game` (
  `ID_GAME` int(3) NOT NULL,
  `GAME_MODE_NAME` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `GAME_INSTRUCTIONS` varchar(1000) COLLATE utf8_unicode_ci NOT NULL,
  `QUESTION_TIME_S` int(3) NOT NULL DEFAULT 30
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `game`
--

INSERT INTO `game` (`ID_GAME`, `GAME_MODE_NAME`, `GAME_INSTRUCTIONS`, `QUESTION_TIME_S`) VALUES
(1, 'Trivia', 'game instructions', 30),
(2, 'True or False', 'game instructions', 30),
(3, 'Scratch Game', 'game instructions', 30);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `question`
--

DROP TABLE IF EXISTS `question`;
CREATE TABLE `question` (
  `ID_QUESTION` int(3) NOT NULL,
  `ID_GAME` int(3) NOT NULL,
  `QUESTION_TEXT` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `QUESTION_INFORMATION` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `QUESTION_IMAGE` varchar(50) COLLATE utf8_unicode_ci DEFAULT '../uploads/no_image.png'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `question`
--

INSERT INTO `question` (`ID_QUESTION`, `ID_GAME`, `QUESTION_TEXT`, `QUESTION_INFORMATION`, `QUESTION_IMAGE`) VALUES
(1, 3, 'question text example', 'question information', '../uploads/s_img_q1.jpg'),
(2, 3, 'question text example', 'question information', '../uploads/s_img_q2.jpg'),
(3, 3, 'question text example', 'question information', '../uploads/s_img_q3.jpg'),
(4, 3, 'question text example', 'question information', '../uploads/s_img_q4.jpg');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `q_option`
--

DROP TABLE IF EXISTS `q_option`;
CREATE TABLE `q_option` (
  `ID_QUESTION` int(3) NOT NULL,
  `ID_GAME` int(3) NOT NULL,
  `QUESTION_TEXT` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `QUESTION_INFORMATION` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `QUESTION_IMAGE` varchar(50) COLLATE utf8_unicode_ci DEFAULT '../uploads/no_image.png',
  `T1_OPTION_Q_1` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `T1_OPTION_Q_2` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `T1_OPTION_Q_3` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `T1_OPTION_Q_4` varchar(25) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `q_scratch`
--

DROP TABLE IF EXISTS `q_scratch`;
CREATE TABLE `q_scratch` (
  `ID_QUESTION` int(3) NOT NULL,
  `ID_GAME` int(3) NOT NULL,
  `QUESTION_TEXT` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `QUESTION_INFORMATION` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `QUESTION_IMAGE` varchar(50) COLLATE utf8_unicode_ci DEFAULT '../uploads/no_image.png',
  `T3_OPTION_Q_1` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `T3_OPTION_Q_2` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `T3_OPTION_Q_3` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `T3_OPTION_Q_4` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `T3_ANSWER` varchar(25) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `q_scratch`
--

INSERT INTO `q_scratch` (`ID_QUESTION`, `ID_GAME`, `QUESTION_TEXT`, `QUESTION_INFORMATION`, `QUESTION_IMAGE`, `T3_OPTION_Q_1`, `T3_OPTION_Q_2`, `T3_OPTION_Q_3`, `T3_OPTION_Q_4`, `T3_ANSWER`) VALUES
(1, 3, 'question text example', 'question information', '../uploads/s_img_q1.jpg', 'A', 'B', 'C', 'D', 'B'),
(2, 3, 'question text example', 'question information', '../uploads/s_img_q2.jpg', 'A', 'B', 'C', 'D', 'C'),
(3, 3, 'question text example', 'question information', '../uploads/s_img_q3.jpg', '1', '2', '3', '4', '4'),
(4, 3, 'question text example', 'question information', '../uploads/s_img_q4.jpg', '1', '2', '3', '4', '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `q_true_false`
--

DROP TABLE IF EXISTS `q_true_false`;
CREATE TABLE `q_true_false` (
  `ID_QUESTION` int(3) NOT NULL,
  `ID_GAME` int(3) NOT NULL,
  `QUESTION_TEXT` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `QUESTION_INFORMATION` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `QUESTION_IMAGE` varchar(50) COLLATE utf8_unicode_ci DEFAULT '../uploads/no_image.png',
  `TF_ANSWER` varchar(25) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`USERNAME`);

--
-- Indices de la tabla `account_achievement`
--
ALTER TABLE `account_achievement`
  ADD PRIMARY KEY (`ID_ACHIEVEMENT`,`USERNAME`),
  ADD KEY `FK_ACCOUNT_ACHIEVEMENT2` (`USERNAME`);

--
-- Indices de la tabla `account_game`
--
ALTER TABLE `account_game`
  ADD PRIMARY KEY (`ID_GAME`,`USERNAME`),
  ADD KEY `FK_ACCOUNT_CAN_PLAY_GAME2` (`USERNAME`);

--
-- Indices de la tabla `achievement`
--
ALTER TABLE `achievement`
  ADD PRIMARY KEY (`ID_ACHIEVEMENT`);

--
-- Indices de la tabla `game`
--
ALTER TABLE `game`
  ADD PRIMARY KEY (`ID_GAME`);

--
-- Indices de la tabla `question`
--
ALTER TABLE `question`
  ADD PRIMARY KEY (`ID_QUESTION`),
  ADD KEY `FK_GAME_HAS_QUESTION` (`ID_GAME`);

--
-- Indices de la tabla `q_option`
--
ALTER TABLE `q_option`
  ADD PRIMARY KEY (`ID_QUESTION`);

--
-- Indices de la tabla `q_scratch`
--
ALTER TABLE `q_scratch`
  ADD PRIMARY KEY (`ID_QUESTION`);

--
-- Indices de la tabla `q_true_false`
--
ALTER TABLE `q_true_false`
  ADD PRIMARY KEY (`ID_QUESTION`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `achievement`
--
ALTER TABLE `achievement`
  MODIFY `ID_ACHIEVEMENT` int(5) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `game`
--
ALTER TABLE `game`
  MODIFY `ID_GAME` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `question`
--
ALTER TABLE `question`
  MODIFY `ID_QUESTION` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `account_achievement`
--
ALTER TABLE `account_achievement`
  ADD CONSTRAINT `FK_ACCOUNT_ACHIEVEMENT` FOREIGN KEY (`ID_ACHIEVEMENT`) REFERENCES `achievement` (`ID_ACHIEVEMENT`),
  ADD CONSTRAINT `FK_ACCOUNT_ACHIEVEMENT2` FOREIGN KEY (`USERNAME`) REFERENCES `account` (`USERNAME`);

--
-- Filtros para la tabla `account_game`
--
ALTER TABLE `account_game`
  ADD CONSTRAINT `FK_ACCOUNT_CAN_PLAY_GAME` FOREIGN KEY (`ID_GAME`) REFERENCES `game` (`ID_GAME`),
  ADD CONSTRAINT `FK_ACCOUNT_CAN_PLAY_GAME2` FOREIGN KEY (`USERNAME`) REFERENCES `account` (`USERNAME`);

--
-- Filtros para la tabla `question`
--
ALTER TABLE `question`
  ADD CONSTRAINT `FK_GAME_HAS_QUESTION` FOREIGN KEY (`ID_GAME`) REFERENCES `game` (`ID_GAME`);

--
-- Filtros para la tabla `q_option`
--
ALTER TABLE `q_option`
  ADD CONSTRAINT `FK_IS` FOREIGN KEY (`ID_QUESTION`) REFERENCES `question` (`ID_QUESTION`);

--
-- Filtros para la tabla `q_scratch`
--
ALTER TABLE `q_scratch`
  ADD CONSTRAINT `FK_IS3` FOREIGN KEY (`ID_QUESTION`) REFERENCES `question` (`ID_QUESTION`);

--
-- Filtros para la tabla `q_true_false`
--
ALTER TABLE `q_true_false`
  ADD CONSTRAINT `FK_IS2` FOREIGN KEY (`ID_QUESTION`) REFERENCES `question` (`ID_QUESTION`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
