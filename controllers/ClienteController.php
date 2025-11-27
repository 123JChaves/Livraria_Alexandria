<?php
require "../config/Conexao.php";
require "../models/Cliente.php";
    class ClienteController {
    private $cliente;

    public function __construct() {
        require_once __DIR__ . '/../config/Conexao.php';
        $db = new Conexao();
        $pdo = $db->conectar();
        require_once __DIR__ . '/../models/Cliente.php';
        $this->cliente = new Cliente($pdo);
    }

   public function listarClientes() {
    $clientes = $this->cliente->listarCliente();
    require "../views/cliente/listaDeClientes.php";
}

}