<?php

    class Conexao {
        private static $host = "localhost";
        private static $usuario = "root";
        private static $banco = "alexandria";
        private static $senha = "123456";

        public static function conectar() {
            try {
                return new PDO("mysql:host=".self::$host.";
                            dbname=".self::$banco.";
                            charset=utf8",
                            self::$usuario,
                            self::$senha);

            } catch(PDOException $e) {
                die("<p>Erro ao conectar no banco: {$e->getMessage()}</p>");
            }
        }
    }
