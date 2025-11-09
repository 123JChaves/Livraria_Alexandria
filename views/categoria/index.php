<?php

$descricao = $ativo = NULL;

if (!empty($id)) {
    $dados = $this->categoria->editar($id);

    if (empty($dados)) {
        echo "<script>mensagem('Registro não encontrado!','error');</script>";
        exit;
    }

    $id = $dados->id;
    $descricao = $dados->descricao;
    $ativo = $dados->ativo;
}

?>

<div class="container">
    <div class="card">
        <div class="card-header">
            <div class="float-start">
                <h2>Cadastro de Categorias</h2>
            </div>
            <div class="float-end">
                <a href="categoria" class="btn btn-info">
                    Novo Registro
                </a>
                <a href="categoria/listar" class="btn btn-info">
                    Listar Registros
                </a>
            </div>
        </div>
        <div class="card-body">
            <form name="formCadastro" method="post" action="categoria/salvar"
            data-parsley-validate>
                <div class="row">
                    <div class="col-12 col-md-2">
                        <label for="id">ID</label>
                        <input type="text" name="id" id="id"
                        class="form-control" readonly>
                    </div>
                    <div class="col-12 col-md-8">
                        <label for="descricao">Categoria:</label>
                        <input type="text" name="descricao" id="descricao"
                        required class="form-control" value="<?= $descricao ?>"
                        data-parsley-required-message="Preencha a categoria">
                    </div>
                    <div class="col-12 col-md-2">
                        <label for="ativo">Ativo</label>
                        <select name="ativo" id="ativo" class="form-control"
                        data-parsley-required-message="=Selecione">
                        <option value="">Selecione</option>
                        <option value="S">Sim</option>
                        <option value="N">Não</option>
                        </select>
                    </div>
                </div>
                <br>
                <button type="submit" class="btn btn-success">
                    Enviar Dados
                </button>
            </form>
        </div>
    </div>
</div>
<script>
    $("#id").val(<?=$id?>);
    $("#nome").val("<?=$descricao?>");
    $("#ativo").val("<?=$ativo?>");
</script>