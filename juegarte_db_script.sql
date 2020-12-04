-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 02-12-2020 a las 01:29:20
-- Versión del servidor: 10.4.13-MariaDB
-- Versión de PHP: 7.4.7

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `CREATE_GAME_MODE` (IN `p_GM_name` VARCHAR(25), IN `p_instructions` VARCHAR(1000), IN `p_question_time_seconds` INT(3))  BEGIN
     INSERT INTO game (GAME_MODE_NAME, GAME_INSTRUCTIONS, QUESTION_TIME_S) 
     VALUES (p_GM_name, p_instructions, p_question_time_seconds);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GENERATE_SCRATCH_QUESTION` (IN `p_id_game` INT(3), IN `p_question_text` VARCHAR(100), IN `p_question_information` VARCHAR(100), IN `p_question_image` VARCHAR(50), IN `p_option_1` VARCHAR(25), IN `p_option_2` VARCHAR(25), IN `p_option_3` VARCHAR(25), IN `p_option_4` VARCHAR(25), IN `p_answer` VARCHAR(25))  BEGIN
DECLARE id_question INT;
DECLARE image VARCHAR(50);

	CALL INSERT_QUESTION(p_id_game, p_question_text, p_question_information, p_question_image);
    
    select LAST_INSERT_ID() INTO id_question;
    select QUESTION_IMAGE INTO image FROM question WHERE question.ID_QUESTION = id_question;
    
    CALL INSERT_SCRATCH_QUESTION (id_question, p_id_game, p_question_text, p_question_information, image, p_option_1, p_option_2, p_option_3, p_option_4, p_answer);
   
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `INSERT_QUESTION` (IN `p_id_game` INT(3), IN `p_question_text` VARCHAR(100), IN `p_question_information` VARCHAR(100), IN `p_question_image` VARCHAR(50))  BEGIN
     INSERT INTO question (ID_GAME, QUESTION_TEXT, QUESTION_INFORMATION, QUESTION_IMAGE) 
     VALUES (p_id_game, p_question_text, p_question_information, CONCAT("../uploads/", p_question_image));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `INSERT_SCRATCH_QUESTION` (IN `p_id_question` INT(3), IN `p_id_game` INT(3), IN `p_question_text` VARCHAR(100), IN `p_question_information` VARCHAR(100), IN `p_question_image` VARCHAR(50), IN `p_option_1` VARCHAR(25), IN `p_option_2` VARCHAR(25), IN `p_option_3` VARCHAR(25), IN `p_option_4` VARCHAR(25), IN `p_answer` VARCHAR(25))  BEGIN
     INSERT INTO q_scratch (ID_QUESTION, ID_GAME, QUESTION_TEXT, QUESTION_INFORMATION, QUESTION_IMAGE, T3_OPTION_Q_1, T3_OPTION_Q_2, T3_OPTION_Q_3, T3_OPTION_Q_4, T3_ANSWER) 
     VALUES (p_id_question, p_id_game, p_question_text, p_question_information, p_question_image, p_option_1, p_option_2, p_option_3, p_option_4, p_answer);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SELECT_GAME_MODES` ()  BEGIN
	SELECT * from game;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SELECT_SCRATCH_QUESTIONS` ()  BEGIN
	SELECT  QUESTION_TEXT, QUESTION_INFORMATION, QUESTION_IMAGE, T3_OPTION_Q_1, T3_OPTION_Q_2, T3_OPTION_Q_3, T3_OPTION_Q_4, T3_ANSWER  from q_scratch;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SELECT_TRIVIA_QUESTIONS` ()  BEGIN
	SELECT  QUESTION_TEXT, QUESTION_INFORMATION, QUESTION_IMAGE, T1_OPTION_Q_1, T1_OPTION_Q_2, T1_OPTION_Q_3, T1_OPTION_Q_4, T1_ANSWER  from q_option;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SELECT_TRUE_FALSE_QUESTION` ()  BEGIN
	SELECT  QUESTION_TEXT, QUESTION_INFORMATION, QUESTION_IMAGE, TF_ANSWER  from q_true_false;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SELECT_TRUE_FALSE_QUESTIONS` ()  BEGIN
	SELECT  QUESTION_TEXT, QUESTION_INFORMATION, QUESTION_IMAGE, TF_ANSWER  from q_true_false;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SELECT_USER_BY_USERNAME` (IN `p_username` VARCHAR(25))  BEGIN
    DECLARE userExists VARCHAR(25);

    
	SELECT COUNT(*) INTO userExists FROM ACCOUNT WHERE ACCOUNT.USERNAME = p_username;

    IF userExists = 1 THEN

	SELECT * FROM account WHERE username = p_username;

    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `VERIFY_USER_EXISTS_EMAIL` (IN `p_email` VARCHAR(50))  BEGIN


SELECT COUNT(*) FROM ACCOUNT WHERE ACCOUNT.EMAIL = p_email;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `VERIFY_USER_EXISTS_USERNAME` (IN `p_username` VARCHAR(25))  BEGIN
    
	SELECT COUNT(*) FROM ACCOUNT WHERE ACCOUNT.USERNAME = p_username;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `account`
--

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
('admin4', 'admin4@admin.com', '$2y$10$FdfQXMNMKwVRy2Im16w45e3yQRf3y19mDx3MHB3TaGsp8t04LJNJm', 0, '../uploads/Avatar.png'),
('admin5', 'admin5@admin.com', '$2y$10$./HoWu0.C8AY2aorp.Kn4..OVOGlK6Tl67XXMKGG0dF7QhFHVVbIK', 0, '../uploads/Avatar.png'),
('tester', 'tester@test.com', '$2y$10$uMoZmg4a6/pZBtAaIEvsiOh6X6LzggpQi1sQ2whA5GXFTOMCAv/7q', 0, '../uploads/Avatar.png');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `account_achievement`
--

CREATE TABLE `account_achievement` (
  `USERNAME` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `ID_ACHIEVEMENT` int(5) NOT NULL,
  `A_CURRENT_STEP` int(5) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `account_game`
--

CREATE TABLE `account_game` (
  `ID_ACCOUNT_GAME` int(5) NOT NULL,
  `ID_GAME` int(3) NOT NULL,
  `USERNAME` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `OBTAINED_POINTS` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `achievement`
--

CREATE TABLE `achievement` (
  `ID_ACHIEVEMENT` int(5) NOT NULL,
  `ACHIEVEMENT_TITLE` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `ACHIEVEMENT_DESCRIPTION` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `A_COMPLETED_STEP` int(5) NOT NULL,
  `ICON` varchar(50) COLLATE utf8_unicode_ci DEFAULT '../uploads/Achievement.png'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `achievement`
--

INSERT INTO `achievement` (`ID_ACHIEVEMENT`, `ACHIEVEMENT_TITLE`, `ACHIEVEMENT_DESCRIPTION`, `A_COMPLETED_STEP`, `ICON`) VALUES
(1, 'Play 10 Games', 'Play 10 games of any type', 10, '../uploads/Achievement.png'),
(2, '1000 Points', 'Obtain 1000 points playing any game', 1000, '../uploads/Achievement.png'),
(3, '100 Points', 'Obtain 100 points playing any game', 100, '../uploads/Achievement.png');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `game`
--

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
(1, 'Trivia Quiz', 'Contesta la pregunta con la respuesta correcta.', 30),
(2, 'Verdadero o Falso', 'Contesta la pregunta con la respuesta correcta.', 30),
(3, 'Raspaditas', 'Raspa el área para responder la pregunta solicitada.', 30);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `question`
--

CREATE TABLE `question` (
  `ID_QUESTION` int(3) NOT NULL,
  `ID_GAME` int(3) NOT NULL,
  `QUESTION_TEXT` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `QUESTION_INFORMATION` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `QUESTION_IMAGE` varchar(50) COLLATE utf8_unicode_ci DEFAULT '../uploads/no_image.png'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `question`
--

INSERT INTO `question` (`ID_QUESTION`, `ID_GAME`, `QUESTION_TEXT`, `QUESTION_INFORMATION`, `QUESTION_IMAGE`) VALUES
(1, 1, '¿Qué artista pintó “La joven de la perla”?', 'La joven de la perla (1667) es una obra de Johannes Vermeer. Se trata de un tronie, un género pictórico típico de la Holanda del siglo XVII que significa “rostro” o “expresión”. Es uno de los retratos más famosos de la historia del arte, pero todavía no se sabe quién fue la modelo.', '../uploads/1-LaJovenDeLaPerla.jpg'),
(2, 1, '¿Qué artista pintó “El hijo del hombre”?', 'El hijo del hombre (1964) es una pintura del pintor surrealista y belga René Magritte. Es sin duda, una de sus obras con más repercusión. En ella, el artista yuxtapone imágenes características de su obra: la manzana, la pared y el personaje anónimo con bombín.', '../uploads/2-ElHijoDelHombre.jpg'),
(3, 1, '¿En qué año Gustav Klimt pintó “El Beso”?', 'El pintor austríaco Gustav Klimt elaboró su cuadro más célebre en la llamada ‘época de oro’ (1898-1908) de su carrera profesional, exactamente en el año 1908. Las técnicas usadas son variadas, como la de los frescos y de los mosaicos. El cuadro mide 1,8 metros de alto por 1,8 metros de largo.', '../uploads/3-ElBeso.jpg'),
(4, 1, '¿Cuál artista aparece en la imagen?', 'Frida Khalo (1907-1954) fue una pintora mexicana. Creó una pintura absolutamente personal, ingenua y profundamente metafórica al mismo tiempo, derivada de su exaltada sensibilidad y de varios acontecimientos que marcaron su vida.', '../uploads/4-FridaKhalo.jpg'),
(5, 1, '¿Cuál artista aparece en la imagen?', 'Marcel Duchamp (1887–1968) fue un artista francés que se adelantó al arte conceptual, elevó el objeto cotidiano a categoría de arte y cambió radicalmente la idea de la belleza. Impresionista a los 16 años, fauvista a los 19 y cubista a los 24, terminaría encontrando su libertad en el dadaísmo.', '../uploads/5-MarcelDuchamp.jpg'),
(6, 1, '¿Qué artista esculpió la obra “David”?', 'La escultura David fue realizada por el artista florentino Miguel Ángel Buonarroti entre 1501 y 1504. El artista concentró su atención en el hombre y sus cualidades humanas, esta obra se convirtió en un símbolo del Renacimiento italiano.', '../uploads/6-David.png'),
(7, 1, '¿Con qué otro nombre se le conoce a la “Afrodita de Venus”?', 'La escultura Venus de Milo es una obra fechada en el período helenístico, aunque su estilo se corresponde con la estética predominante del período clásico griego. Fue descubierta en el año 1820 en la isla de Melos o Milo (según el griego moderno), de donde proviene su nombre.', '../uploads/7-VenusDeMilo.jpg'),
(8, 1, '¿Qué escultor realizó el “Éxtasis de Santa Teresa”?', 'Gian Lorenzo Bernini creó uno de los grupos escultóricos más espectaculares del barroco, este éxtasis de Santa Teresa muestra el momento en el que Santa Teresa de Ávila recibe el don místico de la transverberación. El artista no escatimó en intensidad dramática y fuerza dinámica.', '../uploads/8-ExtasisDeSantaTeresa.jpg'),
(9, 1, '¿A cuál época artística pertenece la obra “El nacimiento de Venus”?', 'El período del Renacimiento es para la pintura una auténtica revolución. Los pintores se separan gradualmente de la imagen religiosa para representar el mundo que les rodea. El cuadro El nacimiento de Venus de Sandro Botticelli fue pintado entre 1482 y 1485. Se trata del primer cuadro en tela pintad', '../uploads/9-Renacimiento.jpg'),
(10, 1, '¿A cuál época artística pertenece la obra “Las meninas”?', 'En el periodo Barroco el arte se volvió dinámico, teatral, efectista. Busca sorprender, asombrar. El cuadro Las meninas (1656) de Diego Velázquez retrata a la infanta Margarita, hija del rey Felipe IV, en el taller del pintor situado en el Palacio Real Alcázar de Madrid.', '../uploads/10-LasMeninas.jpg'),
(11, 1, '¿Con qué otro nombre se conoce a la famosa obra de Leonardo DaVinci “La Gioconda”?', 'Es una obra pictórica del genio renacentista italiano Leonardo da Vinci. Fue adquirida por el rey Francisco I de Francia a comienzos del siglo XVI y desde entonces es propiedad del Estado francés. Se halla expuesta en el Museo del Louvre de París, siendo, sin duda, la joya de sus colecciones.', '../uploads/11-LaGioconda.jpg'),
(12, 1, '¿Qué artista pintó la famosa obra expresionista “El Grito”?', 'Este cuadro fue expuesto por primera vez en 1893, formando parte de un conjunto de seis piezas titulado Amor. La idea de Munch era la de representar las distintas fases de un idilio, desde el enamoramiento inicial a una ruptura dramática. El grito representaba la última etapa, envuelta en angustia.', '../uploads/12-ElGrito.jpg'),
(13, 1, '¿A cuál época artística pertenece la obra “La Noche Estrellada”?', 'Sin duda una de las pinturas más reconocidas del artista holandés Vicent Van Gogh, él pintó La noche estrellada sobre el Ródano en 1888. Aunque fue pintada con pinceladas vibrantes y colores expresivos, la escena es tranquila; “dos coloridos amantes en primer plano” son las únicas personas presentes en la pintura, y el cielo lleno de estrellas evoca un sentimiento de serenidad.', '../uploads/13-LaNocheEstrellada.jpg'),
(14, 1, '¿Qué nombre recibe esta obra?', 'Se cree que la obra representa a Cecilia Gallerani, la amante de Ludovico Sforza, duque de Milán. La pintura es uno de los cuatro retratos de mujer pintados por Leonardo, siendo los otros tres La Gioconda, el retrato de Ginevra de\' Benci y el de la Belle Ferronière.', '../uploads/14-LaDamadelArmino.jpg'),
(15, 1, '¿A qué período artístico pertenece la obra “La Libertad guiando al pueblo”?', 'La Libertad guiando al pueblo o El 28 de julio es un cuadro del pintor Eugène Delacroix, máximo exponente del romanticismo francés. El cuadro representa la Revolución de Julio de 1830, ocurrida en París, contra las violaciones constitucionales perpetradas por Carlos X durante la Segunda Restauración.', '../uploads/15-LaLibertadguiandoalPueblo.jpg'),
(16, 2, 'Mirón esculpió la mítica obra “El Discóbolo”', 'Mirón fue un escultor y broncista de mediados del siglo V a. C.​ y uno de los más conocidos autores del arte griego,  nacido en Eléuteras, ​ ciudad situada en la frontera de Beocia y el Ática, cuyas aportaciones escultóricas supusieron la transición al periodo clásico.', '../uploads/16-ElDiscóbolodeMirón.jpg'),
(17, 2, '”Esto es una pipa” es el nombre que recibe esta controversial obra de René Magritte', 'El cuadro de René Magritte \"Esto no es una pipa\" (Traducido del título original en francés: \"Ceci n\'est pas une pipe\") trata, en primera instancia, la oposición entre una imagen y su leyenda. La obra muestra la imagen de una pipa acompañada de la frase “Esto no es una pipa”.', '../uploads/17-Estonoesunapipa.jpg'),
(18, 2, 'El artista Vincent van Gogh realizó a lo largo de su vida 43 autorretratos', 'Este pintor holandés, uno de los principales exponentes del postimpresionismo. Pintó unos 900 cuadros (entre ellos 43 autorretratos y 148 acuarelas) y realizó más de 1600 dibujos. Esta obra en específico tiene como título “Autorretrato con sombrero de fieltro gris” Fue realizada durante la estancia de Van Gogh en París durante el invierno de los años 1887 y 1888.', '../uploads/18-AutorretratoenSombrerodeFieltro.jpg'),
(19, 2, 'El genio artista Miguel Ángel tardo 8 años en terminar su magna obra “La Creación de Adán”', 'La creación de Adán es un fresco en la bóveda de la Capilla Sixtina, pintado por Miguel Ángel alrededor del año 1511. Ilustra uno de los nueve episodios del Génesis representados allí por el artista toscano, ​ en el cual Dios le da vida a Adán, el primer hombre. Miguel ángel tardó cuatro años en realizar esta obra, que despertó la admiración del público desde el primer día hasta la actualidad.', '../uploads/19-LaCreacióndeAdán.jpg'),
(20, 2, 'La Piedad es el nombre recibe esta famosa escultura', 'A finales de 1497, el cardenal Jean de Bilhères-Lagraulas, embajador de Francia en la Santa Sede, le pidió a Miguel Ángel que creara una Piedad a gran escala para su tumba. Al año siguiente, Miguel Ángel comenzó a trabajar en la escultura, que talló en un solo bloque de mármol de Carrara. Cuando la pieza fue completada en 1499, Miguel Ángel recibió muchos elogios y críticas positivas.', '../uploads/20-LaPiedad.jpg'),
(21, 2, 'La escultura “El Pensador” de Rodin pertenece al período artístico Barroco', 'El pensador es una de las esculturas más famosas de Auguste Rodin del periodo artístico Realismo. El escultor concibió esta pieza entre 1881 y 1882 para decorar el tímpano del conjunto escultórico La puerta del Infierno, encargado en 1880 por el Ministerio de Instrucción Pública y Bellas Artes de Francia.', '../uploads/21-ElPensador.jpg'),
(22, 2, 'El artista Leonardo DaVinci pintó esta mundialmente famosa obra', 'La última cena es una pintura mural original de Leonardo da Vinci ejecutada entre 1495 y 1498. Se encuentra en la pared sobre la que se pintó originalmente, en el refectorio del convento dominico de Santa Maria delle Grazie, en Milán (Italia), declarado Patrimonio de la Humanidad por la Unesco en 1980. Muchos expertos e historiadores del arte consideran La última cena como una de las mejores obras pictóricas del mundo.', '../uploads/22-LaÚltimaCena.jpg'),
(23, 2, 'Revolución Nocturna es el nombre que recibe esta famosa obra del período Barroco', 'La ronda de noche o La ronda nocturna es el nombre por el que se conoce comúnmente una de las más famosas obras maestras del pintor neerlandés Rembrandt, pintada entre 1640 y 1642. Este cuadro es una de las joyas de la exposición permanente del Rijksmuseum de Ámsterdam, una pinacoteca (Edificio destinado a la conservación y exposición de colecciones pictóricas). especializada en arte neerlandés.', '../uploads/23-LaRondadeNoche.jpg'),
(24, 2, 'El artista Katsushika Hokusai pintó la famosa obra “La Ola de Kanagawa”', 'La gran ola de Kanagawa​, también conocida simplemente como La ola o La gran ola, es una famosa estampa japonesa del pintor especialista en ukiyo-e, Katsushika Hokusai, publicada entre 1830 y 1833, ​ durante el período Edo de la historia de Japón.', '../uploads/24-LaGranOladeKanagawa.jpg'),
(25, 2, 'Esta famosa obra de Picasso pertenece al movimiento artístico Modernismo', 'Las Señoritas de Avignon es un cuadro del pintor español Pablo Picasso pintado en 1907 al óleo sobre lienzo y sus medidas son 243,9 x 233,7 cm. Se conserva en el Museo de Arte Moderno de Nueva York. Este cuadro, es la referencia clave para hablar del cubismo, del cual el artista español es el máximo exponente y creador del movimiento artístico.', '../uploads/25-LasSeñoritasdeAvignon.jpg'),
(26, 2, 'La artista Tarsila do Amaral pintó la obra “Abaporu”', 'Abaporu (1928) es el cuadro icónico del arte brasileño, pintado por Tarsila do Amaral, es una obra clave que inauguró uno de los movimientos artísticos más importantes en Latinoamérica: la antropofagia. El tamaño del cuerpo, en contraposición a la minúscula cabeza, expresa el trabajo físico en detrimento del mental.', '../uploads/26-Abaporu.jpg'),
(27, 2, 'La artista Tamara de Lempicka pintó “Joven con guantes” en el año 1990', 'Tamara de Lempicka fue una pintora polaca del siglo XX. Su obra se centra principalmente en retratos femeninos, y su pintura sigue una tendencia art decó, influenciándose de artistas como Botticelli o Bronzino, y de tendencias como el cubismo. Pintó “Joven con guantes” en el año 1930', '../uploads/27-JovenConGuantes.jpg'),
(28, 2, 'La artista Remedios Varo pintó la obra “La creación de las aves”', 'Remedios Varo, española de origen, pero exiliada en México, logró transportar con sus pinturas a un mundo onírico y mágico. En La creación de las aves (1957) combina altas dosis de surrealismo, simbolismo y fantasía de una manera peculiar: un extraño ser, a medio camino entre lechuza y humano, hace uso de la ciencia y la magia para crear diferentes aves.', '../uploads/28-LaCreacionDeLasAves.jpg'),
(29, 2, 'La obra “Los girasoles” de Vincent van Gogh se pintó con la técnica fresco', 'Los girasoles (1888) es una serie de cuadros al óleo realizados por el pintor neerlandés Vincent van Gogh. De la serie hay tres cuadros similares con catorce girasoles en un jarrón, dos con doce girasoles, uno con tres y otro con cinco. Van Gogh pintó los primeros cuatro cuadros en agosto de 1888, cuando vivía al sur de Francia.', '../uploads/29-LosGirasoles.jpg'),
(30, 2, 'Paul Gauguin pintó su obra “¿Cuándo te casas?” en la isla Tahití', '¿Cuándo te casas? Es un cuadro de Paul Gauguin hecho en 1892 durante su primera estancia en Tahití. Desde esta isla desarrolló la parte más distintiva de su producción, volcándose mayormente en paisajes y desnudos muy audaces para su época, por su rusticidad y colorido rotundo.', '../uploads/30-CuandoTeCasas.jpg'),
(31, 3, '¿Cuál es la obra oculta?', 'Las dos Fridas (1931) es una pintura de Frida Khalo. Parece haberse inspirado en el recuerdo de una amiga imaginaria que tuvo a los 6 años de edad, una especie de alter ego. En el cuadro representa sus dos herencias culturales: a la izquierda, la europea; a la derecha, la indígena.', '../uploads/31-LasDosFridas.jpg'),
(32, 3, '¿Cuál es la obra oculta?', 'Impresión, Sol naciente (1872) se trata del cuadro más famoso de Claude Monet pues es el que dio su nombre al movimiento impresionista. La pintura representa el puerto de El Havre, ciudad en la que el artista pasó gran parte de su infancia. Esta pintura al óleo sobre lienzo se encuentra actualmente expuesta en el Museo Marmottan Monet de París.', '../uploads/32-ImpresionSolNaciente.jpg'),
(33, 3, '¿Cuál es el artista oculto?', 'Diego Rivera (1886-1957)​ fue un destacado muralista mexicano de ideología comunista, famoso por plasmar obras de alto contenido político y social en edificios públicos. Formado en la Escuela de Bellas Artes de San Carlos de la capital mexicana, luego estudió por quince años en varios países de Europa.', '../uploads/33-DiegoRivera.jpg'),
(34, 3, '¿Cuál es la obra oculta?', 'Terraza de café por la noche (1888) es una pintura de Vincent van Gogh realizada en Arlés, representando el ambiente de una terraza. En esta pintura expresó sus nuevas impresiones de Francia meridional. Ésta es la primera pintura en la cual Vincent utilizó fondos estrellados.', '../uploads/34-TerrazaDeCafePorLaNoche.jpg'),
(35, 3, '¿Cuál es la obra oculta?', 'La bóveda de la Capilla Sixtina es una obra singular de Michelangelo Bonarotti quien realizó esta magna obra sin ser considerado propiamente un pintor. En los nueves recuadros centrales se muestra un programa iconográfico de las historias del Génesis, desde la creación, la caída del hombre, el diluvio y el renacer de la humanidad con el Arca de Noé.', '../uploads/35-CapillaSixtina.jpg'),
(36, 3, '¿Cuál es el artista oculto?', 'Salvador Dalí (1904-1989) fue un pintor, escultor y escritor español del siglo XX. Se le considera uno de los máximos representantes del surrealismo. Es conocido por sus impactantes y oníricas imágenes surrealistas. Sus habilidades pictóricas se suelen atribuir a la influencia y admiración por el arte renacentista. También fue un experto dibujante.', '../uploads/36-Dali.jpg'),
(37, 3, '¿Cuál es la obra oculta?', 'La Rueda de Bicicleta (1913) es el primer ready–made de Marcel Duchamp, toda una serie de objetos que creó para desafiar las suposiciones que constituyen una obra de arte. Combina dos piezas, una rueda de bicicleta y un taburete, esto cambió la experiencia del espectador y la óptica de lo que es el arte.', '../uploads/37-RuedaDeBicicleta.jpg'),
(38, 3, '¿Cuál es la obra oculta?', 'La Fontana di Trevi es una de las mayores (con 40 metros de frente) fuentes monumentales del Barroco en Italia. Los trabajos empezaron en 1732 y terminaron en 1762. Las estatuas de la Abundancia y de la Salubridad, en los dos nichos laterales fueron esculpidas por Filippo della Valle. La fuente es una obra escultórica de bulto redondo y a la vez relieve.', '../uploads/38-Fontana.jpg'),
(39, 3, '¿Cuál es el artista oculto?', 'Leonardo da Vinci (1452-1519), el gran artista del Renacimiento, fue también un genio científico. Aparte de su obra pictórica, tan exquisita como escasa, hubo un Leonardo dedicado a la experimentación. Conforma, junto con Miguel Ángel y Rafael, la tríada de los grandes maestros del Cinquecento.', '../uploads/39-DaVinci.jpg'),
(40, 3, '¿Cuál es la obra oculta?', 'Guernica (1937) es un famoso cuadro de Pablo Picasso, cuyo título alude al bombardeo de Guernica, ocurrido el 26 de abril de 1937, durante la guerra civil española. Fue un encargo del director general de Bellas Artes, Josep Renau, a petición del Gobierno de la Segunda República Española para ser expuesto en París, con el fin de atraer la atención del público hacia la causa republicana en plena guerra civil española.', '../uploads/40-Guernica.jpg');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `q_option`
--

CREATE TABLE `q_option` (
  `ID_QUESTION` int(3) NOT NULL,
  `ID_GAME` int(3) NOT NULL,
  `QUESTION_TEXT` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `QUESTION_INFORMATION` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `QUESTION_IMAGE` varchar(50) COLLATE utf8_unicode_ci DEFAULT '../uploads/no_image.png',
  `T1_OPTION_Q_1` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `T1_OPTION_Q_2` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `T1_OPTION_Q_3` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `T1_OPTION_Q_4` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `T1_ANSWER` varchar(25) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `q_option`
--

INSERT INTO `q_option` (`ID_QUESTION`, `ID_GAME`, `QUESTION_TEXT`, `QUESTION_INFORMATION`, `QUESTION_IMAGE`, `T1_OPTION_Q_1`, `T1_OPTION_Q_2`, `T1_OPTION_Q_3`, `T1_OPTION_Q_4`, `T1_ANSWER`) VALUES
(1, 1, '¿Qué artista pintó “La joven de la perla”?', 'La joven de la perla (1667) es una obra de Johannes Vermeer. Se trata de un tronie, un género pictórico típico de la Holanda del siglo XVII que significa “rostro” o “expresión”. Es uno de los retratos más famosos de la historia del arte, pero todavía no se sabe quién fue la modelo.', '../uploads/1-LaJovenDeLaPerla.jpg', 'Diego Velázquez', 'Johannes Vermeer', 'Caravaggio', 'Rembrandt', 'Johannes Vermeer'),
(2, 1, '¿Qué artista pintó “El hijo del hombre”?', 'El hijo del hombre (1964) es una pintura del pintor surrealista y belga René Magritte. Es sin duda, una de sus obras con más repercusión. En ella, el artista yuxtapone imágenes características de su obra: la manzana, la pared y el personaje anónimo con bombín.', '../uploads/2-ElHijoDelHombre.jpg', 'René Magritte', 'Salvador Dalí', 'Frida Khalo', 'Leonora Carrington', 'René Magritte'),
(3, 1, '¿En qué año Gustav Klimt pintó “El Beso”?', 'El pintor austríaco Gustav Klimt elaboró su cuadro más célebre en la llamada ‘época de oro’ (1898-1908) de su carrera profesional, exactamente en el año 1908. Las técnicas usadas son variadas, como la de los frescos y de los mosaicos. El cuadro mide 1,8 metros de alto por 1,8 metros de largo.', '../uploads/3-ElBeso.jpg', '1850', '1958', '1908', '1930', '1908'),
(4, 1, '¿Cuál artista aparece en la imagen?', 'Frida Khalo (1907-1954) fue una pintora mexicana. Creó una pintura absolutamente personal, ingenua y profundamente metafórica al mismo tiempo, derivada de su exaltada sensibilidad y de varios acontecimientos que marcaron su vida.', '../uploads/4-FridaKhalo.jpg', 'Cordelia Urueta', 'Frida Khalo', 'María Izquierdo', 'Tarsila do Amaral', 'Frida Khalo'),
(5, 1, ' ¿Cuál artista aparece en la imagen?', 'Marcel Duchamp (1887–1968) fue un artista francés que se adelantó al arte conceptual, elevó el objeto cotidiano a categoría de arte y cambió radicalmente la idea de la belleza. Impresionista a los 16 años, fauvista a los 19 y cubista a los 24, terminaría encontrando su libertad en el dadaísmo.', '../uploads/5-MarcelDuchamp.jpg', 'Pablo Picasso', 'Diego Rivera', 'Georges Braque', 'Marcel Duchamp', 'Marcel Duchamp'),
(6, 1, ' ¿Qué artista esculpió la obra “David”?', 'La escultura David fue realizada por el artista florentino Miguel Ángel Buonarroti entre 1501 y 1504. El artista concentró su atención en el hombre y sus cualidades humanas, esta obra se convirtió en un símbolo del Renacimiento italiano.', '../uploads/6-David.png', 'Donatello', 'Miguel Ángel', 'Lorenzo Ghiberti', 'Gianlorenzo Bernini', 'Miguel Ángel'),
(7, 1, '¿Con qué otro nombre se le conoce a la “Afrodita de Venus”?', 'La escultura Venus de Milo es una obra fechada en el período helenístico, aunque su estilo se corresponde con la estética predominante del período clásico griego. Fue descubierta en el año 1820 en la isla de Melos o Milo (según el griego moderno), de donde proviene su nombre.', '../uploads/7-VenusDeMilo.jpg', 'Reina de Venus', 'Diosa de Venus', 'Musa de Venus', 'Princesa de Venus', 'Musa de Venus'),
(8, 1, '¿Qué escultor realizó el “Éxtasis de Santa Teresa”?', 'Gian Lorenzo Bernini creó uno de los grupos escultóricos más espectaculares del barroco, este éxtasis de Santa Teresa muestra el momento en el que Santa Teresa de Ávila recibe el don místico de la transverberación. El artista no escatimó en intensidad dramática y fuerza dinámica.', '../uploads/8-ExtasisDeSantaTeresa.jpg', 'Gian Lorenzo Bernini', 'Pierre Puget', 'Alessandro Algardi', 'Andreas Schluter', 'Gian Lorenzo Bernini'),
(9, 1, '¿A cuál época artística pertenece la obra “El nacimiento de Venus”?', 'El período del Renacimiento es para la pintura una auténtica revolución. Los pintores se separan gradualmente de la imagen religiosa para representar el mundo que les rodea. El cuadro El nacimiento de Venus de Sandro Botticelli fue pintado entre 1482 y 1485. Se trata del primer cuadro en tela pintado en Tuscania, Italia.', '../uploads/9-Renacimiento.jpg', 'Edad Media', 'Renacimiento', 'Barroco', 'Moderna', 'Renacimiento'),
(10, 1, '¿A cuál época artística pertenece la obra “Las meninas”?', 'En el periodo Barroco el arte se volvió dinámico, teatral, efectista. Busca sorprender, asombrar. El cuadro Las meninas (1656) de Diego Velázquez retrata a la infanta Margarita, hija del rey Felipe IV, en el taller del pintor situado en el Palacio Real Alcázar de Madrid.', '../uploads/10-LasMeninas.jpg', 'Edad Media', 'Renacimiento', 'Barroco', 'Moderna', 'Barroco'),
(11, 1, '¿Con qué otro nombre se conoce a la famosa obra de Leonardo DaVinci “La Gioconda”?', 'Es una obra pictórica del genio renacentista italiano Leonardo da Vinci. Fue adquirida por el rey Francisco I de Francia a comienzos del siglo XVI y desde entonces es propiedad del Estado francés. Se halla expuesta en el Museo del Louvre de París, siendo, sin duda, la joya de sus colecciones.', '../uploads/11-LaGioconda.jpg', 'La mujer sin expresiones', 'La Mona Lisa', 'Retrato femenino', 'La Menina', 'La Mona Lisa'),
(12, 1, '¿Qué artista pintó la famosa obra expresionista “El Grito”?', 'Este cuadro fue expuesto por primera vez en 1893, formando parte de un conjunto de seis piezas titulado Amor. La idea de Munch era la de representar las distintas fases de un idilio, desde el enamoramiento inicial a una ruptura dramática. El grito representaba la última etapa, envuelta en angustia.', '../uploads/12-ElGrito.jpg', 'Edvard Munch', 'Marc Chagall', 'Vincent Van Gogh', 'Paul Klee', 'Edvard Munch'),
(13, 1, '¿A cuál época artística pertenece la obra “La Noche Estrellada”?', 'Sin duda una de las pinturas más reconocidas del artista holandés Vicent Van Gogh, él pintó La noche estrellada sobre el Ródano en 1888. Aunque fue pintada con pinceladas vibrantes y colores expresivos, la escena es tranquila; “dos coloridos amantes en primer plano” son las únicas personas presentes en la pintura, y el cielo lleno de estrellas evoca un sentimiento de serenidad.', '../uploads/13-LaNocheEstrellada.jpg', 'Arte moderno', 'Neoimpresionismo', 'Impresionismo', 'Posimpresionismo', 'Posimpresionismo'),
(14, 1, '¿Qué nombre recibe esta obra?', 'Se cree que la obra representa a Cecilia Gallerani, la amante de Ludovico Sforza, duque de Milán. La pintura es uno de los cuatro retratos de mujer pintados por Leonardo, siendo los otros tres La Gioconda, el retrato de Ginevra de\' Benci y el de la Belle Ferronière.', '../uploads/14-LaDamadelArmino.jpg', 'Armiño en brazos de una dama', 'Dama y armiño', 'La dama del armiño', 'Dama con armiño', 'Dama con armiño'),
(15, 1, '¿A qué período artístico pertenece la obra “La Libertad guiando al pueblo”?', 'La Libertad guiando al pueblo o El 28 de julio es un cuadro del pintor Eugène Delacroix, máximo exponente del romanticismo francés. El cuadro representa la Revolución de Julio de 1830, ocurrida en París, contra las violaciones constitucionales perpetradas por Carlos X durante la Segunda Restauración.', '../uploads/15-LaLibertadguiandoalPueblo.jpg', 'Barroco', 'Romanticismo', 'Renacimiento', 'Realismo', 'Romanticismo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `q_scratch`
--

CREATE TABLE `q_scratch` (
  `ID_QUESTION` int(3) NOT NULL,
  `ID_GAME` int(3) NOT NULL,
  `QUESTION_TEXT` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `QUESTION_INFORMATION` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `QUESTION_IMAGE` varchar(50) COLLATE utf8_unicode_ci DEFAULT '../uploads/no_image.png',
  `T3_OPTION_Q_1` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `T3_OPTION_Q_2` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `T3_OPTION_Q_3` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `T3_OPTION_Q_4` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `T3_ANSWER` varchar(50) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `q_scratch`
--

INSERT INTO `q_scratch` (`ID_QUESTION`, `ID_GAME`, `QUESTION_TEXT`, `QUESTION_INFORMATION`, `QUESTION_IMAGE`, `T3_OPTION_Q_1`, `T3_OPTION_Q_2`, `T3_OPTION_Q_3`, `T3_OPTION_Q_4`, `T3_ANSWER`) VALUES
(31, 3, '¿Cuál es la obra oculta?', 'Las dos Fridas (1931) es una pintura de Frida Khalo. Parece haberse inspirado en el recuerdo de una amiga imaginaria que tuvo a los 6 años de edad, una especie de alter ego. En el cuadro representa sus dos herencias culturales: a la izquierda, la europea; a la derecha, la indígena.', '../uploads/31-LasDosFridas.jpg', 'Alma gemela', 'El ciervo herido', 'Las dos Fridas', 'Hermanas', 'Las dos Fridas'),
(32, 3, '¿Cuál es la obra oculta?', 'Impresión, Sol naciente (1872) se trata del cuadro más famoso de Claude Monet pues es el que dio su nombre al movimiento impresionista. La pintura representa el puerto de El Havre, ciudad en la que el artista pasó gran parte de su infancia. Esta pintura al óleo sobre lienzo se encuentra actualmente expuesta en el Museo Marmottan Monet de París.', '../uploads/32-ImpresionSolNaciente.jpg', 'Impresión, Sol naciente', 'El estanque de Ninfeas', 'Crepúsculo en Venecia', 'La urraca', 'Impresión, Sol naciente'),
(33, 3, '¿Cuál es el artista oculto?', 'Diego Rivera (1886-1957)​ fue un destacado muralista mexicano de ideología comunista, famoso por plasmar obras de alto contenido político y social en edificios públicos. Formado en la Escuela de Bellas Artes de San Carlos de la capital mexicana, luego estudió por quince años en varios países de Europa.', '../uploads/33-DiegoRivera.jpg', 'Francisco Zúñiga', 'Diego Rivera', 'Rufino Tamayo', 'Gerardo Murillo', 'Diego Rivera'),
(34, 3, '¿Cuál es la obra oculta?', 'Terraza de café por la noche (1888) es una pintura de Vincent van Gogh realizada en Arlés, representando el ambiente de una terraza. En esta pintura expresó sus nuevas impresiones de Francia meridional. Ésta es la primera pintura en la cual Vincent utilizó fondos estrellados.', '../uploads/34-TerrazaDeCafePorLaNoche.jpg', 'El café de noche', 'Los olivos', 'Casas en Auvers', 'Terraza de café por la noche', 'Terraza de café por la noche'),
(35, 3, '¿Cuál es la obra oculta?', 'La bóveda de la Capilla Sixtina es una obra singular de Michelangelo Bonarotti quien realizó esta magna obra sin ser considerado propiamente un pintor. En los nueves recuadros centrales se muestra un programa iconográfico de las historias del Génesis, desde la creación, la caída del hombre, el diluvio y el renacer de la humanidad con el Arca de Noé.', '../uploads/35-CapillaSixtina.jpg', 'Capilla Sixtina', 'Santo Entierro', 'Crucifixión de San Pedro', 'Tondo Doni', 'Capilla Sixtina'),
(36, 3, '¿Cuál es el artista oculto?', 'Salvador Dalí (1904-1989) fue un pintor, escultor y escritor español del siglo XX. Se le considera uno de los máximos representantes del surrealismo. Es conocido por sus impactantes y oníricas imágenes surrealistas. Sus habilidades pictóricas se suelen atribuir a la influencia y admiración por el arte renacentista. También fue un experto dibujante.', '../uploads/36-Dali.jpg', 'Pablo Picasso', 'Diego Rivera', 'Vincent van Gogh', 'Salvador Dalí', 'Salvador Dalí'),
(37, 3, '¿Cuál es la obra oculta?', 'La Rueda de Bicicleta (1913) es el primer ready–made de Marcel Duchamp, toda una serie de objetos que creó para desafiar las suposiciones que constituyen una obra de arte. Combina dos piezas, una rueda de bicicleta y un taburete, esto cambió la experiencia del espectador y la óptica de lo que es el arte.', '../uploads/37-RuedaDeBicicleta.jpg', 'La fuente', 'Monociclo', 'Rueda de bicicleta', 'Viaje redondo', 'Rueda de bicicleta'),
(38, 3, '¿Cuál es la obra oculta?', 'La Fontana di Trevi es una de las mayores (con 40 metros de frente) fuentes monumentales del Barroco en Italia. Los trabajos empezaron en 1732 y terminaron en 1762. Las estatuas de la Abundancia y de la Salubridad, en los dos nichos laterales fueron esculpidas por Filippo della Valle. La fuente es una obra escultórica de bulto redondo y a la vez relieve.', '../uploads/38-Fontana.jpg', 'Fontana di Trevi', 'Fontana di Crema', 'Fontana di Piazza Colonna', 'Fontana di Nettuno', 'Fontana di Trevi'),
(39, 3, '¿Cuál es el artista oculto?', 'Leonardo da Vinci (1452-1519), el gran artista del Renacimiento, fue también un genio científico. Aparte de su obra pictórica, tan exquisita como escasa, hubo un Leonardo dedicado a la experimentación. Conforma, junto con Miguel Ángel y Rafael, la tríada de los grandes maestros del Cinquecento.', '../uploads/39-DaVinci.jpg', 'Miguel Ángel', 'Caravaggio', 'Donatello', 'Leonardo DaVinci', 'Leonardo DaVinci'),
(40, 3, '¿Cuál es la obra oculta?', 'Guernica (1937) es un famoso cuadro de Pablo Picasso, cuyo título alude al bombardeo de Guernica, ocurrido el 26 de abril de 1937, durante la guerra civil española. Fue un encargo del director general de Bellas Artes, Josep Renau, a petición del Gobierno de la Segunda República Española para ser expuesto en París, con el fin de atraer la atención del público hacia la causa republicana en plena guerra civil española.', '../uploads/40-Guernica.jpg', 'El sueño', 'Guernica', 'La tragedia', 'Picador', 'Guernica');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `q_true_false`
--

CREATE TABLE `q_true_false` (
  `ID_QUESTION` int(3) NOT NULL,
  `ID_GAME` int(3) NOT NULL,
  `QUESTION_TEXT` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `QUESTION_INFORMATION` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `QUESTION_IMAGE` varchar(50) COLLATE utf8_unicode_ci DEFAULT '../uploads/no_image.png',
  `TF_ANSWER` varchar(25) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `q_true_false`
--

INSERT INTO `q_true_false` (`ID_QUESTION`, `ID_GAME`, `QUESTION_TEXT`, `QUESTION_INFORMATION`, `QUESTION_IMAGE`, `TF_ANSWER`) VALUES
(16, 2, 'Mirón esculpió la mítica obra “El Discóbolo”', 'Mirón fue un escultor y broncista de mediados del siglo V a. C.​ y uno de los más conocidos autores del arte griego,  nacido en Eléuteras, ​ ciudad situada en la frontera de Beocia y el Ática, cuyas aportaciones escultóricas supusieron la transición al periodo clásico.', '../uploads/16-ElDiscóbolodeMirón.jpg', 'true'),
(17, 2, '”Esto es una pipa” es el nombre que recibe esta controversial obra de René Magritte', 'El cuadro de René Magritte \"Esto no es una pipa\" (Traducido del título original en francés: \"Ceci n\'est pas une pipe\") trata, en primera instancia, la oposición entre una imagen y su leyenda. La obra muestra la imagen de una pipa acompañada de la frase “Esto no es una pipa”.', '../uploads/17-Estonoesunapipa.jpg', 'false'),
(18, 2, 'El artista Vincent van Gogh realizó a lo largo de su vida 43 autorretratos', 'Este pintor holandés, uno de los principales exponentes del postimpresionismo. Pintó unos 900 cuadros (entre ellos 43 autorretratos y 148 acuarelas) y realizó más de 1600 dibujos. Esta obra en específico tiene como título “Autorretrato con sombrero de fieltro gris” Fue realizada durante la estancia de Van Gogh en París durante el invierno de los años 1887 y 1888.', '../uploads/18-AutorretratoenSombrerodeFieltro.jpg', 'true'),
(19, 2, 'El genio artista Miguel Ángel tardo 8 años en terminar su magna obra “La Creación de Adán”', 'La creación de Adán es un fresco en la bóveda de la Capilla Sixtina, pintado por Miguel Ángel alrededor del año 1511. Ilustra uno de los nueve episodios del Génesis representados allí por el artista toscano, ​ en el cual Dios le da vida a Adán, el primer hombre. Miguel ángel tardó cuatro años en realizar esta obra, que despertó la admiración del público desde el primer día hasta la actualidad.', '../uploads/19-LaCreacióndeAdán.jpg', 'false'),
(20, 2, 'La Piedad es el nombre recibe esta famosa escultura', 'A finales de 1497, el cardenal Jean de Bilhères-Lagraulas, embajador de Francia en la Santa Sede, le pidió a Miguel Ángel que creara una Piedad a gran escala para su tumba. Al año siguiente, Miguel Ángel comenzó a trabajar en la escultura, que talló en un solo bloque de mármol de Carrara. Cuando la pieza fue completada en 1499, Miguel Ángel recibió muchos elogios y críticas positivas.', '../uploads/20-LaPiedad.jpg', 'true'),
(21, 2, ' La escultura “El Pensador” de Rodin pertenece al período artístico Barroco', 'El pensador es una de las esculturas más famosas de Auguste Rodin del periodo artístico Realismo. El escultor concibió esta pieza entre 1881 y 1882 para decorar el tímpano del conjunto escultórico La puerta del Infierno, encargado en 1880 por el Ministerio de Instrucción Pública y Bellas Artes de Francia.', '../uploads/no_image.png', 'false'),
(22, 2, 'El artista Leonardo DaVinci pintó esta mundialmente famosa obra', 'La última cena es una pintura mural original de Leonardo da Vinci ejecutada entre 1495 y 1498. Se encuentra en la pared sobre la que se pintó originalmente, en el refectorio del convento dominico de Santa Maria delle Grazie, en Milán (Italia), declarado Patrimonio de la Humanidad por la Unesco en 1980. Muchos expertos e historiadores del arte consideran La última cena como una de las mejores obras pictóricas del mundo.', '../uploads/22-LaÚltimaCena.jpg', 'true'),
(23, 2, 'Revolución Nocturna es el nombre que recibe esta famosa obra del período Barroco', 'La ronda de noche o La ronda nocturna es el nombre por el que se conoce comúnmente una de las más famosas obras maestras del pintor neerlandés Rembrandt, pintada entre 1640 y 1642. Este cuadro es una de las joyas de la exposición permanente del Rijksmuseum de Ámsterdam, una pinacoteca (Edificio destinado a la conservación y exposición de colecciones pictóricas). especializada en arte neerlandés.', '../uploads/23-LaRondadeNoche.jpg', 'false'),
(24, 2, 'El artista Katsushika Hokusai pintó la famosa obra “La Ola de Kanagawa”', 'La gran ola de Kanagawa​, también conocida simplemente como La ola o La gran ola, es una famosa estampa japonesa del pintor especialista en ukiyo-e, Katsushika Hokusai, publicada entre 1830 y 1833, ​ durante el período Edo de la historia de Japón.', '../uploads/24-LaGranOladeKanagawa.jpg', 'true'),
(25, 2, 'Esta famosa obra de Picasso pertenece al movimiento artístico Modernismo', 'Las Señoritas de Avignon es un cuadro del pintor español Pablo Picasso pintado en 1907 al óleo sobre lienzo y sus medidas son 243,9 x 233,7 cm. Se conserva en el Museo de Arte Moderno de Nueva York. Este cuadro, es la referencia clave para hablar del cubismo, del cual el artista español es el máximo exponente y creador del movimiento artístico.', '../uploads/25-LasSeñoritasdeAvignon.jpg', 'false'),
(26, 2, 'La artista Tarsila do Amaral pintó la obra “Abaporu”', 'La artista Tarsila do Amaral pintó la obra “Abaporu”', '../uploads/26-Abaporu.jpg', 'true'),
(27, 2, 'La artista Tamara de Lempicka pintó “Joven con guantes” en el año 1990', 'Tamara de Lempicka fue una pintora polaca del siglo XX. Su obra se centra principalmente en retratos femeninos, y su pintura sigue una tendencia art decó, influenciándose de artistas como Botticelli o Bronzino, y de tendencias como el cubismo. Pintó “Joven con guantes” en el año 1930', '../uploads/27-JovenConGuantes.jpg', 'false'),
(28, 2, 'La artista Remedios Varo pintó la obra “La creación de las aves”', 'Remedios Varo, española de origen, pero exiliada en México, logró transportar con sus pinturas a un mundo onírico y mágico. En La creación de las aves (1957) combina altas dosis de surrealismo, simbolismo y fantasía de una manera peculiar: un extraño ser, a medio camino entre lechuza y humano, hace uso de la ciencia y la magia para crear diferentes aves.', '../uploads/28-LaCreacionDeLasAves.jpg', 'true'),
(29, 2, 'La obra “Los girasoles” de Vincent van Gogh se pintó con la técnica fresco', 'Los girasoles (1888) es una serie de cuadros al óleo realizados por el pintor neerlandés Vincent van Gogh. De la serie hay tres cuadros similares con catorce girasoles en un jarrón, dos con doce girasoles, uno con tres y otro con cinco. Van Gogh pintó los primeros cuatro cuadros en agosto de 1888, cuando vivía al sur de Francia.', '../uploads/29-LosGirasoles.jpg', 'false'),
(30, 2, 'Paul Gauguin pintó su obra “¿Cuándo te casas?” en la isla Tahití', '¿Cuándo te casas? Es un cuadro de Paul Gauguin hecho en 1892 durante su primera estancia en Tahití. Desde esta isla desarrolló la parte más distintiva de su producción, volcándose mayormente en paisajes y desnudos muy audaces para su época, por su rusticidad y colorido rotundo.', '../uploads/30-CuandoTeCasas.jpg', 'true');

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
  ADD PRIMARY KEY (`ID_ACCOUNT_GAME`),
  ADD KEY `FK_ACCOUNT_CAN_PLAY_GAME` (`ID_GAME`),
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
-- AUTO_INCREMENT de la tabla `account_game`
--
ALTER TABLE `account_game`
  MODIFY `ID_ACCOUNT_GAME` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `achievement`
--
ALTER TABLE `achievement`
  MODIFY `ID_ACHIEVEMENT` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `game`
--
ALTER TABLE `game`
  MODIFY `ID_GAME` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `question`
--
ALTER TABLE `question`
  MODIFY `ID_QUESTION` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

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
