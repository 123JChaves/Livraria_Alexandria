<?php

    require "../config/Conexao.php";
    require "../models/Usuario.php";

    class UsuarioController {

        private $usuario;

        public function __construct()
        {
            $db = new Conexao();
            $pdo = $db->conectar();
            $this->usuario = new Usuario($pdo);
        }

        public function index($id) {

            require "../views/usuario/index.php";

        }

        public function excluir($id) {

        }

        public function salvar() {
            require "../views/usuario/salvar.php";
        }

        public function listar() {
            require "../views/usuario/listar.php";

        }
    }
