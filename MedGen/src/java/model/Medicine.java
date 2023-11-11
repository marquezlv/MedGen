package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import web.AppListener;

public class Medicine {
    private long rowid;
    private String name;
    private String category;
    private int quantity;
    private double price;
    private Date validity;
    
    // SQL para criar a tabela dentro do banco de dados caso não exista
    public static String getCreateStatement(){
        return "CREATE TABLE IF NOT EXISTS medicine("
                + "nm_medicine varchar(100) not null,"
                + "nm_category varchar(100),"
                + "qt_medicine integer not null,"
                + "vl_medicine numeric(10,2) not null,"
                + "dt_validity datetime not null"
                + ")";
    }
    
    
    // Construtor com todos atributos
    public Medicine(long rowid,String name, String category, int quantity, double price, Date validity) {
        this.rowid = rowid;
        this.name = name;
        this.category = category;
        this.quantity = quantity;
        this.price = price;
        this.validity = validity;
    }
    // Getters e Setters
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public Date getValidity() {
        return validity;
    }

    public void setValidity(Date validity) {
        this.validity = validity;
    }
    
    // Função para resgatar os registros contido na tabela, retornando como um array de objetos, porém para Medicine
      public static ArrayList<Medicine> getMedicine() throws Exception{
        ArrayList<Medicine> list = new ArrayList<>();
        Connection con = AppListener.getConnection();
        Statement stmt = con.createStatement();
        // Executando o SQL para resgatar todos os registros da tabela
        ResultSet rs = stmt.executeQuery("SELECT rowid, * from medicine");
        // Enquanto houver registros irá adicionar ao array o novo objeto contendo os dados de medicamentos
        while(rs.next()){
            long rowId = rs.getLong("rowid");
            String name = rs.getString("name");
            String category = rs.getString("category");
            int quantity = rs.getInt("quantity");
            double price = rs.getDouble("price");
            Date validity = rs.getDate("validity");
            list.add(new Medicine(rowId, name, category, quantity, price, validity));
        }
        rs.close();
        stmt.close();
        con.close(); 
        return list;
    }
      // getMedicine para resgatar um medicamento seguindo seu ID
    public static Medicine getMedicine(long rowid) throws Exception{
        Medicine medicine = null;
        Connection con = AppListener.getConnection();
        // Buscando no banco o ID do medicamento que corresponde ao medicamento desejado
        String sql = "SELECT * from medicine WHERE rowid=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        // Setando o "?" como o rowid recebido
        stmt.setLong(1,rowid);
        ResultSet rs = stmt.executeQuery();
        // Verificando se retornou um dado, se retornou cria um objeto com os dados do medicamento
        if(rs.next()){
            long rowId = rs.getLong("rowid");
            String name = rs.getString("name");
            String category = rs.getString("category");
            int quantity = rs.getInt("quantity");
            double price = rs.getDouble("price");
            Date validity = rs.getDate("validity");
            medicine = new Medicine(rowId, name, category, quantity, price, validity);
        }
        rs.close();
        stmt.close();
        con.close(); 
        return medicine;
    }
    
    // Função para inserir novos medicamentos no banco
    public static void insertMedicine(String name, String category, int quantity, double price, Date validity) throws Exception{
        Connection con = AppListener.getConnection();
        String sql = "INSERT INTO medicine(name, category, quantity, price, validity)"
                + "VALUES(?,?,?,?,?)";
        // Preparando a string de sql a ser executado e setando as "?" com os parametros
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1,name);
        stmt.setString(2,category);
        stmt.setInt(3,quantity);
        stmt.setDouble(4,price);
        stmt.setDate(5, (java.sql.Date) validity);
        stmt.execute();
        stmt.close();
        con.close();       
    }
    
    // Atualizar dados do medicamento
    public static void updateMedicine(String name, String category, int quantity, double price, Date validity) throws Exception{
        Connection con = AppListener.getConnection();
        // Identico ao insert com a diferença de que o login seja igual ao do usuario logado
        String sql = "UPDATE users SET name=?, category=?, quantity=?, price=?, validity=? WHERE rowid=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1,name);
        stmt.setString(2,category);
        stmt.setInt(3,quantity);
        stmt.setDouble(4,price);
        stmt.setDate(5, (java.sql.Date) validity);
        stmt.execute();
        stmt.close();
        con.close();       
    }
    
    // Função para deletar o medicamento com o ID
    public static void deleteMedicine(long rowId) throws Exception{
        Connection con = AppListener.getConnection();
        // Deleta todos os dados do medicamento que corresponde ao ID do parametro
        String sql = "DELETE FROM medicine WHERE rowid=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setLong(1, rowId);
        stmt.execute();
        stmt.close();
        con.close();       
    }
    

     
}

