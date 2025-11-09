<?php
    header("Content-Type: application/json");
    require_once "../../config/Conexao.php";

    $db = new Conexao();
    $pdo = $db->conectar();

    $sql = "select * from produto where destaque = 'S' order by descricao";
    $consulta = $pdo->prepare($sql);
    $consulta->execute();

    $dadosCategoria = $consulta->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode($dadosCategoria);