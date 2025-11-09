<div class="container">
    <div class="card">
        <div class="card-header">
            <h2>Listagem de Categorias</h2>
        </div>
        <div class="card-body">
            <table class="table table-bordered table-stripe">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nome da Categoria</th>
                        <th>Ativo</th>
                        <th>Opções</th>
                    </tr>
                </thead>
                <tbody>
                    <?php

                        $dadosCategoria = $this->categoria->listar();
                        foreach($dadosCategoria as $dados) {

                            if ($dados->ativo == "S")
                                $status = "Sim";
                            else
                                $status = "Não";

                            ?>
                            <tr>
                                <td><?=$dados->id?></td>
                                <td><?=$dados->descricao?></td>
                                <td><?=$status?></td>
                                <td>
                                    <a href="categoria/index/<?=$dados->id?>" class="btn btn-success"
                                    title="Editar">
                                    <i class="fas fa-edit"></i>
                                    </a>

                                    <a href="javascript:excluir(<?=$dados->id?>)" class="btn btn-danger"
                                    title="Excluir">
                                        <i class="fas fa-trash"></i>
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
<script>
    function excluir(id) {
        Swal.fire({
            title: "Deseja realmente excluir este ítem?",
            showCancelButton: true,
            confirmButtonText: "Sim",
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = "categoria/excluir/"+id;
            }
        })
    }
</script>