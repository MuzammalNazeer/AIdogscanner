package spring_dog_backend.spring_dog_backend.dto.response;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AuthResponse {
    // Getters and Setters
    private String token;
    private String type = "Bearer";
    private UserResponse user;

    // Constructors
    public AuthResponse() {}

    public AuthResponse(String token, UserResponse user) {
        this.token = token;
        this.user = user;
    }

}