<?php

    $urlProduto
    $dadosProduto

    if (!empty($dadosProduto->id)) {

        $qtde =$_SESSION["carrionho"] [$id] ["$qtde"] ?? 0;
        $qtde++;

        $_SESSION["carrinho"][$id] = array("id" => $dadosProduto->id,
            "nome" => $dadosProduto->nome,
            "qtde" => $qtd,
            "valor" = $dadosProduto->valor,
            "imagem" => $dadosProduto->imagem);

            echo "<script>location.href='carrionho'</script>;"


    } else {
        echo "<h2>Produto inválido!</h2>";
    }

?>