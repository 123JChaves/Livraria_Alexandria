<div class="login">
    <div class="card">
        <div class="card-header">
            <img src="images/logo.jpg" alt="Livraria Alexandria">
        </div>
        <div class="card-body">
            <form name="form1" method="post" data-parsley-validate="">
                <label for="email">E-mail:</label>
                <input type="email" name="email" id="email" class="form-control" 
                required
                data-parsley-required-message="Preecha o email"
                data-parsley-type-message="Digite um email válido"
                placeholder="Digite um e-mail">
                <br>
                <label for="senha">Senha:</label>
                <div class="input-group mb-3">
                    <input type="password" class="form-control" name="senha" id="senha"
                    placeholder="Digite a sua senha" required
                    data-parsley-required-message="Digite uma senha"
                    data-parsley-errors-container="#erro">
                    <button class="btn btn-outline-secondary" type="button" onclick="mostrarSenha()">
                    <i class="fas fa-eye"></i></button>
                </div>
                <div id="erro"></div>
                <br>
                <button type="submit" class="btn btn-success w-100">
                    <i class="fas fa-check"></i>Fazer login
                </button>
            </form>
        </div>
    </div>
</div>
