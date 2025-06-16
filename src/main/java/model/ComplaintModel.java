package model;

import dto.Complaint;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ComplaintModel {
    private DataSource ds;

    public ComplaintModel(DataSource dataSource) {
        this.ds = dataSource;
    }

    public List<Complaint> getAllComplaints() throws SQLException {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT * FROM complaints ORDER BY created_at DESC";
        String query = "select username from users where id = ?";

        try (Connection conn = ds.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            System.out.println("Executing query: " + sql);

            while (rs.next()) {
                Complaint c = new Complaint();
                c.setId(rs.getInt("id"));
                c.setTitle(rs.getString("title"));
                c.setDescription(rs.getString("description"));
                c.setCategory(rs.getString("category"));
                c.setPriority(rs.getString("priority"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                c.setStatus(rs.getString("status"));
                c.setAdminRemarks(rs.getString("admin_remarks")); // Add this line

                try (PreparedStatement preparedStatement = conn.prepareStatement(query)) {
                    preparedStatement.setInt(1, rs.getInt("submitted_by"));
                    ResultSet rs2 = preparedStatement.executeQuery();
                    while (rs2.next()) {
                        c.setSubmitterName(rs2.getString("username"));
                    }
                }
                complaints.add(c);
            }
            System.out.println("Found " + complaints.size() + " complaints");
        } catch (SQLException e) {
            System.err.println("Database error: " + e.getMessage());
            throw e;
        }

        return complaints;
    }

    public boolean saveComplaint(Complaint complaint) throws SQLException {
        String sql = "INSERT INTO complaints (title, description, category, status, priority,submitted_by,assigned_to,admin_remarks) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = ds.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            System.out.println(complaint.getSubmittedBy());
            stmt.setString(1, complaint.getTitle());
            stmt.setString(2, complaint.getDescription());
            stmt.setString(3, complaint.getCategory());
            stmt.setString(4, complaint.getStatus().toUpperCase());
            stmt.setString(5, complaint.getPriority());
            stmt.setInt(6, complaint.getSubmittedBy());
            stmt.setInt(7, complaint.getSubmittedBy());
            stmt.setString(8, complaint.getAdminRemarks());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean complaintExists(int complaintId) {
        String sql = "SELECT COUNT(*) FROM complaints WHERE id = ?";

        try (Connection conn = ds.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, complaintId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("Complaint exists check for ID " + complaintId + ": " + (count > 0));
                return count > 0;
            }
            return false;

        } catch (Exception e) {
            System.err.println("Error checking complaint existence: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteComplain(int complaintId) {
        String sql = "DELETE FROM complaints WHERE id = ?";
        try (Connection conn = ds.getConnection()) {
            PreparedStatement preparedStatement = conn.prepareStatement(sql);
            preparedStatement.setInt(1, complaintId);
            return preparedStatement.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error checking complaint existence: " + e.getMessage());
            throw new RuntimeException(e);
        }
    }

    public boolean updateComplaintStatus(int complaintId, String newStatus) throws SQLException {
        String sql = "UPDATE complaints SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";

        try (Connection conn = ds.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, newStatus.toUpperCase());
            stmt.setInt(2, complaintId);

            int rowsAffected = stmt.executeUpdate();
            System.out.println("Updated complaint " + complaintId + " status to " + newStatus +
                    ". Rows affected: " + rowsAffected);

            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating complaint status: " + e.getMessage());
            throw e;
        }
    }

    public boolean updateAdminRemarks(int complaintId, String remarks) throws SQLException {
        String sql = "UPDATE complaints SET admin_remarks = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";

        try (Connection conn = ds.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, remarks);
            stmt.setInt(2, complaintId);

            int rowsAffected = stmt.executeUpdate();
            System.out.println("Updated admin remarks for complaint " + complaintId +
                    ". Rows affected: " + rowsAffected);

            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating admin remarks: " + e.getMessage());
            throw e;
        }
    }

    public List<Complaint> getAllComplaintsById(Integer employeeId) {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT * FROM complaints WHERE submitted_by = ? ORDER BY created_at DESC";
        String query = "select username from users where id = ?";

        try (Connection conn = ds.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, employeeId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Complaint c = new Complaint();
                c.setId(rs.getInt("id"));
                c.setTitle(rs.getString("title"));
                c.setDescription(rs.getString("description"));
                c.setCategory(rs.getString("category"));
                c.setPriority(rs.getString("priority"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                c.setStatus(rs.getString("status"));
                c.setAdminRemarks(rs.getString("admin_remarks"));

                try (PreparedStatement preparedStatement = conn.prepareStatement(query)) {
                    preparedStatement.setInt(1, rs.getInt("submitted_by"));
                    ResultSet rs2 = preparedStatement.executeQuery();
                    while (rs2.next()) {
                        c.setSubmitterName(rs2.getString("username"));
                    }
                }
                complaints.add(c);
            }
        } catch (SQLException e) {
            System.err.println("Error loading complaints for employee ID " + employeeId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return complaints;
    }

    public boolean updateComplaint(Complaint complaint) throws SQLException {
        String sql = "UPDATE complaints SET title = ?, description = ?, category = ?, priority = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";

        try (Connection conn = ds.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, complaint.getTitle());
            stmt.setString(2, complaint.getDescription());
            stmt.setString(3, complaint.getCategory());
            stmt.setString(4, complaint.getPriority());
            stmt.setInt(5, complaint.getId());

            int rowsAffected = stmt.executeUpdate();
            System.out.println("Updated complaint " + complaint.getId() +
                    ". Rows affected: " + rowsAffected);

            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating complaint: " + e.getMessage());
            throw e;
        }
    }
}
