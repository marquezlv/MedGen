<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MedGen</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.2/font/bootstrap-icons.css" integrity="sha384-b6lVK+yci+bfDmaY1u0zE8YYJt0TZxLEAFyYSLHId4xoVvsrQu3INevFKo+Xir8e" crossorigin="anonymous">
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>   
    </head>
    <body>
        <%@ include file="WEB-INF/jspf/header.jspf" %>
        <div id="app" class="container" >
            <div v-if="shared.session">
                <div v-else class="mt-4">
                    <div class="input-group" style="width: 500px;  display: flex; align-items: center;"  >
                        <h2 class="mb-3" style="margin-right: 10px; margin-top: 30px;">Medicines </h2>
                        <input type="text" class="form-control" id="categoryFilter" v-model="categoryFilter" placeholder="Search for category:" style= "width: 250px; margin-left: 10px; margin-top: 20px;">
                        <button style="margin-top: 20px;" class="btn btn-primary" @click="filterByCategory" >
                            <i class="bi bi-search"></i> Filter
                        </button>
                    </div>
                    <table class="table">
                        <tr>
                            <th>BATCH</th>
                            <th>NAME</th>
                            <th>CATEGORY</th>
                            <th>QUANTITY</th>
                            <th>PRICE</th>
                            <!-- um icone de seta para indicar qual a ordenação da validade, ao clicar chama a função para inverter -->
                            <th>
                                VALIDITY DATE
                                <span @click="sortByValidity" v-html="sortDirection === 'asc' ? '<i class=\'bi bi-arrow-up\'></i>' : '<i class=\'bi bi-arrow-down\'></i>'"></span>
                            </th>
                            <th>ACTIONS</th>
                        </tr>
                        <tr v-for="item in list" :key="item.rowid">
                            <td>{{item.rowid}}</td>
                            <td>{{item.name}}</td>
                            <td>{{item.category}}</td>
                            <td>{{item.quantity}}</td>
                            <td>{{item.price}}</td>
                            <td>{{item.validity}}</td>
                            <!-- Botão de carrinho para dar abater do medicamento, abrindo um formulario e setando as variaveis do respectivo medicamento -->
                            <td><button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#checkOut" @click="setVariables(item.name,item.price, item.category, item.validity, item.quantity, item.rowid, item.supplier)"><i class="bi bi-cart2"></i></button></td>
                        </tr>
                    </table>
                    <!-- Formulario para dar abate no medicamento -->
                    <div class="modal fade" id="checkOut" tabindex="-1">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h1 class="modal-title fs-5">Medicine Check Out</h1>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <form>
                                        <div class="mb-3">
                                            <label for="quantity" class="form-label">Sell quantity</label>
                                            <!-- Evento de interação do input com validação -->
                                            <input type="number" class="form-control" v-model="quantity" id="quantity" @input="validateQuantity" required min="1">
                                            <div v-if="error" class="alert alert-danger mt-2" role="alert">
                                                {{error}}
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <label for="medicineName" class="form-label">Medicine Name</label>
                                            <input type="text" v-model="medicineName" class="form-control" id="medicineName" disabled>
                                        </div>
                                        <div class="mb-3">
                                            <label for="medicinePrice" class="form-label">Unitary Price</label>
                                            <input type="number" v-model="medicinePrice" class="form-control" id="medicinePrice" step="0.01" disabled>
                                        </div>
                                    </form>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                    <button type="button" class="btn btn-warning" data-bs-dismiss="modal" @click="checkOut()">Check Out</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script>
const app = Vue.createApp({
    data() {
        return{
            shared: shared,
            error: null,
            list: [],
            categoryFilter: '',
            listOriginally: [],
            currentQtd: 0,
            quantity: 0,
            medicineName: '',
            medicinePrice: 0,
            category: '',
            validityDate: '',
            sortDirection: 'asc',
            rowid: 0,
            supplier: ''
        }
    },
    methods: {
        async request(url = "", method, data) {
            try {
                const response = await fetch(url, {
                    method: method,
                    headers: {"Content-Type": "application/json"},
                    body: JSON.stringify(data)
                });
                if (response.status == 200) {
                    return response.json();
                } else {
                    this.error = response.statusText;
                }
            } catch (e) {
                this.error = e;
                return null;
        }
        },
        // Metodo para organizar a lista de por ordem da data de validade
        sortByValidity() {
            // Alterna a direção da ordenação
            this.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc';

            // Ordena a lista por data de validade e direção
            this.list.sort((a, b) => {
                const dateA = new Date(a.validity);
                const dateB = new Date(b.validity);
                const comparison = dateA - dateB;

                // Multiplica por -1 se a direção for 'desc' para inverter a ordenação
                return this.sortDirection === 'asc' ? comparison : comparison * -1;
            });
        },
        // Metodo para buscar os medicamentos pela categoria digitada
        filterByCategory() {
            // Comparando se o campo digitado contem nenhum caractere (metodo trim retira espaços em branco do inicio e fim)
            if (this.categoryFilter.trim() === "") {
                // Se o campo de filtro estiver vazio, carregue a lista completa
                this.list = this.listOriginally.slice();
            } else {
                // Filtrar a lista por categoria
                const filteredList = this.listOriginally.filter(item =>
                    item.category.toLowerCase().includes(this.categoryFilter.toLowerCase())
                );
                this.list = filteredList;
            }
        },
        // Metodo para setar as variaveis quando necessario
        async setVariables(name, price, category, date, quantity, id, supplier) {
            this.medicineName = name;
            this.medicinePrice = price;
            this.category = category;
            this.validityDate = date;
            this.currentQtd = quantity;
            this.rowid = id;
            this.supplier = supplier;
        },
        //Metodo para dar update na medicine
        async updateMedicine() {
            // Formatando a data para que garanta o envio correto á API
            const originalDate = new Date(this.validityDate);
            const day = originalDate.getDate().toString().padStart(2, '0');
            const month = (originalDate.getMonth() + 1).toString().padStart(2, '0');
            const year = originalDate.getFullYear();
            const formattedDate = day + '/' + month + '/' + year;
            // Neste caso iremos abater a quantidade da medicine, então iremos subtrair a quantidade atual pela quantidade digitada
            const newQuantity = this.currentQtd - this.quantity;
            const data = await this.request("/MedGen/api/medicine?id=" + this.rowid, "PUT", {
                name: this.medicineName,
                category: this.category,
                quantity: newQuantity,
                price: parseFloat(this.medicinePrice),
                date: formattedDate,
                supplier: this.supplier
            });
        },
        // Valida se o valor colocado é negativo ou maior que a quantidade de estoque
        validateQuantity() {
            if (this.quantity < 0) {
                this.quantity = 1; // se for negativo, muda para 1 no input
            } else if (this.quantity > this.currentQtd) {
                this.quantity = this.currentQtd; // se for maior que a qtd de estoque, retorna pro maximo valor existente de estoque

            }
        },
        // Valida se o valor colocado é negativo ou maior que a quantidade de estoque
        async checkOut() {
            const sysDate = new Date();
            const day = sysDate.getDate().toString().padStart(2, '0');
            const month = (sysDate.getMonth() + 1).toString().padStart(2, '0');
            const year = sysDate.getFullYear();
            const formattedDate = day + '/' + month + '/' + year;
            const data = await this.request("/MedGen/api/checkOut", "POST", {
                user: this.shared.session.name,
                price: this.medicinePrice,
                medicine: this.medicineName,
                quantity: this.quantity,
                date: formattedDate
            });
            // Chamando o update medicines para descontar a quantidade fornecida
            this.updateMedicine();
            // Resetando as variaveis utilizadas
            this.resetForm();
            this.loadList();
            // Atualizando a pagina para garantir a atualização da lista
            window.location.reload();
        },
        // Metodo para resetar todos os campos usado na pagina
        async resetForm() {
            this.currentQtd = 0;
            this.quantity = 0;
            this.medicineName = '';
            this.medicinePrice = 0;
            this.category = '';
            this.validityDate = '';
            this.rowid = 0;
        },
        async loadList() {
            const data = await this.request("/MedGen/api/medicine", "GET");
            if (data) {
                this.list = data.list;
                // Salvando uma copia da lista para realizar o filtro se necessario
                this.listOriginally = data.list.slice();
            }
        }
    },
    mounted() {
        this.loadList();
    }
});
app.mount('#app');
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    </body>
</html>
