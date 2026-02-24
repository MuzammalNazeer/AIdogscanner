package spring_dog_backend.spring_dog_backend.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class LoginRequest {
    @JsonProperty("usernameOremail")  
    private String usernameOremail;
    private String password;

    // Constructors
    public LoginRequest() {}

    @Override
    public String toString() {
        return "LoginRequest{username='" + usernameOremail + "', password='[PROTECTED]'}";
    }
}

