<!-- include summernote css/js -->
<link href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote.min.css" rel="stylesheet">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote.min.js"></script>

<?php

    if (!empty($id)) {
        $dados = $this->produto->editar($id);
    }

    $id = $dados->id ?? NULL;
    $nome = $dados->nome ?? NULL;
    $categoria_id = $dados->categoria_id ?? NULL;
    $descricao = $dados->descricao ?? NULL;
    $valor = $dados->valor ?? NULL;
    $ativo = $dados->ativo ?? NULL;
    $destaque = $dados->destaque ?? NULL;
    $imagem = $dados->imagem ?? NULL;
    $autor = $dados->autor ?? NULL;
    $quantidade = $dados->quantidade ?? NULL;

    $valor = number_format($valor,2,",",".");
?>
<style>
    a.btn-dark:hover {
        background-color: #3e8dbeff;
        color: #fff;
        transition: background-color 0.3s ease;
    }

button[type="submit"]:hover {
        background-color: #3e8dbeff;
        transition: background-color 0.3s ease;
}
a.btn-danger:hover {
        background-color: #ffffffff;
        color: #ff1c1cff;
        transition: background-color 0.3s ease;
    }
</style>
<div class="container">
    <div class="card">
        <div class="card-header">
            <div class="float-start">
                <h2>Cadastro de Produtos</h2>
            </div>
            <div class="float-end">
                <a href="produto" class="btn btn-dark mt-2 border-0 rounded-4">
                    <i class="fas fa-file"></i> Adicionar Novo
                </a>
                <a href="produto/listar" class="btn btn-dark mt-2 border-0 rounded-4">
                    <i class="fas fa-search"></i> Listar
                </a>
            </div>
        </div>
        <div class="card-body">
            <form name="formCadastro" method="post" action="produto/salvar" enctype="multipart/form-data"
            data-parsley-validate="">
                <div class="row">
                    <div class="col-12 col-md-1">
                        <label for="id">ID:</label>
                        <input type="text" readonly name="id" id="id" class="form-control"
                        value="<?=$id?>">
                    </div>
                    <div class="col-12 col-md-8">
                        <label for="nome">Nome do Produto:</label>
                        <input type="text" name="nome" id="nome" class="form-control"
                        required data-parsley-required-message="Digite o nome do produto"
                        value="<?=$nome?>">
                    </div>
                    <div class="col-12 col-md-3">
                        <label for="categoria_id">Categoria:</label>
                        <select name="categoria_id" id="categoria_id" class="form-control"
                        required data-parsley-required-message="Selecione uma categoria">
                            <option value=""></option>
                            <?php
                                $dadosCategoria = $this->produto->listarCategoria();
                                foreach($dadosCategoria as $dados) {
                                    ?>
                                    <option value="<?=$dados->id?>">
                                        <?=$dados->descricao?>
                                    </option>
                                    <?php
                                
                                }
                            ?>
                        </select>
                        <script>
                            $("#categoria_id").val(<?=$categoria_id?>);
                        </script>
                    </div>
                </div>
                <br>
                <div class="row">
                    <div class="col-12 col-md-4">
                        <label for="autor">Autor:</label>
                        <input type="text" name="autor" id="autor" class="form-control"
                        required data-parsley-required-message="Digite o nome do autor"
                        value="<?=$autor?>">
                        </input>
                    </div>
                    <div class="col-12 col-md-1">
                        <label for="autor">Quantidade:</label>
                        <input type="text" name="quantidade" id="quantidade" class="form-control"
                        required data-parsley-required-message="Digite a quantidade"
                        value="<?=$quantidade?>">
                        </input>
                    </div>
                </div>
                <br>
                <br>
                <div class="row">
                    <div class="col-12 col-md-12">
                        <label for="descricao">Descrição do Produto:</label>
                        <textarea name="descricao" id="descricao" class="form-control"
                        required data-parsley-required-message="Digite a descrição do produto"
                        ><?=$descricao?></textarea>
                    </div>
                </div>
                <br>
                <div class="row">
                    <div class="col-12 col-md-6">
                        <label for="descricao">Selecione uma foto JPG:</label>
                        <input type="file" name="imagem" id="imagem" class="form-control"
                        accept=".jpg">
                        <input type="hidden" name="imagem" value="<?=$imagem?>">
                    </div>
                    <div class="col-12 col-md-2">
                        <label for="valor">Valor:</label>
                        <input type="text" name="valor" id="valor" class="form-control"
                        required data-parsley-required-message="Digite o valor"
                        value="<?=$valor?>">
                    </div>
                    <div class="col-12 col-md-2">
                        <label for="destaque">destaque:</label>
                            <select name="destaque" id="destaque" class="form-control" required
                            data-parsley-require-message="Selecione">
                            <option value=""></option>
                            <option value="S">Sim</option>
                            <option value="N">Não</option>
                            </select>
                        <script>
                            $("#destaque").val("<?=$destaque?>");
                        </script>
                    </div>
                    <div class="col-12 col-md-2">
                        <label for="ativo">Ativo:</label>
                            <select name="ativo" id="ativo" class="form-control" required
                            data-parsley-require-message="Selecione">
                            <option value=""></option>
                            <option value="S">Sim</option>
                            <option value="N">Não</option>
                            </select>
                        <script>
                            $("#ativo").val("<?=$ativo?>");
                        </script>
                    </div>
                </div>
                <br>
                <button type="submit" class="btn btn-dark mt-2 border-0 rounded-4 float-end">
                    <i class="fas fa-check"></i> Salvar/Alterar
                </button>
            </form>
        </div>
    </div>
</div>
<script>
    $(document).ready(function() {
        $("#descricao").summernote({
            height: 200
        });
    })
    $(function() {
        $('#valor').maskMoney({thousands:".",decimal:","});
    })
</script>
