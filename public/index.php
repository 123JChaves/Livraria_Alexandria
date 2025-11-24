<?php
session_start();
?>
<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Painel de Controle - Livraria Alexandria</title>

    <base href="http://<?=$_SERVER['SERVER_NAME'].$_SERVER['SCRIPT_NAME'];?>">

    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/all.min.css">
    <link rel="stylesheet" href="sweetalert2.min.css">
    <link rel="stylesheet" href="css/style.css">

    <script src="js/jquery-3.5.1.min.js"></script>
    <script src="js/bootstrap.bundle.min.js"></script>
    <script src="js/sweetalert2.js"></script>
    <script src="js/jquery.inputmask.min.js"></script>
    <script src="js/jquery.maskedinput-1.2.1.js"></script>
    <script src="js/parsley.min.js"></script>
    <script>
        //função para mostrar a senha

        mostrarSenha = function() {
            const campo = document.getElementById('senha');
            if (campo.type === 'password') {
                campo.type = 'text';
            } else {
                campo.type = 'password';
            }
        }

        //função para mensagem de erro

        mensagem = function(msg, url, icone) {

            Swal.fire({
                icon: icone,
                title: msg,
                confirmButtontext: "Ok",
            }).then((result) => {
                location.href = tabela;
            });
        }

        //mensagem par excluir

        excluir = function(id, tabela) {
            Swal.fire({
                icon: "question",
                title: "Deseja realmente excluir este registro?",
                showCancelButton: true,
                confirmButtontext: "Excluir",
                cancelButtonText: "Cancelar",
            }).then((result) => {
                if (result.isConfirmed) {
                    location.href = tabela + "/excluir/" + id;
                }
            });
        }

    </script>

</head>

<body>
    <?php

    if ((!isset($_SESSION["alexandria"])) && (!$_POST)) {
        //não tem sessão e não foi dado post
        require "../views/index/login.php";
    } else if ((!isset($_SESSION["alexandria"])) && ($_POST)) {
        //não tem sessão e não foi dado post
        $email = trim($_POST["email"] ?? NULL);
        $senha = trim($_POST["senha"] ?? NULL);

        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            echo "<script>mensagem('Email inválido','index','error');</script>";
        } else if (empty($senha)) {
            echo "<script>mensagem('Digite a senha','index','error');</script>";
        } else {
            require "../controllers/IndexController.php";
            $acao = new IndexController();
            $acao->verificar($email, $senha);
        }
    } else {

    ?>

    <nav class="navbar navbar-expand-lg bg-body-tertiary">
        <div class="container-fluid" >
            <a class="navbar-brand" href="index">
                <img src="images/logo3.png" alt="Livraria Alexandria" width="200">
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link" href="index">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="categoria">Categoria</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="produto">Produto</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="usuario">Usuário</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="dashboard">Dashboard</a>
                    </li>
                </ul>
                <div class="d-flex align-items-center gap-4" role="search">
                    Olá <?=$_SESSION["alexandria"]["nome"]?>
                    <a href="index/sair" title="sair" class="btn btn-danger border-0 rounded-4">
                        <i class="fas fa-power-of"></i>Sair
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <main>
        <?php
            $param = explode("/",$_GET["param"]);
            //print_r($param);
            $controller = $param[0] ?? 'index';
            $acao = $param[1] ?? 'index';
            $id = $param[2] ?? NULL;

            $controller = ucfirst($controller)."Controller";

            if (file_exists("../controllers/{$controller}.php") ) {
                require "../controllers/{$controller}.php";
                $control = new $controller();
                $control->$acao($id);
            } 
            else {
                require "../views/index/erro.php";
            }
        ?>
    </main>

    <?php

    }

    ?>
</body>

</html>
<style>
    a.btn-dark:hover {
        background-color: #263055;
        color: #fff;
        transition: background-color 0.3s ease;
    }

button[type="submit"]:hover {
        background-color: #263055;
        transition: background-color 0.3s ease;
}
a.btn-danger:hover {
        background-color: #ffffffff;
        color: #ff1c1cff;
        transition: background-color 0.3s ease;
}
</style>