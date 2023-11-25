
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
                    <h2>
                        Users
                    <!-- Botão do modal  -->
                        <button type ="button" @click="removeUser(item.rowId)" class="btn btn-success btn-sm" data-bs-toggle="modal" data-bs-target="#addUserModal">
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
                                            <input type="password" v-model="newPassword" class="form-control" id="inputPass">
                                        </div>
                                    </form>
                                </div>
                                <!-- Botões de save e cancel -->
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal"
                                            @click="addUser()">Save</button>
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
                        <tr v-for="item in list" :key="item.rowId">
                            <td>{{ item.rowId }}</td>
                            <td>{{ item.login }}</td>
                            <td>{{ item.name }}</td>
                            <td>{{ item.role }}</td>
                            <td>
                                <!-- Botão de remover  -->
                                <button type="button" @click="removeUser(item.rowid)" class="btn btn-danger btn-sm">
                                    Remove
                                </button>
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
                    list: []
                };
            },
            methods: {
                // Requisição
                async request(url = "", method, data) {
                    try {
                        const response = await fetch(url, {
                            method: method,
                            headers: { "Content-Type": "application/json" },
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
                async loadList() {
                    const data = await this.request("/MedGen/api/users", "GET");
                    if (data) {
                        this.list = data.list;
                    }
                },
                async addUser() {
                    const data = await this.request("/MedGen/api/users", "POST", {
                        login: this.newLogin,
                        name: this.newName,
                        role: this.newRole,
                        password: this.newPassword
                    });
                    if (data) {
                        // Limpa e atualiza a lista
                        this.newRole = 'USER';
                        this.newLogin = '';
                        this.newName = '';
                        this.newPassword = '';
                        await this.loadList();
                    }
                },
                
                async removeUser(id) {
                try{
                    // Box de confirmação de delete
                    const confirmDelete = confirm("Tem certeza que deseja excluir este usuário?");
                    if (!confirmDelete) {
                    return;
                    }
                
                    const data = await this.request("/MedGen/api/users?id=" +id, "DELETE");
                    if (data) {
                        await this.loadList();
                    }
                } catch (error) {
                  console.error("Erro ao excluir o usuário:", error);
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
