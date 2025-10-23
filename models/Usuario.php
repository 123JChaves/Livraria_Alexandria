<?php
    class Usuario {

        private $pdo;

        public function __construct($pdo)
        {
            $this->pdo = $pdo;
        }

        public function getUsuario($email) {
            
            $sql = "select id,nome,ativo,senha from usuario where email = :email limit 1";
            $consulta = $this->pdo->prepare($sql);
            $consulta->bindParam(":email", $email);
            $consulta->execute();

            return $consulta->fetch(PDO::FETCH_OBJ);
        }

        public function editar($id) {
            $sql = "select * from usuario where id = :id limit 1";
            $consulta = $this->pdo->prepare($sql);
            $consulta->bindParam(":id", $id);
            $consulta->execute();

            return $consulta->fetch(PDO::FETCH_OBJ);
        }

        public function salvar($dados) {
            if(empty($dados->id)) {
                $sql = "insert into usuario (id, nome, email, senha, telefone, ativo)
                values (NULL, :nome, :email, :senha, :telefone, :ativo)";
                $consulta = $this->pdo->prepare($sql);
                $consulta->bindParam(":nome", $dados["nome"]);
                $consulta->bindParam(":email", $dados["email"]);
                $consulta->bindParam(":senha", $dados["senha"]);
                $consulta->bindParam(":telefone", $dados["telefone"]);
                $consulta->bindParam(":ativo", $dados["ativo"]);
            } else {
                //atualizar produto
                $sql = "update usuario set nome = :nome, email = :email, senha = :senha, telefone = :telefone,
                ativo = :ativo where id = :id";
                $consulta = $this->pdo->prepare($sql);
                $consulta->bindParam(":id", $dados["id"]);
                $consulta->bindParam(":nome", $dados["nome"]);
                $consulta->bindParam(":email", $dados["email"]);
                $consulta->bindParam(":senha", $dados["senha"]);
                $consulta->bindParam(":telefone", $dados["telefone"]);
                $consulta->bindParam(":ativo", $dados["ativo"]);
            }

            return $consulta->execute();
        }
             public function listar() {
            $sql = "select id, nome, telefone from usuario order by nome";
            $consulta = $this->pdo->prepare($sql);
            $consulta->execute();

            return $consulta->fetchAll(PDO::FETCH_OBJ);

        }


    }
