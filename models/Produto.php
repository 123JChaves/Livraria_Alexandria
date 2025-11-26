<?php

class Produto
{
    private $pdo;

    public function __construct($pdo)
    {

        $this->pdo = $pdo;
    }

    public function listarCategoria()
    {
        $sql = "select * from categoria order by descricao";
        $consulta = $this->pdo->prepare($sql);
        $consulta->execute();

        return $consulta->fetchAll(PDO::FETCH_OBJ);
    }


    public function salvar($dados)
    {
        $this->pdo->exec("SET @usuario_id = " . $_SESSION["alexandria"]["id"]);
        $this->pdo->exec("SET @usuario_nome = '" . $_SESSION["alexandria"]["nome"] . "'");

        if (empty($dados["id"])) {
            $sql = "insert into produto (id, nome, categoria_id, descricao, autor, valor, destaque, ativo, imagem, quantidade)
            values (NULL, :nome, :categoria_id, :descricao, :autor, :valor, :destaque, :ativo, :imagem, :quantidade)";
            $consulta = $this->pdo->prepare($sql);
            $consulta->bindParam(":nome", $dados["nome"]);
            $consulta->bindParam(":categoria_id", $dados["categoria_id"]);
            $consulta->bindParam(":descricao", $dados["descricao"]);
            $consulta->bindParam(":autor", $dados["autor"]);
            $consulta->bindParam(":valor", $dados["valor"]);
            $consulta->bindParam(":destaque", $dados["destaque"]);
            $consulta->bindParam(":ativo", $dados["ativo"]);
            $consulta->bindParam(":imagem", $dados["imagem"]);
            $consulta->bindParam(":quantidade", $dados["quantidade"]);
        } else {
            if (!empty($dados["adicionar_quantidade"])) {
                $novaQuantidade = $dados["quantidade"] + $dados["adicionar_quantidade"];
                $sql = "update produto set nome = :nome, categoria_id = :categoria_id, autor = :autor, descricao = :descricao, 
                valor = :valor, destaque = :destaque, ativo = :ativo, imagem = :imagem, quantidade = :quantidade where id = :id";
                $consulta = $this->pdo->prepare($sql);
                $consulta->bindParam(":id", $dados["id"]);
                $consulta->bindParam(":nome", $dados["nome"]);
                $consulta->bindParam(":categoria_id", $dados["categoria_id"]);
                $consulta->bindParam(":autor", $dados["autor"]);
                $consulta->bindParam(":descricao", $dados["descricao"]);
                $consulta->bindParam(":valor", $dados["valor"]);
                $consulta->bindParam(":destaque", $dados["destaque"]);
                $consulta->bindParam(":ativo", $dados["ativo"]);
                $consulta->bindParam(":imagem", $dados["imagem"]);
                $consulta->bindParam(":quantidade", $novaQuantidade);
            } elseif (!empty($dados["subtrair_quantidade"])) {
                $novaQuantidade = $dados["quantidade"] - $dados["subtrair_quantidade"];
                if ($novaQuantidade < 0) {
                    return false;
                }
                $sql = "update produto set nome = :nome, categoria_id = :categoria_id, autor = :autor, descricao = :descricao, 
                valor = :valor, destaque = :destaque, ativo = :ativo, imagem = :imagem, quantidade = :quantidade where id = :id";
                $consulta = $this->pdo->prepare($sql);
                $consulta->bindParam(":id", $dados["id"]);
                $consulta->bindParam(":nome", $dados["nome"]);
                $consulta->bindParam(":categoria_id", $dados["categoria_id"]);
                $consulta->bindParam(":autor", $dados["autor"]);
                $consulta->bindParam(":descricao", $dados["descricao"]);
                $consulta->bindParam(":valor", $dados["valor"]);
                $consulta->bindParam(":destaque", $dados["destaque"]);
                $consulta->bindParam(":ativo", $dados["ativo"]);
                $consulta->bindParam(":imagem", $dados["imagem"]);
                $consulta->bindParam(":quantidade", $novaQuantidade);
            } else {
                $sql = "update produto set nome = :nome, categoria_id = :categoria_id, autor = :autor, descricao = :descricao, 
                valor = :valor, destaque = :destaque, ativo = :ativo, imagem = :imagem, quantidade = :quantidade where id = :id";
                $consulta = $this->pdo->prepare($sql);
                $consulta->bindParam(":id", $dados["id"]);
                $consulta->bindParam(":nome", $dados["nome"]);
                $consulta->bindParam(":categoria_id", $dados["categoria_id"]);
                $consulta->bindParam(":autor", $dados["autor"]);
                $consulta->bindParam(":descricao", $dados["descricao"]);
                $consulta->bindParam(":valor", $dados["valor"]);
                $consulta->bindParam(":destaque", $dados["destaque"]);
                $consulta->bindParam(":ativo", $dados["ativo"]);
                $consulta->bindParam(":imagem", $dados["imagem"]);
                $consulta->bindParam(":quantidade", $dados["quantidade"]);
            }
        }
        return $consulta->execute();
    }

    public function listar()
    {
        $sql = "select * from produto order by nome";
        $consulta = $this->pdo->prepare($sql);
        $consulta->execute();

        return $consulta->fetchAll(PDO::FETCH_OBJ);
    }

    public function editar($id)
    {
        $sql = "select * from produto where id = :id limit 1";
        $consulta = $this->pdo->prepare($sql);
        $consulta->bindParam(":id", $id);
        $consulta->execute();

        return $consulta->fetch(PDO::FETCH_OBJ);
    }

    public function excluir($id)
    {
        $sql = "delete from produto where id = :id";
        $consulta = $this->pdo->prepare($sql);
        $consulta->bindParam(":id", $id);

        return $consulta->execute();
    }

    public function atualizarEstoque($id, $quantidade)
    {
        $sql = "update produto set quantidade = quantidade + :quantidade where id = :id";
        $consulta = $this->pdo->prepare($sql);
        $consulta->bindParam(":id", $id);
        $consulta->bindParam(":quantidade", $quantidade);

        return $consulta->execute();
    }
}
