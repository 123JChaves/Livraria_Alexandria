<?php
header("Content-Type: application/json");

require_once "../../config/Conexao.php";

$db = new Conexao();
$pdo = $db->conectar();

$sql = "select p.id, p.nome, p.quantidade as estoque from produto p;";

$consulta = $pdo->prepare($sql);
$consulta->execute();
$dadosVerificarEstoque = $consulta->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($dadosVerificarEstoque);
