<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manage Medicines</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.2/font/bootstrap-icons.css" integrity="sha384-b6lVK+yci+bfDmaY1u0zE8YYJt0TZxLEAFyYSLHId4xoVvsrQu3INevFKo+Xir8e" crossorigin="anonymous">
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    </head>
    <body>
        <%@ include file="WEB-INF/jspf/header.jspf" %>
        <div id="app" class="container mt-5">
            <div v-if="shared.session">
                <table class="table">
                    <tr>
                        <th>ID</th>
                        <th>NAME</th>
                        <th>CATEGORY</th>
                        <th>QUANTITY</th>
                        <th>PRICE</th>
                        <th>VALIDITY DATE</th>
                    </tr>
                    <tr v-for="item in list" :key="item.rowId">
                        <td>{{item.rowid}}</td>
                        <td>{{item.name}}</td>
                        <td>{{item.category}}</td>
                        <td>{{item.quantity}}</td>
                        <td>{{item.price}}</td>
                        <td>{{item.validity}}</td>
                    </tr>
                </table>
                <h2 v-if="!showContent">Inserir Novo Medicamento</h2>
                <div v-if="showContent"> 
                <form @submit.prevent="insertMedicine">
                    <div class="mb-3">
                        <label for="medicineName" class="form-label">Nome do Medicamento</label>
                        <input v-model="medicineName" type="text" class="form-control" id="medicineName" required>
                    </div>
                    <div class="mb-3">
                        <label for="category" class="form-label">Categoria</label>
                        <input v-model="category" type="text" class="form-control" id="category" required>
                    </div>
                    <div class="mb-3">
                        <label for="quantity" class="form-label">Quantidade</label>
                        <input v-model="quantity" type="number" class="form-control" id="quantity" required>
                    </div>
                    <div class="mb-3">
                        <label for="price" class="form-label">Preço</label>
                        <input v-model="price" type="number" class="form-control" id="price" required>
                    </div>
                    <div class="mb-3">
                        <label for="validityDate" class="form-label">Data de Validade</label>
                        <input v-model="validityDate" type="date" class="form-control" id="validityDate" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Inserir Medicamento</button>
                </form>   
            </div>
                <button @click="toggleContent()" class="btn btn-success">{{ showContent ? 'Cancelar' : 'Adicionar Medicamento' }}</button>    
            </div>
            <table class="table">
                <tr v-for="item in list" :key="item.rowId">
                </tr>
            </table>
        </div>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script>
    const app = Vue.createApp({
        data() {
            return {
                shared: shared,
                showContent: false,
                medicineName: '',
                category: '',
                quantity: 0,
                price: 0,
                validityDate: '',
                list: []
            };
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
            insertMedicine() {

                console.log('Medicamento inserido:', this.medicineName, this.category, this.quantity, this.price, this.validityDate);

                // Limpar os campos após a inserção (opcional)
                this.resetForm();
            },
            async loadList() {
                const data = await this.request("/MedGen/api/medicine", "GET");
                if (data) {
                    this.list = data.list;
                }
            },
            toggleContent() {
                this.showContent = !this.showContent;
                if (!this.showContent) {
                    this.resetForm();
                }
            },
            resetForm() {
                this.medicineName = '';
                this.category = '';
                this.quantity = 0;
                this.price = 0;
                this.validityDate = '';
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
