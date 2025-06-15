package model;

import dto.User;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserModel {
    private final DataSource ds;

    public UserModel(DataSource ds) {
        this.ds = ds;
    }

    public boolean register(User user) {
        System.out.println(ds);
        String sql = "INSERT INTO users (username, password, full_name, email, role) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = ds.getConnection()) {
            PreparedStatement preparedStatement = conn.prepareStatement(sql);
            preparedStatement.setString(1, user.getUsername());
            preparedStatement.setString(2, user.getPassword());
            preparedStatement.setString(3, user.getFullName());
            preparedStatement.setString(4, user.getEmail());
            preparedStatement.setString(5, user.getRole());
            preparedStatement.executeUpdate();
            return preparedStatement.getUpdateCount() > 0;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public User login(String username, String password) {
        System.out.println(ds);
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        try (Connection conn = ds.getConnection()) {
            PreparedStatement preparedStatement = conn.prepareStatement(sql);
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, password);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return new User(
                        resultSet.getInt("id"),
                        resultSet.getString("username"),
                        resultSet.getString("password"),
                        resultSet.getString("full_name"),
                        resultSet.getString("email"),
                        resultSet.getString("role")
                );
            }
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
}
