<?php

class Dashboard
{
    private $pdo;

    public function __construct($pdo)
    {
        $this->pdo = $pdo;
    }

    public function getDadosCliente($clienteId)
    {
        $sql = "CALL querys_cliente_compras2(:clienteId)";
        $consulta = $this->pdo->prepare($sql);
        $consulta->bindParam(':clienteId', $clienteId);
        $consulta->execute();
        
        return $consulta->fetchAll(PDO::FETCH_OBJ);
    }
}
