<?php
    require "../config/Conexao.php";

    class DashboardController {
        public function index() {
            require "../views/dashboard/dashboard.php";
        }
    }

