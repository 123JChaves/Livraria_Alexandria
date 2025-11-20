<?php
    header("Content-Type: application/json");
    
    require_once "../../config/Conexao.php";

    $db = new Conexao();
    $pdo = $db->conectar();

    $sql = "select p.nome, SUM(i.qtde) as quantidade_vendida from item i join produto 
    p on i.produto_id = p.id group by i.produto_id, p.nome order by quantidade_vendida asc"; 
    $consulta = $pdo->prepare($sql);
    $consulta->execute();

    $dadosCategoria = $consulta->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode($dadosCategoria);