<?php
        header("Content-Type: application/json");

        require_once "../../config/Conexao.php";

        $db = new Conexao();
        $pdo = $db->conectar();

        $sql = "select c.nome, sum(i.qtde) as total_itens
        from cliente c
        join pedido p on c.id = p.cliente_id
        join item i on p.id = i.pedido_id
        group by c.nome
        order by total_itens asc;";

        $consulta = $pdo->prepare($sql);
        $consulta->execute();

        $dadosItensClientes = $consulta->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode($dadosItensClientes);