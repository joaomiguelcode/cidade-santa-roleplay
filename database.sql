-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           10.10.2-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Copiando estrutura do banco de dados para cidadesanta
CREATE DATABASE IF NOT EXISTS `cidadesanta` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci */;
USE `cidadesanta`;

-- Copiando estrutura para tabela cidadesanta.accounts
CREATE TABLE IF NOT EXISTS `accounts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `whitelist` tinyint(1) NOT NULL DEFAULT 0,
  `chars` int(10) NOT NULL DEFAULT 1,
  `gems` float NOT NULL DEFAULT 0,
  `rolepass` int(20) NOT NULL DEFAULT 0,
  `premium` int(20) NOT NULL DEFAULT 0,
  `discord` varchar(25) NOT NULL DEFAULT '0',
  `license` varchar(50) NOT NULL DEFAULT '0',
  `amount_logins` int(11) NOT NULL DEFAULT 0,
  `name` varchar(150) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `sex` varchar(50) DEFAULT NULL,
  `whatsapp` varchar(35) DEFAULT NULL,
  `recommendation` varchar(50) DEFAULT NULL,
  `account_create` datetime DEFAULT current_timestamp(),
  `birthday` date DEFAULT NULL,
  `token` varchar(50) DEFAULT NULL,
  `purchased` decimal(20,6) NOT NULL DEFAULT 0.000000,
  `ip` longtext DEFAULT NULL,
  `last_ip` varchar(255) DEFAULT NULL,
  `priority` int(11) DEFAULT 0,
  `LA` tinyint(4) DEFAULT 0,
  `tos` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `license` (`license`),
  KEY `id` (`id`),
  KEY `license2` (`license`),
  KEY `discord` (`discord`),
  KEY `token` (`token`),
  KEY `idx_account_create` (`account_create`),
  KEY `idx_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.accounts: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.accounts_login
CREATE TABLE IF NOT EXISTS `accounts_login` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `login` datetime NOT NULL DEFAULT current_timestamp(),
  `logoff` datetime DEFAULT NULL,
  `id_pk` bigint(20) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id_pk`),
  KEY `accounts_login_account_id` (`id`),
  KEY `logoff` (`logoff`),
  CONSTRAINT `accounts_login_account_id` FOREIGN KEY (`id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.accounts_login: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.achievements
CREATE TABLE IF NOT EXISTS `achievements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group` int(11) NOT NULL DEFAULT 0,
  `name` varchar(100) NOT NULL DEFAULT '0',
  `description` varchar(250) NOT NULL DEFAULT '0',
  `rewards` longtext NOT NULL DEFAULT '{}',
  `title` varchar(100) DEFAULT NULL,
  `progress` int(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `achievements_group_FK` (`group`),
  CONSTRAINT `achievements_group_FK` FOREIGN KEY (`group`) REFERENCES `achievements_group` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.achievements: ~79 rows (aproximadamente)
INSERT INTO `achievements` (`id`, `group`, `name`, `description`, `rewards`, `title`, `progress`) VALUES
	(1, 3, 'Boostado', 'FaÃ§a a missÃ£o do Boost', '[{"name":"VIPBOOST","amount":5,"type":"TemporaryGroup"}]', 'Energizado', 1),
	(2, 2, 'ComeÃ§ando com o pÃ© direito', 'Fale com todos os NPCs do pier', '[{"name":"pantinho","amount":1,"type":"Vehicle"}]', 'PÃ© direito', 5),
	(3, 2, 'Primeiro milhÃ£o', 'Conquiste seu primeiro milhÃ£o no banco.', '[{"name":"dollars","amount":70,"type":"Item"}]', 'Rico', 1),
	(4, 2, 'Fome de poder', 'Conquiste 100 milhÃµes no banco', '[{"name":"dollars","amount":70,"type":"Item"}]', 'Magnata', 1),
	(5, 2, 'Clube do BilhÃ£o', 'Consiga um bilhÃ£o no banco', '[{"name":"dollars","amount":70,"type":"Item"}]', 'BilionÃ¡rio', 1),
	(6, 2, 'Carteira assinada', 'Seja contratado!', '[{"name":"dollars","amount":120000,"type":"Item"}]', NULL, 1),
	(7, 2, 'Homem da lei', 'Entre para a policia', '[{"name":"dollars","amount":120000,"type":"Item"}]', NULL, 1),
	(8, 2, 'Engenheiro', 'Entre para a mecanica', '[{"name":"dollars","amount":120000,"type":"Item"}]', NULL, 1),
	(9, 2, 'Salvando vidas', 'Entre para o hospital', '[{"name":"dollars","amount":120000,"type":"Item"}]', NULL, 1),
	(10, 2, 'Vida bandida', 'Entre para o ilegal', '[{"name":"dollars","amount":120000,"type":"Item"}]', NULL, 1),
	(11, 3, 'Armado e perigoso', 'Equipe uma arma', '[{"name":"WEAPON_COMBATPISTOL","amount":1,"type":"Item"}]', NULL, 1),
	(12, 3, 'O fim Ã© triste...', 'Morra pela primeira vez', '[{"name":"drugtoy","amount":1,"type":"Item"}]', NULL, 5),
	(13, 3, 'Compre sua primeira moto', 'Compre uma moto na concessionÃ¡ria', '[{"name":"dollars","amount":120000,"type":"Item"}]', NULL, 1),
	(14, 3, 'Compre sua primeira aeronave', 'Compre uma aeronave na concessionÃ¡ria', '[{"name":"dollars","amount":120000,"type":"Item"}]', NULL, 1),
	(15, 3, 'Tune um veÃ­culo', 'VÃ¡ a mecanica e tune seu carro!', '[{"name":"venvanse","amount":120000,"type":"Item"}]', NULL, 1),
	(16, 3, 'Garagem cheia', 'Adquira 10 carros', '[{"name":"","amount":70,"type":""}]', 'Colecionador', 1),
	(17, 1, 'Departamento Policial', 'Visite a DP', '[{"name":"","amount":70,"type":""}]', 'Lado bom da forÃ§a', 1),
	(18, 1, 'Hospital', 'Visite o HP', '[{"name":"","amount":70,"type":""}]', 'Salva-vidas', 1),
	(19, 1, 'Ammunation', 'Roube uma ammunation', '[{"name":"dollars","amount":70,"type":"Item"}]', NULL, 1),
	(20, 1, 'Floricultura', 'Roube a floricultura', '[{"name":"dollars","amount":70,"type":"Item"}]', NULL, 1),
	(21, 1, 'Lojinha', 'Roube uma lojinha', '[{"name":"dollars","amount":70,"type":"Item"}]', NULL, 1),
	(22, 1, 'McDonalds', 'Roube o McDonalds', '[{"name":"dollars","amount":70,"type":"Item"}]', NULL, 1),
	(23, 1, 'Lucky Plucker', 'Roube o Lucky Puclker', '[{"name":"dollars","amount":70,"type":"Item"}]', NULL, 1),
	(24, 1, 'Comedy', 'Roube o comedy', '[{"name":"dollars","amount":70,"type":"Item"}]', NULL, 1),
	(25, 1, 'Auditorio', 'Roube o auditorio', '[{"name":"dollars","amount":70,"type":"Item"}]', NULL, 1),
	(26, 1, 'Observas', 'Roube o observatorio', '[{"name":"dollars","amount":70,"type":"Item"}]', NULL, 1),
	(27, 1, 'Galinheiro', 'Roube o galinheiro', '[{"name":"dollars","amount":70,"type":"Item"}]', NULL, 1),
	(28, 1, 'Banco Central', 'Roube o banco central', '[{"name":"dollars","amount":70,"type":"Item"}]', NULL, 1),
	(29, 1, 'Fleeca', 'Roube um banco fleeca', '[{"name":"dollars","amount":70,"type":"Item"}]', NULL, 1),
	(30, 1, 'Dominante', 'Ganhe uma dominaÃ§Ã£o', '[{"name":"","amount":70,"type":""}]', 'Dominante', 1),
	(32, 4, 'Algorithms & Code', 'Abuser', '{}', 'Ex_Machina', 1),
	(33, 4, 'The Matrix', 'Participou ativamente da montagem da S4', '{}', 'The Architect ', 0),
	(34, 4, 'Os seus problemas', 'Isso Ã© viver', '{}', 'Hakuna Matata', 0),
	(35, 4, 'Brainstorming', 'Esse cara realmente dÃ¡ boas ideias', '{}', 'Genio', 0),
	(36, 4, 'Trial Phase', 'Participaram ativamente da fase de testes S4', '{}', 'Rato de LaboratÃ³rio', 0),
	(37, 2, 'Começando com o pé direito', 'Fale com todos os NPCs do pier', '[{"amount":1,"type":"Vehicle","name":"pantinho"}]', 'Pé direito', 5),
	(38, 2, 'Primeiro milhão', 'Conquiste seu primeiro milhão no banco.', '[{"amount":70,"type":"Item","name":"dollars"}]', 'Rico', 1),
	(39, 2, 'Clube do Bilhão', 'Consiga um bilhão no banco', '[{"amount":70,"type":"Item","name":"dollars"}]', 'Bilionário', 1),
	(40, 3, 'O fim é triste...', 'Morra pela primeira vez', '[{"amount":1,"type":"Item","name":"drugtoy"}]', NULL, 5),
	(41, 3, 'Tune um veículo', 'Vá a mecanica e tune seu carro!', '[{"amount":120000,"type":"Item","name":"venvanse"}]', NULL, 1),
	(42, 4, 'Dono da pista', '', '[]', 'Dono da pista', 1),
	(43, 4, 'Só mato no rolas', 'Só mato no rolas', '[]', 'Só mato no rolas', 1),
	(44, 4, '01 não é 02', '01 não é 02', '[]', '01 não é 02', 1),
	(45, 2, 'Deixando de ser desabrigado', 'Compre uma casa', '[{"amount":50000,"name":"dollars","type":"Item"}]', NULL, 1),
	(46, 2, 'Deixando de andar a pé', 'Compre um carro', '[{"amount":60000,"name":"dollars","type":"Item"}]', NULL, 1),
	(47, 2, 'Adquirindo recursos', 'Tenha 10 carros na garagem', '[{"amount":140000,"name":"dollars","type":"Item"}]', NULL, 1),
	(48, 2, 'Iniciandro a frota', 'Tenha 50 carros na garagem', '[{"amount":50000,"name":"dollars","type":"Item"}]', NULL, 1),
	(49, 2, 'GearHead', 'Tenha pelo menos 100 carros na garagem', '[{"amount":3000000,"name":"dollars","type":"Item"}]', 'GearHead', 1),
	(50, 2, 'Colecionador', 'Tenha pelo menos 200 carros na garagem', '[{"amount":9000000,"name":"dollars","type":"Item"}]', 'Colecionador', 1),
	(51, 2, 'Bem relacionado', 'Consiga um parceiro(a)', '[{"amount":100,"name":"dollars","type":"Item"}]', NULL, 1),
	(52, 2, 'Bons costumes', 'Dê um like em alguém.', '[{"amount":100,"name":"dollars","type":"Item"}]', NULL, 1),
	(53, 2, 'Sendo querido pelos demais', 'Receba um like de alguém.', '[{"amount":100,"name":"dollars","type":"Item"}]', NULL, 1),
	(54, 2, 'Amigo da vizinhança', 'Consiga 500 likes', '[{"amount":100,"name":"dollars","type":"Item"}]', NULL, 1),
	(55, 2, 'Miss Simpatia', 'Consiga 1000 likes', '[{"amount":100,"name":"dollars","type":"Item"}]', 'Miss Simpatia', 1),
	(56, 1, 'Ninguém tá puro', 'Elimine 10 adversarios sem morrer', '[]', 'Perigoso', 1),
	(57, 1, 'Ninguém tá puro 2.0', 'Elimine 20 adversarios sem morrer', '[]', 'Lenda', 1),
	(58, 1, 'Perigo iminente', 'Equipe uma arma', '[]', NULL, 1),
	(59, 1, 'PvPlayer?', 'Elimine pelo menos 1000 adversários', '[]', 'PvPas', 1),
	(60, 1, 'PvPlayer? 2.0', 'Elimine pelo menos 10000 adversários', '[]', 'DuByPass', 1),
	(61, 4, 'O começo de tudo!', 'Complete 12 horas jogadas', '[{"amount":50000,"name":"dollars","type":"Item"}]', NULL, 1),
	(62, 4, 'Engajando!', 'Complete 24 horas jogadas', '[{"amount":100000,"name":"dollars","type":"Item"}]', NULL, 1),
	(63, 4, 'Resolvi ficar!', 'Complete 72 horas jogadas', '[{"amount":50000,"name":"dollars","type":"Item"}]', NULL, 1),
	(64, 4, 'Já conheço tudo!', 'Complete 170 horas jogadas', '[]', '⏱️ 170 Horas', 1),
	(65, 4, 'Parece casa de mãe!', 'Complete 720 horas jogadas', '[]', '⏱️ 720 Horas', 1),
	(66, 4, 'Aqui é minha casa!', 'Complete 1500 horas jogadas', '[]', '⏱️ 1500 Horas', 1),
	(67, 4, 'Inderrubável', 'Jogue por 30 minutos sem deslogar', '[{"amount":50000,"name":"dollars","type":"Item"}]', NULL, 1),
	(68, 4, 'Fechamento', 'Faça 10 sessões de 30 minutos sem deslogar.', '[{"amount":50000,"name":"dollars","type":"Item"}]', NULL, 1),
	(69, 4, '01 carro de luxo', 'Faça 30 sessões de 30 minutos sem deslogar.', '[{"amount":50000,"name":"dollars","type":"Item"}]', NULL, 1),
	(70, 4, 'Receba!', 'Faça 100 sessões de 30 minutos sem deslogar.', '[{"amount":50000,"name":"dollars","type":"Item"}]', NULL, 1),
	(71, 3, 'Mecanica', 'Visite a Mecanica', '[{"amount":50000,"name":"dollars","type":"Item"}]', NULL, 1),
	(72, 3, 'Mt. Chilliad', 'Visite o Monte Chilliad', '[{"amount":50000,"name":"dollars","type":"Item"}]', NULL, 1),
	(73, 3, 'Cayo Perico', 'Visite a ilha de Cayo Perico', '[{"amount":50000,"name":"dollars","type":"Item"}]', NULL, 1),
	(74, 3, 'Pier do Norte', 'Visite o Pier do Norte', '[{"amount":50000,"name":"dollars","type":"Item"}]', NULL, 1),
	(75, 3, 'Aeroporto', 'Visite o Aeroporto', '[{"amount":50000,"name":"dollars","type":"Item"}]', NULL, 1),
	(76, 3, 'Esgotos', 'Explore o esgoto da cidade.', '[{"amount":50000,"name":"dollars","type":"Item"}]', NULL, 1),
	(77, 4, '01 de uma facção', 'Seja o dono de uma facção', '[]', '👑 Bigode Grosso', 1),
	(78, 4, 'Cliente Especial Season 04', 'Entre em contato com seu vendedor favorito', '[]', '👑 Conta Larga', 1),
	(79, 4, 'Velhos tempos', 'Players que estão conosco desde a S1 ~ S2', '[]', '🦈 Respeita Minha História', 1),
	(80, 4, 'Vencedor cidadesantaCUP', 'Ganhe o cidadesantaCup', '[]', '👑 We are the Champions', 1);

-- Copiando estrutura para tabela cidadesanta.achievements_group
CREATE TABLE IF NOT EXISTS `achievements_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group` (`group`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.achievements_group: ~4 rows (aproximadamente)
INSERT INTO `achievements_group` (`id`, `group`) VALUES
	(4, 'EVENTOS'),
	(1, 'PVP'),
	(2, 'ROLEPLAY'),
	(3, 'VISITAS');

-- Copiando estrutura para tabela cidadesanta.admin_feedback
CREATE TABLE IF NOT EXISTS `admin_feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin` int(11) NOT NULL DEFAULT 0,
  `player` int(11) NOT NULL DEFAULT 0,
  `rating` int(2) NOT NULL,
  `feedback` varchar(255) NOT NULL DEFAULT '',
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `admin_feedback_admin_FK` (`admin`),
  KEY `admin_feedback_player_FK` (`player`),
  CONSTRAINT `admin_feedback_admin_FK` FOREIGN KEY (`admin`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `admin_feedback_player_FK` FOREIGN KEY (`player`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.admin_feedback: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.aimlabs_ranking
CREATE TABLE IF NOT EXISTS `aimlabs_ranking` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Passport` int(11) NOT NULL DEFAULT 0,
  `type` int(1) NOT NULL DEFAULT 0,
  `time` int(6) NOT NULL DEFAULT 0,
  `points` int(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `aimlabs_ranking_FK` (`Passport`),
  KEY `aimlabs_ranking_type_FK` (`type`),
  CONSTRAINT `aimlabs_ranking_FK` FOREIGN KEY (`Passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.aimlabs_ranking: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.arena_ranking
CREATE TABLE IF NOT EXISTS `arena_ranking` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Passport` int(11) NOT NULL DEFAULT 0,
  `arena` int(11) NOT NULL DEFAULT 0,
  `points` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `arena_rank_Passport_FK` (`Passport`),
  KEY `arena_rank_arena_FK` (`arena`),
  CONSTRAINT `arena_rank_Passport_FK` FOREIGN KEY (`Passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `arena_rank_arena_FK` FOREIGN KEY (`arena`) REFERENCES `arena_type` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.arena_ranking: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.arena_type
CREATE TABLE IF NOT EXISTS `arena_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.arena_type: ~3 rows (aproximadamente)
INSERT INTO `arena_type` (`id`, `type`) VALUES
	(1, '1x1'),
	(2, '3x3'),
	(3, '6x6');

-- Copiando estrutura para tabela cidadesanta.bank_log
CREATE TABLE IF NOT EXISTS `bank_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Passport` int(11) NOT NULL DEFAULT 0,
  `Amount` int(11) NOT NULL DEFAULT 0,
  `Type` varchar(50) NOT NULL DEFAULT '0',
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `Passport` (`Passport`),
  CONSTRAINT `bank_log_Passport_FK` FOREIGN KEY (`Passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.bank_log: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.banneds
CREATE TABLE IF NOT EXISTS `banneds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accountId` bigint(20) NOT NULL DEFAULT 9999999,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `reason` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `license` (`accountId`) USING BTREE,
  KEY `id` (`id`),
  CONSTRAINT `banneds_accountId_FK` FOREIGN KEY (`accountId`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.banneds: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.banneds_hwid
CREATE TABLE IF NOT EXISTS `banneds_hwid` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(100) NOT NULL DEFAULT '0',
  `accountId` bigint(20) NOT NULL DEFAULT 99999,
  `banned` tinyint(1) NOT NULL DEFAULT 0,
  `reason` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `tokenkey` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.banneds_hwid: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.banned_ip
CREATE TABLE IF NOT EXISTS `banned_ip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accountId` bigint(20) NOT NULL DEFAULT 0,
  `ip` varchar(255) DEFAULT '0',
  `reason` varchar(255) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.banned_ip: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.battlepass
CREATE TABLE IF NOT EXISTS `battlepass` (
  `passport` int(11) NOT NULL DEFAULT 0,
  `experience` int(11) NOT NULL DEFAULT 0,
  `level` int(11) NOT NULL DEFAULT 0,
  `hasPremium` tinyint(1) NOT NULL DEFAULT 0,
  `premium` longtext NOT NULL DEFAULT '{}',
  `free` longtext NOT NULL DEFAULT '{}',
  `completed` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.battlepass: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.blips
CREATE TABLE IF NOT EXISTS `blips` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` int(11) NOT NULL DEFAULT 0,
  `name` varchar(50) NOT NULL DEFAULT '0',
  `blip_id` int(3) NOT NULL,
  `coordinates` varchar(250) NOT NULL,
  `color` int(3) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqueName` (`name`),
  KEY `id` (`id`),
  KEY `owner` (`owner`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.blips: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.characters
CREATE TABLE IF NOT EXISTS `characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(50) DEFAULT NULL,
  `phone` varchar(10) DEFAULT NULL,
  `name` varchar(50) DEFAULT 'Individuo',
  `name2` varchar(50) DEFAULT 'Indigente',
  `sex` varchar(1) NOT NULL DEFAULT 'M',
  `age` int(2) NOT NULL DEFAULT 0,
  `skin` varchar(50) DEFAULT 'mp_m_freemode_01',
  `bank` bigint(50) NOT NULL DEFAULT 0,
  `economy` bigint(20) DEFAULT NULL,
  `blood` int(1) NOT NULL DEFAULT 1,
  `fines` int(20) NOT NULL DEFAULT 0,
  `prison` int(11) NOT NULL DEFAULT 0,
  `tracking` int(30) NOT NULL DEFAULT 0,
  `spending` int(20) NOT NULL DEFAULT 0,
  `cardlimit` int(20) NOT NULL DEFAULT 0,
  `deleted` int(1) NOT NULL DEFAULT 0,
  `login` datetime DEFAULT current_timestamp(),
  `avarageFPS` int(3) NOT NULL DEFAULT 0,
  `maisrep` int(10) NOT NULL DEFAULT 0,
  `menosrep` int(10) NOT NULL DEFAULT 0,
  `title` varchar(100) DEFAULT NULL,
  `garages` int(3) NOT NULL DEFAULT 4,
  `paypal` int(11) DEFAULT 0,
  `relationship` varchar(50) NOT NULL DEFAULT 'Solteiro',
  `toxic` tinyint(1) NOT NULL DEFAULT 0,
  `customSpawn` varchar(255) DEFAULT NULL,
  `Kills` int(6) NOT NULL DEFAULT 0,
  `Deaths` int(6) NOT NULL DEFAULT 0,
  `weapon` tinyint(1) DEFAULT 0,
  `created` datetime DEFAULT current_timestamp(),
  `firstspawn` datetime DEFAULT NULL,
  `bullying` tinyint(4) DEFAULT 0,
  `profile_picture` varchar(255) DEFAULT NULL,
  `tutorial` tinyint(1) NOT NULL DEFAULT 0,
  `photo` varchar(255) DEFAULT NULL,
  `initial` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `license` (`license`),
  KEY `id` (`id`),
  KEY `tracking` (`tracking`),
  KEY `idx_firstspawn` (`firstspawn`),
  KEY `idx_phone_name_name2` (`phone`,`name`,`name2`),
  CONSTRAINT `characters_license_FK` FOREIGN KEY (`license`) REFERENCES `accounts` (`license`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.characters: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.chests
CREATE TABLE IF NOT EXISTS `chests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `weight` int(10) NOT NULL DEFAULT 0,
  `perm` varchar(50) NOT NULL,
  `logs` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.chests: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.crowns
CREATE TABLE IF NOT EXISTS `crowns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Serial` varchar(50) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Coords` longtext DEFAULT NULL,
  `Color` int(3) NOT NULL DEFAULT 1,
  `Sprite` int(3) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.crowns: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.custom_chests
CREATE TABLE IF NOT EXISTS `custom_chests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL DEFAULT '0',
  `Owner` int(11) NOT NULL DEFAULT 0,
  `permission` longtext NOT NULL DEFAULT '{}',
  `Weight` int(11) NOT NULL DEFAULT 1000,
  `Coords` varchar(250) DEFAULT NULL,
  `Alarm` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`Name`) USING BTREE,
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.custom_chests: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.delivery_kit
CREATE TABLE IF NOT EXISTS `delivery_kit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `AccountId` bigint(20) NOT NULL DEFAULT 0,
  `info` longtext NOT NULL DEFAULT '{}',
  `after` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `AccountId` (`AccountId`),
  CONSTRAINT `delivery_kit_AccountId_FK` FOREIGN KEY (`AccountId`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.delivery_kit: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.dependents
CREATE TABLE IF NOT EXISTS `dependents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Passport` int(10) NOT NULL DEFAULT 0,
  `Dependent` int(10) NOT NULL DEFAULT 0,
  `Name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`),
  KEY `id` (`id`),
  KEY `dependents_Dependent_FK` (`Dependent`),
  CONSTRAINT `dependents_Dependent_FK` FOREIGN KEY (`Dependent`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `dependents_Passport_FK` FOREIGN KEY (`Passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.dependents: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.domination
CREATE TABLE IF NOT EXISTS `domination` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zone` varchar(50) NOT NULL DEFAULT '',
  `owner` varchar(50) NOT NULL DEFAULT 'Ninguem',
  `time` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `zone` (`zone`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.domination: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.dropkill_ranking
CREATE TABLE IF NOT EXISTS `dropkill_ranking` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) NOT NULL DEFAULT 0,
  `points` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `dropkill_ranking_passport_FK` (`passport`),
  CONSTRAINT `dropkill_ranking_passport_FK` FOREIGN KEY (`passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.dropkill_ranking: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.drop_count
CREATE TABLE IF NOT EXISTS `drop_count` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) NOT NULL DEFAULT 0,
  `reason` int(11) NOT NULL DEFAULT 0,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.drop_count: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.entitydata
CREATE TABLE IF NOT EXISTS `entitydata` (
  `dkey` varchar(100) NOT NULL,
  `dvalue` longtext DEFAULT NULL,
  PRIMARY KEY (`dkey`),
  KEY `dkey` (`dkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.entitydata: ~58 rows (aproximadamente)
INSERT INTO `entitydata` (`dkey`, `dvalue`) VALUES
	('Permissions:Admin', '[]'),
	('Permissions:Amarelos', '[]'),
	('Permissions:Azuis', '[]'),
	('Permissions:Bahamas', '[]'),
	('Permissions:Ballas', '[]'),
	('Permissions:Barragem', '[]'),
	('Permissions:Bellagio', '[]'),
	('Permissions:Bennys', '[]'),
	('Permissions:Blacks', '[]'),
	('Permissions:Bloods', '[]'),
	('Permissions:Brancos', '[]'),
	('Permissions:Cartel', '[]'),
	('Permissions:China', '[]'),
	('Permissions:Cinzas', '[]'),
	('Permissions:Crips', '[]'),
	('Permissions:Desempregado', '[]'),
	('Permissions:DriftKing', '[]'),
	('Permissions:Forza', '[]'),
	('Permissions:Franca', '[]'),
	('Permissions:Galaxy', '[]'),
	('Permissions:Gringa', '[]'),
	('Permissions:Groove', '[]'),
	('Permissions:HellsAngels', '[]'),
	('Permissions:Israel', '[]'),
	('Permissions:Italia', '[]'),
	('Permissions:Juridico', '[]'),
	('Permissions:Lancamento', '[]'),
	('Permissions:Laranjas', '[]'),
	('Permissions:Luxor', '[]'),
	('Permissions:Marrons', '[]'),
	('Permissions:Mechanic', '[]'),
	('Permissions:Mercenarios', '[]'),
	('Permissions:Mexico', '[]'),
	('Permissions:Outlaws', '[]'),
	('Permissions:Overdrive', '[]'),
	('Permissions:Palazzo', '[]'),
	('Permissions:Paramedic', '[]'),
	('Permissions:Playboy', '[]'),
	('Permissions:Policia', '[]'),
	('Permissions:Redline', '[]'),
	('Permissions:Restaurante', '[]'),
	('Permissions:Rosas', '[]'),
	('Permissions:Roxos', '[]'),
	('Permissions:Russia', '[]'),
	('Permissions:Sinaloa', '[]'),
	('Permissions:Sindicato', '[]'),
	('Permissions:SonsofAnarchy', '[]'),
	('Permissions:TESTE1', '[]'),
	('Permissions:TESTE2', '[]'),
	('Permissions:TopGear', '[]'),
	('Permissions:Triade', '[]'),
	('Permissions:Umbrella', '[]'),
	('Permissions:Vagos', '[]'),
	('Permissions:Vanilla', '[]'),
	('Permissions:Verdes', '[]'),
	('Permissions:Vermelhos', '[]'),
	('Permissions:Warlocks', '[]'),
	('Permissions:Yakuza', '[]');

-- Copiando estrutura para tabela cidadesanta.fidentity
CREATE TABLE IF NOT EXISTS `fidentity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `name2` varchar(50) NOT NULL DEFAULT '',
  `port` int(1) NOT NULL DEFAULT 1,
  `blood` int(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.fidentity: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.fines
CREATE TABLE IF NOT EXISTS `fines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Passport` int(10) NOT NULL DEFAULT 0,
  `Name` varchar(50) NOT NULL,
  `Date` varchar(50) NOT NULL,
  `Hour` varchar(50) NOT NULL,
  `Value` int(11) NOT NULL,
  `Message` longtext DEFAULT NULL,
  `mdt` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`),
  KEY `id` (`id`),
  CONSTRAINT `fines_Passport_FK` FOREIGN KEY (`Passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.fines: ~0 rows (aproximadamente)

-- Copiando estrutura para função cidadesanta.generate_discord_token
DELIMITER //
CREATE FUNCTION `generate_discord_token`() RETURNS char(8) CHARSET utf8mb4 COLLATE utf8mb4_general_ci
    DETERMINISTIC
RETURN LEFT(UPPER(MD5(RAND())), 4)//
DELIMITER ;

-- Copiando estrutura para tabela cidadesanta.global_banned
CREATE TABLE IF NOT EXISTS `global_banned` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(250) DEFAULT NULL,
  `reason` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `license` (`license`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela cidadesanta.global_banned: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.groups
CREATE TABLE IF NOT EXISTS `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`group`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=529 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.groups: ~176 rows (aproximadamente)
INSERT INTO `groups` (`id`, `group`) VALUES
	(1, 'Abuser'),
	(2, 'Acoes'),
	(3, 'Admin'),
	(4, 'AlcateiaHsT'),
	(5, 'Aliado'),
	(6, 'Amarelos'),
	(7, 'Ammogroup'),
	(8, 'Azuis'),
	(9, 'Bahamas'),
	(10, 'Ballas'),
	(11, 'Barragem'),
	(12, 'Bellagio'),
	(13, 'Bennys'),
	(14, 'Black'),
	(15, 'Blacks'),
	(16, 'Bloco01'),
	(17, 'Bloco02'),
	(18, 'Bloco03'),
	(19, 'Bloco04'),
	(20, 'Bloco05'),
	(21, 'Bloods'),
	(22, 'BolsaFamilia'),
	(23, 'Bombeiros'),
	(24, 'Bopegg'),
	(25, 'Brancos'),
	(26, 'Bronze'),
	(27, 'Cartel'),
	(28, 'China'),
	(29, 'Cinzas'),
	(30, 'ClienteBlack'),
	(31, 'ClienteEspecial'),
	(32, 'Comercial'),
	(33, 'Crips'),
	(34, 'Desempregado'),
	(35, 'Diamante'),
	(36, 'Dismantle'),
	(37, 'DriftKing'),
	(38, 'Emergency'),
	(39, 'Esmeralda'),
	(40, 'Especial'),
	(41, 'Eventos'),
	(42, 'Festeiro'),
	(43, 'Forza'),
	(44, 'Franca'),
	(45, 'Gringa'),
	(46, 'Groove'),
	(47, 'HellsAngels'),
	(48, 'Helper'),
	(49, 'Iate01'),
	(50, 'Iate02'),
	(51, 'Ilegal'),
	(52, 'Influ'),
	(53, 'Influencer'),
	(54, 'Influenciador'),
	(55, 'InfluenciadorVerificado'),
	(56, 'Iniciante'),
	(57, 'Israel'),
	(58, 'Italia'),
	(59, 'Juridico'),
	(60, 'LaMafia'),
	(61, 'Lancamento'),
	(62, 'Laranjas'),
	(63, 'Laundry'),
	(64, 'LosAztecas'),
	(65, 'Luxor'),
	(66, 'Mansao01'),
	(67, 'Mansao02'),
	(68, 'Mansao03'),
	(69, 'Mansao04'),
	(70, 'Mansao05'),
	(71, 'Mansao06'),
	(72, 'Mansao07'),
	(73, 'Mansao08'),
	(74, 'Mansao09'),
	(75, 'Mansao10'),
	(76, 'Mansao11'),
	(77, 'Mansao12'),
	(78, 'Mansao13'),
	(79, 'Mansao14'),
	(80, 'Mansao15'),
	(81, 'Mansao16'),
	(82, 'Mansao17'),
	(83, 'Mansao18'),
	(84, 'Mansao19'),
	(85, 'Mansao20'),
	(86, 'Mansao21'),
	(87, 'Mansao22'),
	(88, 'Mansao23'),
	(89, 'Mansao24'),
	(90, 'Mansao25'),
	(91, 'Mansao26'),
	(92, 'Mansao27'),
	(93, 'Mansao28'),
	(94, 'Mansao29'),
	(95, 'Mansao30'),
	(96, 'Mansao31'),
	(97, 'Mansao32'),
	(98, 'Mansao33'),
	(99, 'Mansao34'),
	(100, 'Mansao35'),
	(101, 'Mansao36'),
	(102, 'Mansao37'),
	(103, 'Mansao38'),
	(104, 'Mansao39'),
	(105, 'Mansao40'),
	(106, 'Mansao41'),
	(107, 'Mansao42'),
	(108, 'Mansao43'),
	(109, 'Mansao44'),
	(110, 'Mansao45'),
	(111, 'Mansao46'),
	(112, 'Mansao47'),
	(113, 'Mansao48'),
	(114, 'Mansao49'),
	(115, 'Mansao50'),
	(116, 'Mansao51'),
	(117, 'Mansao52'),
	(118, 'Mansao53'),
	(119, 'Mansao54'),
	(120, 'Mansao55'),
	(121, 'Mansao56'),
	(122, 'Mansao57'),
	(123, 'Marrons'),
	(124, 'Mechanic'),
	(125, 'Mercenarios'),
	(126, 'Mexico'),
	(127, 'Natal'),
	(128, 'Noticia'),
	(129, 'Ouro'),
	(130, 'Outlaws'),
	(131, 'Overdrive'),
	(132, 'Palazzo'),
	(133, 'Paramedic'),
	(134, 'Platina'),
	(135, 'Playboy'),
	(136, 'Policia'),
	(137, 'Prata'),
	(138, 'Premium'),
	(139, 'Putaria'),
	(140, 'QA'),
	(141, 'Redline'),
	(142, 'Rosas'),
	(143, 'Roupas2'),
	(144, 'Roxos'),
	(145, 'Rubi'),
	(146, 'Russia'),
	(147, 'SS'),
	(148, 'SalarioAvançado'),
	(149, 'SalarioBrabo'),
	(150, 'SalarioDosDeuses'),
	(151, 'SalarioIniciante'),
	(152, 'SalarioMediano'),
	(153, 'cidadesanta'),
	(154, 'Sinaloa'),
	(155, 'Sindicato'),
	(156, 'SonsofAnarchy'),
	(157, 'Spotify'),
	(158, 'TESTE1'),
	(159, 'TESTE2'),
	(160, 'TopGear'),
	(161, 'Triade'),
	(162, 'Tropadu7'),
	(163, 'Tutor'),
	(164, 'Umbrella'),
	(165, 'Vagos'),
	(166, 'Verdes'),
	(167, 'Verificado'),
	(168, 'Vermelhos'),
	(169, 'VipLancamento'),
	(170, 'VipSorteio'),
	(171, 'Wall'),
	(172, 'Wallg'),
	(173, 'Warlocks'),
	(174, 'Yakuza'),
	(175, 'garagempanamera'),
	(176, 'kitiniciante');

-- Copiando estrutura para tabela cidadesanta.gungame_ranking
CREATE TABLE IF NOT EXISTS `gungame_ranking` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) NOT NULL DEFAULT 0,
  `wins` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `gungame_ranking_passport_FK` (`passport`),
  CONSTRAINT `gungame_ranking_passport_FK` FOREIGN KEY (`passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.gungame_ranking: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.hire_history
CREATE TABLE IF NOT EXISTS `hire_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group` varchar(50) DEFAULT NULL,
  `recruited` int(11) DEFAULT NULL,
  `recruiter` int(11) DEFAULT NULL,
  `newbie` tinyint(1) NOT NULL DEFAULT 0,
  `date` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `group` (`group`),
  KEY `hire_history_recruited_FK` (`recruited`),
  KEY `hire_history_recruiter_FK` (`recruiter`),
  CONSTRAINT `hire_history_recruited_FK` FOREIGN KEY (`recruited`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `hire_history_recruiter_FK` FOREIGN KEY (`recruiter`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.hire_history: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.hub_news
CREATE TABLE IF NOT EXISTS `hub_news` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `subtitle` varchar(255) DEFAULT NULL,
  `previewImage` longtext DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `author` int(11) NOT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.hub_news: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.hydrus_credits
CREATE TABLE IF NOT EXISTS `hydrus_credits` (
  `player_id` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `amount` int(11) DEFAULT 0,
  PRIMARY KEY (`player_id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela cidadesanta.hydrus_credits: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.hydrus_scheduler
CREATE TABLE IF NOT EXISTS `hydrus_scheduler` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `player_id` varchar(100) NOT NULL,
  `command` varchar(100) NOT NULL,
  `args` varchar(4096) NOT NULL,
  `execute_at` bigint(20) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `player_index` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela cidadesanta.hydrus_scheduler: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.icr
CREATE TABLE IF NOT EXISTS `icr` (
  `amount` int(6) NOT NULL DEFAULT 0,
  `date` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.icr: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.info_new_player
CREATE TABLE IF NOT EXISTS `info_new_player` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.info_new_player: ~9 rows (aproximadamente)
INSERT INTO `info_new_player` (`id`, `name`) VALUES
	(1, 'Connect'),
	(2, 'Spawn'),
	(3, 'Second Login'),
	(4, 'Activation'),
	(5, 'Pier'),
	(6, 'Quit'),
	(7, 'First Reward BattlePas'),
	(8, 'Finish BattlePass'),
	(9, 'VIP Store');

-- Copiando estrutura para tabela cidadesanta.investments
CREATE TABLE IF NOT EXISTS `investments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Passport` int(10) NOT NULL DEFAULT 0,
  `Liquid` int(20) NOT NULL DEFAULT 0,
  `Monthly` int(20) NOT NULL DEFAULT 0,
  `Deposit` int(20) NOT NULL DEFAULT 0,
  `Last` int(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`),
  KEY `id` (`id`),
  CONSTRAINT `investments_Passport_FK` FOREIGN KEY (`Passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.investments: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.invoices
CREATE TABLE IF NOT EXISTS `invoices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Passport` int(10) NOT NULL DEFAULT 0,
  `Received` int(10) NOT NULL DEFAULT 0,
  `Type` varchar(50) NOT NULL,
  `Reason` longtext NOT NULL,
  `Holder` varchar(50) NOT NULL,
  `Value` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.invoices: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.item_list
CREATE TABLE IF NOT EXISTS `item_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item` varchar(255) DEFAULT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Type` varchar(255) DEFAULT NULL,
  `Weight` float DEFAULT NULL,
  `Block` tinyint(1) DEFAULT NULL,
  `Economy` int(11) DEFAULT NULL,
  `Class` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `item` (`item`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1336 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.item_list: ~445 rows (aproximadamente)
INSERT INTO `item_list` (`id`, `item`, `Name`, `Type`, `Weight`, `Block`, `Economy`, `Class`) VALUES
	(1, 'donut', 'Rosquinha', 'Usável', 0.25, 0, 15, 'Comida'),
	(2, 'spray04', 'Desodorante 72hrs', 'Comum', 0.35, 0, 75, 'Utilitarios'),
	(3, 'pizzamozzarella', 'Pizza de Muçarela', 'Usável', 0.75, 0, 150, 'Comida'),
	(4, 'evidence02', 'Evidência', 'Usável', 0.25, 0, 0, 'Utilitarios'),
	(5, 'spray01', 'Desodorante 24hrs', 'Comum', 0.35, 0, 75, 'Utilitarios'),
	(6, 'cotton', 'Algodão', 'Comum', 0.35, 0, 45, 'Utilitarios'),
	(7, 'premium01', 'VIP Diamante', 'Usável', 0.15, 1, 300000, 'Premium'),
	(8, 'propertys', 'Cartão de Segurança', 'Comum', 0.35, 0, 0, 'Utilitarios'),
	(9, 'premium05', 'VIP Bronze', 'Usável', 0.15, 1, 150000, 'Premium'),
	(10, 'WEAPON_RAYCARBINE', 'RPG', 'Armamento', 3.75, 0, 775, 'Armas'),
	(11, 'racetrophy', 'Troféu', 'Comum', 1.25, 0, 2250, 'Utilitarios'),
	(12, 'esqueleto', 'Esqueleto', 'Usável', 2, 0, 0, 'Utilitarios'),
	(13, 'vipsorteio', 'VIP Sorteio', 'Usável', 0.15, 1, 200000, 'Premium'),
	(14, 'rainha', 'Rainha', 'Usável', 2, 0, 0, 'Utilitarios'),
	(15, 'card02', 'Cartão In-Comum', 'Comum', 0.25, 0, 325, 'Utilitarios'),
	(16, 'shrimp', 'Camarão', 'Comum', 0.5, 0, 14, 'Utilitarios'),
	(17, 'WEAPON_PISTOL_AMMO', 'M. Pistola', 'Munição', 0.001, 0, 50, 'Armas'),
	(18, 'WEAPON_RPG_AMMO', 'M. RPG', 'Munição', 0.001, 0, 30, 'Armas'),
	(19, 'engined', 'Motor', 'Usável', 12.25, 0, 0, 'Utilitarios'),
	(20, 'premium04', 'VIP Prata', 'Usável', 0.15, 1, 150000, 'Premium'),
	(21, 'graos', 'Graos ', 'Usável', 0.25, 0, 1000, 'Comida'),
	(22, 'WEAPON_CROWBAR', 'Pé de Cabra', 'Armamento', 1.35, 0, 725, 'Armas'),
	(23, 'creditcard', 'Cartão de Crédito', 'Comum', 0.25, 0, 0, 'Utilitarios'),
	(24, 'docefantasma', 'Doce Fantasma', 'Usável', 2, 0, 0, 'Utilitarios'),
	(25, 'playstation', 'Playstation', 'Comum', 1.25, 0, 75, 'Utilitarios'),
	(26, 'braked', 'Freios', 'Usável', 10.25, 0, 0, 'Utilitarios'),
	(27, 'cigarette', 'Cigarro', 'Usável', 0.15, 0, 10, 'Utilitarios'),
	(28, 'acetone', 'Acetona', 'Comum', 0.01, 0, 40, 'Drogas'),
	(29, 'packbasic', 'Pack de Armas - Basic', 'Usável', 0.35, 1, 2250, 'Premium'),
	(30, 'WEAPON_TACTICALRIFLE', 'M16', 'Armamento', 0.6, 0, 250000, 'Armas'),
	(31, 'ferro', 'Ferro', 'Comum', 0, 0, 0, 'Utilitarios'),
	(32, 'codeine', 'Codeína', 'Comum', 0.1, 0, 10000, 'Drogas'),
	(33, 'emptybottle', 'Garrafa Vazia', 'Comum', 0.15, 0, 30, 'Utilitarios'),
	(34, 'vehkey', 'Chave Cópia', 'Usável', 0.75, 0, 0, 'Utilitarios'),
	(35, 'soda', 'Sprunk', 'Usável', 0.25, 0, 15, 'Comida'),
	(36, 'pizzathis1', 'Copo de Suco', 'Comum', 0.25, 0, 10, 'Comida'),
	(37, 'WEAPON_RAYPISTOL', 'RPG', 'Armamento', 3.75, 0, 775, 'Armas'),
	(38, 'money5', '10 milhões de Dollars', 'Usável', 0.35, 1, 2250, 'Premium'),
	(39, 'repairkit03', 'Kit de Reparos - Épico', 'Comum', 1.25, 0, 7250, 'Utilitarios'),
	(40, 'repairkit04', 'Kit de Reparos - Lendário', 'Comum', 1.75, 0, 16000, 'Utilitarios'),
	(41, 'mulherfrank', 'Mulher Frank', 'Usável', 2, 0, 0, 'Utilitarios'),
	(42, 'handcuff', 'Algemas', 'Usável', 1.25, 0, 5750, 'Utilitarios'),
	(43, 'sheetmetal', 'Chapa de Metal', 'Comum', 0.75, 0, 50, 'Utilitarios'),
	(44, 'credential', 'Credencial', 'Comum', 0.75, 0, 1000, 'Utilitarios'),
	(45, 'WEAPON_RPG', 'RPG', 'Armamento', 3.75, 0, 775, 'Armas'),
	(46, 'suspensiond', 'Suspensão', 'Usável', 10.25, 0, 0, 'Utilitarios'),
	(47, 'blocksignal', 'Bloqueador de Sinal', 'Usável', 0.75, 0, 325, 'Utilitarios'),
	(48, 'soap', 'Sabonete', 'Usável', 0.25, 0, 75, 'Utilitarios'),
	(49, 'milhodoce', 'Milho doce', 'Usável', 2, 0, 0, 'Utilitarios'),
	(50, 'burgershot2', 'Caixa de Lanche', 'Comum', 0.25, 0, 10, 'Comida'),
	(51, 'bolsadesangue', 'Bolsa de Sangue', 'Usável', 0.35, 0, 200000, 'Utilitarios'),
	(52, 'paper', 'Papel', 'Comum', 0.15, 0, 120, 'Utilitarios'),
	(53, 'uwucoffee1', 'Copo de Suco', 'Comum', 0.25, 0, 10, 'Comida'),
	(54, 'newchars', '+1 Personagem', 'Usável', 0.25, 1, 150000, 'Premium'),
	(55, 'money3', '10 milhões de Dollars', 'Usável', 0.35, 1, 2250, 'Premium'),
	(56, 'heman', 'Heman', 'Usável', 2, 0, 0, 'Utilitarios'),
	(57, 'advrem', 'Remover ADV', 'Usável', 0.35, 1, 2250, 'Premium'),
	(58, 'silvercoin', 'Moeda de Prata', 'Usável', 0.05, 0, 20, 'Utilitarios'),
	(59, 'badge01', 'Distintivo', 'Usável', 0.75, 1, 10, 'Utilitarios'),
	(60, 'WEAPON_GRENADELAUNCHER', 'RPG', 'Armamento', 3.75, 0, 775, 'Armas'),
	(61, 'evidence03', 'Evidência', 'Usável', 0.25, 0, 0, 'Utilitarios'),
	(62, 'enginec', 'Motor', 'Usável', 11.25, 0, 0, 'Utilitarios'),
	(63, 'dismantle', 'Contrato', 'Usável', 0.75, 0, 125, 'Utilitarios'),
	(64, 'WEAPON_MACHETE', 'Facão', 'Armamento', 1.35, 0, 15000, 'Armas'),
	(65, 'applelove', 'Maça do Amor', 'Usável', 0.55, 0, 75, 'Comida'),
	(66, 'fan', 'Ventilador', 'Comum', 1.15, 0, 75, 'Utilitarios'),
	(67, 'hennessy', 'Hennessy', 'Usável', 0.55, 0, 15, 'Comida'),
	(68, 'changesexm', 'Criação de Personagem', 'Usável', 15, 1, 0, 'Premium'),
	(69, 'WEAPON_FLASHLIGHT', 'Lanterna', 'Armamento', 1.15, 0, 15000, 'Armas'),
	(70, 'sugar', 'Açucar', 'Comum', 0.15, 0, 5, 'Comida'),
	(71, 'backcyclist', 'Mochila de Ciclista', 'Usável', 1.25, 0, 100000, 'Utilitarios'),
	(72, 'tacos', 'Tacos', 'Usável', 0.25, 0, 25, 'Comida'),
	(73, 'medkit', 'Kit Médico', 'Usável', 0.75, 0, 575, 'Medicamentos'),
	(74, 'WEAPON_BULLPUPRIFLE', 'QBZ-95', 'Armamento', 0.6, 0, 250000, 'Armas'),
	(75, 'WEAPON_SMG_AMMO', 'M. Sub', 'Munição', 0.001, 0, 60, 'Armas'),
	(76, 'skate', 'Skate', 'Usável', 2, 0, 0, 'Utilitarios'),
	(77, 'amethyst', 'Ametista', 'Comum', 0.75, 0, 35, 'Utilitarios'),
	(78, 'uwucoffee4', 'Combo + Brinquedo', 'Comum', 1.25, 0, 270, 'Comida'),
	(79, 'fries', 'Fritas', 'Usável', 0.25, 0, 125, 'Comida'),
	(80, 'card04', 'Cartão Raro', 'Comum', 0.25, 0, 275, 'Utilitarios'),
	(81, 'WEAPON_SNSPISTOL_MK2', 'HK P7M10', 'Armamento', 0.6, 0, 125000, 'Armas'),
	(82, 'album', 'Álbum da Copa', 'Usável', 2, 0, 0, 'Utilitarios'),
	(83, 'cokeleaf', 'Folha de Coca', 'Comum', 0.01, 0, 5, 'Drogas'),
	(84, 'valecasa', 'Vale Casa', 'Comum', 0, 0, 0, 'Premium'),
	(85, 'money2', '25 milhões de Dollars', 'Usável', 0.35, 1, 2250, 'Premium'),
	(86, 'brakea', 'Freios', 'Usável', 7.25, 0, 0, 'Utilitarios'),
	(87, 'syringe03', 'Seringa A-', 'Comum', 0.25, 0, 10, 'Utilitarios'),
	(88, 'weedclone', 'Clonagem de Maconha', 'Usável', 0.15, 0, 0, 'Drogas'),
	(89, 'burgershot3', 'Combo', 'Comum', 1.25, 0, 120, 'Comida'),
	(90, 'c4', 'C4', 'Usável', 1.75, 0, 625, 'Utilitarios'),
	(91, 'WEAPON_MOLOTOV', 'Coquetel Molotov', 'Throwing', 0.95, 0, 225, 'Armas'),
	(92, 'floppy', 'Disquete', 'Comum', 0.15, 0, 45, 'Utilitarios'),
	(93, 'burgershot4', 'Combo + Brinquedo', 'Comum', 1.25, 0, 270, 'Comida'),
	(94, 'lockpick', 'Lockpick de Alumínio', 'Usável', 1.25, 0, 425, 'Utilitarios'),
	(95, 'cocaine', 'Coca', 'Usável', 0.01, 0, 10000, 'Drogas'),
	(96, 'gemstone', 'Gemstone', 'Usável', 0.15, 0, 2000, 'Premium'),
	(97, 'pendrive', 'Pendrive', 'Comum', 0.75, 0, 325, 'Utilitarios'),
	(98, 'spray03', 'Desodorante 48hrs', 'Comum', 0.35, 0, 75, 'Utilitarios'),
	(99, 'slipper', 'Chinelo', 'Comum', 0.35, 0, 75, 'Utilitarios'),
	(100, 'WEAPON_SMG_MK2', 'Evo-3', 'Armamento', 0.6, 0, 190000, 'Armas'),
	(101, 'pliers', 'Alicate', 'Comum', 0.75, 0, 55, 'Utilitarios'),
	(102, 'battery', 'Pilhas', 'Comum', 0.35, 0, 90, 'Utilitarios'),
	(103, 'deck', 'Baralho', 'Usável', 0.25, 0, 75, 'Utilitarios'),
	(104, 'gamebooster', 'Game booster', 'Usável', 0.25, 0, 100, 'Comida'),
	(105, 'rimel', 'Rímel', 'Comum', 0.35, 0, 75, 'Utilitarios'),
	(106, 'WEAPON_SAWNOFFSHOTGUN', 'Mossberg 500', 'Armamento', 0.6, 0, 190000, 'Armas'),
	(107, 'domino', 'Dominó', 'Comum', 0.15, 0, 45, 'Utilitarios'),
	(108, 'suspensione', 'Suspensão', 'Usável', 11.25, 0, 0, 'Utilitarios'),
	(109, 'WEAPON_PUMPSHOTGUN', 'Mossberg 590', 'Armamento', 0.6, 0, 250000, 'Armas'),
	(110, 'transmissionc', 'Transmissão', 'Usável', 11.25, 0, 0, 'Utilitarios'),
	(111, 'ominitrix', 'Ominitrix', 'Comum', 0.75, 0, 75, 'Utilitarios'),
	(112, 'WEAPON_HATCHET', 'Machado', 'Armamento', 1.75, 0, 15000, 'Armas'),
	(113, 'switch', 'Interruptor', 'Comum', 0.35, 0, 45, 'Utilitarios'),
	(114, 'blender', 'Liquidificador', 'Usável', 0.75, 0, 75, 'Utilitarios'),
	(115, 'hood', 'Capuz', 'Usável', 1.75, 0, 5750, 'Utilitarios'),
	(116, 'pan', 'Panela', 'Usável', 0.55, 0, 100, 'Utilitarios'),
	(117, 'syringe04', 'Seringa B-', 'Comum', 0.25, 0, 10, 'Utilitarios'),
	(118, 'dish', 'Prato', 'Comum', 0.55, 0, 75, 'Utilitarios'),
	(119, 'WEAPON_COMPACTRIFLE', 'AK Compact', 'Armamento', 0.6, 0, 250000, 'Armas'),
	(120, 'namechange', 'Troca de Nome', 'Usável', 0.25, 1, 100000, 'Premium'),
	(121, 'transmissiona', 'Transmissão', 'Usável', 9.25, 0, 0, 'Utilitarios'),
	(122, 'WEAPON_PISTOL_MK2', 'FN Five Seven', 'Armamento', 0.6, 0, 125000, 'Armas'),
	(123, 'cappuccino', 'Cappuccino', 'Usável', 0.65, 0, 150, 'Comida'),
	(124, 'spray02', 'Antisséptico', 'Comum', 0.35, 0, 75, 'Utilitarios'),
	(125, 'saline', 'Soro Fisiológico', 'Comum', 0.01, 0, 25, 'Drogas'),
	(126, 'dildo', 'Vibrador', 'Comum', 0.45, 0, 75, 'Utilitarios'),
	(127, 'bracelet', 'Bracelete', 'Comum', 0.55, 0, 75, 'Utilitarios'),
	(128, 'vest', 'Colete', 'Usável', 0.25, 0, 1500, 'Utilitarios'),
	(129, 'brush', 'Escova', 'Comum', 0.25, 0, 75, 'Utilitarios'),
	(130, 'premiumplate', 'Placa Personalizada', 'Usável', 0.75, 1, 100000, 'Premium'),
	(131, 'xbox', 'Xbox', 'Comum', 1.25, 0, 75, 'Utilitarios'),
	(132, 'watch', 'Relógio', 'Comum', 0.75, 0, 75, 'Utilitarios'),
	(133, 'pizzathis2', 'Caixa de Lanche', 'Comum', 0.25, 0, 10, 'Comida'),
	(134, 'transmissiond', 'Transmissão', 'Usável', 12.25, 0, 0, 'Utilitarios'),
	(135, 'binoculars', 'Binóculos', 'Usável', 0.75, 0, 275, 'Utilitarios'),
	(136, 'goldring', 'Anel de Ouro', 'Comum', 0.45, 0, 100, 'Utilitarios'),
	(137, 'uwucoffee3', 'Combo', 'Comum', 1.25, 0, 120, 'Comida'),
	(138, 'camera', 'Câmera', 'Usável', 1.25, 0, 275, 'Utilitarios'),
	(139, 'repairkit02', 'Kit de Reparos - Raro', 'Comum', 3.75, 0, 3250, 'Utilitarios'),
	(140, 'et', 'ET', 'Usável', 2, 0, 0, 'Utilitarios'),
	(141, 'silverring', 'Anel de Prata', 'Comum', 0.35, 0, 75, 'Utilitarios'),
	(142, 'attachsGrip', 'Empunhadura', 'Usável', 1.15, 0, 1750, 'Utilitarios'),
	(143, 'rubber', 'Borracha', 'Comum', 0.05, 0, 20, 'Utilitarios'),
	(144, 'mouse', 'Mouse', 'Comum', 0.55, 0, 75, 'Utilitarios'),
	(145, 'alvejantegrande', 'Alvejante Grande', 'Comum', 0.95, 0, 625, 'Drogas'),
	(146, 'kitmafioso', 'Kit Mafioso', 'Usável', 0.15, 1, 150000, 'Premium'),
	(147, 'repairkit01', 'Kit de Reparos - Comum', 'Comum', 1.25, 0, 550, 'Utilitarios'),
	(148, 'pickaxe', 'Picareta', 'Comum', 1.25, 0, 525, 'Utilitarios'),
	(149, 'enginee', 'Motor', 'Usável', 13.25, 0, 0, 'Utilitarios'),
	(150, 'teddy', 'Teddy', 'Usável', 1.25, 0, 75, 'Utilitarios'),
	(151, 'medicbag', 'Bolsa Médica', 'Usável', 1.75, 0, 425, 'Utilitarios'),
	(152, 'radio', 'Rádio', 'Usável', 0.75, 0, 975, 'Utilitarios'),
	(153, 'WEAPON_NIGHTSTICK', 'Cassetete', 'Armamento', 1.15, 0, 125, 'Armas'),
	(154, 'amber', 'Âmbar', 'Comum', 0.75, 0, 25, 'Utilitarios'),
	(155, 'sapphire', 'Safira', 'Comum', 0.85, 0, 45, 'Utilitarios'),
	(156, 'polvora', 'Polvora', 'Comum', 0.01, 0, 625, 'Armas'),
	(157, 'orangejuice', 'Suco de Laranja', 'Usável', 0.75, 0, 100, 'Comida'),
	(158, 'ruby', 'Rubi', 'Comum', 0.85, 0, 55, 'Utilitarios'),
	(159, 'plaster', 'Esparadrapo', 'Comum', 0.45, 0, 35, 'Utilitarios'),
	(160, 'brakee', 'Freios', 'Usável', 11.25, 0, 0, 'Utilitarios'),
	(161, 'pizzachocolate', 'Pizza de Chocolate', 'Usável', 0.75, 0, 150, 'Comida'),
	(162, 'notebook', 'Notebook', 'Usável', 1.25, 0, 4250, 'Utilitarios'),
	(163, 'emerald', 'Esmeralda', 'Comum', 0.95, 0, 85, 'Utilitarios'),
	(164, 'sandwich', 'Sanduiche', 'Usável', 0.25, 0, 15, 'Comida'),
	(165, 'gsrkit', 'Kit Residual', 'Usável', 0.75, 0, 20, 'Utilitarios'),
	(166, 'gamebooster1', 'Game booster', 'Usável', 0.25, 0, 100, 'Comida'),
	(167, 'tambaqui', 'Tambaqui', 'Usável', 0.75, 0, 28, 'Utilitarios'),
	(168, 'dinheirosujo', 'Dinheiro Sujo', 'Comum', 0, 0, 1, 'Utilitarios'),
	(169, 'pizzabanana', 'Pizza de Banana', 'Usável', 0.75, 0, 150, 'Comida'),
	(170, 'backschool', 'Mochila de Escola', 'Usável', 1.25, 0, 100000, 'Utilitarios'),
	(171, 'enginea', 'Motor', 'Usável', 9.25, 0, 0, 'Utilitarios'),
	(172, 'firecracker', 'Fogos de Artificio', 'Usável', 1.25, 0, 100, 'Utilitarios'),
	(173, 'pager', 'Pager', 'Usável', 1.25, 0, 125, 'Utilitarios'),
	(174, 'GADGET_PARACHUTE', 'Paraquedas', 'Usável', 1.25, 0, 1000, 'Armas'),
	(175, 'grape', 'Uva', 'Usável', 0.25, 0, 10, 'Comida'),
	(176, 'vape', 'Vape', 'Usável', 0.75, 0, 4750, 'Utilitarios'),
	(177, 'WEAPON_SHOES', 'Tênis', 'Throwing', 0.755, 0, 25, 'Armas'),
	(178, 'glass', 'Vidro', 'Comum', 0.065, 0, 20, 'Utilitarios'),
	(179, 'copper', 'Cobre', 'Comum', 0.095, 0, 30, 'Utilitarios'),
	(180, 'kitdosraul', 'Kit dos Raul', 'Usável', 0.15, 1, 150000, 'Premium'),
	(181, 'syringe02', 'Seringa B+', 'Comum', 0.25, 0, 10, 'Utilitarios'),
	(182, 'attachsSilencer', 'Silenciador', 'Usável', 1.15, 0, 1750, 'Utilitarios'),
	(183, 'WEAPON_PETROLCAN_AMMO', 'Combustível', 'Munição', 0, 0, 0, 'Armas'),
	(184, 'glassbottle', 'Garrafa de Vidro', 'Comum', 0.45, 0, 60, 'Utilitarios'),
	(185, 'evidence01', 'Evidência', 'Usável', 0.25, 0, 0, 'Utilitarios'),
	(186, 'brakeb', 'Freios', 'Usável', 8.25, 0, 0, 'Utilitarios'),
	(187, 'phonechange', 'Número Personalizada', 'Usável', 0.75, 1, 100000, 'Premium'),
	(188, 'hotdog', 'Cachorro-Quente', 'Usável', 0.45, 0, 15, 'Comida'),
	(189, 'WEAPON_SHOTGUN_AMMO', 'M. Escopeta', 'Munição', 0.001, 0, 75, 'Armas'),
	(190, 'drugtoy', 'Brinquedo', 'Comum', 0.5, 0, 100, 'Utilitarios'),
	(191, 'tablemeth', 'Mesa de Criação', 'Usável', 12.75, 0, 1750, 'Drogas'),
	(192, 'alcohol', 'Álcool', 'Comum', 0.65, 0, 40, 'Drogas'),
	(193, 'bananajuice', 'Suco de Banana', 'Usável', 0.75, 0, 100, 'Comida'),
	(194, 'dollars', 'Dólares', 'Comum', 0, 0, 1, 'Utilitarios'),
	(195, 'WEAPON_NAIL_AMMO', 'M. Pregos', 'Munição', 0.004, 0, 2, 'Armas'),
	(196, 'pizzathis4', 'Combo + Brinquedo', 'Comum', 1.25, 0, 270, 'Comida'),
	(197, 'WEAPON_TECPISTOL', 'Tec M31', 'Armamento', 0.6, 0, 190000, 'Armas'),
	(198, 'WEAPON_STUNGUN', 'Tazer', 'Armamento', 0.75, 0, 525, 'Armas'),
	(199, 'money1', '50 milhões de Dollars', 'Usável', 0.35, 1, 2250, 'Premium'),
	(200, 'rose', 'Rosa', 'Usável', 0.25, 0, 25, 'Utilitarios'),
	(201, 'fidentity', 'Passaporte', 'Comum', 0.15, 0, 10000, 'Utilitarios'),
	(202, 'WEAPON_PETROLCAN', 'Galão', 'Armamento', 0.6, 0, 50, 'Armas'),
	(203, 'WEAPON_GUSENBERG', 'Thompson', 'Armamento', 0.6, 0, 250000, 'Armas'),
	(204, 'changesexf', 'Criação de Personagem', 'Usável', 15, 1, 0, 'Premium'),
	(205, 'plastic', 'Plástico', 'Comum', 0.065, 0, 20, 'Utilitarios'),
	(206, 'WEAPON_PUMPSHOTGUN_MK2', 'Mossberg 590A1', 'Armamento', 0.6, 0, 250000, 'Armas'),
	(207, 'WEAPON_SPECIALCARBINE_MK2', 'Sig Sauer 556', 'Armamento', 0.6, 0, 300000, 'Armas'),
	(208, 'elastic', 'Elástico', 'Comum', 0.25, 0, 60, 'Utilitarios'),
	(209, 'WEAPON_ASSAULTSMG', 'Steyr AUG', 'Armamento', 0.6, 0, 250000, 'Armas'),
	(210, 'WEAPON_SMOKEGRENADE', 'Granada de Fumaça', 'Throwing', 0.95, 0, 225, 'Armas'),
	(211, 'pacu', 'Pacu', 'Usável', 0.5, 0, 24, 'Utilitarios'),
	(212, 'sprays01', 'Spray', 'Usável', 0.75, 0, 0, 'Utilitarios'),
	(213, 'explosives', 'Explosivos', 'Comum', 0.55, 0, 75, 'Utilitarios'),
	(214, 'WEAPON_ASSAULTRIFLE', 'AK-103', 'Armamento', 0.6, 0, 250000, 'Armas'),
	(215, 'lampshade', 'Abajur', 'Comum', 0.75, 0, 75, 'Utilitarios'),
	(216, 'transmissionb', 'Transmissão', 'Usável', 10.25, 0, 0, 'Utilitarios'),
	(217, 'WEAPON_SMG', 'MP5', 'Armamento', 0.6, 0, 190000, 'Armas'),
	(218, 'WEAPON_MUSKET', 'Winchester 1892', 'Armamento', 0.6, 0, 3250, 'Armas'),
	(219, 'paramedicpass', 'Vale - Médico', 'Comum', 0.25, 0, 0, 'Utilitarios'),
	(220, 'WEAPON_HOMINGLAUNCHER', 'RPG', 'Armamento', 3.75, 0, 775, 'Armas'),
	(221, 'WEAPON_RAYMINIGUN', 'Ray MiniguN', 'Armamento', 3.75, 0, 775, 'Armas'),
	(222, 'WEAPON_MILITARYRIFLE', 'MTAR-21', 'Armamento', 0.6, 0, 250000, 'Armas'),
	(223, 'valemansao', 'Vale Mansão', 'Comum', 0, 0, 0, 'Premium'),
	(224, 'megaphone', 'Megafone', 'Usável', 0.01, 1, 0, 'Utilitarios'),
	(225, 'sushi', 'Sushi', 'Usável', 0.65, 0, 75, 'Comida'),
	(226, 'chickenfries', 'Frango Frito', 'Usável', 0.75, 0, 125, 'Comida'),
	(227, 'WEAPON_COMBATMG_MK2', 'M249', 'Armamento', 0.6, 0, 250000, 'Armas'),
	(228, 'WEAPON_SNIPERRIFLE', 'AWM Magnum', 'Armamento', 0.6, 0, 650000, 'Armas'),
	(229, 'pizzathispass', 'Vale - Pizza This', 'Comum', 0.25, 0, 0, 'Utilitarios'),
	(230, 'WEAPON_SPECIALCARBINE', 'G36C', 'Armamento', 0.6, 0, 250000, 'Armas'),
	(231, 'backalohomorawhite', 'Mochila Alohomora Branca', 'Usável', 1.25, 0, 150000, 'Utilitarios'),
	(232, 'switchblade', 'Canivete', 'Usável', 0.75, 0, 525, 'Utilitarios'),
	(233, 'fishingrod', 'Vara de Pescar', 'Usável', 1.75, 0, 725, 'Utilitarios'),
	(234, 'WEAPON_BULLPUPRIFLE_MK2', 'L85', 'Armamento', 0.6, 0, 250000, 'Armas'),
	(235, 'lighter', 'Isqueiro', 'Comum', 0.55, 0, 175, 'Utilitarios'),
	(236, 'kitfogueteiro', 'Kit Fogueteiro', 'Usável', 0.15, 1, 150000, 'Premium'),
	(237, 'WEAPON_M9A3', 'M9A3', 'Armamento', 0.6, 0, 125000, 'Armas'),
	(238, 'mechanicpass', 'Vale - Mecânico', 'Comum', 0.25, 0, 0, 'Utilitarios'),
	(239, 'advtoolbox', 'Kit de Reparo - Usado para reparar veículos quebrados.', 'Usável', 1.25, 0, 1525, 'Utilitarios'),
	(240, 'hamburger', 'Hambúrguer', 'Usável', 0.55, 0, 25, 'Comida'),
	(241, 'WEAPON_CARBINERIFLE', 'M4A1', 'Armamento', 0.6, 0, 250000, 'Armas'),
	(242, 'suspensiona', 'Suspensão', 'Usável', 7.25, 0, 0, 'Utilitarios'),
	(243, 'WEAPON_NSR', 'NSR', 'Armamento', 0.6, 0, 250000, 'Armas'),
	(244, 'WEAPON_COLTXM177', 'COLT XM177', 'Armamento', 0.6, 0, 250000, 'Armas'),
	(245, 'WEAPON_NAVYCARBINE', 'Navy Carbine', 'Armamento', 0.6, 0, 250000, 'Armas'),
	(246, 'WEAPON_SCARH', 'Scar-H', 'Armamento', 0.6, 0, 250000, 'Armas'),
	(247, 'uwucoffee2', 'Caixa de Lanche', 'Comum', 0.25, 0, 10, 'Comida'),
	(248, 'WEAPON_PARAFAL', 'PARA-FAL M964A1', 'Armamento', 0.6, 0, 250000, 'Armas'),
	(249, 'transmissione', 'Transmissão', 'Usável', 13.25, 0, 0, 'Utilitarios'),
	(250, 'keycard', 'Keycard', 'Comum', 0.95, 0, 625, 'Utilitarios'),
	(251, 'badge02', 'Distintivo', 'Usável', 0.75, 1, 10, 'Utilitarios'),
	(252, 'codfish', 'Bacalhau', 'Usável', 0.5, 0, 16, 'Utilitarios'),
	(253, 'WEAPON_COMBATPISTOL', 'Glock', 'Armamento', 0.6, 0, 125000, 'Armas'),
	(254, 'luckywheelpass', 'Vale - Roda da Fortuna', 'Comum', 0.25, 0, 5000, 'Utilitarios'),
	(255, 'WEAPON_PISTOL50', 'Desert Eagle', 'Armamento', 0.6, 0, 125000, 'Armas'),
	(256, 'WEAPON_VINTAGEPISTOL', 'M1922', 'Armamento', 0.6, 0, 125000, 'Armas'),
	(257, 'WEAPON_SNSPISTOL', 'AMT 380', 'Armamento', 0.6, 0, 125000, 'Armas'),
	(258, 'rolepass', 'cidadesantaPass Premium', 'Usável', 0.15, 1, 200000, 'Premium'),
	(259, 'WEAPON_CARBINERIFLE_MK2', 'M4A4', 'Armamento', 0.6, 0, 250000, 'Armas'),
	(260, 'WEAPON_MP9', 'MP9', 'Armamento', 0.6, 0, 190000, 'Armas'),
	(261, 'backrudolphred', 'Mochila Rudolph Vermelho', 'Usável', 1.25, 0, 150000, 'Utilitarios'),
	(262, 'WEAPON_MP5K', 'MP5K', 'Armamento', 0.6, 0, 190000, 'Armas'),
	(263, 'bandage', 'Bandagem', 'Usável', 0.25, 0, 15000, 'Medicamentos'),
	(264, 'orange', 'Laranja', 'Usável', 0.25, 0, 10, 'Comida'),
	(265, 'WEAPON_MINISMG', 'Skorpion V61', 'Armamento', 0.6, 0, 190000, 'Armas'),
	(266, 'geode', 'Geodo', 'Usável', 0.75, 0, 10, 'Utilitarios'),
	(267, 'WEAPON_MACHINEPISTOL', 'Tec-9', 'Armamento', 0.6, 0, 190000, 'Armas'),
	(268, 'WEAPON_NAILGUN', 'Arma de Prego', 'Armamento', 0.6, 0, 3250, 'Armas'),
	(269, 'WEAPON_MICROSMG', 'Uzi', 'Armamento', 0.6, 0, 190000, 'Armas'),
	(270, 'WEAPON_HEAVYPISTOL', 'Ati FX45', 'Armamento', 0.6, 0, 125000, 'Armas'),
	(271, 'marshmallow', 'Marshmallow', 'Usável', 0.25, 0, 35, 'Comida'),
	(272, 'tableweed', 'Mesa de Criação', 'Usável', 12.75, 0, 1750, 'Drogas'),
	(273, 'WEAPON_APPISTOL', 'Koch Vp9', 'Armamento', 0.6, 0, 125000, 'Armas'),
	(274, 'nigirizushi', 'Nigirizushi', 'Usável', 0.65, 0, 75, 'Comida'),
	(275, 'attachsCrosshair', 'Mira Holográfica', 'Usável', 1.15, 0, 1750, 'Utilitarios'),
	(276, 'dices', 'Dados', 'Usável', 0.35, 0, 45, 'Utilitarios'),
	(277, 'evidence04', 'Evidência', 'Usável', 0.25, 0, 0, 'Utilitarios'),
	(278, 'beanmachine3', 'Combo', 'Comum', 1.25, 0, 120, 'Comida'),
	(279, 'diagram', 'Diagrama', 'Comum', 0.75, 0, 0, 'Utilitarios'),
	(280, 'turquoise', 'Turquesa', 'Comum', 0.65, 0, 15, 'Utilitarios'),
	(281, 'strawberry', 'Morango', 'Usável', 0.25, 0, 10, 'Comida'),
	(282, 'attachsMagazine', 'Pente Estendido', 'Usável', 1.15, 0, 1750, 'Utilitarios'),
	(283, 'techtrash', 'Lixo Eletrônico', 'Comum', 0.75, 0, 125, 'Utilitarios'),
	(284, 'amphetamine', 'Anfetamina', 'Comum', 0.01, 0, 10000, 'Drogas'),
	(285, 'beanmachine1', 'Copo de Suco', 'Comum', 0.25, 0, 10, 'Comida'),
	(286, 'WEAPON_WRENCH', 'Chave Inglesa', 'Armamento', 1.45, 0, 725, 'Armas'),
	(287, 'tilapia', 'Tilápia', 'Usável', 0.25, 0, 14, 'Utilitarios'),
	(288, 'guarananatural', 'Guaraná Natural', 'Usável', 0.25, 0, 100, 'Comida'),
	(289, 'WEAPON_POOLCUE', 'Taco de Sinuca', 'Armamento', 1.25, 0, 15000, 'Armas'),
	(290, 'energetico', 'Energético ', 'Usável', 0.25, 0, 1000, 'Comida'),
	(291, 'oxy', 'Oxy', 'Usável', 0.25, 0, 35, 'Medicamentos'),
	(292, 'leather', 'Couro', 'Comum', 0.25, 0, 20, 'Utilitarios'),
	(293, 'scuba', 'Roupa de Mergulho', 'Usável', 4.75, 0, 975, 'Utilitarios'),
	(294, 'pirarucu', 'Pirarucu', 'Usável', 0.25, 0, 26, 'Utilitarios'),
	(295, 'WEAPON_GOLFCLUB', 'Taco de Golf', 'Armamento', 1.65, 0, 15000, 'Armas'),
	(296, 'capsula', 'Capsula', 'Comum', 0.01, 0, 0, 'Armas'),
	(297, 'burgershot1', 'Copo de Suco', 'Comum', 0.25, 0, 10, 'Comida'),
	(298, 'fishfillet', 'Filé de Peixe', 'Comum', 0.75, 0, 10, 'Comida'),
	(299, 'balinhas', 'Balinhas', 'Usável', 2, 0, 0, 'Utilitarios'),
	(300, 'packpremium', 'Pack de Armas - Premium', 'Usável', 0.35, 1, 2250, 'Premium'),
	(301, 'WEAPON_KARAMBIT', 'Karambit', 'Armamento', 1.25, 0, 75000, 'Armas'),
	(302, 'WEAPON_PISTOL', 'M1911', 'Armamento', 0.6, 0, 125000, 'Armas'),
	(303, 'WEAPON_BAT', 'Bastão de Beisebol', 'Armamento', 1.75, 0, 15000, 'Armas'),
	(304, 'backalohomorared', 'Mochila Alohomora Vermelha', 'Usável', 1.25, 0, 150000, 'Utilitarios'),
	(305, 'horseshoe', 'Ferradura', 'Comum', 0.45, 0, 75, 'Utilitarios'),
	(306, 'alvejantepequeno', 'Alvejante Pequeno ', 'Comum', 0.95, 0, 625, 'Drogas'),
	(307, 'goldbar', 'Barra de Ouro', 'Comum', 0.75, 0, 525, 'Utilitarios'),
	(308, 'barrier', 'Barreira', 'Usável', 1.75, 0, 250, 'Utilitarios'),
	(309, 'cupcake', 'Cupcake', 'Usável', 0.55, 0, 75, 'Comida'),
	(310, 'brakec', 'Freios', 'Usável', 9.25, 0, 0, 'Utilitarios'),
	(311, 'dewars', 'Dewars', 'Usável', 0.55, 0, 15, 'Comida'),
	(312, 'notepad', 'Bloco de Notas', 'Usável', 0.25, 0, 10, 'Utilitarios'),
	(313, 'beanmachine4', 'Combo + Brinquedo', 'Comum', 1.25, 0, 270, 'Comida'),
	(314, 'keyboard', 'Teclado', 'Comum', 0.75, 0, 75, 'Utilitarios'),
	(315, 'gdtkit', 'Kit Químico', 'Usável', 0.75, 0, 20, 'Utilitarios'),
	(316, 'chocolate', 'Chocolate', 'Usável', 0.15, 0, 15, 'Comida'),
	(317, 'kitboqueta', 'Kit Boqueta', 'Usável', 0.15, 1, 150000, 'Premium'),
	(318, 'plasticbottle', 'Garrafa Plástica', 'Comum', 0.25, 0, 60, 'Utilitarios'),
	(319, 'eraser', 'Apagador', 'Comum', 0.15, 0, 75, 'Utilitarios'),
	(320, 'WEAPON_ADVANCEDRIFLE', 'Tar-21', 'Armamento', 0.6, 0, 250000, 'Armas'),
	(321, 'uwucoffeepass', 'Vale - Uwu Café', 'Comum', 0.25, 0, 0, 'Utilitarios'),
	(322, 'tomato', 'Tomate', 'Usável', 0.25, 0, 10, 'Comida'),
	(323, 'passion', 'Maracujá', 'Usável', 0.25, 0, 10, 'Comida'),
	(324, 'canofbeans', 'Lata de Feijão', 'Usável', 0.75, 0, 55, 'Comida'),
	(325, 'ritmoneury', 'Ritmoneury', 'Usável', 0.75, 0, 475, 'Utilitarios'),
	(326, 'aluminum', 'Alumínio', 'Comum', 0.075, 0, 30, 'Utilitarios'),
	(327, 'WEAPON_SNOWBALL', 'Bola de Neve', 'Throwing', 0.55, 0, 6, 'Armas'),
	(328, 'coffee', 'Copo de Café', 'Usável', 0.25, 0, 20, 'Comida'),
	(329, 'cellphone', 'Celular', 'Comum', 0.75, 0, 300, 'Utilitarios'),
	(330, 'apple', 'Maça', 'Usável', 0.25, 0, 10, 'Comida'),
	(331, 'chiclete', 'Chiclete', 'Usável', 2, 0, 0, 'Utilitarios'),
	(332, 'chandon', 'Chandon', 'Usável', 0.55, 0, 15, 'Comida'),
	(333, 'syringe01', 'Seringa A+', 'Comum', 0.25, 0, 10, 'Utilitarios'),
	(334, 'frankenstein', 'Frankenstein', 'Usável', 2, 0, 0, 'Utilitarios'),
	(335, 'toolbox', 'Ferramentas Básicas', 'Usável', 1.25, 0, 625, 'Utilitarios'),
	(336, 'minhocadoce', 'Minhoca Doce', 'Usável', 2, 0, 0, 'Utilitarios'),
	(337, 'plate', 'Placa', 'Comum', 0.75, 0, 525, 'Utilitarios'),
	(338, 'WEAPON_MUSKET_AMMO', 'M. Mosquete', 'Munição', 0.004, 0, 7, 'Armas'),
	(339, 'WEAPON_HAMMER', 'Martelo', 'Armamento', 1.45, 0, 15000, 'Armas'),
	(340, 'diamond', 'Diamante', 'Comum', 0.95, 0, 75, 'Utilitarios'),
	(341, 'calzone', 'Calzone', 'Usável', 0.55, 0, 150, 'Comida'),
	(342, 'aboboradoce', 'Aboboradoce', 'Usável', 2, 0, 0, 'Utilitarios'),
	(343, 'card05', 'Cartão Lendário', 'Comum', 0.25, 0, 425, 'Utilitarios'),
	(344, 'lixo', 'Lixo', 'Usável', 2, 0, 0, 'Utilitarios'),
	(345, 'kitcriminal', 'Kit Criminal', 'Usável', 0.15, 1, 150000, 'Premium'),
	(346, 'pizzamushroom', 'Pizza de Cogumelo', 'Usável', 0.75, 0, 150, 'Comida'),
	(347, 'pistolbody', 'Corpo de Pistola', 'Comum', 0.75, 0, 425, 'Armas'),
	(348, 'sinkalmy', 'Sinkalmy', 'Usável', 0.75, 0, 375, 'Utilitarios'),
	(349, 'legos', 'Legos', 'Comum', 0.45, 0, 75, 'Utilitarios'),
	(350, 'cookedfishfillet', 'Filé de Peixe Cozido', 'Usável', 0.55, 0, 35, 'Comida'),
	(351, 'prisaorem', 'Remover Prisao', 'Usável', 0.35, 1, 2250, 'Premium'),
	(352, 'backalohomorablack', 'Mochila Alohomora Preta', 'Usável', 1.25, 0, 150000, 'Utilitarios'),
	(353, 'packelite', 'Pack de Armas - Elite', 'Usável', 0.35, 1, 2250, 'Premium'),
	(354, 'WEAPON_BATTLEAXE', 'Machado de Batalha', 'Armamento', 1.75, 0, 15000, 'Armas'),
	(355, 'tablecoke', 'Mesa de Criação', 'Usável', 12.75, 0, 1750, 'Drogas'),
	(356, 'cannedsoup', 'Sopa em Lata', 'Usável', 0.75, 0, 55, 'Comida'),
	(357, 'ketchup', 'Ketchup', 'Comum', 0.75, 0, 75, 'Comida'),
	(358, 'bread', 'Pão', 'Comum', 0.25, 0, 5, 'Comida'),
	(359, 'coffee2', 'Grão de Café', 'Usável', 0.25, 0, 10, 'Comida'),
	(360, 'horsefish', 'Cavala', 'Usável', 0.5, 0, 12, 'Utilitarios'),
	(361, 'acerolajuice', 'Suco de Acerola', 'Usável', 0.75, 0, 100, 'Comida'),
	(362, 'WEAPON_RIFLE_AMMO', 'M. Rifle', 'Munição', 0.001, 0, 75, 'Armas'),
	(363, 'mushroom', 'Cogumelo', 'Usável', 0.25, 0, 10, 'Comida'),
	(364, 'tangejuice', 'Suco de Tangerina', 'Usável', 0.75, 0, 100, 'Comida'),
	(365, 'WEAPON_STONE_HATCHET', 'Machado de Pedra', 'Armamento', 1.55, 0, 15000, 'Armas'),
	(366, 'strawberryjuice', 'Suco de Morango', 'Usável', 0.75, 0, 100, 'Comida'),
	(367, 'cookies', 'Cookies', 'Usável', 0.25, 0, 60, 'Comida'),
	(368, 'roadsigns', 'Placas de Trânsito', 'Comum', 0.65, 0, 50, 'Utilitarios'),
	(369, 'onionrings', 'Anéis de Cebola', 'Usável', 0.55, 0, 70, 'Comida'),
	(370, 'acerola', 'Acerola', 'Usável', 0.25, 0, 10, 'Comida'),
	(371, 'guarana', 'Guaraná', 'Usável', 0.25, 0, 10, 'Comida'),
	(372, 'alvejante', 'Alvejante', 'Comum', 0, 0, 0, 'Drogas'),
	(373, 'banana', 'Banana', 'Usável', 0.25, 0, 10, 'Comida'),
	(374, 'suitcase', 'Maleta', 'Usável', 1, 0, 275, 'Utilitarios'),
	(375, 'tange', 'Tangerina', 'Usável', 0.25, 0, 10, 'Comida'),
	(376, 'WEAPON_ASSAULTRIFLE_MK2', 'AK-74', 'Armamento', 0.6, 0, 250000, 'Armas'),
	(377, 'WEAPON_SCORPIONEVO', 'Scorpion Evo', 'Armamento', 0.6, 0, 190000, 'Armas'),
	(378, 'smgbody', 'Corpo de Sub-Metralhadora', 'Comum', 0.85, 0, 525, 'Armas'),
	(379, 'cereais', 'Cereais ', 'Usável', 0.25, 0, 1000, 'Comida'),
	(380, 'tyres', 'Pneu', 'Usável', 1.75, 0, 225, 'Utilitarios'),
	(381, 'suspensionc', 'Suspensão', 'Usável', 9.25, 0, 0, 'Utilitarios'),
	(382, 'suspensionb', 'Suspensão', 'Usável', 8.25, 0, 0, 'Utilitarios'),
	(383, 'cola', 'Cola', 'Usável', 0.25, 0, 15, 'Comida'),
	(384, 'octopus', 'Polvo', 'Comum', 0.75, 0, 14, 'Utilitarios'),
	(385, 'silk', 'Seda', 'Comum', 0.01, 0, 5, 'Drogas'),
	(386, 'wheelchair', 'Cadeira de Rodas, item para rp de [doente, machucado]', 'Usável', 1.25, 1, 2750, 'Utilitarios'),
	(387, 'gauze', 'Ataduras', 'Usável', 0.25, 0, 10000, 'Medicamentos'),
	(388, 'cup', 'Cálice', 'Comum', 0.45, 0, 100, 'Utilitarios'),
	(389, 'meth', 'Metanfetamina', 'Usável', 0.01, 0, 10000, 'Drogas'),
	(390, 'grapejuice', 'Suco de Uva', 'Usável', 0.75, 0, 100, 'Comida'),
	(391, 'milkbottle', 'Garrafa de Leite', 'Usável', 0.25, 0, 35, 'Comida'),
	(392, 'hamburger2', 'Hambúrguer Artesanal', 'Usável', 0.75, 0, 125, 'Comida'),
	(393, 'carp', 'Carpa', 'Usável', 0.5, 0, 12, 'Utilitarios'),
	(394, 'goldenfish', 'Dourado', 'Usável', 0.25, 0, 30, 'Utilitarios'),
	(395, 'metalcan', 'Lata de Metal', 'Comum', 0.55, 0, 90, 'Utilitarios'),
	(396, 'md', 'MD', 'Usável', 0.05, 0, 10000, 'Drogas'),
	(397, 'syringe', 'Seringa', 'Comum', 0.15, 0, 2, 'Utilitarios'),
	(398, 'card01', 'Cartão Comum', 'Comum', 0.25, 0, 325, 'Utilitarios'),
	(399, 'water', 'Água', 'Usável', 0.25, 0, 30, 'Comida'),
	(400, 'WEAPON_SNIPER_AMMO', 'M. Sniper', 'Munição', 0.001, 0, 120, 'Armas'),
	(401, 'molas', 'Molas', 'Comum', 0.01, 0, 0, 'Armas'),
	(402, 'attachments', 'Modificador de Arma ', 'Usável', 0.25, 0, 100, 'Utilitarios'),
	(403, 'WEAPON_KNUCKLE', 'Soco Inglês', 'Armamento', 1.15, 0, 15000, 'Armas'),
	(404, 'weedleaf', 'Folha de Maconha', 'Comum', 0.01, 0, 0, 'Drogas'),
	(405, 'premium03', 'VIP Ouro', 'Usável', 0.15, 1, 200000, 'Premium'),
	(406, 'lanca', 'Lança', 'Usável', 0.05, 0, 10000, 'Drogas'),
	(407, 'joint', 'Baseado', 'Usável', 0.05, 0, 10000, 'Drogas'),
	(408, 'bait', 'Isca', 'Comum', 0.25, 0, 5, 'Utilitarios'),
	(409, 'passionjuice', 'Suco de Maracujá', 'Usável', 0.75, 0, 100, 'Comida'),
	(410, 'catfish', 'Bagre', 'Usável', 0.5, 0, 16, 'Utilitarios'),
	(411, 'adrenaline', 'Adrenalina', 'Usável', 0.35, 0, 200000, 'Utilitarios'),
	(412, 'attachsFlashlight', 'Lanterna Tatica', 'Usável', 1.15, 0, 1750, 'Utilitarios'),
	(413, 'aguadestilada', 'Agua Destilada', 'Comum', 0.01, 0, 625, 'Drogas'),
	(414, 'coffeemilk', 'Café com Leite', 'Usável', 0.35, 0, 95, 'Comida'),
	(415, 'creator', 'Criação de Personagem', 'Usável', 15, 1, 0, 'Premium'),
	(416, 'woodlog', 'Tora de Madeira', 'Comum', 0.75, 0, 40, 'Utilitarios'),
	(417, 'card03', 'Cartão Épico', 'Comum', 0.25, 0, 375, 'Utilitarios'),
	(418, 'WEAPON_KATANA', 'Katana', 'Armamento', 1.75, 0, 75000, 'Armas'),
	(419, 'campfire', 'Fogueira', 'Usável', 1.75, 0, 675, 'Utilitarios'),
	(420, 'premium02', 'VIP Policia', 'Usável', 0.15, 1, 250000, 'Premium'),
	(421, 'absolut', 'Absolut', 'Usável', 0.55, 0, 15, 'Comida'),
	(422, 'troll', 'Troll', 'Usável', 2, 0, 0, 'Utilitarios'),
	(423, 'beanmachine2', 'Caixa de Lanche', 'Comum', 0.25, 0, 10, 'Comida'),
	(424, 'pizzathis3', 'Combo', 'Comum', 1.25, 0, 120, 'Comida'),
	(425, 'goldcoin', 'Moeda de Ouro', 'Usável', 0.05, 0, 40, 'Utilitarios'),
	(426, 'scanner', 'Scanner', 'Usável', 4.75, 0, 6750, 'Utilitarios'),
	(427, 'milkshake', 'Milk Shake', 'Usável', 0.8555, 0, 125, 'Comida'),
	(428, 'sulfuric', 'Ácido Sulfúrico', 'Usável', 0.01, 0, 30, 'Drogas'),
	(429, 'WEAPON_RAILGUN', 'RPG', 'Armamento', 3.75, 0, 775, 'Armas'),
	(430, 'alvejantemedio', 'Alvejante Medio', 'Comum', 0.95, 0, 625, 'Drogas'),
	(431, 'backcamping', 'Mochila de Acampamento', 'Usável', 1.25, 0, 100000, 'Utilitarios'),
	(432, 'weaponbody', 'Peça de Arma', 'Comum', 0.01, 0, 625, 'Armas'),
	(433, 'cloro', 'Cloro', 'Comum', 0, 0, 625, 'Drogas'),
	(434, 'identity', 'Passaporte', 'Comum', 0.15, 0, 5000, 'Utilitarios'),
	(435, 'tarp', 'Lona', 'Comum', 0.65, 0, 50, 'Utilitarios'),
	(436, 'money4', '1 milhão de Dollars', 'Usável', 0.35, 1, 2250, 'Premium'),
	(437, 'medicbed', 'Maca Médica', 'Usável', 1.25, 0, 725, 'Utilitarios'),
	(438, 'cheese', 'Queijo', 'Comum', 0.55, 0, 10, 'Comida'),
	(439, 'WEAPON_BRICK', 'Tijolo', 'Throwing', 0.75, 0, 25, 'Armas'),
	(440, 'burgershotpass', 'Vale - BurgerShot', 'Comum', 0.25, 0, 0, 'Utilitarios'),
	(441, 'WEAPON_REVOLVER', 'Magnum 44', 'Armamento', 0.6, 0, 125000, 'Armas'),
	(442, 'rentalveh', 'Aluguel de Veículo', 'Usável', 0.15, 0, 0, 'Premium'),
	(443, 'backrudolphpurple', 'Mochila Rudolph Roxo', 'Usável', 1.25, 0, 150000, 'Utilitarios'),
	(444, 'analgesic', 'Analgésico', 'Usável', 0.25, 0, 10000, 'Medicamentos'),
	(445, 'engineb', 'Motor', 'Usável', 10.25, 0, 0, 'Utilitarios');

-- Copiando estrutura para tabela cidadesanta.item_spawn
CREATE TABLE IF NOT EXISTS `item_spawn` (
  `itemId` int(11) DEFAULT NULL,
  `date` datetime DEFAULT current_timestamp(),
  `Amount` int(11) DEFAULT 1,
  KEY `item_spawn_FK_itemId` (`itemId`),
  CONSTRAINT `item_spawn_FK_itemId` FOREIGN KEY (`itemId`) REFERENCES `item_list` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.item_spawn: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.login_steps
CREATE TABLE IF NOT EXISTS `login_steps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account` bigint(20) NOT NULL DEFAULT 0,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `action` int(2) NOT NULL DEFAULT 1,
  KEY `id` (`id`,`account`),
  KEY `account_logins_steps_FK` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.login_steps: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.mdt_arrest
CREATE TABLE IF NOT EXISTS `mdt_arrest` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) NOT NULL,
  `officer` int(11) NOT NULL,
  `description` varchar(250) NOT NULL DEFAULT '',
  `infraction` varchar(50) NOT NULL DEFAULT '{}',
  `datetime` datetime NOT NULL DEFAULT current_timestamp(),
  `time` int(11) NOT NULL DEFAULT 0,
  `arrested` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `passport` (`passport`),
  KEY `mdt_arrest_officer_FK` (`officer`),
  CONSTRAINT `mdt_arrest_officer_FK` FOREIGN KEY (`officer`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `mdt_arrest_passport_FK` FOREIGN KEY (`passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.mdt_arrest: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.mdt_bills
CREATE TABLE IF NOT EXISTS `mdt_bills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) DEFAULT NULL,
  `officer` int(11) DEFAULT NULL,
  `amount` int(11) DEFAULT 0,
  `infraction` varchar(50) DEFAULT '{}',
  `description` varchar(50) DEFAULT NULL,
  `datetime` datetime DEFAULT current_timestamp(),
  `paid` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `passport` (`passport`),
  KEY `mdt_bills_officer_FK` (`officer`),
  CONSTRAINT `mdt_bills_officer_FK` FOREIGN KEY (`officer`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `mdt_bills_passport_FK` FOREIGN KEY (`passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.mdt_bills: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.mdt_news
CREATE TABLE IF NOT EXISTS `mdt_news` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `user` int(11) NOT NULL DEFAULT 0,
  `message` varchar(255) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `datetime` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`uid`),
  KEY `mdt_news_user_FK` (`user`),
  CONSTRAINT `mdt_news_user_FK` FOREIGN KEY (`user`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.mdt_news: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.mdt_reports
CREATE TABLE IF NOT EXISTS `mdt_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `officer` int(11) DEFAULT NULL,
  `suspect` int(11) DEFAULT NULL,
  `suspectId` int(11) DEFAULT NULL,
  `requester` int(11) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `datetime` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `officer` (`officer`),
  KEY `requester` (`requester`),
  KEY `mdt_reports_suspect_FK` (`suspect`) USING BTREE,
  CONSTRAINT `mdt_reports_officer_FK` FOREIGN KEY (`officer`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `mdt_reports_requester_FK` FOREIGN KEY (`requester`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `mdt_reports_suspect_FK` FOREIGN KEY (`suspect`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.mdt_reports: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.mdt_wanted
CREATE TABLE IF NOT EXISTS `mdt_wanted` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) DEFAULT NULL,
  `officer` int(11) DEFAULT NULL,
  `datetime` datetime NOT NULL DEFAULT current_timestamp(),
  `reason` varchar(255) NOT NULL DEFAULT '',
  `wanted` tinyint(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mdt_wanted_passport_FK` (`passport`),
  KEY `mdt_wanted_officer_FK` (`officer`),
  CONSTRAINT `mdt_wanted_officer_FK` FOREIGN KEY (`officer`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `mdt_wanted_passport_FK` FOREIGN KEY (`passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.mdt_wanted: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.missions
CREATE TABLE IF NOT EXISTS `missions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `missionGroup` int(3) unsigned NOT NULL DEFAULT 0,
  `missionInfo` longtext NOT NULL DEFAULT '{}',
  `finalBonus` varchar(300) NOT NULL DEFAULT '{}',
  PRIMARY KEY (`id`),
  UNIQUE KEY `missionGroup` (`missionGroup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.missions: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.new_player
CREATE TABLE IF NOT EXISTS `new_player` (
  `id` bigint(20) NOT NULL DEFAULT 0,
  `action` int(3) NOT NULL DEFAULT 0,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  KEY `id` (`id`),
  KEY `action` (`action`),
  CONSTRAINT `new_player_accounts_id` FOREIGN KEY (`id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `new_player_aciont_FK` FOREIGN KEY (`action`) REFERENCES `info_new_player` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.new_player: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.new_player_promo
CREATE TABLE IF NOT EXISTS `new_player_promo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accountID` bigint(20) NOT NULL DEFAULT 0,
  `token` varchar(100) NOT NULL DEFAULT '0',
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `tokenId` int(10) NOT NULL,
  `redeemed` tinyint(1) NOT NULL DEFAULT 0,
  `discount` int(3) DEFAULT NULL,
  `expires` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `new_player_promo_accountID_FK` (`accountID`),
  CONSTRAINT `new_player_promo_accountID_FK` FOREIGN KEY (`accountID`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.new_player_promo: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.painel
CREATE TABLE IF NOT EXISTS `painel` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT ' ',
  `level` int(2) NOT NULL DEFAULT 0,
  `bankAmount` int(11) NOT NULL DEFAULT 0,
  `organization_points` int(11) NOT NULL DEFAULT 0,
  `domination` int(4) NOT NULL DEFAULT 0,
  `leader` int(11) NOT NULL DEFAULT 0,
  `discord` varchar(500) DEFAULT NULL,
  `buff` float DEFAULT 1,
  `farm` float DEFAULT 0,
  `members` longtext DEFAULT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `bankLogs` longtext DEFAULT NULL,
  `alias` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `name` (`name`),
  KEY `type` (`level`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.painel: ~51 rows (aproximadamente)
INSERT INTO `painel` (`id`, `name`, `level`, `bankAmount`, `organization_points`, `domination`, `leader`, `discord`, `buff`, `farm`) VALUES
	(1, 'Amarelos', 0, 0, 0, 0, 0, '""', 1, 0),
	(2, 'Sindicato', 0, 0, 0, 0, 0, '""', 1, 0),
	(3, 'Verdes', 0, 0, 0, 0, 0, '""', 1, 0),
	(4, 'Warlocks', 0, 0, 0, 0, 0, '""', 1, 0),
	(5, 'Crips', 0, 0, 0, 0, 0, '""', 1, 0),
	(7, 'Paramedic', 0, 0, 0, 0, 0, '""', 1, 0),
	(8, 'Bahamas', 0, 0, 0, 0, 0, '""', 1, 0),
	(9, 'Vagos', 0, 0, 0, 0, 0, '""', 1, 0),
	(10, 'Bennys', 0, 0, 0, 0, 0, '""', 1, 0),
	(11, 'Laranjas', 0, 0, 0, 0, 0, '""', 1, 0),
	(12, 'Redline', 0, 0, 0, 0, 0, '""', 1, 0),
	(13, 'Yakuza', 0, 0, 0, 0, 0, '""', 1, 0),
	(15, 'Brancos', 0, 0, 0, 0, 0, '""', 1, 0),
	(16, 'Mexico', 0, 0, 0, 0, 0, '""', 1, 0),
	(17, 'Vermelhos', 0, 0, 0, 0, 0, '""', 1, 0),
	(18, 'Umbrella', 0, 0, 0, 0, 0, '""', 1, 0),
	(19, 'Israel', 0, 0, 0, 0, 0, '""', 1, 0),
	(20, 'Azuis', 0, 0, 0, 0, 0, '""', 1, 0),
	(21, 'HellsAngels', 0, 0, 0, 0, 0, '""', 1, 0),
	(22, 'Roxos', 0, 0, 0, 0, 0, '""', 1, 0),
	(23, 'Vanilla', 0, 0, 0, 0, 0, '""', 1, 0),
	(24, 'Rosas', 0, 0, 0, 0, 0, '""', 1, 0),
	(25, 'Luxor', 0, 0, 0, 0, 0, '""', 1, 0),
	(26, 'China', 0, 0, 0, 0, 0, '""', 1, 0),
	(27, 'Ballas', 0, 0, 0, 0, 0, '""', 1, 0),
	(28, 'Italia', 0, 0, 0, 0, 0, '""', 1, 0),
	(29, 'Mechanic', 0, 0, 0, 0, 0, '""', 1, 0),
	(30, 'Marrons', 0, 0, 0, 0, 0, '""', 1, 0),
	(31, 'Cinzas', 0, 0, 0, 0, 0, '""', 1, 0),
	(32, 'Policia', 0, 0, 0, 0, 0, '""', 1, 0),
	(33, 'Gringa', 0, 0, 0, 0, 0, '""', 1, 0),
	(34, 'Galaxy', 0, 0, 0, 0, 0, '""', 1, 0),
	(35, 'Bellagio', 0, 0, 0, 0, 0, '""', 1, 0),
	(36, 'Cartel', 0, 0, 0, 0, 0, '""', 1, 0),
	(37, 'Bloods', 0, 0, 0, 0, 0, '""', 1, 0),
	(38, 'Russia', 0, 0, 0, 0, 0, '""', 1, 0),
	(40, 'Forza', 0, 0, 0, 0, 0, '""', 1, 0),
	(41, 'Triade', 0, 0, 0, 0, 0, '""', 1, 0),
	(42, 'Groove', 0, 0, 0, 0, 0, '""', 1, 0),
	(43, 'Palazzo', 0, 0, 0, 0, 0, '""', 1, 0),
	(44, 'Outlaws', 0, 0, 0, 0, 0, '""', 1, 0),
	(45, 'Franca', 0, 0, 0, 0, 0, '""', 1, 0),
	(46, 'Overdrive', 0, 0, 0, 0, 0, '""', 1, 0),
	(47, 'Barragem', 0, 0, 0, 0, 0, '""', 1, 0),
	(48, 'DriftKing', 0, 0, 0, 0, 0, '""', 1, 0),
	(49, 'SonsofAnarchy', 0, 0, 0, 0, 0, '""', 1, 0),
	(50, 'Juridico', 0, 0, 0, 0, 0, '""', 1, 0),
	(51, 'TopGear', 0, 0, 0, 0, 0, '""', 1, 0),
	(52, 'Playboy', 0, 0, 0, 0, 0, '""', 1, 0),
	(53, 'Mercenarios', 0, 0, 0, 0, 0, '""', 1, 0),
	(54, 'Sinaloa', 0, 0, 0, 0, 0, '""', 1, 0);

-- Copiando estrutura para tabela cidadesanta.painel_bank
CREATE TABLE IF NOT EXISTS `painel_bank` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) NOT NULL DEFAULT 0,
  `type` tinyint(1) NOT NULL DEFAULT 0,
  `timer` datetime NOT NULL DEFAULT current_timestamp(),
  `quantity` int(11) NOT NULL DEFAULT 0,
  `groupid` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `painelbank_passport_FK` (`passport`),
  KEY `painelbank_type_FK` (`type`),
  KEY `FK_painel_bank_painel` (`groupid`),
  KEY `timer` (`timer`),
  CONSTRAINT `FK_painel_bank_painel` FOREIGN KEY (`groupid`) REFERENCES `painel` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `painelbank_passport_FK` FOREIGN KEY (`passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `painelbank_type_FK` FOREIGN KEY (`type`) REFERENCES `painel_bank_type` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.painel_bank: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.painel_bank_type
CREATE TABLE IF NOT EXISTS `painel_bank_type` (
  `id` tinyint(1) NOT NULL AUTO_INCREMENT,
  `type` varchar(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.painel_bank_type: ~3 rows (aproximadamente)
INSERT INTO `painel_bank_type` (`id`, `type`) VALUES
	(1, 'withdraw'),
	(2, 'deposit'),
	(3, 'removed');

-- Copiando estrutura para tabela cidadesanta.painel_members
CREATE TABLE IF NOT EXISTS `painel_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) NOT NULL DEFAULT 0,
  `groupid` int(11) NOT NULL,
  `roleid` int(11) NOT NULL,
  `recruiter` int(11) NOT NULL,
  `recruiter_date` datetime NOT NULL DEFAULT current_timestamp(),
  `fired` tinyint(1) NOT NULL DEFAULT 0,
  `points` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `painel_members_groupid_FK` (`groupid`),
  KEY `painel_members_roleid_FK` (`roleid`),
  KEY `painel_members_passport_FK` (`passport`),
  KEY `painel_members_recruiter_FK` (`recruiter`),
  KEY `recruiter_date` (`recruiter_date`),
  CONSTRAINT `painel_members_groupid_FK` FOREIGN KEY (`groupid`) REFERENCES `painel` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `painel_members_passport_FK` FOREIGN KEY (`passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `painel_members_recruiter_FK` FOREIGN KEY (`recruiter`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `painel_members_roleid_FK` FOREIGN KEY (`roleid`) REFERENCES `painel_roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.painel_members: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.painel_messages
CREATE TABLE IF NOT EXISTS `painel_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL DEFAULT 0,
  `content` varchar(255) NOT NULL DEFAULT '',
  `author` int(11) NOT NULL DEFAULT 0,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `painel_messages_groipId` (`groupId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.painel_messages: 0 rows
/*!40000 ALTER TABLE `painel_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `painel_messages` ENABLE KEYS */;

-- Copiando estrutura para tabela cidadesanta.painel_roles
CREATE TABLE IF NOT EXISTS `painel_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role` varchar(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.painel_roles: ~3 rows (aproximadamente)
INSERT INTO `painel_roles` (`id`, `role`) VALUES
	(1, 'Chefe'),
	(2, 'Sub-Chefe'),
	(3, 'Membro');

-- Copiando estrutura para tabela cidadesanta.painel_squad
CREATE TABLE IF NOT EXISTS `painel_squad` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group` int(11) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `members` longtext DEFAULT '{}',
  PRIMARY KEY (`id`),
  KEY `group` (`group`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.painel_squad: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.painel_squad_messages
CREATE TABLE IF NOT EXISTS `painel_squad_messages` (
  ` id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `group` int(11) DEFAULT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `message` varchar(250) DEFAULT NULL,
  `author` int(11) DEFAULT NULL,
  `type` int(1) DEFAULT 1,
  PRIMARY KEY (` id`),
  KEY `group` (`group`) USING BTREE,
  KEY `painel_squad_messages_FK_author` (`author`),
  CONSTRAINT `painel_squad_messages_FK_author` FOREIGN KEY (`author`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `painel_squad_messages_FK_group` FOREIGN KEY (`group`) REFERENCES `painel` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.painel_squad_messages: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.peds_shop
CREATE TABLE IF NOT EXISTS `peds_shop` (
  `Passport` int(11) NOT NULL DEFAULT 0,
  `info` text DEFAULT '{}',
  PRIMARY KEY (`Passport`) USING BTREE,
  KEY `id` (`Passport`) USING BTREE,
  CONSTRAINT `peds_shop_Passport_FK` FOREIGN KEY (`Passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.peds_shop: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.playerdata
CREATE TABLE IF NOT EXISTS `playerdata` (
  `Passport` int(11) NOT NULL,
  `dkey` varchar(100) NOT NULL,
  `dvalue` longtext DEFAULT NULL,
  PRIMARY KEY (`Passport`,`dkey`),
  KEY `Passport` (`Passport`),
  KEY `dkey` (`dkey`),
  CONSTRAINT `playerdata_Passport_FK` FOREIGN KEY (`Passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.playerdata: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.players_amount
CREATE TABLE IF NOT EXISTS `players_amount` (
  `amount` int(11) NOT NULL DEFAULT 0,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.players_amount: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.players_amount_group
CREATE TABLE IF NOT EXISTS `players_amount_group` (
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `amount` int(11) NOT NULL DEFAULT 0,
  `group` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.players_amount_group: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.player_achievements
CREATE TABLE IF NOT EXISTS `player_achievements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) NOT NULL DEFAULT 0,
  `achievement` int(11) NOT NULL DEFAULT 0,
  `progress` int(3) NOT NULL DEFAULT 0,
  `completed` datetime DEFAULT NULL,
  `rewarded` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `player_achievements_achievement_FK` (`achievement`),
  KEY `player_achievements_player_FK` (`passport`) USING BTREE,
  CONSTRAINT `player_achievements_achievement_FK` FOREIGN KEY (`achievement`) REFERENCES `achievements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `player_achievements_player_FK` FOREIGN KEY (`passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.player_achievements: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.player_code
CREATE TABLE IF NOT EXISTS `player_code` (
  `code` varchar(100) NOT NULL DEFAULT '',
  `player` int(11) NOT NULL DEFAULT 0,
  `createdby` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.player_code: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.player_code_steps_history
CREATE TABLE IF NOT EXISTS `player_code_steps_history` (
  `player` int(11) NOT NULL DEFAULT 0,
  `step` int(11) NOT NULL DEFAULT 0,
  `code` varchar(100) NOT NULL DEFAULT '',
  `date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.player_code_steps_history: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.player_code_uses
CREATE TABLE IF NOT EXISTS `player_code_uses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(100) NOT NULL DEFAULT '',
  `player` int(11) NOT NULL DEFAULT 0,
  `steps` int(11) NOT NULL DEFAULT 0,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.player_code_uses: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.player_purchases
CREATE TABLE IF NOT EXISTS `player_purchases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Passport` int(11) NOT NULL DEFAULT 0,
  `Price` decimal(20,6) NOT NULL DEFAULT 0.000000,
  `orderID` int(11) NOT NULL DEFAULT 0,
  `Type` varchar(255) NOT NULL,
  `Packages` longtext NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.player_purchases: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.premium
CREATE TABLE IF NOT EXISTS `premium` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) NOT NULL DEFAULT 0,
  `premium` int(11) NOT NULL DEFAULT 5,
  `expires` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `premium_passport_FK` (`passport`),
  CONSTRAINT `premium_passport_FK` FOREIGN KEY (`passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.premium: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.premium_time
CREATE TABLE IF NOT EXISTS `premium_time` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) DEFAULT 0,
  `vip` varchar(50) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `passport` (`passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.premium_time: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.promos
CREATE TABLE IF NOT EXISTS `promos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` longtext NOT NULL,
  `timer` int(20) NOT NULL DEFAULT 0,
  `cupom` varchar(50) NOT NULL DEFAULT '',
  `cronometro` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.promos: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.promoter_score
CREATE TABLE IF NOT EXISTS `promoter_score` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) DEFAULT 0,
  `rating` int(2) NOT NULL DEFAULT 0,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `type` int(2) NOT NULL DEFAULT 0,
  `FeedBack` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `passport` (`passport`),
  CONSTRAINT `promoter_score_passport_FK` FOREIGN KEY (`passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.promoter_score: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.promotion_system
CREATE TABLE IF NOT EXISTS `promotion_system` (
  `id` int(11) DEFAULT NULL,
  `image` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.promotion_system: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.propertys
CREATE TABLE IF NOT EXISTS `propertys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(20) NOT NULL DEFAULT 'Homes0001',
  `Interior` varchar(20) NOT NULL DEFAULT 'Middle',
  `Keys` int(3) NOT NULL DEFAULT 3,
  `Tax` datetime DEFAULT current_timestamp(),
  `Number` int(11) NOT NULL DEFAULT 0,
  `Passport` int(6) NOT NULL DEFAULT 0,
  `Serial` varchar(10) NOT NULL,
  `Vault` int(6) NOT NULL DEFAULT 1,
  `Fridge` int(6) NOT NULL DEFAULT 1,
  `Garage` longtext NOT NULL DEFAULT '{}',
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `Passport` (`Passport`),
  KEY `Name` (`Name`),
  CONSTRAINT `propertys_Passport_FK` FOREIGN KEY (`Passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.propertys: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.races
CREATE TABLE IF NOT EXISTS `races` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Race` int(3) NOT NULL DEFAULT 0,
  `Passport` int(5) NOT NULL DEFAULT 0,
  `Name` varchar(100) NOT NULL DEFAULT 'Individuo Indigente',
  `Vehicle` varchar(50) NOT NULL DEFAULT 'Sultan RS',
  `Points` int(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`),
  KEY `Race` (`Race`),
  CONSTRAINT `races_Passport_FK` FOREIGN KEY (`Passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.races: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.release_promotion
CREATE TABLE IF NOT EXISTS `release_promotion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `endAt` datetime DEFAULT NULL,
  `timer` int(11) NOT NULL DEFAULT 600,
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.release_promotion: ~0 rows (aproximadamente)

-- Copiando estrutura para evento cidadesanta.remove_bank_funds
DELIMITER //
CREATE EVENT `remove_bank_funds` ON SCHEDULE EVERY 1 DAY STARTS '2023-03-31 16:58:00' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE characters SET bank = bank * 0.99 WHERE bank > 100000000//
DELIMITER ;

-- Copiando estrutura para tabela cidadesanta.reputation
CREATE TABLE IF NOT EXISTS `reputation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Passport` int(11) NOT NULL DEFAULT 0,
  `other` int(11) NOT NULL DEFAULT 0,
  `time` int(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `idx_passport_other` (`Passport`,`other`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.reputation: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.season_pass
CREATE TABLE IF NOT EXISTS `season_pass` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) NOT NULL DEFAULT 0,
  `done` longtext NOT NULL DEFAULT '{}',
  `premium` tinyint(1) NOT NULL DEFAULT 0,
  `experience` int(11) NOT NULL DEFAULT 0,
  `completed` datetime DEFAULT NULL,
  `started` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `season_pass_passport_FK` (`passport`),
  CONSTRAINT `season_pass_passport_FK` FOREIGN KEY (`passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.season_pass: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.server_info
CREATE TABLE IF NOT EXISTS `server_info` (
  `robbery_north_start` int(11) DEFAULT 0,
  `robbery_north_end` int(11) DEFAULT 0,
  `robbery_south_start` int(11) DEFAULT 0,
  `robbery_south_end` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.server_info: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.skinstock
CREATE TABLE IF NOT EXISTS `skinstock` (
  `model` varchar(60) NOT NULL,
  `stock` int(11) DEFAULT 0,
  PRIMARY KEY (`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.skinstock: ~72 rows (aproximadamente)
INSERT INTO `skinstock` (`model`, `stock`) VALUES
	('COMPONENT_AK47_AA_SKIN', 500),
	('COMPONENT_AK47_AB_SKIN', 500),
	('COMPONENT_AK47_AC_SKIN', 500),
	('COMPONENT_AK47_AE_SKIN', 500),
	('COMPONENT_AK47_AG_SKIN', 500),
	('COMPONENT_AK47_AH_SKIN', 500),
	('COMPONENT_AK47_AI_SKIN', 500),
	('COMPONENT_AK47_AK_SKIN', 500),
	('COMPONENT_AK47_AL_SKIN', 500),
	('COMPONENT_AK47_AM_SKIN', 500),
	('COMPONENT_AK47_AN_SKIN', 500),
	('COMPONENT_AK47_AQ_SKIN', 500),
	('COMPONENT_AK47_MARK_SKIN', 500),
	('COMPONENT_AK47_PARTEN_SKIN', 500),
	('COMPONENT_AK47_SKIN', 500),
	('COMPONENT_AK47_TOE_SKIN', 500),
	('COMPONENT_AK47_WHITEB_SKIN', 500),
	('COMPONENT_AK47_WHITE_SKIN', 500),
	('COMPONENT_AK47_WH_SKIN', 500),
	('COMPONENT_AK47_YE_SKIN', 500),
	('COMPONENT_AWM_ASIIMOV', 500),
	('COMPONENT_AWM_CORTICERA', 500),
	('COMPONENT_AWM_DRAGONLORE', 500),
	('COMPONENT_AWM_HYPERBEAST', 500),
	('COMPONENT_AWM_LIGHTNINSTRIKE', 500),
	('COMPONENT_AWM_MEDUSA', 500),
	('COMPONENT_AWM_MIKU', 500),
	('COMPONENT_AWM_REDLINE', 500),
	('COMPONENT_AWM_WESTERN', 500),
	('COMPONENT_DESERT_OMATSURI', 500),
	('COMPONENT_FIVESEVEN_AA', 500),
	('COMPONENT_FIVESEVEN_AI', 500),
	('COMPONENT_FIVESEVEN_AJ', 500),
	('COMPONENT_FIVESEVEN_AM', 500),
	('COMPONENT_FIVESEVEN_AO', 500),
	('COMPONENT_FIVESEVEN_AP', 500),
	('COMPONENT_FIVESEVEN_AR', 500),
	('COMPONENT_FIVESEVEN_AT', 500),
	('COMPONENT_FIVESEVEN_BARBIE', 500),
	('COMPONENT_FIVESEVEN_NV', 500),
	('COMPONENT_G3_ANCI', 500),
	('COMPONENT_G3_BB', 500),
	('COMPONENT_G3_BRIN', 500),
	('COMPONENT_G3_CA', 500),
	('COMPONENT_G3_MK2_GP', 500),
	('COMPONENT_G3_MK2_ONI', 500),
	('COMPONENT_G3_MK2_RGX', 500),
	('COMPONENT_G3_MK2_SAQ', 500),
	('COMPONENT_G3_MK2_SING', 500),
	('COMPONENT_G3_PB', 500),
	('COMPONENT_G3_RAE', 500),
	('COMPONENT_G3_SUB', 500),
	('COMPONENT_GLOCK_BT', 500),
	('COMPONENT_GLOCK_BW', 500),
	('COMPONENT_GLOCK_CH', 500),
	('COMPONENT_GLOCK_CI', 500),
	('COMPONENT_GLOCK_REDSAMURAI', 500),
	('COMPONENT_GLOCK_SEATERROR', 500),
	('COMPONENT_GLOCK_SNACKCLUB', 500),
	('COMPONENT_M4_AD_SKIN', 500),
	('COMPONENT_M4_AL_SKIN', 500),
	('COMPONENT_M4_AM_SKIN', 500),
	('COMPONENT_M4_AR_SKIN', 500),
	('COMPONENT_M4_AS_SKIN', 500),
	('COMPONENT_M4_COLT_SKIN', 500),
	('COMPONENT_M4_DK_SKIN', 500),
	('COMPONENT_M4_DRAGON_SKIN', 500),
	('COMPONENT_M4_GR_SKIN', 500),
	('COMPONENT_M4_HUNTER_SKIN', 500),
	('COMPONENT_M4_MK2_AJ_SKIN', 500),
	('COMPONENT_M4_MK2_BL_SKIN', 500),
	('COMPONENT_M4_W_SKIN', 500);

-- Copiando estrutura para tabela cidadesanta.skinweapon
CREATE TABLE IF NOT EXISTS `skinweapon` (
  `user_id` int(11) NOT NULL,
  `component` varchar(50) NOT NULL,
  `weapon` varchar(50) NOT NULL,
  `equip` varchar(5) NOT NULL DEFAULT 'false',
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `expirate` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`user_id`,`component`) USING BTREE,
  KEY `dkey` (`user_id`,`component`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.skinweapon: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_bank_invoices
CREATE TABLE IF NOT EXISTS `smartphone_bank_invoices` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `payee_id` int(11) NOT NULL,
  `payer_id` int(11) NOT NULL,
  `reason` varchar(255) NOT NULL DEFAULT '',
  `value` int(11) NOT NULL,
  `paid` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` int(11) NOT NULL,
  `updated_at` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_bank_invoices: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_blocks
CREATE TABLE IF NOT EXISTS `smartphone_blocks` (
  `user_id` int(11) NOT NULL,
  `phone` varchar(32) NOT NULL,
  PRIMARY KEY (`user_id`,`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_blocks: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_calls
CREATE TABLE IF NOT EXISTS `smartphone_calls` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `initiator` varchar(50) NOT NULL,
  `target` varchar(50) NOT NULL,
  `duration` int(11) NOT NULL DEFAULT 0,
  `status` varchar(255) NOT NULL,
  `video` tinyint(4) NOT NULL DEFAULT 0,
  `anonymous` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `initiator_index` (`initiator`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_calls: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_contacts
CREATE TABLE IF NOT EXISTS `smartphone_contacts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `owner_index` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_contacts: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_gallery
CREATE TABLE IF NOT EXISTS `smartphone_gallery` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `folder` varchar(255) NOT NULL DEFAULT '/',
  `url` varchar(255) NOT NULL,
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_gallery: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_ifood_orders
CREATE TABLE IF NOT EXISTS `smartphone_ifood_orders` (
  `id` varchar(10) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `worker_id` int(11) DEFAULT NULL,
  `store_id` int(11) DEFAULT NULL,
  `total` int(11) DEFAULT NULL,
  `fee` int(11) DEFAULT NULL,
  `rate` tinyint(4) DEFAULT 0,
  `created_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_ifood_orders: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_instagram
CREATE TABLE IF NOT EXISTS `smartphone_instagram` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `bio` varchar(255) NOT NULL,
  `avatarURL` varchar(255) DEFAULT NULL,
  `verified` tinyint(4) NOT NULL DEFAULT 0,
  `followers` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_instagram: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_instagram_followers
CREATE TABLE IF NOT EXISTS `smartphone_instagram_followers` (
  `follower_id` bigint(20) NOT NULL,
  `profile_id` bigint(20) NOT NULL,
  PRIMARY KEY (`follower_id`,`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_instagram_followers: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_instagram_likes
CREATE TABLE IF NOT EXISTS `smartphone_instagram_likes` (
  `post_id` bigint(20) NOT NULL,
  `profile_id` bigint(20) NOT NULL,
  PRIMARY KEY (`post_id`,`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_instagram_likes: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_instagram_notifications
CREATE TABLE IF NOT EXISTS `smartphone_instagram_notifications` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL,
  `author_id` int(11) NOT NULL,
  `content` varchar(512) NOT NULL,
  `saw` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `profile_id_index` (`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_instagram_notifications: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_instagram_posts
CREATE TABLE IF NOT EXISTS `smartphone_instagram_posts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `profile_id` bigint(20) NOT NULL,
  `post_id` bigint(20) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `profile_id_index` (`profile_id`),
  KEY `post_id_index` (`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_instagram_posts: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_olx
CREATE TABLE IF NOT EXISTS `smartphone_olx` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  `description` varchar(1024) NOT NULL,
  `images` varchar(1024) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_olx: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_paypal_transactions
CREATE TABLE IF NOT EXISTS `smartphone_paypal_transactions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `target` bigint(20) NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'payment',
  `description` varchar(255) DEFAULT NULL,
  `value` bigint(20) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_paypal_transactions: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_tinder
CREATE TABLE IF NOT EXISTS `smartphone_tinder` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL,
  `bio` varchar(1024) NOT NULL,
  `age` tinyint(4) NOT NULL,
  `gender` varchar(50) NOT NULL,
  `show_gender` tinyint(4) NOT NULL,
  `tags` varchar(255) NOT NULL,
  `show_tags` tinyint(4) NOT NULL,
  `target` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`),
  KEY `gender_index` (`gender`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_tinder: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_tinder_messages
CREATE TABLE IF NOT EXISTS `smartphone_tinder_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sender` int(11) NOT NULL,
  `target` int(11) NOT NULL,
  `content` varchar(255) NOT NULL,
  `liked` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sender_index` (`sender`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_tinder_messages: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_tinder_rating
CREATE TABLE IF NOT EXISTS `smartphone_tinder_rating` (
  `profile_id` int(11) NOT NULL,
  `rated_id` int(11) NOT NULL,
  `rating` tinyint(4) DEFAULT 0,
  PRIMARY KEY (`profile_id`,`rated_id`),
  KEY `rating` (`rating`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_tinder_rating: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_tor_messages
CREATE TABLE IF NOT EXISTS `smartphone_tor_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `channel` varchar(24) NOT NULL DEFAULT 'geral',
  `sender` varchar(50) NOT NULL,
  `image` varchar(512) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `content` varchar(500) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `channel_index` (`channel`),
  KEY `sender_index` (`sender`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_tor_messages: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_tor_payments
CREATE TABLE IF NOT EXISTS `smartphone_tor_payments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sender` bigint(20) NOT NULL,
  `target` bigint(20) NOT NULL,
  `amount` int(11) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sender_index` (`sender`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_tor_payments: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_twitter_followers
CREATE TABLE IF NOT EXISTS `smartphone_twitter_followers` (
  `follower_id` bigint(20) NOT NULL,
  `profile_id` bigint(20) NOT NULL,
  KEY `profile_id_index` (`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_twitter_followers: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_twitter_likes
CREATE TABLE IF NOT EXISTS `smartphone_twitter_likes` (
  `tweet_id` bigint(20) NOT NULL,
  `profile_id` bigint(20) NOT NULL,
  KEY `tweet_id_index` (`tweet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_twitter_likes: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_twitter_profiles
CREATE TABLE IF NOT EXISTS `smartphone_twitter_profiles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `avatarURL` varchar(255) NOT NULL,
  `bannerURL` varchar(255) NOT NULL,
  `bio` varchar(255) DEFAULT NULL,
  `verified` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_twitter_profiles: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_twitter_tweets
CREATE TABLE IF NOT EXISTS `smartphone_twitter_tweets` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL,
  `tweet_id` bigint(20) DEFAULT NULL,
  `content` varchar(280) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `profile_id_index` (`profile_id`),
  KEY `tweet_id_index` (`tweet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_twitter_tweets: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_uber_trips
CREATE TABLE IF NOT EXISTS `smartphone_uber_trips` (
  `id` varchar(10) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `total` int(11) DEFAULT NULL,
  `from` varchar(255) DEFAULT NULL,
  `to` varchar(255) DEFAULT NULL,
  `user_rate` tinyint(4) DEFAULT 0,
  `driver_rate` tinyint(4) DEFAULT 0,
  `created_at` int(11) DEFAULT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_uber_trips: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_whatsapp
CREATE TABLE IF NOT EXISTS `smartphone_whatsapp` (
  `owner` varchar(32) NOT NULL,
  `avatarURL` varchar(255) DEFAULT NULL,
  `read_receipts` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_whatsapp: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_whatsapp_channels
CREATE TABLE IF NOT EXISTS `smartphone_whatsapp_channels` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sender` varchar(50) NOT NULL,
  `target` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sender_index` (`sender`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_whatsapp_channels: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_whatsapp_groups
CREATE TABLE IF NOT EXISTS `smartphone_whatsapp_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `avatarURL` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `members` varchar(1200) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_whatsapp_groups: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.smartphone_whatsapp_messages
CREATE TABLE IF NOT EXISTS `smartphone_whatsapp_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `channel_id` bigint(20) unsigned NOT NULL,
  `sender` varchar(50) NOT NULL,
  `image` varchar(512) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `content` varchar(500) DEFAULT NULL,
  `deleted_by` varchar(255) DEFAULT NULL,
  `readed` tinyint(4) NOT NULL DEFAULT 0,
  `saw_at` bigint(20) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sender_index` (`sender`),
  KEY `channel_id_index` (`channel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.smartphone_whatsapp_messages: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.squad_deaths
CREATE TABLE IF NOT EXISTS `squad_deaths` (
  `name` varchar(50) DEFAULT NULL,
  `deathtimer` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.squad_deaths: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.support_tickets
CREATE TABLE IF NOT EXISTS `support_tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Passport` int(11) NOT NULL DEFAULT 0,
  `Admin` int(11) NOT NULL DEFAULT 0,
  `Type` int(11) NOT NULL DEFAULT 0,
  `solved` tinyint(1) NOT NULL DEFAULT 0,
  `rating` int(11) NOT NULL DEFAULT 0,
  `cancelled` tinyint(1) NOT NULL DEFAULT 0,
  `created` datetime DEFAULT NULL,
  `answered` datetime DEFAULT NULL,
  `finished` datetime DEFAULT NULL,
  `feedback` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `support_tickets_Passport_FK` (`Passport`),
  KEY `support_tickets_Admin_FK` (`Admin`),
  CONSTRAINT `support_tickets_Passport_FK` FOREIGN KEY (`Passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.support_tickets: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.taxs
CREATE TABLE IF NOT EXISTS `taxs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Passport` int(10) NOT NULL DEFAULT 0,
  `Name` varchar(50) NOT NULL,
  `Date` varchar(50) NOT NULL,
  `Hour` varchar(50) NOT NULL,
  `Value` int(11) NOT NULL,
  `Message` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`),
  KEY `id` (`id`),
  CONSTRAINT `taxs_Passport_FK` FOREIGN KEY (`Passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.taxs: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.temporary_banneds
CREATE TABLE IF NOT EXISTS `temporary_banneds` (
  `id` bigint(20) NOT NULL,
  `time` int(11) NOT NULL DEFAULT 0,
  `reason` varchar(50) NOT NULL DEFAULT '0',
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `adminid` int(11) NOT NULL DEFAULT 0,
  KEY `temporary_banneds_id` (`id`),
  CONSTRAINT `temporary_banneds_id` FOREIGN KEY (`id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.temporary_banneds: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.totem_sale
CREATE TABLE IF NOT EXISTS `totem_sale` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `totem_id` int(3) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_totem_id` (`totem_id`),
  KEY `totem_id` (`totem_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.totem_sale: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.transactions
CREATE TABLE IF NOT EXISTS `transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Passport` int(10) NOT NULL DEFAULT 0,
  `Type` varchar(50) NOT NULL,
  `Date` varchar(50) NOT NULL,
  `Value` bigint(20) NOT NULL,
  `Balance` bigint(20) NOT NULL,
  `time` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`),
  KEY `id` (`id`),
  CONSTRAINT `transactions_Passport_FK` FOREIGN KEY (`Passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.transactions: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.user_album
CREATE TABLE IF NOT EXISTS `user_album` (
  `id` int(11) NOT NULL,
  `team_id` varchar(3) NOT NULL,
  `figure_id` int(11) NOT NULL,
  PRIMARY KEY (`id`,`team_id`,`figure_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.user_album: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.user_collections
CREATE TABLE IF NOT EXISTS `user_collections` (
  `id` int(11) NOT NULL,
  `team_id` varchar(3) NOT NULL,
  `figure_id` int(11) NOT NULL,
  `amount` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`,`team_id`,`figure_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.user_collections: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.user_groups
CREATE TABLE IF NOT EXISTS `user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL DEFAULT 0,
  `passport` int(11) NOT NULL DEFAULT 0,
  `permission` int(11) DEFAULT 0,
  `expires` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `groupId` (`groupId`),
  KEY `passport` (`passport`),
  CONSTRAINT `user_groups_groupId_FK` FOREIGN KEY (`groupId`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_groups_passport_FK` FOREIGN KEY (`passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.user_groups: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.user_packs
CREATE TABLE IF NOT EXISTS `user_packs` (
  `id` int(11) NOT NULL,
  `packs` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.user_packs: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.user_titles
CREATE TABLE IF NOT EXISTS `user_titles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) NOT NULL DEFAULT 0,
  `title` varchar(250) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `user_titles_passport_FK` (`passport`),
  CONSTRAINT `user_titles_passport_FK` FOREIGN KEY (`passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.user_titles: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.vehicles
CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Passport` int(11) NOT NULL,
  `vehicle` varchar(100) NOT NULL,
  `tax` int(20) NOT NULL DEFAULT 0,
  `plate` varchar(10) DEFAULT NULL,
  `rental` int(20) NOT NULL DEFAULT 0,
  `arrest` int(20) NOT NULL DEFAULT 0,
  `engine` int(4) NOT NULL DEFAULT 1000,
  `body` int(4) NOT NULL DEFAULT 1000,
  `health` int(4) NOT NULL DEFAULT 1000,
  `fuel` int(3) NOT NULL DEFAULT 100,
  `nitro` int(5) NOT NULL DEFAULT 0,
  `work` varchar(5) NOT NULL DEFAULT 'false',
  `doors` varchar(250) NOT NULL DEFAULT '',
  `windows` varchar(250) NOT NULL DEFAULT '',
  `tyres` varchar(250) NOT NULL DEFAULT '',
  `degrade` int(20) NOT NULL DEFAULT 0,
  `chest` longtext DEFAULT '{}',
  `expires` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate` (`plate`),
  KEY `Passport` (`Passport`),
  KEY `vehicle` (`vehicle`),
  KEY `idx_passport_vehicle` (`Passport`,`vehicle`),
  CONSTRAINT `vehicles_Passport_FK` FOREIGN KEY (`Passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.vehicles: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.vip_vehicle
CREATE TABLE IF NOT EXISTS `vip_vehicle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) DEFAULT NULL,
  `vehicles` longtext DEFAULT '{}',
  PRIMARY KEY (`id`),
  KEY `vip_vehicle_passport_FK` (`passport`),
  CONSTRAINT `vip_vehicle_passport_FK` FOREIGN KEY (`passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.vip_vehicle: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.warehouse
CREATE TABLE IF NOT EXISTS `warehouse` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `weight` int(10) NOT NULL DEFAULT 200,
  `password` varchar(50) NOT NULL,
  `Passport` int(11) NOT NULL DEFAULT 0,
  `tax` int(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`),
  KEY `id` (`id`),
  CONSTRAINT `warehouse_Passport_FK` FOREIGN KEY (`Passport`) REFERENCES `characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.warehouse: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.warsystem
CREATE TABLE IF NOT EXISTS `warsystem` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `attack` varchar(50) DEFAULT '0',
  `defense` varchar(50) DEFAULT '0',
  `start` datetime DEFAULT NULL,
  `end` datetime DEFAULT NULL,
  `killsAttack` int(11) DEFAULT 0,
  `killsDefense` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.warsystem: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cidadesanta.whitelist_kd
CREATE TABLE IF NOT EXISTS `whitelist_kd` (
  `passport` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cidadesanta.whitelist_kd: ~0 rows (aproximadamente)

-- Copiando estrutura para trigger cidadesanta.banneds_before_delete
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `banneds_before_delete` BEFORE DELETE ON `banneds` FOR EACH ROW UPDATE banneds_hwid SET banned = 0, reason = NULL WHERE accountId = old.accountId//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger cidadesanta.banneds_before_insert
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `banneds_before_insert` BEFORE INSERT ON `banneds` FOR EACH ROW UPDATE banneds_hwid SET banned = 1, reason = NEW.reason WHERE accountId = NEW.accountId//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger cidadesanta.banned_ip_before_delete
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `banned_ip_before_delete` BEFORE DELETE ON `banneds` FOR EACH ROW DELETE FROM banned_ip WHERE accountId = OLD.accountId//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger cidadesanta.banned_ip_before_insert
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `banned_ip_before_insert` BEFORE INSERT ON `banneds` FOR EACH ROW
BEGIN
  DECLARE last_ip_value VARCHAR(45);
  SELECT last_ip INTO last_ip_value FROM accounts WHERE id = NEW.accountId;
  INSERT INTO banned_ip (accountId, reason, ip) VALUES (NEW.accountId, NEW.reason, last_ip_value);
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger cidadesanta.before_delete_fines
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `before_delete_fines` BEFORE DELETE ON `fines` FOR EACH ROW BEGIN
    IF (OLD.mdt IS NOT NULL) THEN
        UPDATE mdt_bills
        SET paid = 1
        WHERE mdt_bills.id = OLD.mdt;
    END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger cidadesanta.before_insert_accounts
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `before_insert_accounts` BEFORE INSERT ON `accounts` FOR EACH ROW BEGIN 
	SET @newToken = generate_discord_token();
	WHILE EXISTS(SELECT token FROM accounts WHERE token = @newToken) DO
		SET @newToken = generate_discord_token();
	END WHILE;
	SET new.token = @newToken;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- =========================================================================
-- TABELAS ADICIONAIS NECESSARIAS PARA SCRIPTS DO SERVIDOR
-- =========================================================================

CREATE TABLE IF NOT EXISTS `dashboard_tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) NOT NULL DEFAULT 0,
  `subject` varchar(255) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'open',
  `staff_passport` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `passport` (`passport`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `player_missions` (
  `passport` int(11) NOT NULL,
  `mission_id` varchar(50) NOT NULL,
  `progress` int(11) NOT NULL DEFAULT 0,
  `completed` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`passport`, `mission_id`),
  KEY `passport` (`passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `player_skills` (
  `passport` int(11) NOT NULL,
  `skill_id` varchar(50) NOT NULL,
  `xp` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`passport`, `skill_id`),
  KEY `passport` (`passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `player_pets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) NOT NULL DEFAULT 0,
  `name` varchar(50) NOT NULL DEFAULT 'Pet',
  `model` varchar(50) NOT NULL DEFAULT 'a_c_chop',
  `hunger` int(11) NOT NULL DEFAULT 100,
  `happiness` int(11) NOT NULL DEFAULT 100,
  `xp` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `passport` (`passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `painel_points_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL DEFAULT 0,
  `amount` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `groupId` (`groupId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `player_ped_skins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) NOT NULL DEFAULT 0,
  `skin` varchar(100) NOT NULL DEFAULT '',
  `label` varchar(100) NOT NULL DEFAULT '',
  `is_favorite` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `passport` (`passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `player_titles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) NOT NULL DEFAULT 0,
  `title` varchar(100) NOT NULL DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `passport` (`passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `santa_cargame_ranking` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) NOT NULL DEFAULT 0,
  `name` varchar(100) NOT NULL DEFAULT '',
  `points` int(11) NOT NULL DEFAULT 0,
  `wins` int(11) NOT NULL DEFAULT 0,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `passport` (`passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `santa_deathstatue_ranking` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) NOT NULL DEFAULT 0,
  `name` varchar(100) NOT NULL DEFAULT '',
  `points` int(11) NOT NULL DEFAULT 0,
  `wins` int(11) NOT NULL DEFAULT 0,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `passport` (`passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `character_customizations` (
  `passport` int(11) NOT NULL,
  `data` longtext DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `audio_schedules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `url` varchar(500) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `frequency` varchar(50) DEFAULT NULL,
  `scheduled_at` datetime DEFAULT NULL,
  `audience` varchar(100) DEFAULT NULL,
  `world` int(11) NOT NULL DEFAULT 0,
  `volume` float NOT NULL DEFAULT 1,
  `status` varchar(50) NOT NULL DEFAULT 'active',
  `created_by` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `staffgang_farms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `templateId` varchar(50) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `shopTitle` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `allowedGroupsText` text DEFAULT NULL,
  `isAfk` tinyint(1) NOT NULL DEFAULT 0,
  `disabled` tinyint(1) NOT NULL DEFAULT 0,
  `data` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `staffgang_points` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `farmId` int(11) NOT NULL DEFAULT 0,
  `data` longtext DEFAULT NULL,
  `disabled` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `farmId` (`farmId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `staffgang_shops` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `farmId` int(11) NOT NULL DEFAULT 0,
  `data` longtext DEFAULT NULL,
  `disabled` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `farmId` (`farmId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `custom_logs` (
  `hook` varchar(100) NOT NULL,
  `link` varchar(500) NOT NULL,
  PRIMARY KEY (`hook`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `log_itemvip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `passport` int(11) NOT NULL DEFAULT 0,
  `item` varchar(100) DEFAULT NULL,
  `amount` int(11) NOT NULL DEFAULT 1,
  `selections` longtext DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `passport` (`passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `rank_1x1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `winner` int(11) NOT NULL DEFAULT 0,
  `loser` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `shops_stock` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `store` varchar(50) NOT NULL,
  `item` varchar(50) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `store_item` (`store`, `item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
