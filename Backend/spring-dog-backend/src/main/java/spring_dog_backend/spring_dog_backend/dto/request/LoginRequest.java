package spring_dog_backend.spring_dog_backend.dto.request;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class LoginRequest {
    private String username;
    private String password;

    // Constructors
    public LoginRequest() {}

    @Override
    public String toString() {
        return "LoginRequest{username='" + username + "', password='[PROTECTED]'}";
    }
}

