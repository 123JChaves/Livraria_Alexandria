<?php
    require "../config/Conexao.php";
    require "../models/Usuario.php";

    class IndexController {

        private $usuario;

        public function __construct()
        {
            $db = new Conexao();
            $pdo = $db->conectar();
            $this->usuario = new Usuario($pdo);

        }

        public function index() {

            require "../views/index/home.php";

        }

        public function verificar($email, $senha) {

            $dados = $this->usuario->getUsuario($email);
            if (!password_verify($senha, $dados->senha)) {
                echo "<script>mensagem('Erro de senha','index','error');</script>";
                exit;
            } else {
                $_SESSION["alexandria"] = array("id"=>$dados->id, "nome"=>$dados->nome);
                echo "<script>location.href='index';</script>";
                exit;
            }

        }

        public function sair() {

            session_destroy();
            echo "<script>location.href='index';</script>";

        }


    }