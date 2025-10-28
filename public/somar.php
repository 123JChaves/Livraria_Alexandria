<?php
    session_start();

    $id = $_GET["id"] ?? NULL;
    $qtde = $_GET["qtde"] ?? NULL;

    $id = (int)$id;
    $qtde = (int)$qtde;

    if (empty($id)) {
        echo "Produto inválido!";
    } else if ($qtde < 1) {
        echo "Quantidade inválida!";
    } else { 
        
        $_SESSION["carrinho"] [$id] ["qtde"] = $qtde;
    }
