<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manage Supplier</title>
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
                    Suppliers
                    <button @click="resetForm()" type ="button" class="btn btn-success btn-sm" data-bs-toggle="modal" data-bs-target="#addSupplierModal">
                        Add
                    </button>
                </h2>
                <!-- Modal -->
                <div class="modal fade" id="addSupplierModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h1 class="modal-title fs-5">New supplier</h1>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <!-- Formulário de adição de novo fornecedor -->
                                <form>
                                    <div class="mb-3">
                                        <label for="inputName" class="form-label">Name</label>
                                        <input type="text" v-model="name" class="form-control" id="inputName" placeholder="Supplier name">
                                    </div>
                                    <div class="mb-3">
                                        <label for="inputAddress" class="form-label">Address</label>
                                        <input type="text" v-model="address" class="form-control" id="inputAddress" placeholder="Av. Paulista, 123" >
                                    </div>
                                    <div class="mb-3">
                                        <label for="inputPhone" class="form-label">Phone</label>
                                        <input type="text" v-model="phone" class="form-control" id="inputPhone" pattern="\(\d{2}\) \d{5}-\d{4}" placeholder="(12) 34567-8901" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="inputEmail" class="form-label">E-mail</label>
                                        <input type="text" v-model="email" class="form-control" id="inputEmail" placeholder="someone@gmail.com">
                                    </div>
                                    <div class="mb-3">
                                        <label for="inputCnpj" class="form-label">CNPJ</label>
                                        <input type="text" v-model="cnpj" class="form-control" id="inputCnpj" placeholder="12.345.678/0001-12">
                                    </div>
                                </form>
                            </div>
                            <!-- Botões de save e cancel -->
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="button" class="btn btn-primary" data-bs-dismiss="modal"
                                        @click="insertOrUpdateSupplier()">Save</button>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Tabela para exibição -->
                <table class="table">
                    <tr>
                        <th>ID</th>
                        <th>NAME</th>
                        <th>ADDRESS</th>
                        <th>PHONE</th>
                        <th>EMAIL</th>
                        <th>CNPJ</th>
                        <th>ACTIONS</th>
                    </tr>
                    <tr v-for="item in list" :key="item.rowid">
                        <td>{{item.rowid}}</td>
                        <td>{{item.name}}</td>
                        <td>{{item.address}}</td>
                        <td>{{item.phone}}</td>
                        <td>{{item.email}}</td>
                        <td>{{item.cnpj}}</td>
                        <td>
                            <div class="btn-group" role="group" aria-label="Basic Example">
                                <button class="btn btn-warning" @click="toggleContent(item)" data-bs-toggle="modal" data-bs-target="#addSupplierModal"><i class="bi bi-pen"></i></button>
                                <button class="btn btn-danger" @click="deleteSupplier(item.rowid)"><i class="bi bi-trash"></i></button>
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
            showContent: false,
            name: '',
            address: '',
            phone: '',
            email: '',
            cnpj: '',
            error: '',
            list: [],
            editingSupplier: null
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

        // Metodo para verificar qual dos 2 metodos irá chamar, update ou insert
        async insertOrUpdateSupplier() {
            if (this.editingSupplier) {
                await this.updateSupplier();
            } else {
                await this.insertSupplier();
            }
        },
        // Metodo para inserir o novo fornecedor
        async insertSupplier() {
            console.log(this.name);
            console.log(this.address);
            console.log(this.phone);
            console.log(this.email);
            console.log(this.cnpj);
            const data = await this.request("/MedGen/api/supplier", "POST", {
                name: this.name,
                address: this.address,
                phone: this.phone,
                email: this.email,
                cnpj: this.cnpj
            });
            console.log(data);
            this.loadList();
            this.resetForm();
        },
        // Metodo para realizar update no fornecedor
        async updateSupplier() {
            // Modifica apenas o item editado na lista
            const index = this.list.findIndex(item => item.rowid === this.editingSupplier.rowid);
            if (index !== -1) {
                this.list[index] = {
                    ...this.list[index],
                    name: this.name,
                    address: this.address,
                    phone: this.phone,
                    email: this.email,
                    cnpj: this.cnpj
                };
            }

            // Envia para o servidor 
            const data = await this.request("/MedGen/api/supplier?id=" + (this.editingSupplier.rowid), "PUT", {

                name: this.name,
                address: this.address,
                phone: this.phone,
                email: this.email,
                cnpj: this.cnpj
            });

            console.log(data);
            this.loadList();
            this.resetForm();
            this.editingSupplier = null;
            this.toggleContent(null);
        },
        async loadList() {
            const data = await this.request("/MedGen/api/supplier", "GET");
            if (data) {
                this.list = data.list;
            }
            console.log(data);
        },
        // Metodo para deletar o fornecedor
        async deleteSupplier(rowid) {
            try {
                // Box de confirmação de delete
                const confirmDelete = confirm("Tem certeza que deseja excluir este fornecedor?");

                if (!confirmDelete) {
                    return;
                }
                // Envia uma solicitação para excluir o medicamento
                const response = await this.request("/MedGen/api/supplier?id=" + rowid, "DELETE");
                if (response) {
                    this.loadList();
                }
            } catch (error) {
                console.error("Erro ao excluir o fornecedor:", error);
            }
        },
        // Metodo para habilitar edição do fornecedor
        toggleContent(supplier) {
            if (supplier) {
                this.editingSupplier = {...supplier};
                this.name = this.editingSupplier.name;
                this.address = this.editingSupplier.address;
                this.phone = this.editingSupplier.phone;
                this.email = this.editingSupplier.email;
                this.cnpj = this.editingSupplier.cnpj;
            } else {
                this.resetForm();
            }
        },
        // Resetar as variaveis utilizada no formulario
        resetForm() {
            this.name = '';
            this.address = '';
            this.phone = '';
            this.email = '';
            this.cnpj = '';
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