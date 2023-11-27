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
        <div id="app" class="container">
            <!-- Verifica se existe uma sessão -->
            <div v-if="shared.session">
                <div v-if="error" class="alert alert-danger m-2" role="alert">
                    {{error}}
                </div>
                <div v-else>
                    <h2 class="mb-3" style="margin-top: 50px;">
                        Users
                        <!-- Botão do modal  -->
                        <button @click="resetForm()" type ="button" class="btn btn-success btn-sm" data-bs-toggle="modal" data-bs-target="#addUserModal">
                            Add
                        </button>
                    </h2>
                    <!-- Modal -->
                    <div class="modal fade" id="addUserModal" tabindex="-1">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h1 class="modal-title fs-5">New user</h1>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <!-- Formulário de adição de novo usuário -->
                                    <form>
                                        <div class="mb-3">
                                            <label for="inputRole" class="form-label">Role</label>
                                            <select class="form-select" v-model="newRole">
                                                <!-- Opções selecionáveis -->
                                                <option value="USER">USER</option>
                                                <option value="ADMIN">ADMIN</option>
                                            </select>
                                        </div>
                                        <!-- Campos para digitar -->
                                        <div class="mb-3">
                                            <label for="inputLogin" class="form-label">Login</label>
                                            <input type="text" v-model="newLogin" class="form-control" id="inputLogin">
                                        </div>
                                        <div class="mb-3">
                                            <label for="inputName" class="form-label">Name</label>
                                            <input type="text" v-model="newName" class="form-control" id="inputName">
                                        </div>
                                        <div class="mb-3">
                                            <label for="inputPass" class="form-label">Password</label>
                                            <input type="password" v-model="newPassword" class="form-control" id="inputPass" required>
                                        </div>
                                    </form>
                                </div>
                                <!-- Botões de save e cancel -->
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" @click="resetForm()">Cancel</button>
                                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal" @click="insertOrUpdate()">Save</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Tabela para a exibição de usuários -->
                    <table class="table">
                        <tr>
                            <th>ID</th>
                            <th>LOGIN</th>
                            <th>NAME</th>
                            <th>ROLE</th>
                            <th>ACTIONS</th>
                        </tr>
                        <!-- for para completar a tabela com as informações -->
                        <tr v-for="item in list" :key="item.rowid">
                            <td>{{ item.rowid }}</td>
                            <td>{{ item.login }}</td>
                            <td>{{ item.name }}</td>
                            <td>{{ item.role }}</td>
                            <td>
                                <!-- Botões de edit e remove  -->
                                <div class="btn-group" role="group" aria-label="Basic Example">
                                    <button type ="button" @click="setVariables(item)" class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#addUserModal"><i class="bi bi-pen"></i></button>
                                    <button type ="button" @click="removeUser(item.rowid)" class="btn btn-danger btn-sm"><i class="bi bi-trash"></i></button>
                                </div>
                            </td>
                    </table>
                </div>
            </div>
        </div>
        <script>
const app = Vue.createApp({
    data() {
        return {
            shared: shared,
            error: null,
            newRole: 'USER',
            newLogin: '',
            newName: '',
            newPassword: '',
            list: [],
            user: null
        };
    },
    methods: {
        // Requisição
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
        // Metodo para verificar se deve chamar o inser ou update dependendo do objeto user
        async insertOrUpdate() {
            if (this.user) {
                await this.updateUser();
            } else {
                await this.addUser();
            }
        },
        async loadList() {
            const data = await this.request("/MedGen/api/users", "GET");
            if (data) {
                this.list = data.list;
            }
        },
        // Metodo para adicionar um novo usuario no sistema
        async addUser() {
            const data = await this.request("/MedGen/api/users", "POST", {
                login: this.newLogin,
                name: this.newName,
                role: this.newRole,
                password: this.newPassword
            });
            this.loadList();
        },
        // Metodo para dar update no usuario    
        async updateUser() {
            // Altera somente o campo que foi editado
            const index = this.list.findIndex(item => item.rowid === this.user.rowid);
            if (index !== -1) {
                this.list[index] = {
                    ...this.list[index],
                    name: this.newName,
                    login: this.newLogin,
                    role: this.newRole,
                    password: this.newPassword
                };
            }

            // Envia pro servidor
            const data = await this.request(`/MedGen/api/users?id=` + (this.user.rowid), "PUT", {
                name: this.newName,
                login: this.newLogin,
                role: this.newRole,
                password: this.newPassword
            });

            this.resetForm();
            this.user = null;
        },

        // Metodo para remover o usuario do sistema
        async removeUser(id) {
            try {
                // Box de confirmação de delete
                const confirmDelete = confirm("Tem certeza que deseja excluir este usuário?");
                if (!confirmDelete) {
                    return;
                }

                const data = await this.request("/MedGen/api/users?id=" + id, "DELETE");
                if (data) {
                    await this.loadList();
                }
            } catch (error) {
                console.error("Erro ao excluir o usuário:", error);
            }
        },
        // Metodo para setar as variaveis de edição
        setVariables(user) {
            if (user) {
                this.user = {...user};
                this.newRole = this.user.role;
                this.newLogin = this.user.login;
                this.newName = this.user.name;
            } else {
                this.resetForm();
            }
        },
        // Metodo para resetar o formulario e atualizar a lista
        resetForm() {
            this.newRole = 'USER';
            this.newLogin = '';
            this.newName = '';
            this.newPassword = '';
            this.loadList();
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
