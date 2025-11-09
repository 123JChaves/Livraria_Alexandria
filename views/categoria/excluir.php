<?php

    if (empty($id)) {
        echo "<script>mensagem('Registro inválido','error');</script>";
        exit;
    }

    $msg = $this->categoria->excluir($id);

    if ($msg == 1) $msg = "Registro excluído com sucesso!";
    else $msg = "Erro ao excluir registro";

    echo "<script>mensagem('{$msg}','categoria/listar','success');</script>";
    exit;
