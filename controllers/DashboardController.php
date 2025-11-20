<?php
    require "../config/Conexao.php";

    class DashboardController {
        public function dashboard() {
            require "../views/dashboard/dashboard.php";
        }
    }

