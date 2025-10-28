<div class="card">
    <div class="card-header">
        <h2>Carrionho de Compras</h2>
    </div>
    <div> class="card-body">
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Imagem</th>
                    <th>Nome do Produto</th>
                    <th>Quantidade</th>
                    <th>Unitário</th>
                    <th>Total</th>
                    <th>Excluir</th>
                </tr>
            </thead>
            <tbody>
                <?php
                if(!empty($_SESSION["carrinho"])) { 
                    foreach ($_SESSION["carrinho"] as $dados) {
                        ?>
                        <tr>
                            <td><img src="<?=$img?><?=$dados["imagem"]?>" alt="<?=$dados["nome"]?>" width="130px"></td>
                            <td><?=$dados["nome"]?></td>
                            <td>
                                <input type="number" value="<?=$dados["qtde"]?>" class="form-control"
                                on blur="somarQuantidade(this.value, <?=$dados["id"]?>)">
                            </td>    
                            <td><?=number_format($dados["valor"], 2, ",", ".")?></td>
                            <td><?=number_format($dados["qtde"] * $dados["valor"], 2, ",", ".")?></td>
                            <td>
                                <a href ="carrinho/excluir/<?=$dados["id"]?>" class="btn btn-danger">
                                    <i class="fa fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                        <?php
                    }
                }    
                ?>
            </tbody>
        </table>
        <p>
            <a href="carrinho/limpar" class="btn btn-warning">
                Limpar Carrinho de Compras
            </a>
            <a href="carrinho/finalizar" class="btn btn-success" ></a>
        </p>
    </div>
</div>
<script>
    somarQuantidade = function(qtde, id) {
        $.get("somar.php",{qtde:qted,id:id}, function(dados){
            if (dados =="") window.location.reload();
            else alert(dados);
        })

    }