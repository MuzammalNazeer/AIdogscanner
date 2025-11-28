package spring_dog_backend.spring_dog_backend.dto.response;

public class LoginResponse {
    private String username;
    private String email;
    private String fullName;
    private String token; // Optional JWT

    public LoginResponse(String username, String email, String fullName, String token) {
        this.username = username;
        this.email = email;
        this.fullName = fullName;
        this.token = token;
    }

    // Getters & Setters
    public String getUsername() { return username; }
    public String getEmail() { return email; }
    public String getFullName() { return fullName; }
    public String getToken() { return token; }
}
