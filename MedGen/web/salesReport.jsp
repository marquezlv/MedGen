<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sales Report</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.2/font/bootstrap-icons.css" integrity="sha384-b6lVK+yci+bfDmaY1u0zE8YYJt0TZxLEAFyYSLHId4xoVvsrQu3INevFKo+Xir8e" crossorigin="anonymous">
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    </head>
    <body>
        <%@ include file="WEB-INF/jspf/header.jspf" %>
        <div id="app" class="container">
            <div v-if="shared.session">
                <div v-if="error" class="alert alert-danger m-2" role="alert">
                    {{error}}
                </div>
                <div v-else>
                    <h2>Sales Report</h2>
                 <!--  Restrição para que apenas o admin consiga deletar histórico -->
                 <button v-if="shared.session.role == 'ADMIN'" class="btn btn-danger" @click="clearHistory()">Clear History</button>
                    <table class="table">
                        <tr>
                            <th>User Name</th>
                            <th>Unitary Price</th>
                            <th>Quantity Sold</th>
                            <th>Medicine Name</th>
                            <th>Date Sold</th>
                            <th>Total Price</th>
                        </tr>
                        <tr v-for="item in list" :key="item.rowid">
                            <td>{{ item.userName }}</td>
                            <td>{{ item.price }}</td>
                            <td>{{ item.quantity }}</td>
                            <td>{{ item.medicineName }}</td>
                            <td>{{ item.checkOut }}</td>
                            <td>{{ item.priceTotal }}</td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <script>
const app = Vue.createApp({
    data() {
        return{
            shared: shared,
            error: null,
            list: []
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
        async loadList() {
            const data = await this.request("/MedGen/api/checkOut", "GET");
            if (data) {
                this.list = data.list;
            }
        },
        async clearHistory() {
            const confirmDelete = confirm("Tem certeza que deseja limpar TODO historico de vendas?");

            if (!confirmDelete) {
                return;
            } else {
                const data = await this.request("/MedGen/api/checkOut", "DELETE");
                if (data) {
                    await this.loadList();
                }
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