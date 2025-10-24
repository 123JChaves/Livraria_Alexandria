<?php

    if($_POST) {

        $id = $_POST["id"] ?? NULL;
        $nome = $_POST["nome"] ?? NULL;
        $senha = $_POST["senha"] ?? NULL;
        $redigite = $_POST["redigite"] ?? NULL;
        $email = $_POST["email"] ?? NULL;
        $telefone = $_POST["telefone"] ?? NULL;
        $ativo = $_POST["ativo"] ?? NULL;

        if(empty($nome)) {
            echo "<script>mensagem('Digite o nome','usuario','error');</script>";
        } else if (empty($email)) {
            echo "<script>mensagem('Digite o e-mail','usuario','error');</script>";
        } else if (empty($telefone)) {
            echo "<script>mensagem('Digite o telefone','usuario','error');</script>";
        } else if (empty($ativo)) {
            echo "<script>mensagem('Selecione ativo','usuario','error');</script>";
        } else if ($senha != $redigite) {
            echo "<script>mensagem('Erro! As senhas não são iguais','usuario','error');</script>";
        } else if ((empty($id) && (empty($senha)))) {
            echo "<script>mensagem('Por favor, preencha a senha','usuario','error');</script>";
        } else {

        }

        if(!empty($senha)) {
            $_POST["senha"] = password_hash($senha, PASSWORD_BCRYPT);
        }

        $msg = $this->usuario->salvar($_POST);

        if($msg == 1) {
            echo "<script>mensagem('Registro salvo com sucesso!','usuario','ok');</script>";
        } else {
            echo "<script>mensagem('Erro! Registro não salvo','usuario','error');</script>";
        }

    } else {
        echo "<script>mensagem('Erro! Requisição inválida','usuario','error');</script>";
    }