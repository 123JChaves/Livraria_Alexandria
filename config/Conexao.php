<?php

    class Conexao {
        private static $host = "localhost";
        private static $usuario = "root";
        private static $banco = "alexandria";
        private static $senha = "";

        public static function conectar () {
            try {
                return new PDO("mysql:host=".self::$host.";dbname=".self::$banco."charset=utf84"
                ,self::$usuario,self::$senha);

            } catch (PDOException $e) {
                die ("Erro ao conectar com o banco de dados: {$e->getMessage()}");
            }
        }
    }
