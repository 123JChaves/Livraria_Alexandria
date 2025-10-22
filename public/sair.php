<?php
    session_start();
    //apagar a sessao do usuario
    unset($_SESSION["usuario"]);
    //redirecionar o usuario para a pagina de login
    header("Location: index.php");
