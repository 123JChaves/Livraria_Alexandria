<?php
    header("Content-Type: application/json");
    
    $id = $_GET["id"] ?? NULL;
    $categoria = $_GET["categoria"] ?? NULL;

    require_once "../../config/Conexao.php";

    $db = new Conexao();
    $pdo = $db->conectar();

    if(!empty($categoria)) {
        // produtos de uma determinada categoria
        $sql = "select * from produto where ativo = 'S' and categoria_id = :categoria order by nome";
        $consulta = $pdo->prepare($sql);
        $consulta->bindParam(":categoria", $categoria);
        $consulta->execute();

        $dadosProduto = $consulta->fetchAll(PDO::FETCH_ASSOC);

    } else if(!empty($id)) {
        // um determinado produto
        $sql = "select * from produto where ativo = 'S' and id = :id limit 1";
        $consulta = $pdo->prepare($sql);
        $consulta->bindParam(":id", $id);
        $consulta->execute();

        $dadosProduto = $consulta->fetch(PDO::FETCH_ASSOC);
    } else {
        // todos os produtos
        $sql = "select * from produto where ativo = 'S' order by nome";
        $consulta = $pdo->prepare($sql);
        $consulta->execute();

        $dadosProduto = $consulta->fetchAll(PDO::FETCH_ASSOC);
    }

    echo json_encode($dadosProduto);