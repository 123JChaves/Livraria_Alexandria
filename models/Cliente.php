<?php
    class Cliente {

        private $pdo;
        public $id;

        public function __construct($pdo) {
            $this->pdo = $pdo;
        }

        public function listarCliente() {
            $sql = "select id, nome from cliente;";
            $consulta = $this->pdo->prepare($sql);
            $consulta->execute();

            return $consulta->fetchAll(PDO::FETCH_OBJ);
        }
    }