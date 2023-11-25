package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import web.AppListener;

public class Supplier {
    private long rowid;
    private String name;
    private String address;
    private String phone;
    private String email;
    private String cnpj;
 
    // Criação da tabela caso não exista 
    public static String getCreateStatement(){
            return "CREATE TABLE IF NOT EXISTS supplier("
                    + "nm_supplier VARCHAR(200) NOT NULL,"
                    + "nm_address VARCHAR(255) NOT NULL,"
                    + "nm_phone VARCHAR(15) NOT NULL,"
                    + "nm_email VARCHAR(255) NOT NULL,"
                    + "nm_cnpj varchar(255) NOT NULL"
                    + ")";
    }
    
    // Construtor
    public Supplier(long rowid, String name, String address, String phone, String email, String cnpj) {
        this.rowid = rowid;
        this.name = name;
        this.address = address;
        this.phone = phone;
        this.email = email;
        this.cnpj = cnpj;
    }
    // Getters e Setters
    public long getRowid(){
    return rowid;
}
    public void setRowid(long rowid){
    this.rowid = rowid;
    }
    public String getName(){
    return name;
    }
    public void setName(String name){
    this.name = name;
    }
    public String getAddress(){
    return address;
    }
    public void setAddress(String address){
    this.address = address;
    }
    public String getPhone(){
    return phone;
    }
    public void setPhone(String phone){
    this.phone = phone;
    }
    public String getEmail(){
    return email;
    }
    public void setEmail(String email){
    this.email = email;
    }
    public String getCnpj(){
    return cnpj;
    }
    public void setCnpj(String cnpj){
    this.cnpj = cnpj;
    }
    
    // Retornar array de objetos
    public static ArrayList<Supplier> getSuppliers() throws Exception{
        ArrayList<Supplier> list = new ArrayList<>();
        Connection con = AppListener.getConnection();
        Statement stmt = con.createStatement();
        // Executar SQL
        ResultSet rs = stmt.executeQuery("SELECT rowid, * from supplier");
        while(rs.next()){
            long rowId = rs.getLong("rowid");
            String name = rs.getString("nm_supplier");
            String address = rs.getString("nm_address");
            String phone = rs.getString("nm_phone");
            String email = rs.getString("nm_email");
            String cnpj = rs.getString("nm_cnpj");
            list.add(new Supplier(rowId, name, address, phone, email, cnpj));
        }
        rs.close();
        stmt.close();
        con.close(); 
        return list;
    }
     // getMedicine para resgatar um fornecedor seguindo seu ID
    public static Supplier getSupplier(long rowid) throws Exception{
        Supplier supplier = null;
        Connection con = AppListener.getConnection();
        // Buscando no banco o ID do fornecedor correspondente
        String sql = "SELECT * from supplier WHERE rowid=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        // Setando o "?" como o rowid recebido
        stmt.setLong(1,rowid);
        ResultSet rs = stmt.executeQuery();
        // Verificando se retornou um dado, se retornou cria um objeto com os dados do fornecedor
        if(rs.next()){
            long rowId = rs.getLong("rowid");
            String name = rs.getString("nm_supplier");
            String address = rs.getString("nm_address");
            String phone = rs.getString("nm_phone");
            String email = rs.getString("nm_email");
            String cnpj = rs.getString("nm_cnpj");
            supplier = new Supplier(rowId, name, address, phone, email, cnpj);
        }
        rs.close();
        stmt.close();
        con.close(); 
        return supplier;
    }
     // Função para inserir novos fornecedores no banco
    public static void insertSupplier(String name, String address, String phone, String email, String cnpj) throws Exception{
        Connection con = AppListener.getConnection();
        String sql = "INSERT INTO supplier(nm_supplier, nm_address, nm_phone, nm_email, nm_cnpj)"
                + "VALUES(?,?,?,?,?)";
        // Preparando a string de sql a ser executado e setando as "?" com os parametros
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1,name);
        stmt.setString(2,address);
        stmt.setString(3,phone);
        stmt.setString(4,email);
        stmt.setString(5,cnpj);      
        stmt.execute();
        stmt.close();
        con.close();       
    }
     // Atualizar dados do fornecedor
    public static void updateSupplier(long id,String name, String address, String phone, String email, String cnpj) throws Exception{
        Connection con = AppListener.getConnection();
        // Identico ao insert
        String sql = "UPDATE supplier SET nm_supplier=?, nm_address=?, nm_phone=?, nm_email=?, nm_cnpj=? WHERE rowid=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1,name);
        stmt.setString(2,address);
        stmt.setString(3,phone);
        stmt.setString(4,email);
        stmt.setString(5,cnpj);    
        stmt.setLong(6,id);
        stmt.execute();
        stmt.close();
        con.close();       
    }
    public static void deleteSupplier(long rowId) throws Exception{
        Connection con = AppListener.getConnection();
        // Deleta todos os dados do fornecedor que corresponde ao ID do parametro
        String sql = "DELETE FROM supplier WHERE rowid=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setLong(1, rowId);
        stmt.execute();
        stmt.close();
        con.close();
    }
}