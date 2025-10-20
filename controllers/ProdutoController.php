<?php

    require "../config/Conexao.php";
    require "../models/Produto.php";

    class ProdutoController {

        private $produto;

        public function __construct()
        {
            $db = new Conexao();
            $pdo = $db->conectar();
            $this->produto = new Produto($pdo);
        }

        public function index($id) {
            //form de cadastro e edição
            require "../views/produto/index.php";
        }

        public function salvar() {
            //salvar ou alterar dados
            require "../views/produto/salvar.php";
        }

        public function excluir($id) {
            //excluir os dados
            require "../views/produto/excluir.php";

        }

        public function listar() {
            //listar os dados
            require "../views/produto/listar.php";
        }
    }