<?php
header("Content-Type: application/json");

require_once "../../config/Conexao.php";

$db = new Conexao();
$pdo = $db->conectar();

$sql = "select c.nome, sum(i.valor * i.qtde) as total_vendido
        from cliente c
        join pedido p on c.id = p.cliente_id
        join item i on p.id = i.pedido_id
        group by c.nome
        order by total_vendido asc;";
$consulta = $pdo->prepare($sql);
$consulta->execute();

$dadosCategoria = $consulta->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($dadosCategoria);
