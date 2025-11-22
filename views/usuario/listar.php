<style>
    a.btn-dark:hover {
        background-color: #1d5c83ff;
        color: #fff;
        transition: background-color 0.3s ease;
    }

button[type="submit"]:hover {
        background-color: #1d5c83ff;
        transition: background-color 0.3s ease;
}
</style>
<div class="container">
    <div class="card">
        <div class="card-header">
            <h2 class="float-start">Listagem de Usuários</h2>
            <div class="float-end">
                <a href="usuario" title="novo registro" class="btn btn-dark mt-2 border-0 rounded-4">
                    <i class="fas fa-file"></i> Novo Registro
                </a>

                <a href="usuario/listar" title="Listar" class="btn btn-dark mt-2 border-0 rounded-4">
                    <i class="fas fa-file"></i> Listar
                </a>
            </div>
        </div>
        <div class="card-body">
            <table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <td>ID</td>
                        <td>Nome do Usuário</td>
                        <td>Telefone</td>
                        <td>Opções</td>
                    </tr>
                </thead>
                <tbody>
                    <?php
                        $dadosUsuarios = $this->usuario->listar();
                        foreach ($dadosUsuarios as $dados) {
                            ?>
                            <tr>
                                <td><?=$dados->id?></td>
                                <td><?=$dados->nome?></td>
                                <td><?=$dados->telefone?></td>
                                <td>
                                    <a href="usuario/index/<?=$dados->id?>" class="btn btn-dark mt-2 border-0 rounded-4">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                </td>
                            </tr>
                            <?php
                        }
                    ?>
                </tbody>
            </table>
        </div>
    </div>
</div>
