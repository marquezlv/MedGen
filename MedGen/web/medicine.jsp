<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
                <div v-if="error" class="alert alert-danger m-2" role="alert">
                    {{error}}
                </div>
                <h2>
                    Medicine Inventory 
                    <button @click="resetForm()" type="button" class="btn btn-success btn-sm" data-bs-toggle="modal" data-bs-target="#addMedicineModal">
                        Add
                    </button>
                </h2>
                <!-- Formulario para inserção de um novo medicamento -->
                <div class="modal fade" id="addMedicineModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h1 class="modal-title fs-5">New medicine</h1>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <form>
                                    <div class="mb-3">
                                        <label for="medicineName" class="form-label">Name</label>
                                        <input type="text" v-model="medicineName" class="form-control" id="medicineName" placeholder="ex. Medicine" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="category" class="form-label">Category</label>
                                        <input type="text" v-model="category" class="form-control" id="category" placeholder= "ex. Antibiotic" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="quantity" class="form-label">Quantity</label>
                                        <input type="number" class="form-control" v-model="quantity" id="quantity" @input="validateQuantity" required min="1">
                                        <div v-if="error" class="alert alert-danger mt-2" role="alert">
                                            {{error}}
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label for="price" class="form-label">Price</label>
                                        <input type="number" class="form-control" v-model="price" id="price" step="0.01" @input="validatePrice" required>
                                        <div v-if="error" class="alert alert-danger mt-2" role="alert">
                                            {{error}}
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label for="validityDate" class="form-label">Validity Date</label>
                                        <input v-model="validityDate" type="date" class="form-control" id="validityDate" required> 
                                    </div>
                                    <div class="mb-3">
                                        <label for="supplier" class="form-label">Supplier</label>
                                        <!-- Select para o usuario selecionar um dos fornecedores ja cadastrados (item2 para não dar conflito com a tabela) -->
                                        <select class="form-select" v-model="newSupplier" id="supplier">
                                            <option v-for="item2 in supplier" :key="item2.rowid" :value="item2.name">{{item2.name}}</option>
                                        </select>
                                    </div>
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <!-- Aproveitando o mesmo formulario para inserir e dar update chamando uma função de verificação -->
                                <button type="button" class="btn btn-primary" data-bs-dismiss="modal"
                                        @click="insertOrUpdateMedicine()">Save</button>
                            </div>
                        </div>
                    </div>
                </div>        

                <table class="table">
                    <tr>
                        <th>BATCH</th>
                        <th>NAME</th>
                        <th>CATEGORY</th>
                        <th>QUANTITY</th>
                        <th>PRICE</th>
                        <th>VALIDITY DATE</th>
                        <th>SUPPLIER</th>
                        <th>ACTIONS</th>
                    </tr>
                    <tr v-for="item in list" :key="item.rowid">
                        <td>{{item.rowid}}</td>
                        <td>{{item.name}}</td>
                        <td>{{item.category}}</td>
                        <td>{{item.quantity}}</td>
                        <td>{{item.price.toFixed(2)}}</td>
                        <td>{{item.validity}}</td>
                        <td>{{item.supplier}}</td>
                        <td>
                            <div class="btn-group" role="group" aria-label="Basic Example">
                                <!-- Passando como parametro para o toggleContent o item da lista que é o objeto medicine -->
                                <button class="btn btn-warning" @click="toggleContent(item)" data-bs-toggle="modal" data-bs-target="#addMedicineModal"><i class="bi bi-pen"></i></button>
                                <button class="btn btn-danger" @click="deleteMedicine(item.rowid)"><i class="bi bi-trash"></i></button>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <script>
const app = Vue.createApp({
    data() {
        return {
            shared: shared,
            medicineName: '',
            category: '',
            quantity: 0,
            price: 0,
            validityDate: '',
            list: [],
            supplier: [], // Uma lista dos fornecedores resgatado do get
            newSupplier: '', // Variavel utilizada para selecionar o fornecedor
            editingMedicine: null // Objeto de edição de medicine iniciando como nulo
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
                if (response.status === 200) {
                    return response.json();
                } else {
                    this.error = response.statusText;
                }
            } catch (e) {
                this.error = e;
                return null;
        }
        },
        // Metodo para chamar uma das 2 funções, insert ou update verificando se existe algum objeto dentro do editingMedicine
        async insertOrUpdateMedicine() {
            if (this.editingMedicine) {
                await this.updateMedicine();
            } else {
                await this.insertMedicine();
            }
        },
        // Metodo para inserir a nova medicina no banco
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
                date: formattedDate,
                supplier: this.newSupplier
            });
            this.loadList();
            this.resetForm();
        },
        // Metodo para dar update na medicine
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
                    validity: formattedDate,
                    supplier: this.newSupplier
                };
            }

            // Envia para o servidor 
            const data = await this.request(`/MedGen/api/medicine?id=` + (this.editingMedicine.rowid), "PUT", {
                name: this.medicineName,
                category: this.category,
                quantity: this.quantity,
                price: parseFloat(this.price),
                date: formattedDate,
                supplier: this.newSupplier
            });
            this.loadList();
            // Adicionando o historico de edição após o update da medicine
            this.addHistory();
            this.resetForm();
            // setando o objeto da edição da medicina para nulo novamente
            this.editingMedicine = null;
            this.toggleContent(null);
        },
        // Metodo para adicionar o historico de edição que fez a edição no medicamento
        async addHistory() {
            // Pegando a data atual e formatando para manter no banco
            const sysDate = new Date();
            const day = sysDate.getDate().toString().padStart(2, '0');
            const month = (sysDate.getMonth() + 1).toString().padStart(2, '0');
            const year = sysDate.getFullYear();
            const formattedDate = day + '/' + month + '/' + year;

            const data = await this.request("/MedGen/api/editHistory", "POST", {
                // Pegando o nome da pessoa logada para inserir no historico
                user: this.shared.session.name,
                modified: formattedDate,
                medicine: this.medicineName
            });
        },
        // Metodo para carregar as 2 listas na pagina
        async loadList() {
            const data = await this.request("/MedGen/api/medicine", "GET");
            if (data) {
                this.list = data.list;
            }
            const supplier = await this.request("/MedGen/api/supplier", "GET");
            if (supplier) {
                this.supplier = supplier.list;
            }
        },
        // Metodo para deletar a medicina
        async deleteMedicine(rowid) {
            try {
                // Box de confirmação de delete
                const confirmDelete = confirm("Tem certeza que deseja excluir este medicamento?");

                if (!confirmDelete) {
                    return;
                }
                // Envia uma solicitação para excluir o medicamento
                const response = await this.request(`/MedGen/api/medicine?id=` + rowid, "DELETE");
                if (response) {
                    this.loadList();
                }
            } catch (error) {
                console.error("Erro ao excluir o medicamento:", error);
            }
        },
        // Metodo para validar a quantidade não sendo menor que zero
        validateQuantity() {
            if (this.quantity < 0) {
                this.quantity = 1; // se for negativo, muda para 1 no input
            }
        },
        // Metodo para validar o preço não sendo menor que zero
        validatePrice() {
            if (this.price < 0) {
                this.price = 1; // se for negativo, muda para 1 no input
            }
        },
        // Metodo para habilitar o conteudo de edição, realizando uma copia do objeto medicine para a variavel de edição
        toggleContent(medicine) {
            if (medicine) {
                this.editingMedicine = {...medicine};
                this.medicineName = this.editingMedicine.name;
                this.category = this.editingMedicine.category;
                this.quantity = this.editingMedicine.quantity;
                this.price = parseFloat(this.editingMedicine.price);
                this.validityDate = this.editingMedicine.validity;
                this.newSupplier = this.editingMedicine.supplier;
            } else {
                // Se for nulo reseta o formulario
                this.resetForm();
            }
        },
        // Metodo para resetar o formulario
        resetForm() {
            this.medicineName = '';
            this.category = '';
            this.quantity = 0;
            this.price = 0;
            this.validityDate = '';
            this.newSupplier = '';
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
