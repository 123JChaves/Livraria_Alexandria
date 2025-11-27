-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 27/11/2025 às 22:41
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `querys_cliente_compras` (IN `p_cliente_id` INT)   begin
	-- Nome do cliente
	select c.nome as nome_cliente
	from cliente c
	where c.id = p_cliente_id;
	
    -- Valor total de compras do cliente
    select sum(i.qtde * i.valor) AS valor_total_compras
    from pedido p
    inner join item i ON p.id = i.pedido_id
    where p.cliente_id = p_cliente_id;

    -- Quantidade total de itens comprados pelo cliente
    select sum(i.qtde) as quantidade_itens_comprados
    from pedido p
    inner join item i ON p.id = i.pedido_id
    where p.cliente_id = p_cliente_id;

    -- Itens comprados pelo cliente e valor de cada item
    select pr.nome as produto, 
    sum(i.qtde ) as quantidade_itens_comprados,
        i.valor as valor_unitario,
    sum(i.qtde * i.valor) as valor_total_itens
    from pedido p
    inner join item i ON p.id = i.pedido_id
    inner join produto pr ON i.produto_id = pr.id
    where p.cliente_id = p_cliente_id
    group by pr.nome, i.valor;

    -- Itens comprados pelo cliente, quantidade e valor total
    select pr.nome AS produto,
        sum(i.qtde) AS quantidade_itens_comprados,
        sum(i.qtde * i.valor) AS valor_total_itens
    from pedido p
    inner join item i ON p.id = i.pedido_id
    inner join produto pr ON i.produto_id = pr.id
    where p.cliente_id = p_cliente_id
    group by pr.nome;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `querys_cliente_compras2` (IN `p_cliente_id` INT)   begin
    select 
        c.nome as nome_cliente, 
        (select sum(i.qtde * i.valor) from pedido p inner join item i ON p.id = i.pedido_id where p.cliente_id = p_cliente_id) AS valor_total_compras,
        pr.nome as produto, 
        i.valor as valor_unitario, 
        sum(i.qtde) as quantidade_itens_comprados, 
        sum(i.qtde * i.valor) as valor_total_itens 
    from 
        cliente c 
    inner join 
        pedido p ON c.id = p.cliente_id 
    inner join 
        item i ON p.id = i.pedido_id 
    inner join 
        produto pr ON i.produto_id = pr.id 
    where 
        c.id = p_cliente_id 
    group by 
        pr.nome, i.valor;
end$$

--
-- Funções
--
CREATE DEFINER=`root`@`localhost` FUNCTION `verificar_estoque_pedido` (`pedido_id` INT) RETURNS TINYINT(4)  BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE produto_id INT;
    DECLARE qtde_pedido INT;
    DECLARE estoque INT;
    DECLARE resultado TINYINT DEFAULT 1;

    DECLARE cur1 CURSOR FOR
        SELECT p.id, i.qtde
        FROM item i
        JOIN produto p ON i.produto_id = p.id
        WHERE i.pedido_id = pedido_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur1;

    read_loop: LOOP
        FETCH cur1 INTO produto_id, qtde_pedido;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT quantidade INTO estoque
        FROM produto
        WHERE id = produto_id;

        IF estoque IS NULL OR estoque < qtde_pedido THEN
            SET resultado = 0;
            LEAVE read_loop;
        END IF;
    END LOOP;

    CLOSE cur1;

    RETURN resultado;
end$$

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
(14, 'Andressa Rabelo', 'andressa@gmail.com', '$2y$10$VP6ldyN1n/vOxAx15E0ouOI4wlVT.5zY85cAvtcaz.iZl4pgqHmYG'),
(15, 'Juliano Chaves Baptista', 'juliano@hotmail.com', '$2y$10$neTvupun.k6U19M3Ak2CBOra45cK12/qM5bqfclUt0HZVVi4TlonK'),
(16, 'Maria Cida', 'maria@gmail.com', '$2y$10$fG/Etj1K3pwTN1YILna8LuNKX.YW5WB4IVRIWJOBaABn/15KhF6VG'),
(17, 'Lori Marlei Markus', 'lori@gmail.com', '$2y$10$K4hvKyihyLps2WHB.bUHFu5f8tcWVKdV.AC4DQtAjzhHynS1wxooi');

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
(23, 95, 1, 142),
(24, 94, 1, 105),
(25, 59, 4, 147),
(25, 60, 3, 157),
(25, 91, 3, 120),
(25, 93, 1, 118),
(25, 95, 3, 142),
(26, 58, 1, 96),
(26, 59, 1, 147),
(27, 53, 1, 97),
(27, 54, 1, 107),
(27, 55, 2, 142),
(27, 58, 1, 96),
(27, 60, 1, 157),
(27, 91, 1, 120),
(27, 92, 1, 207),
(28, 55, 1, 142),
(28, 59, 1, 147),
(28, 60, 1, 157),
(28, 95, 1, 142),
(29, 93, 1, 118),
(29, 94, 1, 105),
(29, 95, 1, 142),
(30, 91, 4, 120),
(30, 92, 4, 207),
(30, 93, 1, 118),
(30, 94, 1, 105),
(30, 95, 5, 142),
(31, 94, 5, 105),
(32, 55, 4, 142),
(32, 93, 3, 118),
(33, 52, 1, 97),
(33, 56, 1, 67),
(33, 58, 1, 96),
(33, 60, 1, 157),
(33, 91, 1, 120),
(33, 92, 3, 207),
(33, 93, 1, 118),
(33, 94, 1, 105),
(33, 95, 1, 142),
(34, 55, 1, 142),
(34, 60, 1, 157),
(34, 93, 1, 118),
(34, 95, 1, 142),
(35, 60, 1, 137),
(36, 60, 1, 137),
(37, 94, 1, 85),
(38, 58, 15, 96),
(38, 94, 1, 85),
(39, 58, 5, 96),
(40, 93, 10, 118),
(40, 94, 1, 85),
(41, 60, 1, 137),
(41, 93, 1, 118),
(42, 60, 3, 137),
(42, 94, 5, 85),
(43, 60, 1, 137),
(43, 93, 1, 118),
(43, 94, 1, 85),
(44, 94, 3, 85),
(45, 94, 1, 85),
(46, 94, 1, 85),
(47, 60, 1, 137),
(47, 93, 1, 118),
(48, 60, 9, 137),
(49, 58, 1, 107),
(49, 59, 1, 147),
(49, 60, 1, 110),
(50, 58, 1, 107),
(51, 58, 5, 107),
(52, 58, 5, 97),
(53, 58, 8, 97),
(54, 54, 1, 87),
(54, 58, 3, 97),
(54, 60, 1, 110),
(55, 55, 1, 132),
(55, 58, 1, 97),
(55, 92, 1, 207),
(55, 94, 1, 97),
(55, 95, 2, 132),
(56, 52, 1, 87),
(56, 53, 1, 87),
(56, 58, 1, 97),
(56, 92, 1, 207),
(58, 52, 2, 87),
(58, 58, 1, 97),
(58, 60, 1, 110),
(58, 92, 1, 207),
(62, 58, 1, 97),
(62, 94, 1, 97),
(64, 54, 1, 87),
(64, 60, 1, 110),
(70, 59, 1, 147),
(72, 58, 1, 97),
(73, 59, 1, 147),
(74, 60, 1, 110),
(76, 60, 1, 110),
(82, 60, 1, 110),
(83, 93, 1, 118),
(84, 58, 1, 97),
(85, 52, 1, 97),
(85, 58, 1, 97),
(86, 52, 1, 97),
(87, 91, 1, 120),
(88, 91, 1, 120),
(89, 91, 1, 120),
(93, 60, 1, 110),
(94, 58, 1, 97),
(113, 91, 1, 120),
(114, 54, 1, 87),
(114, 91, 1, 120),
(115, 91, 1, 120),
(117, 54, 1, 87),
(117, 58, 1, 97),
(117, 60, 1, 110),
(117, 94, 1, 97),
(117, 95, 1, 132),
(118, 53, 1, 87),
(118, 54, 1, 87),
(118, 55, 1, 132),
(118, 58, 1, 97),
(118, 91, 1, 120),
(119, 52, 1, 97),
(119, 58, 1, 97),
(119, 91, 1, 120),
(119, 95, 1, 132),
(120, 58, 1, 97);

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
(23, 13, '2025-11-23 13:43:06', '1077390063-e006207d-1416-4872-9777-abb17add5d99'),
(24, 11, '2025-11-24 13:49:54', '1077390063-117b9537-4b55-4807-af66-c1a1cb04543d'),
(25, 11, '2025-11-24 14:04:37', '1077390063-e411921c-e88d-4166-90c9-73353975a75e'),
(26, 11, '2025-11-24 14:15:06', '1077390063-01139d0b-a9e3-4ef1-a471-ecc6cba89ed0'),
(27, 16, '2025-11-24 16:34:25', '1077390063-54fb1811-b51a-470b-bc1a-287619f317ea'),
(28, 16, '2025-11-24 16:34:57', '1077390063-17c2a0b8-9ade-4030-b9ce-63b2dd3d8b2a'),
(29, 16, '2025-11-24 16:37:19', '1077390063-1d087f29-f379-4ed9-8a64-0210fd80f7b0'),
(30, 14, '2025-11-24 16:39:56', '1077390063-05107d9e-fedd-43f8-a17d-0a6ff6d3c4cb'),
(31, 14, '2025-11-24 16:40:57', '1077390063-da446815-a2c3-4526-9fce-549eb56ec124'),
(32, 14, '2025-11-24 17:26:17', '1077390063-28d45100-bb87-41fa-a642-cb768987504c'),
(33, 17, '2025-11-24 17:28:56', '1077390063-51ec9b38-ddc0-4fc9-a987-e60c9dedde94'),
(34, 17, '2025-11-24 17:29:20', '1077390063-0488ab0b-ad50-4175-b56f-04d64b5e8732'),
(35, 17, '2025-11-25 19:08:25', '1077390063-8ed08833-ddae-4829-99f9-1203b98bf794'),
(36, 17, '2025-11-25 19:22:13', '1077390063-b457eb51-8350-4d87-a682-fa4bca4d9de4'),
(37, 17, '2025-11-25 19:52:06', '1077390063-2fcba8cb-1487-46d7-a98c-fcf3ebcb7ddc'),
(38, 17, '2025-11-25 20:07:13', '1077390063-b20eb2ea-9464-4f59-92d2-0c396adf90ad'),
(39, 17, '2025-11-25 20:28:26', '1077390063-437ab86c-1d01-41e1-8e8f-53ac821924f0'),
(40, 17, '2025-11-25 22:54:21', '1077390063-beafce38-e025-4b72-8813-81f67a469637'),
(41, 13, '2025-11-25 22:57:03', '1077390063-68f92400-7fad-4dd2-a3e4-e10b4153f946'),
(42, 13, '2025-11-26 00:20:32', '1077390063-f8ddfa00-a8d7-4fd6-ac0c-5b58da8e1e5f'),
(43, 13, '2025-11-26 00:21:23', '1077390063-e9dc1fd2-42e9-4cb3-91d4-c64ac86fdea7'),
(44, 13, '2025-11-26 00:58:25', '1077390063-080660a3-a4ca-42c3-865c-2f9975378ab1'),
(45, 13, '2025-11-26 01:00:58', '1077390063-3b2b45c9-4688-4d0a-8971-6e3359af98cf'),
(46, 13, '2025-11-26 01:01:21', '1077390063-bb42747a-7eaf-4255-9af1-aa9b975698af'),
(47, 13, '2025-11-26 01:03:00', '1077390063-0cd53e44-fb65-409b-8385-724a50b075a7'),
(48, 13, '2025-11-26 01:05:14', '1077390063-f4ee4267-9448-46f4-83c8-44780dd3d427'),
(49, 13, '2025-11-26 03:51:14', '1077390063-69aa4515-0fcb-4e03-aefc-a26b36b9748d'),
(50, 13, '2025-11-26 04:05:51', '1077390063-3b8755a6-679c-4b6e-85b5-23800d23060c'),
(51, 13, '2025-11-26 04:10:16', '1077390063-9ed6a3a2-6314-454a-8a58-a53852488d15'),
(52, 13, '2025-11-26 04:16:20', '1077390063-aad205eb-7b69-4c4a-a254-cf2744aa5612'),
(53, 13, '2025-11-26 04:22:10', '1077390063-9145dd64-f8a0-4947-b667-c3613b9904ea'),
(54, 12, '2025-11-26 14:56:52', '1077390063-621d30c0-72b1-4484-a1f1-cfc49312f5cf'),
(55, 12, '2025-11-26 22:36:15', '1077390063-f56cbbfd-d988-468b-bbab-ad43d4d6896a'),
(56, 12, '2025-11-26 22:55:22', ''),
(57, 12, '2025-11-26 22:55:30', ''),
(58, 12, '2025-11-26 23:05:50', ''),
(59, 12, '2025-11-26 23:06:00', ''),
(60, 12, '2025-11-26 23:10:05', ''),
(61, 12, '2025-11-26 23:10:18', ''),
(62, 12, '2025-11-26 23:47:37', ''),
(63, 12, '2025-11-26 23:47:45', ''),
(64, 12, '2025-11-26 23:49:36', ''),
(65, 12, '2025-11-26 23:50:53', ''),
(66, 12, '2025-11-27 00:02:13', ''),
(67, 12, '2025-11-27 00:02:18', ''),
(68, 12, '2025-11-27 00:02:20', ''),
(69, 12, '2025-11-27 00:02:25', ''),
(70, 12, '2025-11-27 00:04:51', ''),
(71, 12, '2025-11-27 00:05:17', ''),
(72, 12, '2025-11-27 00:08:08', ''),
(73, 12, '2025-11-27 00:08:17', ''),
(74, 12, '2025-11-27 00:09:10', ''),
(75, 12, '2025-11-27 00:11:40', ''),
(76, 12, '2025-11-27 00:11:49', ''),
(77, 12, '2025-11-27 05:01:10', ''),
(78, 12, '2025-11-27 05:02:40', ''),
(79, 12, '2025-11-27 05:03:34', ''),
(80, 12, '2025-11-27 05:06:29', ''),
(81, 12, '2025-11-27 05:07:41', ''),
(82, 12, '2025-11-27 05:09:33', '1077390063-cbddfd4a-3e32-4468-8556-90b140791bf5'),
(83, 12, '2025-11-27 05:17:25', '1077390063-c21d74e6-ace8-4b8a-87b9-299e660434d1'),
(84, 12, '2025-11-27 05:28:36', '1077390063-0b3a3bb2-3556-41ec-8105-c0dec81e1b57'),
(85, 12, '2025-11-27 05:32:05', '1077390063-0753fad7-c494-498d-8ef0-a71364f8801e'),
(86, 12, '2025-11-27 05:34:24', '1077390063-2db2d4cd-a7cd-4e82-bc31-04d5030da79c'),
(87, 12, '2025-11-27 05:34:40', '1077390063-046e3927-b706-433c-a55c-974c5672ef4d'),
(88, 12, '2025-11-27 05:45:52', '1077390063-32dbe590-9f05-4513-8637-2d4c89d1408c'),
(89, 12, '2025-11-27 05:46:53', '1077390063-245b9077-fee0-4d6b-b711-21d1e7087c2e'),
(93, 12, '2025-11-27 06:23:26', '1077390063-5f79b782-90c1-4b06-b960-349fe1c94ed5'),
(94, 12, '2025-11-27 07:21:25', '1077390063-c479ff30-714b-4085-a1c8-97fd6ad673b3'),
(113, 12, '2025-11-27 08:20:59', '1077390063-86a0bd5c-6109-4257-beac-b72f72957343'),
(114, 12, '2025-11-27 08:22:40', '1077390063-b6eb1f3d-cdef-4fc9-8471-938467e844db'),
(115, 12, '2025-11-27 08:30:11', '1077390063-9fc2e002-4cd2-4563-b3fd-30bf77095c96'),
(117, 12, '2025-11-27 09:16:55', '1077390063-3f0b4fcd-df18-4b6b-a5c9-b3d2eb1c6b26'),
(118, 12, '2025-11-27 15:51:35', '1077390063-9b533a17-00d2-4ad0-8d3d-43bb395f112c'),
(119, 12, '2025-11-27 15:52:27', '1077390063-c43b2830-ec75-43e4-84fb-47c7cf45a878'),
(120, 12, '2025-11-27 15:54:34', '1077390063-e389d30d-85ec-4807-8f52-4a63104362e9');

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
(52, 'As Crônicas de Nárnia', 18, 'C. S. Lewis', '<p>Famoso livor de ficção infanto-juvenil do escritor irlandês C. S. Lewis</p>', '1764271315.jpg', 97, 'S', 'S', 0),
(53, 'O Silmarillion', 18, 'J. R. Tolkien', '<p>Livro que contém as primeiras história do famoso universo de \"O Senhor dos Anéis\" Tolkien.</p>', '1764140817.jpg', 87, 'S', 'S', 18),
(54, 'Direito Natural e História', 15, 'Leo Strauss', '<p>Importante obra que abordam de forma btilhante o tema do Direito Natural. O livro é uma busca para justificar e importância do direito natural, principalmente levando em consideração o século XX, século tanto das duas mais violentas e destrutivas guerras já registradas na história, como da ascensã dos regimes mais autoritários e também violentos da história humana. </p>', '1764137046.jpg', 87, 'S', 'S', 20),
(55, 'Crime e Castigo', 16, 'Fiódor M. Dostoiévski', '<p>Importante obra de Dostoiéviski, Crime e Castigo narra a história de Raskólninkov, gênio matemático que foi tomado por uma noção niilista de mundo, e que tecidindo levar até o fim a sua tese comete um terrível ato que tanto marcará toda a sus história no livro, como servirá de importante ocasião para marcar o sentido da obra. </p>', '1764271355.jpg', 107, 'S', 'S', 0),
(56, 'Apologia de Sócrates', 15, 'Platão', 'Narrando o fatídico epísódio do julgamento de Sócrates, esse diálogo platônico é um símbolo universal a filosofia. <br>Acusado de impiedade e de corromper a juventude, Sócrates defende a sua atividade como um chamamento divino, atividade que basicamente consisitia em, por meio da conversação, testar os limites da sabedoria dos sábios atenienses. O que é possível ver é que na atividade filosófica de Sócrates está a busca pela transicção da aparência da realidade para a própria realidade, que operada pelo jogo de perguntas respostas acaba por desunar o coração daqueles envolvidos pela conversação socrática - resultado nem sempre bem-vindo aos amantes da aparência que tinham revelada a sua verdadeira ignorância. ', '1764133154.jpg', 77, 'S', 'S', 25),
(58, 'O Diário de Anne Frank', 17, 'Anne Frank', '<p>Essa é a famosa e imortal biografia de Anne Frank. O Diário contém auto-relatos que compreendem o período que vai de antes da Segunda Guerra Mundial até a Guerra, período em que a família de Anne, junto a ela, por ser judia, se escondeu em algum lugar da Holanda enquanto fugia das forças nazistas. </p>', '1764141758.jpg', 97, 'S', 'S', 2),
(59, 'Jerusalém: A Biografia', 19, 'Simon Sebag Montefiore', 'Esse livro, escrito pelo renomado jornalista Simon S. Montefiore, discorre sobre a movimentada história milenar da cidade de Jerusalém, passando pela época do domínio dos judeus, ao período islâmido até os tempos modernos. ', '1764001821.jpg', 147, 'S', 'S', 12),
(60, 'A República', 15, 'Platão', 'Sendo de forma incontestável o mais famoso diálogo de Platão, a República trata da busca filosófica pela compreensão do conceito de justiça. A universalidade do tema atinge amplamente todas as esferas humanas, indo da área teológica, às artes, à guerra, educação, propriedade etc. Para Platão o conceito de justiça não é meramente uma consideração a respeito do certo e do errado, antes tem certo status ontológico não por ser apenas uma forma (Ideia) que poder gerador, como o são as Ideias na teoria de Platão, mas sim mais alta e nobre configuraçõ da alma que por si equilibras e unidas todas as potências da alma, seja ela a potência da coragem, da sabedoria e da moderação. E como a cidade é o \'Homem em letras grandes\', a justiça é aquela que dá o ato de ser à nobre Pólis, que mesmo que não exista no campo da existência, ainda assim tem seu modelo, como diria o filósofo, guardado nos Céus. ', '1764140777.jpg', 110, 'S', 'S', 17),
(91, 'Metafísica', 15, 'Aristóteles', 'Obra clássica da Filosofia', '1764271417.jpg', 120, 'S', 'S', 0),
(92, 'Guerra e Paz, vols I e II', 16, 'Liev Tolstói', 'Romance histórico', '1764271389.jpg', 207, 'S', 'S', 0),
(93, 'Trotsky: Uma Biografia', 17, 'Robert Service', 'Biografia de Léon Trotsky', '1764121699.jpg', 118, 'S', 'S', 18),
(94, '1984', 18, 'George Orwell', 'Distopia clássica', '1764136365.jpg', 97, 'S', 'S', 27),
(95, 'Memórias da II Guerra Mundial', 19, 'Wintson Chuchill', 'Relatos de Wintson Churchill sobre a Segunda Guerra Mundial', '1764145341.jpg', 132, 'N', 'S', 6);

--
-- Acionadores `produto`
--
DELIMITER $$
CREATE TRIGGER `alteracao_quantidade_produto` BEFORE UPDATE ON `produto` FOR EACH ROW BEGIN 
    IF OLD.quantidade != NEW.quantidade AND @usuario_id IS NOT NULL AND @usuario_nome IS NOT NULL THEN 
        INSERT INTO produto_quantidade_log (produto_id, nome_produto, quantidade_antiga, quantidade_nova, usuario_id, usuario_nome) 
        VALUES (OLD.id, OLD.nome, OLD.quantidade, NEW.quantidade, @usuario_id, @usuario_nome); 
    END IF; 
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `alteracao_valor_produto` BEFORE UPDATE ON `produto` FOR EACH ROW BEGIN
    IF OLD.valor != NEW.valor THEN
        INSERT INTO produto_valor_log (produto_id, nome_produto, valor_antigo, valor_novo, usuario_id, usuario_nome)
        VALUES (OLD.id, OLD.nome, OLD.valor, NEW.valor, @usuario_id, @usuario_nome);
    END IF;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `produto_quantidade_log`
--

CREATE TABLE `produto_quantidade_log` (
  `id` int(11) NOT NULL,
  `produto_id` int(11) DEFAULT NULL,
  `nome_produto` varchar(255) DEFAULT NULL,
  `quantidade_antiga` int(11) DEFAULT NULL,
  `quantidade_nova` int(11) DEFAULT NULL,
  `data_alteracao` datetime DEFAULT current_timestamp(),
  `usuario_id` int(11) DEFAULT NULL,
  `usuario_nome` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `produto_quantidade_log`
--

INSERT INTO `produto_quantidade_log` (`id`, `produto_id`, `nome_produto`, `quantidade_antiga`, `quantidade_nova`, `data_alteracao`, `usuario_id`, `usuario_nome`) VALUES
(1, 60, 'A República', 25, 30, '2025-11-26 03:20:13', NULL, NULL),
(2, 52, 'As Crônicas de Nárnia', 2, 3, '2025-11-26 03:27:18', NULL, NULL),
(3, 52, 'As Crônicas de Nárnia', 3, 7, '2025-11-26 03:31:03', 1, 'Bill Gates'),
(4, 60, 'A República', 30, 25, '2025-11-26 03:48:25', 1, 'Bill Gates'),
(5, 59, 'Jerusalém: A Biografia', 15, 14, '2025-11-26 03:51:14', NULL, NULL),
(6, 60, 'A República', 25, 24, '2025-11-26 03:51:14', NULL, NULL),
(7, 58, 'O Diário de Anne Frank', 2, 1, '2025-11-26 03:51:14', NULL, NULL),
(8, 58, 'O Diário de Anne Frank', 1, 0, '2025-11-26 04:05:51', NULL, NULL),
(9, 60, 'A República', 24, 25, '2025-11-26 04:06:17', 1, 'Bill Gates'),
(10, 53, 'O Silmarillion', 0, 20, '2025-11-26 04:06:57', 1, 'Bill Gates'),
(11, 58, 'O Diário de Anne Frank', 0, 10, '2025-11-26 04:09:57', 1, 'Bill Gates'),
(12, 58, 'O Diário de Anne Frank', 10, 5, '2025-11-26 04:10:16', NULL, NULL),
(13, 58, 'O Diário de Anne Frank', 0, 25, '2025-11-26 04:17:19', 1, 'Bill Gates'),
(14, 52, 'As Crônicas de Nárnia', 7, 0, '2025-11-26 04:24:05', 1, 'Bill Gates'),
(15, 95, 'Memórias da II Guerra Mundial', 0, 10, '2025-11-26 05:22:21', 10, 'Gabriela Markus Chaves'),
(16, 52, 'As Crônicas de Nárnia', -3, 0, '2025-11-26 23:35:24', 10, 'Gabriela Markus Chaves'),
(17, 55, 'Crime e Castigo', -1, 0, '2025-11-26 23:35:49', 10, 'Gabriela Markus Chaves'),
(18, 91, 'Metafísica', -6, 0, '2025-11-27 09:05:33', 10, 'Gabriela Markus Chaves'),
(19, 52, 'As Crônicas de Nárnia', -2, 0, '2025-11-27 09:12:44', 10, 'Gabriela Markus Chaves'),
(20, 52, 'As Crônicas de Nárnia', -1, 0, '2025-11-27 16:21:55', 10, 'Gabriela Markus Chaves'),
(21, 55, 'Crime e Castigo', -1, 0, '2025-11-27 16:22:35', 10, 'Gabriela Markus Chaves'),
(22, 92, 'Guerra e Paz, vols I e II', -3, 0, '2025-11-27 16:23:09', 10, 'Gabriela Markus Chaves'),
(23, 91, 'Metafísica', -2, 0, '2025-11-27 16:23:37', 10, 'Gabriela Markus Chaves');

-- --------------------------------------------------------

--
-- Estrutura para tabela `produto_valor_log`
--

CREATE TABLE `produto_valor_log` (
  `id` int(11) NOT NULL,
  `produto_id` int(11) DEFAULT NULL,
  `nome_produto` varchar(255) DEFAULT NULL,
  `valor_antigo` decimal(10,2) DEFAULT NULL,
  `valor_novo` decimal(10,2) DEFAULT NULL,
  `data_alteracao` datetime DEFAULT current_timestamp(),
  `usuario_id` int(11) DEFAULT NULL,
  `usuario_nome` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `produto_valor_log`
--

INSERT INTO `produto_valor_log` (`id`, `produto_id`, `nome_produto`, `valor_antigo`, `valor_novo`, `data_alteracao`, `usuario_id`, `usuario_nome`) VALUES
(1, 60, 'A República', 127.00, 117.00, '2025-11-26 03:20:13', NULL, NULL),
(2, 52, 'As Crônicas de Nárnia', 93.00, 97.00, '2025-11-26 03:27:18', NULL, NULL),
(3, 52, 'As Crônicas de Nárnia', 97.00, 87.00, '2025-11-26 03:31:03', 1, 'Bill Gates'),
(4, 60, 'A República', 117.00, 110.00, '2025-11-26 03:48:25', 1, 'Bill Gates'),
(5, 53, 'O Silmarillion', 97.00, 87.00, '2025-11-26 04:06:57', 1, 'Bill Gates'),
(6, 58, 'O Diário de Anne Frank', 107.00, 97.00, '2025-11-26 04:09:57', 1, 'Bill Gates'),
(7, 95, 'Memórias da II Guerra Mundial', 142.00, 132.00, '2025-11-26 05:22:21', 10, 'Gabriela Markus Chaves'),
(8, 52, 'As Crônicas de Nárnia', 87.00, 97.00, '2025-11-26 23:35:24', 10, 'Gabriela Markus Chaves'),
(9, 55, 'Crime e Castigo', 132.00, 107.00, '2025-11-27 16:22:35', 10, 'Gabriela Markus Chaves');

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
(6, 'Gordon Thompson', 'gordonth@gmail.com', '$2y$10$fy4U1sHG7uuss4fJWyBUfOxr85SNUUcTT8f3YRtEsaWVvFqaB8kTm', '(44) 99999-9999', 'S'),
(10, 'Gabriela Markus Chaves', 'gabriela.markus@gmail.com', '$2y$10$h6DSGzTm2PmHXowrHh4iyeVjJrx9ZikLNZswqfXzku6NDrAtMyRQ6', '(99) 99999-9999', 'S');

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
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_cliente_email` (`email`),
  ADD KEY `idx_cliente_nome` (`nome`),
  ADD KEY `idx_cliente_nome_email` (`nome`,`email`);

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
  ADD KEY `cliente_id` (`cliente_id`),
  ADD KEY `idx_pedido_cliente` (`cliente_id`),
  ADD KEY `idx_pedido_data` (`data`),
  ADD KEY `idx_pedido_cliente_data` (`cliente_id`,`data`),
  ADD KEY `idx_pedido_preference` (`preference_id`);

--
-- Índices de tabela `produto`
--
ALTER TABLE `produto`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_produto_nome` (`nome`),
  ADD KEY `idx_produto_nome_categoria` (`nome`,`categoria_id`),
  ADD KEY `idx_produto_valor` (`valor`),
  ADD KEY `idx_produto_valor_destaque` (`valor`,`destaque`);

--
-- Índices de tabela `produto_quantidade_log`
--
ALTER TABLE `produto_quantidade_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `produto_id` (`produto_id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Índices de tabela `produto_valor_log`
--
ALTER TABLE `produto_valor_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `produto_id` (`produto_id`),
  ADD KEY `usuario_id` (`usuario_id`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de tabela `pedido`
--
ALTER TABLE `pedido`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=121;

--
-- AUTO_INCREMENT de tabela `produto`
--
ALTER TABLE `produto`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT de tabela `produto_quantidade_log`
--
ALTER TABLE `produto_quantidade_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de tabela `produto_valor_log`
--
ALTER TABLE `produto_valor_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

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
-- Restrições para tabelas `produto_quantidade_log`
--
ALTER TABLE `produto_quantidade_log`
  ADD CONSTRAINT `produto_quantidade_log_ibfk_1` FOREIGN KEY (`produto_id`) REFERENCES `produto` (`id`),
  ADD CONSTRAINT `produto_quantidade_log_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`);

--
-- Restrições para tabelas `produto_valor_log`
--
ALTER TABLE `produto_valor_log`
  ADD CONSTRAINT `produto_valor_log_ibfk_1` FOREIGN KEY (`produto_id`) REFERENCES `produto` (`id`),
  ADD CONSTRAINT `produto_valor_log_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`);

--
-- Restrições para tabelas `sessao`
--
ALTER TABLE `sessao`
  ADD CONSTRAINT `sessao_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
