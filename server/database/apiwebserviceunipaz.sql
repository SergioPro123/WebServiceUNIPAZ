-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 28-06-2021 a las 01:33:40
-- Versión del servidor: 10.4.18-MariaDB
-- Versión de PHP: 7.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `apiwebserviceunipaz`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddBanco` (IN `nombre_barrio_VARIABLE` VARCHAR(50), IN `nombre_banco` VARCHAR(50), IN `direccion_VARIABLE` VARCHAR(50), IN `telefono_VARIABLE` VARCHAR(10), IN `sitio_web_VARIABLE` VARCHAR(100))  BEGIN
	CALL getIdBarrioByNombreBarrio(nombre_barrio_VARIABLE,@id_barrio);
	INSERT INTO banco
    	(banco.id_barrio,banco.nombre,
        banco.direccion,banco.telefono,banco.sitio_web)
        VALUES(@id_barrio,nombre_banco,direccion_VARIABLE,telefono_VARIABLE,sitio_web_VARIABLE);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddBarrio` (IN `nombre_barrio_VARIABLE` VARCHAR(50), IN `numero_habitantes_VARIABLE` INT(11), IN `numero_comuna_VARIABLE` INT(3))  BEGIN
	CALL 
    GetOrAddHabitantes(numero_habitantes_VARIABLE,@id_habitantes);
    CALL 
    GetIdComunaByNumeroComuna(numero_comuna_VARIABLE,@id_comuna);
	INSERT INTO
    	barrio
        	(barrio.nombre,barrio.id_habitantes,barrio.id_comuna)		VALUES(nombre_barrio_VARIABLE,@id_habitantes,@id_comuna);
        
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddColegio` (IN `nombre_barrio_VARIABLE` VARCHAR(50), IN `nombre_colegio_VARIABLE` VARCHAR(50), IN `direccion_VARIABLE` VARCHAR(50), IN `telefono_VARIABLE` VARCHAR(10), IN `sitio_web_VARIABLE` VARCHAR(100), IN `sector_VARIABLE` VARCHAR(7), IN `modalidad_VARIABLE` VARCHAR(30))  BEGIN

	CALL getIdPublicoPrivado(sector_VARIABLE,@id_publico_privado);
    CALL getIdBarrioByNombreBarrio(nombre_barrio_VARIABLE,@id_barrio);
	CALL getIdModalidad(modalidad_VARIABLE,@id_modalidad);
    INSERT INTO colegio
    	(colegio.id_barrio,colegio.nombre,
        colegio.direccion,colegio.telefono,
         colegio.sitio_web,colegio.id_publico_privado,
        colegio.id_modalidad)
        VALUES(@id_barrio,nombre_colegio_VARIABLE,direccion_VARIABLE,
               telefono_VARIABLE,sitio_web_VARIABLE,@id_publico_privado,@id_modalidad);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddComuna` (IN `numero_comuna_VARIABLE` INT(3), IN `estrato_comuna_VARIABLE` INT(1), IN `numero_habitantes_VARIABLE` INT(11))  BEGIN
	CALL 
    GetOrAddHabitantes(numero_habitantes_VARIABLE,@id_habitantes);
	INSERT INTO comuna
    	(comuna.estrato,comuna.n_comuna,comuna.id_habitantes)
    VALUES(estrato_comuna_VARIABLE,numero_comuna_VARIABLE,@id_habitantes);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddHospital` (IN `nombre_barrio_VARIABLE` VARCHAR(50), IN `nombre_hospital_VARIABLE` VARCHAR(50), IN `direccion_VARIABLE` VARCHAR(50), IN `telefono_VARIABLE` VARCHAR(10), IN `sitio_web_VARIABLE` VARCHAR(100))  BEGIN
	CALL getIdBarrioByNombreBarrio(nombre_barrio_VARIABLE,@id_barrio);
	INSERT INTO hospital
    	(hospital.id_barrio,hospital.nombre,
        hospital.direccion,hospital.telefono,hospital.sitio_web)
        VALUES(@id_barrio,nombre_hospital_VARIABLE,direccion_VARIABLE,telefono_VARIABLE,sitio_web_VARIABLE);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddMensajeria` (IN `nombre_barrio_VARIABLE` VARCHAR(50), IN `nombre_mensajeria` VARCHAR(50), IN `direccion_VARIABLE` VARCHAR(50), IN `telefono_VARIABLE` VARCHAR(10), IN `sitio_web_VARIABLE` VARCHAR(100))  BEGIN
	CALL getIdBarrioByNombreBarrio(nombre_barrio_VARIABLE,@id_barrio);
	INSERT INTO mensajeria
    	(mensajeria.id_barrio,mensajeria.nombre,
        mensajeria.direccion,mensajeria.telefono,mensajeria.sitio_web)
        VALUES(@id_barrio,nombre_mensajeria,direccion_VARIABLE,telefono_VARIABLE,sitio_web_VARIABLE);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddUniversidad` (IN `nombre_barrio_VARIABLE` VARCHAR(50), IN `nombre_universidad_VARIABLE` VARCHAR(50), IN `direccion_VARIABLE` VARCHAR(50), IN `telefono_VARIABLE` VARCHAR(10), IN `sitio_web_VARIABLE` VARCHAR(100), IN `sector_VARIABLE` VARCHAR(7))  BEGIN

	CALL getIdPublicoPrivado(sector_VARIABLE,@id_publico_privado);
    CALL getIdBarrioByNombreBarrio(nombre_barrio_VARIABLE,@id_barrio);
	INSERT INTO universidad
    	(universidad.id_barrio,universidad.nombre,
        universidad.direccion,universidad.telefono,
         universidad.sitio_web,universidad.id_publico_privado)
        VALUES(@id_barrio,nombre_universidad_VARIABLE,direccion_VARIABLE,
               telefono_VARIABLE,sitio_web_VARIABLE,@id_publico_privado);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getBancoByBarrio` (IN `nombre_barrio_VARIABLE` VARCHAR(50))  BEGIN
	SELECT banco.nombre nombre_banco,
    	   comuna.n_comuna as numero_comuna,
           comuna.estrato,
           myBarrio.nombre as nombre_barrio,
           habitantes.cantidad_habitantes
           	as cantidad_habitantes_barrio,
           banco.direccion,
           banco.telefono,
           banco.sitio_web
    FROM banco
    INNER JOIN barrio as myBarrio
    	on banco.id_barrio
        	= myBarrio.id_barrio
    INNER JOIN comuna
    	ON myBarrio.id_comuna
        	= comuna.id_comuna
    INNER JOIN habitantes
    	ON myBarrio.id_habitantes
        	= habitantes.id_habitantes
     WHERE myBarrio.nombre = nombre_barrio_VARIABLE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getBancoByNumeroComuna` (IN `numero_comuna_VARIABLE` INT(3))  BEGIN
	SELECT banco.nombre nombre_banco,
    	   comuna.n_comuna as numero_comuna,
           comuna.estrato,
           myBarrio.nombre as nombre_barrio,
           habitantes.cantidad_habitantes
           	as cantidad_habitantes_barrio,
           banco.direccion,
           banco.telefono,
           banco.sitio_web
    FROM banco
    INNER JOIN barrio as myBarrio
    	on banco.id_barrio
        	= myBarrio.id_barrio
    INNER JOIN comuna
    	ON myBarrio.id_comuna
        	= comuna.id_comuna
    INNER JOIN habitantes
    	ON myBarrio.id_habitantes
        	= habitantes.id_habitantes
     WHERE comuna.n_comuna = numero_comuna_VARIABLE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getBancos` ()  BEGIN
	SELECT banco.nombre nombre_banco,
    	   comuna.n_comuna as numero_comuna,
           comuna.estrato,
           myBarrio.nombre as nombre_barrio,
           habitantes.cantidad_habitantes
           	as cantidad_habitantes_barrio,
           banco.direccion,
           banco.telefono,
           banco.sitio_web
    FROM banco
    INNER JOIN barrio as myBarrio
    	on banco.id_barrio
        	= myBarrio.id_barrio
    INNER JOIN comuna
    	ON myBarrio.id_comuna
        	= comuna.id_comuna
    INNER JOIN habitantes
    	ON myBarrio.id_habitantes
        	= habitantes.id_habitantes;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getBarrios` ()  BEGIN
       SELECT  
       	barrio.nombre as nombre_barrio,
        comuna.n_comuna,
        habitantes.cantidad_habitantes AS numero_habitantes
    FROM barrio
    INNER JOIN habitantes	
        ON barrio.id_habitantes = habitantes.id_habitantes
    INNER JOIN comuna
    	ON barrio.id_comuna = comuna.id_comuna;
 

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getBarriosByNumeroComuna` (IN `numero_comuna_VARIABLE` INT(2))  BEGIN
       SELECT  
       	barrio.nombre as nombre_barrio,
        comuna.n_comuna,
        habitantes.cantidad_habitantes AS numero_habitantes
    FROM barrio
    INNER JOIN habitantes	
        ON barrio.id_habitantes = habitantes.id_habitantes
    INNER JOIN comuna
    	ON barrio.id_comuna = comuna.id_comuna
    WHERE comuna.n_comuna = numero_comuna_VARIABLE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getColegioByBarrio` (IN `nombre_barrio_VARIABLE` VARCHAR(50))  BEGIN
	SELECT colegio.nombre nombre_colegio,
    	   comuna.n_comuna as numero_comuna,
           comuna.estrato,
           myBarrio.nombre as nombre_barrio,
           habitantes.cantidad_habitantes
           	as cantidad_habitantes_barrio,
           colegio.direccion,
           colegio.telefono,
           colegio.sitio_web,
           publico_privado.tipo as sector,
           modalidad.tipo as modalidad
    FROM colegio
    INNER JOIN barrio as myBarrio
    	on colegio.id_barrio
        	= myBarrio.id_barrio
    INNER JOIN publico_privado
    	ON colegio.id_publico_privado
        	= publico_privado.id_publico_privado
    INNER JOIN modalidad
    	ON colegio.id_modalidad = modalidad.id_modalidad     
    INNER JOIN comuna
    	ON myBarrio.id_comuna
        	= comuna.id_comuna
    INNER JOIN habitantes
    	ON myBarrio.id_habitantes
        	= habitantes.id_habitantes
    WHERE
    	myBarrio.nombre = nombre_barrio_VARIABLE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getColegioByNumeroComuna` (IN `numero_comuna_VARIABLE` INT(3))  BEGIN
	SELECT colegio.nombre nombre_colegio,
    	   comuna.n_comuna as numero_comuna,
           comuna.estrato,
           myBarrio.nombre as nombre_barrio,
           habitantes.cantidad_habitantes
           	as cantidad_habitantes_barrio,
           colegio.direccion,
           colegio.telefono,
           colegio.sitio_web,
           publico_privado.tipo as sector,
           modalidad.tipo as modalidad
    FROM colegio
    INNER JOIN barrio as myBarrio
    	on colegio.id_barrio
        	= myBarrio.id_barrio
    INNER JOIN publico_privado
    	ON colegio.id_publico_privado
        	= publico_privado.id_publico_privado
    INNER JOIN modalidad
    	ON colegio.id_modalidad = modalidad.id_modalidad     
    INNER JOIN comuna
    	ON myBarrio.id_comuna
        	= comuna.id_comuna
    INNER JOIN habitantes
    	ON myBarrio.id_habitantes
        	= habitantes.id_habitantes
    WHERE
    	comuna.n_comuna = numero_comuna_VARIABLE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getColegios` ()  BEGIN
	SELECT colegio.nombre nombre_colegio,
    	   comuna.n_comuna as numero_comuna,
           comuna.estrato,
           myBarrio.nombre as nombre_barrio,
           habitantes.cantidad_habitantes
           	as cantidad_habitantes_barrio,
           colegio.direccion,
           colegio.telefono,
           colegio.sitio_web,
           publico_privado.tipo as sector,
           modalidad.tipo as modalidad
    FROM colegio
    INNER JOIN barrio as myBarrio
    	on colegio.id_barrio
        	= myBarrio.id_barrio
    INNER JOIN publico_privado
    	ON colegio.id_publico_privado
        	= publico_privado.id_publico_privado
    INNER JOIN modalidad
    	ON colegio.id_modalidad = modalidad.id_modalidad
    INNER JOIN comuna
    	ON myBarrio.id_comuna
        	= comuna.id_comuna
    INNER JOIN habitantes
    	ON myBarrio.id_habitantes
        	= habitantes.id_habitantes;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getComunas` ()  BEGIN
    SELECT comuna.n_comuna,
    	   comuna.estrato,
    	   habitantes.cantidad_habitantes AS numero_habitantes
    FROM comuna
    INNER JOIN habitantes
    ON comuna.id_habitantes
    	= habitantes.id_habitantes;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getComunasByNumeroComuna` (IN `numero_comuna_VARIABLE` INT(3))  BEGIN
    SELECT comuna.n_comuna,
    	   comuna.estrato,
    	   habitantes.cantidad_habitantes AS numero_habitantes
    FROM comuna
    INNER JOIN habitantes
    ON comuna.id_habitantes
    	= habitantes.id_habitantes
    WHERE
    	comuna.n_comuna = numero_comuna_VARIABLE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getHospitalByBarrio` (IN `nombre_barrio_VARIABLE` VARCHAR(50))  BEGIN
	SELECT hospital.nombre nombre_hospital,
    	   comuna.n_comuna as numero_comuna,
           comuna.estrato,
           myBarrio.nombre as nombre_barrio,
           habitantes.cantidad_habitantes
           	as cantidad_habitantes_barrio,
           hospital.direccion,
           hospital.telefono,
           hospital.sitio_web
    FROM hospital
    INNER JOIN barrio as myBarrio
    	on hospital.id_barrio
        	= myBarrio.id_barrio
    INNER JOIN comuna
    	ON myBarrio.id_comuna
        	= comuna.id_comuna
    INNER JOIN habitantes
    	ON myBarrio.id_habitantes
        	= habitantes.id_habitantes
     WHERE myBarrio.nombre = nombre_barrio_VARIABLE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getHospitalByNumeroComuna` (IN `numero_comuna_VARIABLE` INT(3))  BEGIN
	SELECT hospital.nombre nombre_hospital,
    	   comuna.n_comuna as numero_comuna,
           comuna.estrato,
           myBarrio.nombre as nombre_barrio,
           habitantes.cantidad_habitantes
           	as cantidad_habitantes_barrio,
           hospital.direccion,
           hospital.telefono,
           hospital.sitio_web
    FROM hospital
    INNER JOIN barrio as myBarrio
    	on hospital.id_barrio
        	= myBarrio.id_barrio
    INNER JOIN comuna
    	ON myBarrio.id_comuna
        	= comuna.id_comuna
    INNER JOIN habitantes
    	ON myBarrio.id_habitantes
        	= habitantes.id_habitantes
     WHERE comuna.n_comuna = numero_comuna_VARIABLE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getHospitales` ()  BEGIN
	SELECT hospital.nombre nombre_hospital,
    	   comuna.n_comuna as numero_comuna,
           comuna.estrato,
           myBarrio.nombre as nombre_barrio,
           habitantes.cantidad_habitantes
           	as cantidad_habitantes_barrio,
           hospital.direccion,
           hospital.telefono,
           hospital.sitio_web
    FROM hospital
    INNER JOIN barrio as myBarrio
    	on hospital.id_barrio
        	= myBarrio.id_barrio
    INNER JOIN comuna
    	ON myBarrio.id_comuna
        	= comuna.id_comuna
    INNER JOIN habitantes
    	ON myBarrio.id_habitantes
        	= habitantes.id_habitantes;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getIdBarrioByNombreBarrio` (IN `nombre_barrio_VARIABLE` VARCHAR(50), OUT `id_barrio_OUT` INT(11))  BEGIN
    SELECT barrio.id_barrio
    INTO id_barrio_OUT
    FROM barrio
    WHERE
    	barrio.nombre = nombre_barrio_VARIABLE
    LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetIdComunaByNumeroComuna` (IN `numero_comuna_VARIABLE` INT(3), OUT `id_comuna_OUT` INT(3))  BEGIN
    SELECT comuna.id_comuna
    INTO id_comuna_OUT
    FROM comuna
    INNER JOIN habitantes
    ON comuna.id_habitantes
    	= habitantes.id_habitantes
    WHERE
    	comuna.n_comuna = numero_comuna_VARIABLE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getIdModalidad` (IN `modadlidad_VARIABLE` VARCHAR(30), OUT `id_modalidad_OUT` INT(1))  BEGIN

	SELECT  modalidad.id_modalidad
    INTO id_modalidad_OUT
    FROM modalidad
    WHERE modalidad.tipo = modadlidad_VARIABLE;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getIdPublicoPrivado` (IN `sector_VARIABLE` VARCHAR(7), OUT `id_publico_privado_OUT` INT)  BEGIN

	SELECT publico_privado.id_publico_privado
    INTO id_publico_privado_OUT
    FROM publico_privado
    WHERE publico_privado.tipo = sector_VARIABLE;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getMensajeriaByBarrio` (IN `nombre_barrio_VARIABLE` VARCHAR(50))  BEGIN
	SELECT mensajeria.nombre nombre_mensajeria,
    	   comuna.n_comuna as numero_comuna,
           comuna.estrato,
           myBarrio.nombre as nombre_barrio,
           habitantes.cantidad_habitantes
           	as cantidad_habitantes_barrio,
           mensajeria.direccion,
           mensajeria.telefono,
           mensajeria.sitio_web
    FROM mensajeria
    INNER JOIN barrio as myBarrio
    	on mensajeria.id_barrio
        	= myBarrio.id_barrio
    INNER JOIN comuna
    	ON myBarrio.id_comuna
        	= comuna.id_comuna
    INNER JOIN habitantes
    	ON myBarrio.id_habitantes
        	= habitantes.id_habitantes
     WHERE myBarrio.nombre = nombre_barrio_VARIABLE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getMensajeriaByNumeroComuna` (IN `numero_comuna_VARIABLE` INT(3))  BEGIN
	SELECT mensajeria.nombre nombre_mensajeria,
    	   comuna.n_comuna as numero_comuna,
           comuna.estrato,
           myBarrio.nombre as nombre_barrio,
           habitantes.cantidad_habitantes
           	as cantidad_habitantes_barrio,
           mensajeria.direccion,
           mensajeria.telefono,
           mensajeria.sitio_web
    FROM mensajeria
    INNER JOIN barrio as myBarrio
    	on mensajeria.id_barrio
        	= myBarrio.id_barrio
    INNER JOIN comuna
    	ON myBarrio.id_comuna
        	= comuna.id_comuna
    INNER JOIN habitantes
    	ON myBarrio.id_habitantes
        	= habitantes.id_habitantes
     WHERE comuna.n_comuna = numero_comuna_VARIABLE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getMensajerias` ()  BEGIN
	SELECT mensajeria.nombre nombre_mensajeria,
    	   comuna.n_comuna as numero_comuna,
           comuna.estrato,
           myBarrio.nombre as nombre_barrio,
           habitantes.cantidad_habitantes
           	as cantidad_habitantes_barrio,
           mensajeria.direccion,
           mensajeria.telefono,
           mensajeria.sitio_web
    FROM mensajeria
    INNER JOIN barrio as myBarrio
    	on mensajeria.id_barrio
        	= myBarrio.id_barrio
    INNER JOIN comuna
    	ON myBarrio.id_comuna
        	= comuna.id_comuna
    INNER JOIN habitantes
    	ON myBarrio.id_habitantes
        	= habitantes.id_habitantes;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrAddHabitantes` (IN `numero_habitantesVariable` INT(11), OUT `id_habitantes_OUT` INT(11))  BEGIN
	DECLARE existeHabitantes INT;
    SELECT  COUNT(habitantes.id_habitantes) 
    	INTO existeHabitantes 
    FROM habitantes 
    WHERE habitantes.cantidad_habitantes = numero_habitantesVariable; 
    
    IF existeHabitantes > 0 THEN
    	SELECT habitantes.id_habitantes INTO id_habitantes_OUT 
        FROM habitantes 
    	WHERE habitantes.cantidad_habitantes = numero_habitantesVariable
        LIMIT 1; 
    ELSE
    	INSERT INTO 
            habitantes(habitantes.cantidad_habitantes)
            VALUES(numero_habitantesVariable);
        SELECT LAST_INSERT_ID() into id_habitantes_OUT;
    END IF;    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getUniversidadByBarrio` (IN `nombre_barrio_VARIABLE` VARCHAR(50))  BEGIN
	SELECT universidad.nombre nombre_universidad,
    	   comuna.n_comuna as numero_comuna,
           comuna.estrato,
           myBarrio.nombre as nombre_barrio,
           habitantes.cantidad_habitantes
           	as cantidad_habitantes_barrio,
           universidad.direccion,
           universidad.telefono,
           universidad.sitio_web,
           publico_privado.tipo as sector
    FROM universidad
    INNER JOIN barrio as myBarrio
    	on universidad.id_barrio
        	= myBarrio.id_barrio
    INNER JOIN publico_privado
    	ON universidad.id_publico_privado
        	= publico_privado.id_publico_privado
    INNER JOIN comuna
    	ON myBarrio.id_comuna
        	= comuna.id_comuna
    INNER JOIN habitantes
    	ON myBarrio.id_habitantes
        	= habitantes.id_habitantes
    WHERE
    	myBarrio.nombre = nombre_barrio_VARIABLE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getUniversidadByNumeroComuna` (IN `numero_comuna_VARIABLE` INT(3))  BEGIN
	SELECT universidad.nombre nombre_universidad,
    	   comuna.n_comuna as numero_comuna,
           comuna.estrato,
           myBarrio.nombre as nombre_barrio,
           habitantes.cantidad_habitantes
           	as cantidad_habitantes_barrio,
           universidad.direccion,
           universidad.telefono,
           universidad.sitio_web,
           publico_privado.tipo as sector
    FROM universidad
    INNER JOIN barrio as myBarrio
    	on universidad.id_barrio
        	= myBarrio.id_barrio
    INNER JOIN publico_privado
    	ON universidad.id_publico_privado
        	= publico_privado.id_publico_privado
    INNER JOIN comuna
    	ON myBarrio.id_comuna
        	= comuna.id_comuna
    INNER JOIN habitantes
    	ON myBarrio.id_habitantes
        	= habitantes.id_habitantes
    WHERE
    	comuna.n_comuna = numero_comuna_VARIABLE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getUniversidades` ()  BEGIN
	SELECT universidad.nombre nombre_universidad,
    	   comuna.n_comuna as numero_comuna,
           comuna.estrato,
           myBarrio.nombre as nombre_barrio,
           habitantes.cantidad_habitantes
           	as cantidad_habitantes_barrio,
           universidad.direccion,
           universidad.telefono,
           universidad.sitio_web,
           publico_privado.tipo as sector
    FROM universidad
    INNER JOIN barrio as myBarrio
    	on universidad.id_barrio
        	= myBarrio.id_barrio
    INNER JOIN publico_privado
    	ON universidad.id_publico_privado
        	= publico_privado.id_publico_privado
    INNER JOIN comuna
    	ON myBarrio.id_comuna
        	= comuna.id_comuna
    INNER JOIN habitantes
    	ON myBarrio.id_habitantes
        	= habitantes.id_habitantes;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `banco`
--

CREATE TABLE `banco` (
  `id_banco` int(11) NOT NULL,
  `id_barrio` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `direccion` varchar(50) NOT NULL,
  `telefono` varchar(10) NOT NULL,
  `sitio_web` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `banco`
--

INSERT INTO `banco` (`id_banco`, `id_barrio`, `nombre`, `direccion`, `telefono`, `sitio_web`) VALUES
(5, 84, 'Ratke-Thiel', '', '(223) 2779', 'de.vu'),
(6, 127, 'Johnston-D\'Amore', '', '(884) 6478', 'amazon.co.uk'),
(8, 81, 'Wuckert-Lebsack', '', '(971) 8668', 'amazonaws.com'),
(9, 125, 'Stracke-Kiehn', '', '(699) 5436', 'dell.com'),
(10, 23, 'Wisozk LLC', '', '(890) 8176', 'netvibes.com'),
(11, 137, 'West-King', '', '(280) 3808', 'theguardian.com'),
(12, 73, 'Bayer-Medhurst', '', '(236) 5144', 'homestead.com'),
(13, 169, 'Ullrich-Abernathy', '', '(329) 3270', 'ihg.com'),
(15, 186, 'Kovacek-Stokes', '', '(781) 2867', 'washingtonpost.com'),
(16, 137, 'Walsh and Sons', '', '(639) 9465', 'go.com'),
(17, 138, 'Beier Group', '', '(239) 5762', '1688.com'),
(20, 184, 'Kub, Corkery and Schuster', '', '(643) 1676', 'army.mil'),
(22, 84, 'Kuhn Group', '', '(957) 6063', 'answers.com'),
(25, 29, 'Feil LLC', '', '(520) 4297', 'mac.com'),
(26, 119, 'Donnelly, Lowe and Sipes', '', '(745) 6978', 'hc360.com'),
(27, 24, 'Torp-King', '', '(674) 1813', 'studiopress.com'),
(31, 79, 'Robel-Kovacek', '', '(585) 4808', 'wiley.com'),
(32, 156, 'Wolff, Kiehn and Shields', '', '(118) 2624', 'mashable.com'),
(33, 18, 'Wiegand, Mitchell and Doyle', '', '(635) 3931', 'google.fr'),
(37, 136, 'Botsford, Emard and Lemke', '', '(732) 2261', 'mtv.com'),
(38, 179, 'Feeney Group', '', '(758) 9274', 'seesaa.net'),
(39, 193, 'Konopelski-Torp', '', '(618) 1563', 'gov.uk'),
(41, 133, 'Kemmer and Sons', '', '(496) 5310', 'google.co.jp'),
(44, 125, 'Towne Inc', '', '(757) 2349', 'de.vu'),
(45, 15, 'Connelly and Sons', '', '(163) 3977', 'cornell.edu'),
(47, 156, 'Lesch, Zieme and Heathcote', '', '(953) 2412', 'toplist.cz'),
(49, 174, 'Hettinger, Cummings and Gutmann', '', '(408) 1852', 'shutterfly.com'),
(50, 17, 'Wehner-Parisian', '', '(967) 1981', 'businessinsider.com'),
(51, 30, 'Herman, Maggio and Cummerata', '', '(249) 1489', 'google.es'),
(52, 84, 'Bernhard, VonRueden and Reichel', '', '(914) 1255', 'latimes.com'),
(53, 16, 'Sanford Group', '', '(180) 4074', 'last.fm'),
(55, 5, 'banco los pros', 'calle los prosss', '626262', 'www.mibanco.com'),
(56, 5, 'Banco prueba Postman', 'calle ....', '630630630', 'www.bancopostman.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `barrio`
--

CREATE TABLE `barrio` (
  `id_barrio` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `id_habitantes` int(11) NOT NULL,
  `id_comuna` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `barrio`
--

INSERT INTO `barrio` (`id_barrio`, `nombre`, `id_habitantes`, `id_comuna`) VALUES
(1, 'Arenal', 28, 1),
(2, 'Buenos Aires', 13, 1),
(3, 'Buenos Aires II', 12, 1),
(4, 'Cardales', 35, 1),
(5, 'Colombia', 39, 1),
(6, 'David Nuez Cala', 32, 1),
(7, 'El Cruce', 27, 1),
(8, 'El Dorado', 38, 1),
(9, 'El Recreo', 36, 1),
(10, 'Gonzalo Jimnez de Quesada', 46, 1),
(11, 'Invasin San Luis', 52, 1),
(12, 'Isla del Zapato', 53, 1),
(13, 'La campana', 32, 1),
(14, 'La Victoria', 32, 1),
(15, 'La Victoria II', 26, 1),
(16, 'Las Margaritas', 35, 1),
(17, 'Las Playas', 20, 1),
(18, 'Palmira', 38, 1),
(19, 'San Francisco', 37, 1),
(20, 'Sector Comercial y Muelle', 35, 1),
(21, 'Tres Unidos', 35, 1),
(22, 'Urb. Nuevo Palmira.', 37, 1),
(23, 'Aguas Claras', 16, 2),
(24, 'Ciudad Bolvar', 42, 2),
(25, 'Galn Gmez', 13, 2),
(26, 'Olaya Herrera', 50, 2),
(27, 'Parnaso', 35, 2),
(28, 'Barrio Pueblo Nuevo', 9, 2),
(29, 'Barrio Torcoroma', 53, 2),
(30, 'Barrio Uribe Uribe', 42, 2),
(31, 'Barrio Villa Luz', 54, 2),
(32, 'esto es una prueba', 12, 5),
(33, 'Alto De Los ngeles', 24, 3),
(34, 'Altos De La Virgen J.V.C', 50, 3),
(35, 'Altos Del Rosario', 15, 3),
(36, 'Asentamiento Humano Caminos De San Silvestre', 32, 3),
(37, ' Belén', 20, 3),
(38, ' Brisas Del 20 De Enero', 50, 3),
(39, ' Campo Hermoso', 7, 3),
(40, ' Ciudadela Pipatón', 29, 3),
(41, ' Colinas Del Norte', 53, 3),
(42, ' Colinas Del Sur J.V.C.', 29, 3),
(43, ' Cortijillo', 51, 3),
(44, ' Cristo Rey', 50, 3),
(45, ' Eduardo Rolón (Coviba)', 42, 3),
(46, ' Internacional', 6, 3),
(47, ' 22 De Marzo', 39, 3),
(48, ' Jerusalén', 29, 3),
(49, ' Jorge Eliecer Gaitán', 37, 3),
(50, ' La Castellana', 54, 3),
(51, ' La Floresta', 6, 3),
(52, ' La Gran Vía', 22, 3),
(53, ' La Libertad', 10, 3),
(54, ' La Paz', 21, 3),
(55, ' La Paz II', 38, 3),
(56, ' Los Ficus J.V.C', 49, 3),
(57, ' Luis Eleazar', 45, 3),
(58, ' Novalito  J.V.C.', 25, 3),
(59, ' Primero De Abril J.V.C.', 45, 3),
(60, ' San Judas Tadeo', 35, 3),
(61, ' Santa Isabel', 39, 3),
(62, ' Urbanización Brisas De La Libertad', 30, 3),
(63, ' Urbanización Miradores Del Cacique', 17, 3),
(64, ' Veinte De Enero', 6, 3),
(65, ' Villa Maria Irida', 11, 3),
(66, ' Villa Nueva', 30, 3),
(67, ' Villas De Santa Isabel J.V.C.', 33, 3),
(68, ' La Tora', 5, 3),
(69, ' Las Camelias.', 41, 3),
(70, 'Altos Del Cincuentenario', 24, 4),
(71, 'Altos Del Caaveral', 14, 4),
(72, ' Antonia Santos', 6, 4),
(73, 'Autoconstruccin VII Etapa Cincuentenario', 10, 4),
(74, 'Bellavista', 21, 4),
(75, 'Bosques De La Cira', 51, 4),
(76, 'Bosques De La Cira II', 52, 4),
(77, 'Buenavista', 35, 4),
(78, ' Buenavista II', 8, 4),
(79, 'Cincuentenario', 47, 4),
(80, 'Cincuentenario Vi Etapa Sector El Madrigal', 22, 4),
(81, 'Ciudadela Del Cincuentenario', 49, 4),
(82, 'El Bosque', 42, 4),
(83, 'El Castillo', 54, 4),
(84, 'El Palmar', 40, 4),
(85, 'El Refugio', 7, 4),
(86, 'J.V.C. Asentamiento Humano Nuevo Milenio Sur', 40, 4),
(87, ' J.V.C. Villa Del Cincuentenario', 6, 4),
(112, 'Alczar', 11, 5),
(113, 'Asentamiento Humano Colinas Del Seminario', 9, 5),
(114, 'Asentamiento Humano La Nueva Esperanza', 38, 5),
(115, 'Asentamiento Humano Las Torres', 17, 5),
(116, 'Asentamiento Humano Nuevo Milenio', 15, 5),
(117, 'Barrancabermeja', 19, 5),
(118, 'Campo Alegre', 37, 5),
(119, 'Chapinero', 9, 5),
(120, 'El Chico', 43, 5),
(121, 'El Porvenir', 48, 5),
(122, 'El Triunfo', 32, 5),
(123, 'Chapinero II', 7, 5),
(124, 'J.V.C. Ramaral', 9, 5),
(125, 'J.V.C. Tierradentro II', 41, 5),
(126, 'La Candelaria', 29, 5),
(127, 'La Esperanza', 17, 5),
(128, 'La Independencia', 30, 5),
(129, 'Las Mercedes', 51, 5),
(130, 'La Tora', 27, 5),
(131, 'Las Amricas', 46, 5),
(132, 'Las Camelias', 46, 5),
(133, 'Las Malvinas Bajas', 43, 5),
(134, 'Los Rosales', 45, 5),
(135, 'Malvinas Alta', 18, 5),
(136, 'Primero De Mayo', 6, 5),
(137, 'San Pedro Claver', 30, 5),
(138, ' San Jos De Provivienda', 38, 5),
(139, ' San Jos Obrero', 25, 5),
(140, 'Santa Ana', 32, 5),
(141, 'Santander', 28, 5),
(142, 'Simon Bolvar', 39, 5),
(143, 'Tierra Adentro', 32, 5),
(144, 'Urbanizacin Los Lagos', 11, 5),
(145, 'Versalles', 31, 5),
(146, 'Villa Rosita.', 33, 5),
(147, 'Antonio Nariño', 49, 6),
(148, ' Benjamín Herrera', 36, 6),
(149, ' Boston', 15, 6),
(150, ' Brisas De San Martin', 45, 6),
(151, ' Brisas De Versalles', 45, 6),
(152, ' Brisas Del Oriente', 8, 6),
(153, ' Corintos', 21, 6),
(154, ' Danubio', 23, 6),
(155, 'Veinte De Agosto', 52, 6),
(156, ' Kennedy', 32, 6),
(157, ' Las Granjas', 26, 6),
(158, ' Los Álamos', 34, 6),
(159, ' Los Comuneros', 54, 6),
(160, ' Oro Negro', 17, 6),
(161, ' Puerta Del Sol', 34, 6),
(162, ' Rafael Rangel', 48, 6),
(163, ' San Pedro', 15, 6),
(164, ' Urbanización Las Granjas', 53, 6),
(165, ' Veinte De Agosto', 50, 6),
(166, ' Veinte De Julio', 10, 6),
(167, ' Villa Del Coral', 47, 6),
(168, ' Villa Fauda', 14, 6),
(169, 'Los Reyes', 6, 6),
(170, '6 De Enero', 40, 6),
(171, '16 De Marzo', 49, 7),
(172, ' 9 De Abril', 36, 7),
(173, ' Altos Del Campestre', 15, 7),
(174, ' Asentamiento Humano Las Palmas', 45, 7),
(175, ' Asentamiento Humano Villa Aura', 45, 7),
(176, ' Campestre', 8, 7),
(177, ' Colinas Del Campestre', 21, 7),
(178, ' Divino Niño', 23, 7),
(179, ' El Campin', 52, 7),
(180, ' El Paraíso', 32, 7),
(181, ' Las Flores', 26, 7),
(182, ' Los Fundadores', 34, 7),
(183, ' Maria Eugenia', 54, 7),
(184, ' Minas Del Paraíso', 17, 7),
(185, ' Nuevo Horizonte', 34, 7),
(186, ' Pablo Acuña', 48, 7),
(187, ' Prados Del Campestre', 15, 7),
(188, ' Urbanización Los Corales', 53, 7),
(189, ' Urbanización Minas Del Paraíso VI Etapa', 50, 7),
(190, ' Vereda La Independencia', 10, 7),
(191, ' Villarelis Dos', 47, 7),
(192, ' Villarelis Uno', 14, 7),
(193, ' Villarelis Tres', 6, 7),
(194, 'Los Mas Pros', 55, 5),
(195, 'Este es un nuevo barrio', 57, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `colegio`
--

CREATE TABLE `colegio` (
  `id_colegio` int(11) NOT NULL,
  `id_barrio` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `direccion` varchar(50) NOT NULL,
  `telefono` varchar(10) NOT NULL,
  `sitio_web` varchar(100) NOT NULL,
  `id_publico_privado` int(1) NOT NULL,
  `id_modalidad` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `colegio`
--

INSERT INTO `colegio` (`id_colegio`, `id_barrio`, `nombre`, `direccion`, `telefono`, `sitio_web`, `id_publico_privado`, `id_modalidad`) VALUES
(1, 11, 'McLaughlin Group', '241 Independence Terrace', '(620) 1690', 'desdev.cn', 1, 1),
(2, 10, 'Jaskolski, Hudson and Homenick', '63014 Hollow Ridge Park', '(488) 8562', 'wikia.com', 1, 1),
(3, 58, 'Haley, Klocko and Watsica', '9100 Pond Junction', '(362) 4949', 'opera.com', 1, 1),
(4, 14, 'Casper, Walsh and Stoltenberg', '1672 Waxwing Park', '(438) 5393', 'noaa.gov', 2, 1),
(5, 17, 'Hamill, Feil and Kutch', '6 Ramsey Road', '(538) 6625', 'alibaba.com', 2, 1),
(6, 5, 'Carter Group', '99188 Cambridge Avenue', '(686) 4954', 'about.com', 2, 1),
(7, 56, 'Nitzsche, DuBuque and Stehr', '5320 East Circle', '(484) 4203', 'usnews.com', 1, 1),
(8, 44, 'Lynch-Lowe', '162 Weeping Birch Hill', '(861) 7680', 'adobe.com', 1, 1),
(9, 55, 'Runolfsdottir Group', '8 Farwell Crossing', '(487) 1024', 'globo.com', 1, 2),
(10, 24, 'Armstrong-Marquardt', '78 Jay Road', '(499) 7328', 'php.net', 1, 2),
(11, 42, 'Rutherford and Sons', '0 Hagan Hill', '(486) 5670', 'tripod.com', 1, 2),
(12, 22, 'Paucek, Feil and Barrows', '89 Springs Plaza', '(310) 8574', 'github.io', 1, 1),
(13, 37, 'Connelly Inc', '803 Kim Park', '(859) 7038', 'tinypic.com', 2, 2),
(14, 25, 'Hahn Group', '5729 Porter Crossing', '(924) 6145', 'marketwatch.com', 1, 1),
(15, 10, 'VonRueden-Upton', '55679 Fulton Point', '(228) 9395', 'china.com.cn', 2, 1),
(16, 23, 'Mann and Sons', '0 Kropf Point', '(235) 5002', 'army.mil', 2, 2),
(17, 27, 'Armstrong Group', '4 Parkside Parkway', '(698) 9179', 'sina.com.cn', 1, 2),
(18, 32, 'Ernser, Mosciski and Kirlin', '92013 Killdeer Court', '(243) 3731', 'google.cn', 2, 1),
(19, 53, 'Cruickshank-Parker', '71980 Algoma Circle', '(445) 5980', 'ucla.edu', 2, 1),
(20, 43, 'Willms-Bauch', '38864 Monterey Point', '(918) 9676', 'amazon.com', 2, 1),
(21, 39, 'Fadel, McLaughlin and Langworth', '65414 Lake View Circle', '(874) 2829', 'ow.ly', 2, 1),
(22, 1, 'Weber-Strosin', '12 Oriole Park', '(413) 8680', 'mlb.com', 2, 2),
(23, 2, 'Abbott Group', '54047 Delladonna Drive', '(910) 8006', 'businessinsider.com', 2, 1),
(24, 57, 'Stamm, Kunze and Daugherty', '012 Old Shore Way', '(328) 1714', 'ifeng.com', 1, 1),
(25, 33, 'Wiegand-Kuhn', '8 Huxley Avenue', '(836) 9996', 'loc.gov', 2, 1),
(26, 18, 'Veum-Harvey', '45 Heath Way', '(267) 7393', 'ning.com', 2, 2),
(27, 7, 'Reilly, Steuber and Lesch', '91 Carpenter Court', '(649) 6356', 'edublogs.org', 2, 2),
(28, 34, 'Pouros-Block', '50262 Crescent Oaks Alley', '(249) 9113', 'php.net', 2, 2),
(29, 3, 'Jerde, Monahan and Haley', '0520 Service Circle', '(285) 3726', 'vk.com', 2, 1),
(30, 1, 'Kub and Sons', '120 Hoffman Avenue', '(452) 6506', 'g.co', 1, 2),
(31, 5, 'colegio los pros', 'calle los pross', '65854125', 'www.micolegio.com', 1, 1),
(32, 5, 'Colegio prueba Postman ', 'Calle 666', '785698', 'www.postman.com', 2, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comuna`
--

CREATE TABLE `comuna` (
  `id_comuna` int(1) NOT NULL,
  `estrato` int(1) NOT NULL,
  `n_comuna` int(2) NOT NULL,
  `id_habitantes` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `comuna`
--

INSERT INTO `comuna` (`id_comuna`, `estrato`, `n_comuna`, `id_habitantes`) VALUES
(1, 6, 1, 2),
(2, 4, 2, 3),
(3, 4, 3, 3),
(4, 1, 4, 2),
(5, 2, 5, 4),
(6, 2, 6, 2),
(7, 1, 7, 1),
(8, 10, 8, 56),
(10, 5, 9, 58);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `habitantes`
--

CREATE TABLE `habitantes` (
  `id_habitantes` int(11) NOT NULL,
  `cantidad_habitantes` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `habitantes`
--

INSERT INTO `habitantes` (`id_habitantes`, `cantidad_habitantes`) VALUES
(1, 40000),
(2, 60000),
(3, 55000),
(4, 20000),
(5, 49),
(6, 3),
(7, 40092),
(8, 7),
(9, 19682),
(10, 6599),
(11, 5),
(12, 26),
(13, 47429),
(14, 8),
(15, 1),
(16, 6),
(17, 95471),
(18, 423),
(19, 143),
(20, 8123),
(21, 3),
(22, 41150),
(23, 37),
(24, 4390),
(25, 110),
(26, 70894),
(27, 92),
(28, 1),
(29, 4712),
(30, 67),
(31, 5132),
(32, 734),
(33, 86),
(34, 4309),
(35, 30),
(36, 0),
(37, 45),
(38, 391),
(39, 359),
(40, 9),
(41, 76),
(42, 4),
(43, 940),
(44, 826),
(45, 49),
(46, 12064),
(47, 11099),
(48, 3),
(49, 7339),
(50, 7382),
(51, 59238),
(52, 80),
(53, 2797),
(54, 749),
(55, 999),
(56, 555),
(57, 69),
(58, 666);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `hospital`
--

CREATE TABLE `hospital` (
  `id_hospital` int(11) NOT NULL,
  `id_barrio` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `direccion` varchar(50) NOT NULL,
  `telefono` varchar(10) NOT NULL,
  `sitio_web` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `hospital`
--

INSERT INTO `hospital` (`id_hospital`, `id_barrio`, `nombre`, `direccion`, `telefono`, `sitio_web`) VALUES
(5, 175, 'Bernhard-Ankunding', '', '(673) 4471', 'wikia.com'),
(6, 114, 'Little-Windler', '', '(996) 9010', 'rambler.ru'),
(7, 167, 'Schuppe-Kautzer', '', '(357) 8532', 'ezinearticles.com'),
(8, 122, 'Kshlerin-Heathcote', '', '(672) 8431', 'wunderground.com'),
(10, 136, 'Macejkovic, Hane and Swift', '', '(175) 1576', 'dion.ne.jp'),
(13, 133, 'Nitzsche, Donnelly and Leffler', '', '(315) 2425', 'mail.ru'),
(14, 130, 'Walsh-Hettinger', '', '(891) 6199', 'cdbaby.com'),
(16, 120, 'Rice, Heathcote and Legros', '', '(988) 3798', 'sogou.com'),
(19, 7, 'Altenwerth-Kreiger', '', '(384) 8724', 'harvard.edu'),
(20, 135, 'Kunde, Marks and Gutmann', '', '(917) 3122', 'lycos.com'),
(22, 163, 'Okuneva LLC', '', '(175) 6392', 'nsw.gov.au'),
(23, 81, 'Braun-Stanton', '', '(149) 7417', 'deliciousdays.com'),
(25, 30, 'Kuhn Group', '', '(967) 4183', 'dion.ne.jp'),
(29, 114, 'Kemmer-Dietrich', '', '(799) 4467', 'fda.gov'),
(33, 184, 'Wisozk Inc', '', '(200) 7316', 'issuu.com'),
(34, 182, 'Howell Inc', '', '(323) 6382', 'earthlink.net'),
(37, 131, 'Labadie LLC', '', '(183) 1680', 'wsj.com'),
(38, 176, 'Carter, Legros and Heathcote', '', '(863) 9537', 'reuters.com'),
(39, 178, 'Nicolas LLC', '', '(401) 6702', 'webs.com'),
(40, 149, 'Crooks, Torp and White', '', '(287) 3378', 'chicagotribune.com'),
(41, 29, 'Kilback-Kunde', '', '(972) 6506', 'blinklist.com'),
(42, 11, 'Yost Group', '', '(824) 2695', 'theatlantic.com'),
(43, 162, 'Thompson Inc', '', '(404) 6126', 'tinyurl.com'),
(45, 5, 'Harber-Schmidt', '', '(160) 1499', 'infoseek.co.jp'),
(47, 5, 'Deckow-Lehner', '', '(895) 5424', 'macromedia.com'),
(48, 73, 'Lakin, Kub and Bergnaum', '', '(307) 9396', 'pbs.org'),
(49, 125, 'Konopelski and Sons', '', '(575) 5435', 'theglobeandmail.com'),
(51, 72, 'Marquardt-Hessel', '', '(149) 6483', 'freewebs.com'),
(53, 129, 'Schimmel and Sons', '', '(251) 6590', 'java.com'),
(54, 193, 'Lockman Inc', '', '(700) 8193', 'stumbleupon.com'),
(55, 5, 'hospital los pros', 'calle los pro', '314314314', 'www.hospital.com'),
(56, 5, 'Hospital prueba Postman', 'Calle 666', '785698', 'www.hospitalpostman.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mensajeria`
--

CREATE TABLE `mensajeria` (
  `id_mensajeria` int(11) NOT NULL,
  `id_barrio` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `direccion` varchar(50) NOT NULL,
  `telefono` varchar(10) NOT NULL,
  `sitio_web` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `mensajeria`
--

INSERT INTO `mensajeria` (`id_mensajeria`, `id_barrio`, `nombre`, `direccion`, `telefono`, `sitio_web`) VALUES
(2, 127, 'Quitzon-Bahringer', '', '(532) 7607', 'blog.com'),
(3, 33, 'Considine, Ondricka and Harvey', '', '(320) 3586', 'oaic.gov.au'),
(5, 114, 'D\'Amore-Mills', '', '(779) 1049', 'meetup.com'),
(6, 152, 'McKenzie-Bode', '', '(329) 1321', 'jigsy.com'),
(7, 134, 'Keeling Inc', '', '(917) 3767', 'youku.com'),
(11, 130, 'Senger and Sons', '', '(655) 8462', 'ucoz.ru'),
(12, 182, 'Lindgren, Hilpert and Luettgen', '', '(529) 3522', 'sourceforge.net'),
(13, 143, 'Hermann-Kutch', '', '(585) 7734', 'cocolog-nifty.com'),
(14, 183, 'O\'Kon, Ruecker and Towne', '', '(313) 6657', 'guardian.co.uk'),
(15, 142, 'Olson and Sons', '', '(648) 3158', 'abc.net.au'),
(17, 126, 'Graham, Kreiger and Nienow', '', '(511) 1456', 'japanpost.jp'),
(18, 177, 'Koelpin-Johnston', '', '(440) 9263', 'instagram.com'),
(21, 156, 'Howe-Lind', '', '(804) 5885', 'spotify.com'),
(22, 27, 'Lang Inc', '', '(380) 7700', 'tinypic.com'),
(24, 185, 'Murray, Stehr and Berge', '', '(890) 3923', 'miibeian.gov.cn'),
(26, 9, 'Swift and Sons', '', '(633) 8222', 'icio.us'),
(27, 20, 'Kunde-Haley', '', '(453) 7192', 'oracle.com'),
(28, 171, 'Hessel, Boyle and Littel', '', '(243) 4112', 'jugem.jp'),
(29, 160, 'Goodwin, Jones and Hartmann', '', '(358) 6735', 'w3.org'),
(30, 152, 'Keeling Inc', '', '(829) 4430', 'phpbb.com'),
(31, 12, 'Olson-McLaughlin', '', '(872) 7036', 'ca.gov'),
(33, 167, 'Nikolaus Inc', '', '(626) 6485', 'free.fr'),
(34, 22, 'Batz Group', '', '(261) 8227', 'bigcartel.com'),
(35, 82, 'Harber, Oberbrunner and Yundt', '', '(779) 6514', 'multiply.com'),
(36, 142, 'Keebler-Hermiston', '', '(897) 9383', 'ca.gov'),
(37, 19, 'Grimes, Pouros and Hyatt', '', '(454) 4118', 'businessinsider.com'),
(38, 142, 'Marquardt LLC', '', '(207) 1175', 'fc2.com'),
(40, 185, 'Koss, Will and Armstrong', '', '(355) 2364', 'friendfeed.com'),
(43, 150, 'Gorczany Inc', '', '(320) 3903', 'flickr.com'),
(45, 168, 'Walsh and Sons', '', '(943) 2252', 'fema.gov'),
(48, 174, 'Rath and Sons', '', '(319) 1156', 'yolasite.com'),
(49, 138, 'Harvey, Cartwright and Treutel', '', '(107) 6344', 'imdb.com'),
(50, 34, 'Wiegand-Johnson', '', '(728) 9391', 'canalblog.com'),
(51, 130, 'Trantow Inc', '', '(572) 3192', 'ibm.com'),
(52, 5, 'Mensajeria Los Pros', 'Calle ####', '602605262', 'www.mensajeriaslospros.com'),
(54, 5, 'Mensajeria prueba Postman', 'Calle 666', '785698', 'www.hospitalpostman.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modalidad`
--

CREATE TABLE `modalidad` (
  `id_modalidad` int(1) NOT NULL,
  `tipo` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `modalidad`
--

INSERT INTO `modalidad` (`id_modalidad`, `tipo`) VALUES
(1, 'Técnico'),
(2, 'Comercial');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `publico_privado`
--

CREATE TABLE `publico_privado` (
  `id_publico_privado` int(1) NOT NULL,
  `tipo` varchar(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `publico_privado`
--

INSERT INTO `publico_privado` (`id_publico_privado`, `tipo`) VALUES
(1, 'Publico'),
(2, 'Privado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `universidad`
--

CREATE TABLE `universidad` (
  `id_universidad` int(11) NOT NULL,
  `id_barrio` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `direccion` varchar(50) NOT NULL,
  `telefono` varchar(10) NOT NULL,
  `sitio_web` varchar(100) NOT NULL,
  `id_publico_privado` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `universidad`
--

INSERT INTO `universidad` (`id_universidad`, `id_barrio`, `nombre`, `direccion`, `telefono`, `sitio_web`, `id_publico_privado`) VALUES
(1, 30, 'Johns, Stracke and Larson', '', '(406) 7289', 'walmart.com', 2),
(2, 185, 'Steuber, Blanda and Gislason', '', '(180) 5663', 'google.com.hk', 2),
(3, 16, 'Stehr, Altenwerth and Von', '', '(701) 3314', 'mtv.com', 2),
(4, 72, 'Moore-Schmitt', '', '(440) 5852', 'exblog.jp', 1),
(5, 166, 'Dickens Inc', '', '(262) 1896', 'unesco.org', 2),
(6, 57, 'Watsica-Kemmer', '', '(202) 7427', 'google.co.jp', 2),
(7, 4, 'Wisozk, Stoltenberg and Dicki', '', '(799) 8138', 'last.fm', 1),
(8, 48, 'Denesik-Dach', '', '(642) 4579', 'sciencedaily.com', 2),
(9, 58, 'Lesch-McGlynn', '', '(431) 5254', 'reverbnation.com', 1),
(10, 55, 'Haley, Corwin and Senger', '', '(963) 7884', 'va.gov', 1),
(11, 15, 'Harvey Inc', '', '(942) 9060', 'amazonaws.com', 1),
(12, 189, 'Littel, Gulgowski and Sawayn', '', '(581) 4210', 'hao123.com', 2),
(13, 178, 'Swaniawski Group', '', '(817) 2866', 'comcast.net', 2),
(14, 50, 'Marks Inc', '', '(662) 1000', 'sitemeter.com', 2),
(15, 12, 'McKenzie, Emmerich and Farrell', '', '(862) 5046', 'topsy.com', 1),
(16, 166, 'Dickens-Bernier', '', '(111) 8150', 'facebook.com', 1),
(17, 21, 'Adams and Sons', '', '(889) 1648', 'cnbc.com', 1),
(18, 162, 'Dibbert and Sons', '', '(660) 1784', 'tumblr.com', 2),
(19, 124, 'Torp-Nienow', '', '(786) 4580', 'sitemeter.com', 2),
(20, 10, 'McKenzie-Larson', '', '(507) 3300', 'thetimes.co.uk', 1),
(21, 33, 'Purdy-Hane', '', '(720) 1080', 'qq.com', 1),
(22, 49, 'Hane-Schiller', '', '(798) 3357', 'slashdot.org', 1),
(23, 76, 'Emmerich, Bradtke and Jaskolski', '', '(786) 4192', 'ted.com', 2),
(24, 52, 'Feest-Rosenbaum', '', '(145) 8125', 'mysql.com', 2),
(25, 164, 'Kovacek-Reichel', '', '(997) 3464', 't.co', 1),
(26, 153, 'Parker Group', '', '(411) 7482', 'sun.com', 1),
(27, 39, 'Koepp Inc', '', '(995) 1630', 'eepurl.com', 1),
(28, 6, 'Gleason LLC', '', '(655) 2834', 'quantcast.com', 2),
(29, 22, 'Davis, Gutmann and Dietrich', '', '(103) 4840', 'boston.com', 2),
(30, 185, 'Ledner and Sons', '', '(600) 3504', 'hubpages.com', 2),
(31, 5, 'universidad los pros', 'calle calle', '32654789', 'www.miuniversidad.com', 2),
(32, 5, 'Universidad prueba Postman', 'Calle 666', '785698', 'www.postman.com', 2),
(33, 5, 'Colegio prueba Postman ', 'Calle 666', '785698', 'www.postman.com', 2);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `banco`
--
ALTER TABLE `banco`
  ADD PRIMARY KEY (`id_banco`),
  ADD KEY `id_barrio` (`id_barrio`);

--
-- Indices de la tabla `barrio`
--
ALTER TABLE `barrio`
  ADD PRIMARY KEY (`id_barrio`),
  ADD UNIQUE KEY `nombre` (`nombre`),
  ADD KEY `id_habitantes` (`id_habitantes`),
  ADD KEY `id_comuna` (`id_comuna`);

--
-- Indices de la tabla `colegio`
--
ALTER TABLE `colegio`
  ADD PRIMARY KEY (`id_colegio`),
  ADD KEY `id_barrio` (`id_barrio`),
  ADD KEY `id_publico_privado` (`id_publico_privado`),
  ADD KEY `id_modalidad` (`id_modalidad`);

--
-- Indices de la tabla `comuna`
--
ALTER TABLE `comuna`
  ADD PRIMARY KEY (`id_comuna`),
  ADD UNIQUE KEY `n_comuna` (`n_comuna`),
  ADD KEY `id_habitantes` (`id_habitantes`);

--
-- Indices de la tabla `habitantes`
--
ALTER TABLE `habitantes`
  ADD PRIMARY KEY (`id_habitantes`);

--
-- Indices de la tabla `hospital`
--
ALTER TABLE `hospital`
  ADD PRIMARY KEY (`id_hospital`),
  ADD KEY `id_barrio` (`id_barrio`);

--
-- Indices de la tabla `mensajeria`
--
ALTER TABLE `mensajeria`
  ADD PRIMARY KEY (`id_mensajeria`),
  ADD KEY `id_barrio` (`id_barrio`);

--
-- Indices de la tabla `modalidad`
--
ALTER TABLE `modalidad`
  ADD PRIMARY KEY (`id_modalidad`);

--
-- Indices de la tabla `publico_privado`
--
ALTER TABLE `publico_privado`
  ADD PRIMARY KEY (`id_publico_privado`);

--
-- Indices de la tabla `universidad`
--
ALTER TABLE `universidad`
  ADD PRIMARY KEY (`id_universidad`),
  ADD KEY `id_barrio` (`id_barrio`),
  ADD KEY `id_publico_privado` (`id_publico_privado`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `banco`
--
ALTER TABLE `banco`
  MODIFY `id_banco` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT de la tabla `barrio`
--
ALTER TABLE `barrio`
  MODIFY `id_barrio` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=197;

--
-- AUTO_INCREMENT de la tabla `colegio`
--
ALTER TABLE `colegio`
  MODIFY `id_colegio` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT de la tabla `comuna`
--
ALTER TABLE `comuna`
  MODIFY `id_comuna` int(1) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `habitantes`
--
ALTER TABLE `habitantes`
  MODIFY `id_habitantes` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT de la tabla `hospital`
--
ALTER TABLE `hospital`
  MODIFY `id_hospital` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT de la tabla `mensajeria`
--
ALTER TABLE `mensajeria`
  MODIFY `id_mensajeria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT de la tabla `modalidad`
--
ALTER TABLE `modalidad`
  MODIFY `id_modalidad` int(1) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `publico_privado`
--
ALTER TABLE `publico_privado`
  MODIFY `id_publico_privado` int(1) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `universidad`
--
ALTER TABLE `universidad`
  MODIFY `id_universidad` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `banco`
--
ALTER TABLE `banco`
  ADD CONSTRAINT `banco_ibfk_1` FOREIGN KEY (`id_barrio`) REFERENCES `barrio` (`id_barrio`);

--
-- Filtros para la tabla `barrio`
--
ALTER TABLE `barrio`
  ADD CONSTRAINT `barrio_ibfk_1` FOREIGN KEY (`id_habitantes`) REFERENCES `habitantes` (`id_habitantes`),
  ADD CONSTRAINT `barrio_ibfk_2` FOREIGN KEY (`id_comuna`) REFERENCES `comuna` (`id_comuna`);

--
-- Filtros para la tabla `colegio`
--
ALTER TABLE `colegio`
  ADD CONSTRAINT `colegio_ibfk_1` FOREIGN KEY (`id_barrio`) REFERENCES `barrio` (`id_barrio`),
  ADD CONSTRAINT `colegio_ibfk_2` FOREIGN KEY (`id_publico_privado`) REFERENCES `publico_privado` (`id_publico_privado`),
  ADD CONSTRAINT `colegio_ibfk_3` FOREIGN KEY (`id_modalidad`) REFERENCES `modalidad` (`id_modalidad`);

--
-- Filtros para la tabla `comuna`
--
ALTER TABLE `comuna`
  ADD CONSTRAINT `comuna_ibfk_2` FOREIGN KEY (`id_habitantes`) REFERENCES `habitantes` (`id_habitantes`);

--
-- Filtros para la tabla `hospital`
--
ALTER TABLE `hospital`
  ADD CONSTRAINT `hospital_ibfk_1` FOREIGN KEY (`id_barrio`) REFERENCES `barrio` (`id_barrio`);

--
-- Filtros para la tabla `mensajeria`
--
ALTER TABLE `mensajeria`
  ADD CONSTRAINT `mensajeria_ibfk_1` FOREIGN KEY (`id_barrio`) REFERENCES `barrio` (`id_barrio`);

--
-- Filtros para la tabla `universidad`
--
ALTER TABLE `universidad`
  ADD CONSTRAINT `universidad_ibfk_1` FOREIGN KEY (`id_barrio`) REFERENCES `barrio` (`id_barrio`),
  ADD CONSTRAINT `universidad_ibfk_2` FOREIGN KEY (`id_publico_privado`) REFERENCES `publico_privado` (`id_publico_privado`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
