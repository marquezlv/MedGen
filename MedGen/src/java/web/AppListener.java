package web;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.Date;
import model.Medicine;
import model.Users;

@WebListener
public class AppListener implements ServletContextListener{
    public static final String CLASS_NAME = "org.sqlite.JDBC";
    public static final String URL = "jdbc:sqlite:medgen.db";
    public static String initializeLog = "";
    public static Exception exception = null;

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        ServletContextListener.super.contextDestroyed(sce);
    }

    // Inicialização do servlet
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContextListener.super.contextInitialized(sce);
        try{
            // Preparando a conexao e execução de comandos SQL
            Connection c = AppListener.getConnection();
            Statement s = c.createStatement();
            // Deixando pronto execução de delete de todos os dados caso necessario
            // s.execute("DELETE FROM users");
            // s.execute("DELETE FROM medicine");
            // Dando feedback no log
            initializeLog += new Date() + ": Initializing database creation;";
            initializeLog += "Creating Users table if not exists...";
            s.execute(Users.getCreateStatement());
            // Adicionando admin de teste caso necessario
            // initializeLog += "Adding admin...";
            // Users.insertUser("admin", "Administrador", "ADMIN", "1234");
            // initializeLog += "Admin added; ";
            initializeLog += "Done; ";
            initializeLog += "Creating Medicine table if not exists...";
            s.execute(Medicine.getCreateStatement());
            initializeLog += "Done.";            
            s.close();
            c.close();
        } catch(Exception ex){
            
        }
    }
    // Função para gerar a senha em Hash
    public static String getMd5Hash(String text) throws NoSuchAlgorithmException{
        MessageDigest m = MessageDigest.getInstance("MD5");
        m.update(text.getBytes(), 0, text.length());
        return new BigInteger(1, m.digest()).toString();
    }
    
    // Criação do banco de dados local definada no inicio
    public static Connection getConnection() throws Exception{
        Class.forName(CLASS_NAME);
        return DriverManager.getConnection(URL);
    }
    
}
