<?php
require "../config/Conexao.php";
class DashboardController {

    public function index() {
        require "../views/dashboard/index.php";
    }

    public function itensVendidos() {
        require "../views/dashboard/itensVendidos.php";
    }

    public function vendaCliente() {
        require "../views/dashboard/vendaCliente.php";
    }

    public function itensCliente() {
        require "../views/dashboard/itensCliente.php";
    }
}


