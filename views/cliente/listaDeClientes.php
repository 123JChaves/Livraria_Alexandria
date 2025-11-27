<div class="container">
    <div class="card">
        <div class="card-header">
            <div class="float-start">
                <h2>Lista de Clientes</h2>
            </div>
            <div class="card-body">
                <table class="table striped table-bordered">
                    <thead>
                        <tr>
                            <td><strong>ID</strong></td>
                            <td><strong>NOME</strong></td>

                            <?php foreach ($clientes as $cliente) { ?>
                        <tr>
                            <td><?= $cliente->id ?></td>
                            <td><?= $cliente->nome ?></td>
                        </tr>
                    <?php } ?>
                </table>
            </div>
        </div>
    </div>
</div>
