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

//package spring_dog_backend.spring_dog_backend.dto;
//
//import lombok.Getter;
//import lombok.Setter;
//
//@Getter
//@Setter
//public class LoginRequest {
//    // Getters and Setters
//    private String username;
//    private String password;
//
//    // Constructors
//    public LoginRequest() {}
//
//    public LoginRequest(String username, String password) {
//        this.username = username;
//        this.password = password;
//    }
//
//    @Override
//    public String toString() {
//        return STR."LoginRequest{username='\{username}', password='[PROTECTED]'}";
//    }
//}