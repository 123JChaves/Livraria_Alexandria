<?php
require "../config/Conexao.php";
require "../models/Dashboard.php";
    class DashboardController {
    private $dashboard;

    public function __construct() {
        require_once __DIR__ . '/../config/Conexao.php';
        $db = new Conexao();
        $pdo = $db->conectar();
        require_once __DIR__ . '/../models/Dashboard.php';
        $this->dashboard = new Dashboard($pdo);
    }

    public function dadosCliente() {
        if (isset($_POST['clienteId'])) {
            $clienteId = $_POST['clienteId'];
            $resultados = $this->dashboard->getDadosCliente($clienteId);
            require __DIR__ . '/../views/dashboard/dadosCliente.php';
        } else {
            require __DIR__ . '/../views/dashboard/index.php';
        }
    }





    public function index()
    {
        require "../views/dashboard/index.php";
    }

    public function itensVendidos()
    {
        require "../views/dashboard/itensVendidos.php";
    }

    public function vendaCliente()
    {
        require "../views/dashboard/vendaCliente.php";
    }

    public function itensCliente()
    {
        require "../views/dashboard/itensCliente.php";
    }
}
