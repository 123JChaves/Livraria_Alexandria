-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 24/11/2025 às 04:45
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `alexandria`
--

DELIMITER $$
--
-- Procedimentos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_massivo_na_tabela_cliente` (IN `qtde` INT)   BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE nome VARCHAR(50);
    DECLARE email VARCHAR(50);
    DECLARE senha VARCHAR(100);
    DECLARE CONTINUE HANDLER FOR 1062
    BEGIN
        SET i = i + 1;
    END;

    WHILE i < qtde DO
        SET nome = CONCAT('Cliente ', i);
        SET email = CONCAT('cliente', i, '@email.com');
        SET senha = CONCAT('senha', i);

        INSERT INTO cliente (nome, email, senha)
        VALUES (nome, email, senha);

        SET i = i + 1;
    END WHILE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_massivo_na_tabela_produto` (IN `qtde` INT)   BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE categoria_id INT;
    DECLARE done INT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro ao inserir produto';
    END;

    START TRANSACTION;
    WHILE i < qtde DO
        SELECT id INTO categoria_id FROM categoria ORDER BY RAND() LIMIT 1;
        IF categoria_id IS NOT NULL THEN
            INSERT INTO produto (nome, categoria_id, autor, descricao, imagem, valor, destaque, ativo)
            VALUES (CONCAT('Produto ', i), categoria_id, CONCAT('Autor ', i), CONCAT('Descrição do produto ', i), CONCAT('imagem', i, '.jpg'), i * 10, 'S', 'S');
            SET i = i + 1;
        END IF;
    END WHILE;
    COMMIT;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `categoria`
--

CREATE TABLE `categoria` (
  `id` int(11) NOT NULL,
  `descricao` varchar(30) NOT NULL,
  `ativo` enum('S','N') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `categoria`
--

INSERT INTO `categoria` (`id`, `descricao`, `ativo`) VALUES
(15, 'Filosofia', 'S'),
(16, 'Romance', 'S'),
(17, 'Biografia', 'S'),
(18, 'Ficção', 'S'),
(19, 'História', 'S');

-- --------------------------------------------------------

--
-- Estrutura para tabela `cliente`
--

CREATE TABLE `cliente` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `senha` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `cliente`
--

INSERT INTO `cliente` (`id`, `nome`, `email`, `senha`) VALUES
(11, 'Juliano Chaves Baptista', 'juliano@gmail.com', '$2y$10$5Xefmm1qKfXbLs5EpGU8X.Hn/1qBRvrvlUjkRB5aHU1/dl2Rak9Ou'),
(12, 'Gabriela Markus Chaves', 'gabi@gmail.com', '$2y$10$ZaKg64BhD6flAANPbd74sefyjgUHAMcG9KaHchKvRcRrS1dO9Mc52'),
(13, 'Daniel Markus Baptista', 'daniel@gmail.com', '$2y$10$NYeJXFGiVowuJ49JsdBw5OfmCznngxgqWh24EAye0BpQVzEguk81u'),
(14, 'Andressa Rabelo', 'andressa@gmail.com', '$2y$10$VP6ldyN1n/vOxAx15E0ouOI4wlVT.5zY85cAvtcaz.iZl4pgqHmYG');

-- --------------------------------------------------------

--
-- Estrutura para tabela `item`
--

CREATE TABLE `item` (
  `pedido_id` int(11) NOT NULL,
  `produto_id` int(11) NOT NULL,
  `qtde` int(11) NOT NULL,
  `valor` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `item`
--

INSERT INTO `item` (`pedido_id`, `produto_id`, `qtde`, `valor`) VALUES
(8, 52, 1, 87),
(8, 54, 1, 97),
(8, 55, 2, 132),
(8, 58, 1, 96),
(8, 59, 1, 137),
(9, 52, 1, 87),
(9, 55, 1, 132),
(9, 56, 1, 67),
(9, 58, 1, 96),
(9, 59, 1, 137),
(15, 54, 1, 97),
(15, 56, 1, 67),
(15, 58, 1, 96),
(16, 53, 1, 127),
(16, 59, 1, 137),
(17, 52, 1, 87),
(17, 54, 3, 97),
(17, 58, 1, 96),
(17, 59, 1, 137),
(18, 52, 2, 87),
(18, 53, 1, 127),
(18, 55, 1, 132),
(18, 59, 1, 137),
(19, 52, 1, 87),
(19, 53, 1, 127),
(19, 55, 1, 132),
(19, 56, 1, 67),
(19, 58, 1, 96),
(19, 59, 1, 137),
(19, 60, 1, 147),
(20, 52, 1, 87),
(20, 54, 1, 97),
(20, 56, 1, 67),
(21, 52, 1, 87),
(21, 53, 1, 127),
(21, 58, 1, 96),
(21, 59, 1, 137),
(22, 55, 1, 132),
(22, 59, 1, 137),
(22, 60, 1, 147),
(23, 58, 1, 96),
(23, 91, 1, 120),
(23, 92, 1, 185),
(23, 93, 1, 98),
(23, 95, 1, 142);

-- --------------------------------------------------------

--
-- Estrutura para tabela `pedido`
--

CREATE TABLE `pedido` (
  `id` int(11) NOT NULL,
  `cliente_id` int(11) NOT NULL,
  `data` datetime NOT NULL,
  `preference_id` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `pedido`
--

INSERT INTO `pedido` (`id`, `cliente_id`, `data`, `preference_id`) VALUES
(8, 11, '2025-11-19 19:27:27', '1077390063-010dc826-31ea-4589-a3df-89f08476498d'),
(9, 11, '2025-11-19 19:35:47', '1077390063-9f8da6ca-51c5-4f0a-a8e1-b462a880de8f'),
(15, 11, '2025-11-19 19:46:17', '1077390063-e749773f-8e44-4cd0-80e5-310eedcad0f8'),
(16, 11, '2025-11-19 19:48:58', '1077390063-57b7b04d-e01f-4c03-a17d-e9cfdce670fc'),
(17, 12, '2025-11-20 07:22:12', '1077390063-38b89f38-4472-4c4f-8058-ec40c9d7e86a'),
(18, 12, '2025-11-20 07:23:41', '1077390063-ff60ee89-df9a-4e6c-b76d-3ae4e66d190a'),
(19, 13, '2025-11-22 04:44:14', '1077390063-caf2a228-ae4c-4140-bb71-65ef6bf23a2e'),
(20, 13, '2025-11-22 04:45:11', '1077390063-bf7a708c-c744-4224-b370-b3783cb7df29'),
(21, 14, '2025-11-22 04:47:19', '1077390063-af989d15-920e-4c89-9d67-5f7fea5bbc8a'),
(22, 14, '2025-11-22 04:48:01', '1077390063-b2419ac9-3486-4a51-a068-94aa7b7377d2'),
(23, 13, '2025-11-23 13:43:06', '1077390063-e006207d-1416-4872-9777-abb17add5d99');

-- --------------------------------------------------------

--
-- Estrutura para tabela `produto`
--

CREATE TABLE `produto` (
  `id` int(11) NOT NULL,
  `nome` varchar(250) NOT NULL,
  `categoria_id` int(11) NOT NULL,
  `autor` varchar(50) NOT NULL,
  `descricao` text NOT NULL,
  `imagem` varchar(100) NOT NULL,
  `valor` double NOT NULL,
  `destaque` enum('S','N') NOT NULL,
  `ativo` enum('S','N') NOT NULL,
  `quantidade` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `produto`
--

INSERT INTO `produto` (`id`, `nome`, `categoria_id`, `autor`, `descricao`, `imagem`, `valor`, `destaque`, `ativo`, `quantidade`) VALUES
(52, 'As Crônicas de Nárnia', 18, 'C. S. Lewis', '<p>Famoso livor de ficção infanto-juvenil do escritor irlandês C. S. Lewis</p>', '1763951402.jpg', 97, 'S', 'S', 0),
(53, 'O Silmarillion', 18, 'J. R. Tolkien', '<p>Livro que contém as primeiras história do famoso universo de \"O Senhor dos Anéis\" Tolkien.</p>', '1763855114.jpg', 87, 'S', 'S', 0),
(54, 'Direito Natural e História', 15, 'Leo Strauss', '<p>Importante obra que abordam de forma btilhante o tema do Direito Natural. O livro é uma busca para justificar e importância do direito natural, principalmente levando em consideração o século XX, século tanto das duas mais violentas e destrutivas guerras já registradas na história, como da ascensã dos regimes mais autoritários e também violentos da história humana. </p>', '1763952619.jpg', 107, 'S', 'S', 0),
(55, 'Crime e Castigo', 16, 'Fiódor M. Dostoiévski', '<p>Importante obra de Dostoiéviski, Crime e Castigo narra a história de Raskólninkov, gênio matemático que foi tomado por uma noção niilista de mundo, e que tecidindo levar até o fim a sua tese comete um terrível ato que tanto marcará toda a sus história no livro, como servirá de importante ocasião para marcar o sentido da obra. </p>', '1763951545.jpg', 142, 'S', 'S', 0),
(56, 'Apologia de Sócrates', 15, 'Platão', 'Narrando o fatídico epísódio do julgamento de Sócrates, esse diálogo platônico é um símbolo universal a filosofia. <br>Acusado de impiedade e de corromper a juventude, Sócrates defende a sua atividade como um chamamento divino, atividade que basicamente consisitia em por meio da conversação, testar os limites da sabedoria dos sábios atenienses. O que é possível ver é que na atividade filosófica de Sócrates está a busca pela transicção da aparência da realidade para a própria realidade, que operada pelo jogo de perguntas respostas acaba por desunar o coração daqueles envolvidos pela conversação socrática - resultando nem sempre bem-vindo aos amantes da aparência. ', '1763948212.jpg', 67, 'S', 'S', 0),
(58, 'O Diário de Anne Frank', 17, 'Anne Frank', '<p>Essa é a famosa e imortal biografia de Anne Frank. O Diário contém auto-relatos que compreendem o período que vai de antes da Segunda Guerra Mundial até a Guerra, período em que a família de Anne, junto a ela, por ser judia, se escondeu em algum lugar da Holanda enquanto fugia das forças nazistas.&nbsp;</p>', '1763590818.jpg', 96, 'S', 'S', 0),
(59, 'Jerusalém: A Biografia', 19, 'Simon Sebag Montefiore', 'Esse livro, escrito pelo renomado jornalista Simon S. Montefiore, discorre sobre a movimentada história milenar da cidade de Jerusalém, passando pela época do domínio dos judeus, ao período islâmido até os tempos modernos.&nbsp;', '1763591035.jpg', 137, 'S', 'S', 0),
(60, 'A República', 15, 'Platão', 'Sendo de forma incontestável o mais famoso diálogo de Platão, a República trata da busca filosófica pela compreensão do conceito de justiça. A universalidade do tema atinge amplamente todas as esferas humanas, indo da área teológica, às artes, à guerra, educação, propriedade etc. Para Platão o conceito de justiça não é meramente uma consideração a respeito do certo e do errado, antes tem certo status ontológico não por ser apenas uma forma (Ideia) que poder gerador, como o são as Ideias na teoria de Platão, mas sim mais alta e nobre configuraçõ da alma que por si equilibras e unidas todas as potências da alma, seja ela a potência da coragem, da sabedoria e da moderação. E como a cidade é o \'Homem em letras grandes\', a justiça é aquela que dá o ato de ser à nobre Pólis, que mesmo que não exista no campo da existência, ainda assim tem seu modelo, como diria o filósofo, guardado nos Céus. ', '1763950906.jpg', 157, 'S', 'S', 0),
(91, 'Metafísica', 15, 'Aristóteles', 'Obra clássica da Filosofia', '1763866777.jpg', 120, 'S', 'S', 0),
(92, 'Guerra e Paz, vols I e II', 16, 'Liev Tolstói', 'Romance histórico', '1763866884.jpg', 185, 'N', 'S', 0),
(93, 'Trotsky: Uma Biografia', 17, 'Robert Service', 'Biografia de Léon Trotsky', '1763866656.jpg', 98, 'S', 'S', 0),
(94, '1984', 18, 'George Orwell', 'Distopia clássica', '1763948899.jpg', 105, 'S', 'S', 25),
(95, 'Memórias da II Guerra Mundial', 19, 'Wintson Chuchill', 'Relatos de Wintson Churchill sobre a Segunda Guerra Mundial', '1763866498.jpg', 142, 'N', 'S', 0);

--
-- Acionadores `produto`
--
DELIMITER $$
CREATE TRIGGER `alteracao_valor_produto` BEFORE UPDATE ON `produto` FOR EACH ROW BEGIN
    IF OLD.valor != NEW.valor THEN
        INSERT INTO produto_valor_log (produto_id, valor_antigo, valor_novo, usuario_id, usuario_nome, data_alteracao)
        VALUES (OLD.id, OLD.valor, NEW.valor, @usuario_id, (SELECT nome FROM usuario WHERE id = @usuario_id), NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `produto_valor_log`
--

CREATE TABLE `produto_valor_log` (
  `id` int(11) NOT NULL,
  `produto_id` int(11) DEFAULT NULL,
  `valor_antigo` decimal(10,2) DEFAULT NULL,
  `valor_novo` decimal(10,2) DEFAULT NULL,
  `data_alteracao` date DEFAULT NULL,
  `usuario_nome` varchar(255) DEFAULT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `usuario` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `produto_valor_log`
--

INSERT INTO `produto_valor_log` (`id`, `produto_id`, `valor_antigo`, `valor_novo`, `data_alteracao`, `usuario_nome`, `usuario_id`, `usuario`) VALUES
(1, 53, 97.00, 87.00, '2025-11-22', NULL, NULL, NULL),
(2, 94, 85.00, 85.00, '2025-11-22', NULL, NULL, NULL),
(3, 95, 142.00, 142.00, '2025-11-22', NULL, NULL, NULL),
(4, 93, 98.00, 98.00, '2025-11-22', NULL, NULL, NULL),
(5, 91, 120.00, 120.00, '2025-11-22', NULL, NULL, NULL),
(6, 92, 155.00, 185.00, '2025-11-23', NULL, NULL, NULL),
(7, 94, 85.00, 85.00, '2025-11-23', NULL, NULL, NULL),
(8, 94, 85.00, 95.00, '2025-11-23', NULL, NULL, NULL),
(9, 56, 67.00, 77.00, '2025-11-23', NULL, NULL, NULL),
(10, 56, 67.00, 77.00, '2025-11-23', NULL, NULL, NULL),
(11, 56, 77.00, 67.00, '2025-11-23', NULL, NULL, NULL),
(12, 56, 67.00, 67.00, '2025-11-23', NULL, NULL, NULL),
(13, 94, 95.00, 105.00, '2025-11-23', NULL, NULL, NULL),
(14, 94, 95.00, 105.00, '2025-11-23', 'Bill Gates', 1, NULL),
(15, 60, 147.00, 157.00, '2025-11-23', NULL, NULL, NULL),
(16, 60, 147.00, 157.00, '2025-11-23', 'Bill Gates', 1, NULL),
(17, 52, 87.00, 97.00, '2025-11-23', NULL, NULL, NULL),
(18, 52, 87.00, 97.00, '2025-11-23', 'Bill Gates', 1, NULL),
(19, 55, 132.00, 142.00, '2025-11-23', NULL, NULL, NULL),
(20, 54, 97.00, 107.00, '2025-11-23', 'Bill Gates', 1, NULL);

-- --------------------------------------------------------

--
-- Estrutura para tabela `sessao`
--

CREATE TABLE `sessao` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuario`
--

CREATE TABLE `usuario` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `senha` varchar(200) NOT NULL,
  `telefone` varchar(25) NOT NULL,
  `ativo` enum('S','N') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `usuario`
--

INSERT INTO `usuario` (`id`, `nome`, `email`, `senha`, `telefone`, `ativo`) VALUES
(1, 'Bill Gates', 'bill@gmail.com', '$2y$10$vlKXwI9l1H42YtnKDrph0uXpV8TrtCKCyWOurwoMibSt.GsRg05qK', '(44) 99999-1234', 'S'),
(2, 'Anderson Burnes', 'burnes@gmail.com', '$2y$10$vlKXwI9l1H42YtnKDrph0uXpV8TrtCKCyWOurwoMibSt.GsRg05qK', '(44) 99999-9999', 'S'),
(3, 'Steve Jobs', 'stevej@gmail.com', '$2y$10$oBBNNoAL3qjQRtpRfEZb9efSrLImrVXhPY8mFAmkP430k0POcunXy', '(44) 98765-4321', 'S'),
(5, 'Juliano Chaves Baptista', 'juliano@gmail.com', '$2y$10$e8qqNBY7KElRFhtEpIOHQu09NgKQ6oIGawk.y7mAgav8glRKwRbX2', '(44) 99999-9999', 'S'),
(6, 'Gordon Thompson', 'gordonth@gmail.com', '$2y$10$fy4U1sHG7uuss4fJWyBUfOxr85SNUUcTT8f3YRtEsaWVvFqaB8kTm', '(44) 99999-9999', 'S');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `categoria` (`descricao`);

--
-- Índices de tabela `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`pedido_id`,`produto_id`),
  ADD KEY `produto_id` (`produto_id`);

--
-- Índices de tabela `pedido`
--
ALTER TABLE `pedido`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cliente_id` (`cliente_id`);

--
-- Índices de tabela `produto`
--
ALTER TABLE `produto`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `produto_valor_log`
--
ALTER TABLE `produto_valor_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `produto_id` (`produto_id`),
  ADD KEY `fk_usuario_id` (`usuario_id`);

--
-- Índices de tabela `sessao`
--
ALTER TABLE `sessao`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Índices de tabela `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `categoria`
--
ALTER TABLE `categoria`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de tabela `cliente`
--
ALTER TABLE `cliente`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de tabela `pedido`
--
ALTER TABLE `pedido`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de tabela `produto`
--
ALTER TABLE `produto`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT de tabela `produto_valor_log`
--
ALTER TABLE `produto_valor_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `item`
--
ALTER TABLE `item`
  ADD CONSTRAINT `item_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `pedido` (`id`),
  ADD CONSTRAINT `item_ibfk_2` FOREIGN KEY (`produto_id`) REFERENCES `produto` (`id`);

--
-- Restrições para tabelas `pedido`
--
ALTER TABLE `pedido`
  ADD CONSTRAINT `pedido_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `cliente` (`id`);

--
-- Restrições para tabelas `produto_valor_log`
--
ALTER TABLE `produto_valor_log`
  ADD CONSTRAINT `fk_usuario_id` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`),
  ADD CONSTRAINT `produto_valor_log_ibfk_1` FOREIGN KEY (`produto_id`) REFERENCES `produto` (`id`);

--
-- Restrições para tabelas `sessao`
--
ALTER TABLE `sessao`
  ADD CONSTRAINT `sessao_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
