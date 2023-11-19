package model;

import java.sql.*;
import java.util.ArrayList;
import web.AppListener;

public class Users {
    private long rowid;
    private String name;
    private String login;
    private String role;
    private String passwordHash;
    
    // Função para criar a tabela de usuarios caso não exista
    public static String getCreateStatement(){
        return "CREATE TABLE IF NOT EXISTS users("
                + "login VARHCAR(50) UNIQUE NOT NULL,"
                + "name VARCHAR(200) NOT NULL,"
                + "role VARCHAR(20) NOT NULL,"
                + "password_hash VARCHAR NOT NULL"
                + ")";
    }
    
    // Função para resgatar os registros contido na tabela, retornando como um array de objetos
    public static ArrayList<Users> getUsers() throws Exception{
        ArrayList<Users> list = new ArrayList<>();
        Connection con = AppListener.getConnection();
        Statement stmt = con.createStatement();
        // Executando o SQL para resgatar todos os registros da tabela
        ResultSet rs = stmt.executeQuery("SELECT rowid, * from users");
        // Enquanto houver registros irá adicionar ao array o novo objeto contendo os dados do usuario
        while(rs.next()){
            long rowId = rs.getLong("rowid");
            String login = rs.getString("login");
            String name = rs.getString("name");
            String role = rs.getString("role");
            String passwordHash = rs.getString("password_hash");
            list.add(new Users(rowId, name, login, role, passwordHash));
        }
        rs.close();
        stmt.close();
        con.close(); 
        return list;
    }
    
    // getUsers para resgatar os dados do usuario logado recebendo como parametro o login e senha
    public static Users getUser(String login, String password) throws Exception{
        Users user = null;
        Connection con = AppListener.getConnection();
        // Buscando no banco o ID do usuario que corresponde ao login e senha
        String sql = "SELECT rowid, * from users WHERE login=? AND password_hash=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        // Setando as "?" como login e o password recebido como parametros
        stmt.setString(1,login);
        stmt.setString(2,AppListener.getMd5Hash(password));
        ResultSet rs = stmt.executeQuery();
        // Verificando se retornou um dado, se retornou cria um objeto com os dados do usuario
        if(rs.next()){
            long rowId = rs.getLong("rowid");
            String name = rs.getString("name");
            String role = rs.getString("role");
            String passwordHash = rs.getString("password_hash");
            user = new Users(rowId, name, login, role, passwordHash);
        }
        rs.close();
        stmt.close();
        con.close(); 
        return user;
    }
    
    // Função para inserir novos usuarios no banco
    public static void insertUser(String login, String name, String role, String password) throws Exception{
        Connection con = AppListener.getConnection();
        String sql = "INSERT INTO users(login, name, role, password_hash)"
                + "VALUES(?,?,?,?)";
        // Preparando a string de sql a ser executado e setando as "?" com os parametros
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1,login);
        stmt.setString(2,name);
        stmt.setString(3,role);
        stmt.setString(4,AppListener.getMd5Hash(password));
        stmt.execute();
        stmt.close();
        con.close();       
    }
    
    // Atualizar dados do usuario
    public static void updateUser(String login, String name, String role, String password) throws Exception{
        Connection con = AppListener.getConnection();
        // Identico ao insert com a diferença de que o login seja igual ao do usuario logado
        String sql = "UPDATE users SET name=?, role=?, password_hash=? WHERE login=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1,name);
        stmt.setString(2,role);
        stmt.setString(3,AppListener.getMd5Hash(password));
        stmt.setString(4,login);
        stmt.execute();
        stmt.close();
        con.close();       
    }
    
    // Função para deletar o usuario com o ID
    public static void deleteUser(long rowId) throws Exception{
        Connection con = AppListener.getConnection();
        // Deleta todos os dados do usuario que corresponde ao id do parametro
        String sql = "DELETE FROM users WHERE rowid=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setLong(1, rowId);
        stmt.execute();
        stmt.close();
        con.close();       
    }

    public Users(long rowid, String name, String login, String role, String passwordHash) {
        this.rowid = rowid;
        this.name = name;
        this.login = login;
        this.role = role;
        this.passwordHash = passwordHash;
    }

    public long getRowid() {
        return rowid;
    }

    public void setRowid(long rowid) {
        this.rowid = rowid;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }
    
    
}
