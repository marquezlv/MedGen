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
                        <th>ACTIONS</th>
                    </tr>
                    <tr v-for="item in list" :key="item.rowId">
                        <td>{{item.rowid}}</td>
                        <td>{{item.name}}</td>
                        <td>{{item.category}}</td>
                        <td>{{item.quantity}}</td>
                        <td>{{item.price.toFixed(2)}}</td>
                        <td>{{item.validity}}</td>
                        <td>
                            <div class="btn-group" role="group" aria-label="Basic Example">
                                <button class="btn btn-warning" @click="toggleContent(item)"><i class="bi bi-pen"></i></button>
                                <button class="btn btn-danger" @click="deleteMedicine(item.rowid)"><i class="bi bi-trash"></i></button>
                            </div>
                        </td>
                    </tr>
                </table>
                <h2 v-if="!showContent">Inserir Novo Medicamento</h2>
                <div v-if="showContent"> 
                    <form @submit.prevent="insertOrUpdateMedicine()">
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
                            <!-- <input v-model="quantity" type="number" class="form-control" id="quantity" required> -->
                                <input v-model="quantity" type="number" class="form-control" id="quantity" step="1" required>

                        </div>
                        <div class="mb-3">
                            <label for="price" class="form-label">Preço</label>
                            <!-- <input v-model="price" type="text" class="form-control" id="price" required> -->
                            <input v-model="price" type="number" class="form-control" id="price" step="0.01" required>
                        </div>
                        <div class="mb-3">
                            <label for="validityDate" class="form-label">Data de Validade</label>
                            <input v-model="validityDate" type="date" class="form-control" id="validityDate" required> 
                        </div>
                        <button type="submit" class="btn btn-primary">{{editingMedicine ? 'Atualizar medicamento' : 'Inserir medicamento'}}</button>
                    </form>   
                </div>
                <button @click="toggleContent()" :class="showContent ? 'btn btn-danger' : 'btn btn-success'">{{ showContent ? 'Cancelar' : 'Adicionar Medicamento' }}</button>    
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
                list: [],
                editingMedicine: null
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
                        async insertOrUpdateMedicine() {
                if (this.editingMedicine) {
                await this.updateMedicine();
                } else {
                await this.insertMedicine();
                }
                },
            async insertMedicine() {
                const originalDate = new Date(this.validityDate);
                // Obtendo componentes de data (dia, mês, ano)
                const day = originalDate.getDate().toString().padStart(2, '0');
                const month = (originalDate.getMonth() + 1).toString().padStart(2, '0'); // O mês é baseado em zero
                const year = originalDate.getFullYear();
                const formattedDate = day + '/' + month + '/' + year;
                const data = await this.request("/MedGen/api/medicine", "POST", {
                name: this.medicineName,
                        category: this.category,
                        quantity: this.quantity,
                        price: parseFloat(this.price),
                        date: formattedDate
                });
                this.resetForm();
                window.location.reload();
                },
            async updateMedicine() {
                const originalDate = new Date(this.validityDate);
                const day = originalDate.getDate().toString().padStart(2, '0');
                const month = (originalDate.getMonth() + 1).toString().padStart(2, '0');
                const year = originalDate.getFullYear();
                const formattedDate = day + '/' + month + '/' + year;
                
                // Modifica apenas o item editado na lista
                const index = this.list.findIndex(item => item.rowid === this.editingMedicine.rowid);
                if (index !== -1) {
                this.list[index] = {
                ...this.list[index],
                name: this.medicineName,
                category: this.category,
                quantity: this.quantity,
                price: parseFloat(this.price),
                validity: formattedDate
                }; }
            
                // Envia para o servidor 
                const data = await this.request(`/MedGen/api/medicine?id=`+ (this.editingMedicine.rowid), "PUT", {     
                    
                //por favor testar a linha abaixo, aqui não está reconhecendo o {this.editingMedicine.rowid} como variavel
                //const data = await this.request(`/MedGen/api/medicine?id={this.editingMedicine.rowid}`, "PUT", {

                name: this.medicineName,
                category: this.category,
                quantity: this.quantity,
                price: parseFloat(this.price),
                date: formattedDate
            });

                console.log(data);
                this.loadList();
                this.addHistory();
                this.resetForm();
                this.editingMedicine = null;
                this.toggleContent(null);
                },
                async addHistory() {
            const sysDate = new Date();
            const day = sysDate.getDate().toString().padStart(2, '0');
            const month = (sysDate.getMonth() + 1).toString().padStart(2, '0');
            const year = sysDate.getFullYear();
            const formattedDate = day + '/' + month + '/' + year;

            const data = await this.request("/MedGen/api/editHistory", "POST", {
                user: this.shared.session.name,
                modified: formattedDate,
                medicine: this.medicineName
            });
            console.log(data);
        },
            async loadList() {
                const data = await this.request("/MedGen/api/medicine", "GET");
                if (data) {
                this.list = data.list;
                }
                },
            async deleteMedicine(rowid) {
            try {
                // Box de confirmação de delete
                const confirmDelete = confirm("Tem certeza que deseja excluir este medicamento?");

                if (!confirmDelete) {
                    return;
                }
                // Envia uma solicitação para excluir o medicamento
                const response = await this.request(`/MedGen/api/medicine?id=` +rowid, "DELETE");
                //por favor testar a linha abaixo, aqui não está receonhcendo {rowid} como variavel
                //const response = await this.request(`/MedGen/api/medicine?id={rowid}`, "DELETE");

                if (response) {
                    this.loadList();
                }
            } catch (error) {
                console.error("Erro ao excluir o medicamento:", error);
            }
        },
            toggleContent(medicine) {
                this.showContent = !this.showContent;
                if (medicine) {
                this.editingMedicine = { ...medicine };
                this.medicineName = this.editingMedicine.name;
                this.category = this.editingMedicine.category;
                this.quantity = this.editingMedicine.quantity;
                this.price = parseFloat (this.editingMedicine.price);
                this.validityDate = this.editingMedicine.date;
                } else{
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
