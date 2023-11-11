package model;

import java.util.Date;

public class Medicine {
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
    public Medicine(String name, String category, int quantity, double price, Date validity) {
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
    
    
}

