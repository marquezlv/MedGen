package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import web.AppListener;

public class CheckOut {

    // Criando todas as variaveis para esta classe
    private long rowid;
    private String userName;
    private double price;
    private double priceTotal;
    private String medicineName;
    private int quantity;
    private Date checkOut;

    // Metodo para retornar o comando SQL de criação da tabela em banco
    public static String getCreateStatement() {
        return "CREATE TABLE IF NOT EXISTS checkOut("
                + "nm_user varchar(100) not null,"
                + "vl_medicine numeric(10,2) not null,"
                + "vl_total numeric(10,2) not null,"
                + "nm_medicine varchar(100) not null,"
                + "qt_total integer not null,"
                + "dt_checkOut datetime not null"
                + ")";
    }

    // Construtor com todos os atributos da classe
    public CheckOut(long rowid, String nameUser, double price, double priceTotal, String nameMedicine, int quantity, Date checkOut) {
        this.rowid = rowid;
        this.userName = nameUser;
        this.price = price;
        this.priceTotal = priceTotal;
        this.medicineName = nameMedicine;
        this.quantity = quantity;
        this.checkOut = checkOut;
    }

    // Metodo get para retornar uma lista de objeto da classe
    public static ArrayList<CheckOut> getCheckOuts() throws Exception {
        ArrayList<CheckOut> list = new ArrayList<>();
        Connection con = AppListener.getConnection();
        Statement stmt = con.createStatement();
        // Setar o resultado do comando sql na variavel rs
        ResultSet rs = stmt.executeQuery("SELECT rowid, * from checkOut");
        // Enquanto retornar resultado ele executa
        while (rs.next()) {
            // Pegando os valores contidos em cada coluna e armazenando em uma lista
            long rowId = rs.getLong("rowid");
            String user = rs.getString("nm_user");
            double price = rs.getDouble("vl_medicine");
            double priceTotal = rs.getDouble("vl_total");
            String medicine = rs.getString("nm_medicine");
            int quantity = rs.getInt("qt_total");
            Date checkOut = rs.getDate("dt_checkOut");
            list.add(new CheckOut(rowId, user, price, priceTotal, medicine, quantity, checkOut));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }

    // Metodo para inserir no banco
    public static void insertCheckOut(String user, double price, double priceTotal, String medicine, int quantity, Date checkOut) throws Exception {
        Connection con = AppListener.getConnection();
        // Comando sql para inserir os dados nas colunas da tabela
        String sql = "INSERT INTO checkOut(nm_user, vl_medicine, vl_total, nm_medicine, qt_total, dt_checkOut)"
                + "VALUES(?,?,?,?,?,?)";
        // Setando as variaveis "?" com os valores recebidos do parametro
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, user);
        stmt.setDouble(2, price);
        stmt.setDouble(3, priceTotal);
        stmt.setString(4, medicine);
        stmt.setInt(5, quantity);
        // Convertendo a data do java para a data do SQL aceito no banco
        java.sql.Date sqlDate = new java.sql.Date(checkOut.getTime());
        stmt.setDate(6, sqlDate);

        stmt.execute();
        stmt.close();
        con.close();
    }

    // Metodo para deletar TODOS os dados da tabela
    public static void deleteCheckOut() throws Exception {
        Connection con = AppListener.getConnection();
        // O metodo não deleta por ID e sim faz uma limpeza na tabela
        String sql = "DELETE FROM checkOut";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.execute();
        stmt.close();
        con.close();
    }

    // Getters e Setters
    public long getRowid() {
        return rowid;
    }

    public void setRowid(long rowid) {
        this.rowid = rowid;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getPriceTotal() {
        return priceTotal;
    }

    public void setPriceTotal(double priceTotal) {
        this.priceTotal = priceTotal;
    }

    public String getMedicineName() {
        return medicineName;
    }

    public void setMedicineName(String medicineName) {
        this.medicineName = medicineName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public void setCheckOut(Date checkOut) {
        this.checkOut = checkOut;
    }

    public Date getCheckOut() {
        return checkOut;
    }
}
