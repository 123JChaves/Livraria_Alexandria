<?php
    if(!empty($id)) {
        $dados = $this->usuario->editar($id);
    }

    $id = $dados->id ?? NULL;
    $nome = $dados->nome ?? NULL;
    $email = $dados->email ?? NULL;
    $telefone = $dados->telefone ?? NULL;
    $ativo = $dados->ativo ?? NULL;

?>

<div class="container">
    <div class="card">
        <div class="card-header">
            <h2 class="float-start">Cadastro de Usuários</h2>
            <div class="float-end">
                <a href="usuario" title="Novo Registro" class="btn btn-success">
                    <i class="fas fa-file"></i> Novo Registro
                </a>

                <a href="usuario/listar" title="Listar" class="btn btn-success">
                    <i class="fas fa-file"></i> Listar
                </a>
            </div>
        </div>
        <div class="card-body">
            <form name="formUsuario" method="post" data-parsley-validate="" action="usuario/salvar">
                <div class="row">
                    <div class="col-12 col-md-1">
                        <label for="id">ID:</label>
                        <input type="text" name="id" id="id" class="form-control"
                        readonly value="<?=$id?>">
                    </div>
                    <div class="col-12 col-md-11">
                        <label for="nome">Nome do Usuário:</label>
                        <input type="text" name="nome" id="nome" class="form-control" value="<?=$nome?>" 
                        required data-parsley-required-message="Preecha o nome">
                    </div>
                </div>
                <br>
                <div class="row">
                    <div class="col12 col-md-6">
                        <label for="email">Digite o seu e-mail:</label>
                        <input type="email" name="email" id="email" class="form-control" value="<?=$email?>"
                        required data-parsley-required-message="Preecha o e-mail"
                        data-parsley-type-message="Digite um e-mail válido">
                    </div>
                    <div class="col-12 col-md-3">
                        <label for="senha">Digite a sua Senha:</label>
                        <input type="password" name="senha" id="senha" class="form-control">
                    </div>
                    <div class="col-12 col-md-3">
                        <label for="redigite">Redigite a senha:</label>
                        <input type="password" name="redigite" id="redigite" class="form-control"
                        data-parsley-equalto="#senha"
                        data-parsley-equalto-message="As senhas não são iguais">
                    </div>
                </div>
                <br>
                <div class="row">
                    <div class="col-12 col-md-4">
                        <label for="telefone">Digite o telefone:</label>
                        <input type="text" name="telefone" id="telefone" class="form-control" value="<?=$telefone?>"
                        required data-parsley-required-message="Digite um telefone">
                    </div>
                    <div class="col-12 col-md-2">
                        <label for="ativo">Ativo:</label>
                        <select name="ativo" id="ativo" class="form-control"
                        required data-parsley-required-message="Selecione ativo">
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
                <button type="submit" class="btn btn-success float-end">
                    <i class="fas fa-check"></i>Slavar/Atualizar Dados
                </button>
            </form>
        </div>
    </div>
</div>
<script>
    $(document).ready(function(){
        $("#telefone").inputmask("(99) 99999-9999")
    });
</script>
