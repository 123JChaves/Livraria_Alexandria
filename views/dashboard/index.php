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
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered table-striped">
                        <thead>
                            <tr>
                                <h2>Dashboard</h2>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>TOTAL DE ITENS POR CLIENTE</td>
                                <td class="text-center">
                                    <a href="dashboard/itensCliente" class="btn btn-dark mt-2 border-0 rounded-4">
                                        <i class="fa-solid fa-share"></i> Ver Gráfico
                                    </a>
                                </td>
                            </tr>
                            <tr>
                                <td>TOTAL DE ITENS VENDIDOS</td>
                                <td class="text-center">
                                    <a href="dashboard/itensVendidos" class="btn btn-dark mt-2 border-0 rounded-4">
                                        <i class="fa-solid fa-share"></i> Ver Gráfico
                                    </a>
                                </td>
                            </tr>
                            <tr>
                                <td>VENDAS POR CLIENTE</td>
                                <td class="text-center">
                                    <a href="dashboard/vendaCliente" class="btn btn-dark mt-2 border-0 rounded-4">
                                        <i class="fa-solid fa-share"></i> Ver Gráfico
                                    </a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>