<div>
<canvas id="myChart" class="grafico" width="80%" height="20px"></canvas>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    async function getData() {
        const url = "http://localhost/Livraria_Alexandria/public/apis/vendaCliente.php";
        try {
            const response = await fetch(url);
            console.log('Gráfico criado com sucesso!');
            if (!response.ok) {
                throw new Error(`Response status: ${response.status}`);
            }

            const result = await response.json();
            
            const ctx = document.getElementById('myChart');
            console.log(result)
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: result.map(cliente => cliente.nome),
                    datasets: [{
                        label: 'Quantidade de vendas por cliente',
                        data: result.map(cliente => cliente.total_vendido),
                        borderWidth: 2,
                        barThickness: 100
                    }]
                },
                options: {
                    scales: { 
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
            if (!result) {
                console.log('Não foi possível obter os dados.');
            } else {
                console.log('Dados obtidos com sucesso!')
            }


        } catch (error) {
            console.error(error.message);
        }
    }
    getData();
</script>