<?php

    $id = $_POST["id"] ?? NULL;
    $descricao = $_POST["descricao"] ?? NULL;
    $ativo = $_POST["ativo"] ?? NULL;

    if (empty($descricao)) {
        echo "<script>mensagem('Por favor, preencha a categoria','error');</script>";
        exit;
    } else if (empty($ativo)) {
        echo "<script>mensagem('Por favor, selecione a opção ativo','error');</script>";
        exit;
    }

    $msg = $this->categoria->salvar();

    if ($msg == 1) $msg ="Registro salvo com sucesso!";
    else $msg = "Erro ao alterar/salvar registro";

    echo "<script>mensagem('{$msg}','categoria','success');</script>";
    exit;
