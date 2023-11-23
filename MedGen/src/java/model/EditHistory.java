package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import web.AppListener;


public class EditHistory {
    private long rowid;
    private String modifiedName;
    private Date modifiedTime;
    private String modifiedMedicine;
    
    public static String getCreateStatement(){
        return "CREATE TABLE IF NOT EXISTS editHistory("
                + "nm_user varchar(100) not null,"
                + "dt_modified datetime not null,"
                + "nm_medicine varchar(100) not null"
                + ")";
    }
    
    public EditHistory(long rowid,String nameUser, Date modified, String nameMedicine) {
        this.rowid = rowid;
        this.modifiedName = nameUser;
        this.modifiedTime = modified;
        this.modifiedMedicine = nameMedicine;
    }
    // Getters e Setters
    public long getRowid() {
        return rowid;
    }

    public void setRowid(long rowid) {
        this.rowid = rowid;
    }
    public String getModifiedName() {
        return modifiedName;
    }

    public void setModifiedName(String modifiedName) {
        this.modifiedName = modifiedName;
    }

    public Date getModifiedTime() {
        return modifiedTime;
    }

    public void setModifiedTime(Date modifiedTime) {
        this.modifiedTime = modifiedTime;
    }

    public String getModifiedMedicine() {
        return modifiedMedicine;
    }

    public void setModifiedMedicine(String modifiedMedicine) {
        this.modifiedMedicine = modifiedMedicine;
    }

      public static ArrayList<EditHistory> getHistory() throws Exception{
        ArrayList<EditHistory> list = new ArrayList<>();
        Connection con = AppListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT rowid, * from editHistory");
        while(rs.next()){
            long rowId = rs.getLong("rowid");
            String user = rs.getString("nm_user");
            Date modified = rs.getDate("dt_modified");
            String medicine = rs.getString("nm_medicine");
            list.add(new EditHistory(rowId, user, modified, medicine));
        }
        rs.close();
        stmt.close();
        con.close(); 
        return list;
    }
    public static void insertHistory(String user, Date modified, String medicine) throws Exception{
        Connection con = AppListener.getConnection();
        String sql = "INSERT INTO editHistory(nm_user, dt_modified, nm_medicine)"
                + "VALUES(?,?,?)";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1,user);
        java.sql.Date sqlDate = new java.sql.Date(modified.getTime());
        stmt.setDate(2,sqlDate);
        stmt.setString(3,medicine);
        
        stmt.execute();
        stmt.close();
        con.close();       
    }
    
    public static void deleteHistory() throws Exception{
        Connection con = AppListener.getConnection();
        String sql = "DELETE FROM editHistory";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.execute();
        stmt.close();
        con.close();       
    }    
}