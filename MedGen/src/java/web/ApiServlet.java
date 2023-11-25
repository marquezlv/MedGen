package web;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.text.SimpleDateFormat;
import java.util.Date;
import model.Medicine;
import org.json.JSONObject;
import model.Users;
import org.json.JSONArray;
import model.EditHistory;
import model.CheckOut;
import model.Supplier;

@WebServlet(name = "ApiServlet", urlPatterns = {"/api/*"})
public class ApiServlet extends HttpServlet {
    
    // Metodo para retornar um objeto em formato de JSON
    private JSONObject getJSONBODY(BufferedReader reader) throws IOException{
        StringBuilder buffer = new StringBuilder();
        String line = null;
        while((line = reader.readLine())!= null){
            buffer.append(line);
        }
        return new JSONObject(buffer.toString());
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        JSONObject file = new JSONObject();
        try{
            if(request.getRequestURI().endsWith("/api/session")){
                processSession(file, request, response);
            } else if(request.getRequestURI().endsWith("/api/users")){
                processUsers(file, request, response);
            } else if(request.getRequestURI().endsWith("/api/medicine")){
                processMedicine(file, request, response);
            } else if (request.getRequestURI().endsWith("/api/editHistory")) {
                processEditHistory(file, request, response);
            } else if (request.getRequestURI().endsWith("/api/checkOut")) {
                processCheckOut(file, request, response);
            }
              else if (request.getRequestURI().endsWith("/api/supplier")) {
                processSupplier(file, request, response);
            }
        } catch(Exception ex){
            response.sendError(500,"Internal Error: "+ex.getLocalizedMessage());
        }
        response.getWriter().print(file.toString());
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Short description";
    }

    // Processar a sessão do usuario
    private void processSession(JSONObject file, HttpServletRequest request, HttpServletResponse response) throws Exception {
        if(request.getMethod().toLowerCase().equals("put")){
            JSONObject body = getJSONBODY(request.getReader());
            String login = body.getString("login");
            String password = body.getString("password");
            Users u = Users.getUser(login, password); // Verificando se o usuario é cadastrado
            if(u == null){
                response.sendError(403, "Login or password incorrect");
            } else {
                // Setando a sessão do usuario
                request.getSession().setAttribute("users", u);
                file.put("id", u.getRowid());
                file.put("login", u.getLogin());
                file.put("name", u.getName());
                file.put("role", u.getRole());
                file.put("passwordHash", u.getPasswordHash());
                file.put("message","Logged in");
            }
        } else if(request.getMethod().toLowerCase().equals("delete")){
            // Removendo a sessão do usuario
            request.getSession().removeAttribute("users");
            file.put("message","Logged out");
        } else if(request.getMethod().toLowerCase().equals("get")){
            // Verificando se existe sessão do usuario
            if(request.getSession().getAttribute("users") == null){
                response.sendError(403,"No Session");
            } else {
                // Se houver resgata os atributos
                Users u = (Users) request.getSession().getAttribute("users");
                file.put("id", u.getRowid());
                file.put("login", u.getLogin());
                file.put("name", u.getName());
                file.put("role", u.getRole());
                file.put("passwordHash", u.getPasswordHash());
            }
        } else{
            response.sendError(405,"Method not allowed");
        }
    }

    private void processUsers(JSONObject file, HttpServletRequest request, HttpServletResponse response) throws Exception {
        if(request.getSession().getAttribute("users")== null){
            response.sendError(401,"Unauthorized: No session");
        } else if(!((Users)request.getSession().getAttribute("users")).getRole().equals("ADMIN")){
            response.sendError(401,"Unauthorized: Only admin can manage users");
        } else if(request.getMethod().toLowerCase().equals("get")){
            file.put("list", new JSONArray(Users.getUsers()));
        } else if(request.getMethod().toLowerCase().equals("post")){
            JSONObject body = getJSONBODY(request.getReader());
            String login = body.getString("login");
            String name = body.getString("name");
            String role = body.getString("role");
            String password = body.getString("password");
            Users.insertUser(login, name, role, password);
        } else if(request.getMethod().toLowerCase().equals("put")){
            JSONObject body = getJSONBODY(request.getReader());
            String login = body.getString("login");
            String name = body.getString("name");
            String role = body.getString("role");
            String password = body.getString("password");
            Users.updateUser(login, name, role, password);
        } else if(request.getMethod().toLowerCase().equals("delete")){
            Long id = Long.parseLong(request.getParameter("id"));
            Users.deleteUser(id);
        } else{
            response.sendError(405,"Methodo not allowed");
        }
    }

    private void processMedicine(JSONObject file, HttpServletRequest request, HttpServletResponse response) throws Exception {
        if(request.getSession().getAttribute("users")== null){
            response.sendError(401,"Unauthorized: No session");
        } else if(request.getMethod().toLowerCase().equals("get")){
            file.put("list", new JSONArray(Medicine.getMedicines()));
        } else if(request.getMethod().toLowerCase().equals("post")){
            JSONObject body = getJSONBODY(request.getReader());
            String name = body.getString("name");
            String category = body.getString("category");
            int quantity = body.getInt("quantity");
            double price = body.getDouble("price");
            String sdate = body.getString("date");
            SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
            Date date = formatter.parse(sdate);
            Medicine.insertMedicine(name, category, quantity, price, date);
        } else if(request.getMethod().toLowerCase().equals("put")){
            JSONObject body = getJSONBODY(request.getReader());
            String name = body.getString("name");
            String category = body.getString("category");
            int quantity = body.getInt("quantity");
            double price = body.getDouble("price");
            String sdate = body.getString("date");
            SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
            Long id = Long.parseLong(request.getParameter("id"));
            Date date = formatter.parse(sdate);
            Medicine.updateMedicine(id, name, category, quantity, price, date);
        } else if(request.getMethod().toLowerCase().equals("delete")){
            Long id = Long.parseLong(request.getParameter("id"));
            Medicine.deleteMedicine(id);
        } else{
            response.sendError(405,"Methodo not allowed");
        }
    }
    
private void processEditHistory(JSONObject file, HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (request.getSession().getAttribute("users") == null) {
            response.sendError(401, "Unauthorized: No session");
        } else if (request.getMethod().toLowerCase().equals("post")) {
            JSONObject body = getJSONBODY(request.getReader());
            String name = body.getString("user");
            String sdate = body.getString("modified");
            String medicine = body.getString("medicine");
            Date modified = new SimpleDateFormat("dd/MM/yyyy").parse(sdate);
            EditHistory.insertHistory(name, modified, medicine);
        } else if (request.getMethod().toLowerCase().equals("delete")) {
            EditHistory.deleteHistory();
        } else if (request.getMethod().toLowerCase().equals("get")) {
            file.put("list", new JSONArray(EditHistory.getHistory()));
        } else {
            response.sendError(405, "Methodo not allowed");
        }
    }

    private void processCheckOut(JSONObject file, HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (request.getSession().getAttribute("users") == null) {
            response.sendError(401, "Unauthorized: No session");
        } else if (request.getMethod().toLowerCase().equals("post")) {
            JSONObject body = getJSONBODY(request.getReader());
            String name = body.getString("user");
            double price = body.getDouble("price");
            String medicine = body.getString("medicine");
            int quantity = body.getInt("quantity");
            String sdate = body.getString("date");
            double priceTotal = price * quantity;
            Date date = new SimpleDateFormat("dd/MM/yyyy").parse(sdate);
            CheckOut.insertCheckOut(name, price, priceTotal, medicine, quantity, date);
        } else if (request.getMethod().toLowerCase().equals("delete")) {
            CheckOut.deleteCheckOut();
        } else if (request.getMethod().toLowerCase().equals("get")) {
            file.put("list", new JSONArray(CheckOut.getCheckOuts()));
        } else {
            response.sendError(405, "Methodo not allowed");
        }
    }
    private void processSupplier(JSONObject file, HttpServletRequest request, HttpServletResponse response) throws Exception {
        if(request.getSession().getAttribute("users")== null){
            response.sendError(401, "Unauthorized: No session");
        } else if(request.getMethod().toLowerCase().equals("get")){
            file.put("list", new JSONArray(Supplier.getSuppliers()));  
        } else if(request.getMethod().toLowerCase().equals("post")){
            JSONObject body = getJSONBODY(request.getReader());
            String name = body.getString("name");
            String address = body.getString("address");
            String phone = body.getString("phone");
            String email = body.getString("email");
            String cnpj = body.getString("cnpj");
            Supplier.insertSupplier(name, address, phone, email, cnpj);         
        } else if(request.getMethod().toLowerCase().equals("put")){
            JSONObject body = getJSONBODY(request.getReader());
            String name = body.getString("name");
            String address = body.getString("address");
            String phone = body.getString("phone");
            String email = body.getString("email");
            String cnpj = body.getString("cnpj");
            Long id = Long.parseLong(request.getParameter("id"));
            Supplier.updateSupplier(id,name, address, phone, email, cnpj);         
        } else if(request.getMethod().toLowerCase().equals("delete")){
            Long id = Long.parseLong(request.getParameter("id"));
            Supplier.deleteSupplier(id);
        } else{
            response.sendError(405, "Method not allowed");
        }
    }
}
