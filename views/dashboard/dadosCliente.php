
<h2>Dados do Cliente</h2>
<table class="table table-bordered table-striped">
    <thead>
        <tr>
            <th>Nome do Cliente</th>
            <th>Valor Total de Compras</th>
            <th>Produto Comprado</th>
            <th>Quantidade de Itens Comprados</th>
            <th>Valor Unitário</th>
            <th>Valor Total dos Itens</th>
        </tr>
    </thead>
    <tbody>
        <?php 
        $primeiraLinha = true;
        foreach ($resultados as $resultado) { ?>
        <tr>
            <td><?= ($primeiraLinha) ? $resultado->nome_cliente : '' ?></td>
            <td><?= ($primeiraLinha) ? $resultado->valor_total_compras : '' ?></td>
            <td><?= $resultado->produto ?></td>
            <td><?= $resultado->quantidade_itens_comprados ?></td>
            <td><?= $resultado->valor_unitario ?></td>
            <td><?= $resultado->valor_total_itens ?></td>
        </tr>
        <?php 
        $primeiraLinha = false;
        } ?>
    </tbody>
</table>