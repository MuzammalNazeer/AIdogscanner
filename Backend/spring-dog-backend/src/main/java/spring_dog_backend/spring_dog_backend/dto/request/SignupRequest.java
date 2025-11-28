
package spring_dog_backend.spring_dog_backend.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class SignupRequest {

    @NotBlank(message = "Username is required")
    @Size(min = 3, max = 50, message = "Username must be between 3 and 50 characters")
    private String username;

    @NotBlank(message = "Email is required")
    @Email(message = "Email should be valid")
    private String email;

    @NotBlank(message = "Password is required")
    @Size(min = 6, max = 100, message = "Password must be between 6 and 100 characters")
    private String password;

    @NotBlank(message = "Full name is required")
    @Size(min = 2, max = 100, message = "Full name must be between 2 and 100 characters")
    private String fullname;

    // Default constructor
    public SignupRequest() {}

    @Override
    public String toString() {
        return STR."SignupRequest{username='\{username}', email='\{email}', password='[PROTECTED]', fullName='\{fullname}'}";
    }
}


//package spring_dog_backend.spring_dog_backend.dto.request;
//
//import jakarta.validation.constraints.Email;
//import jakarta.validation.constraints.NotBlank;
//import jakarta.validation.constraints.Size;
//import lombok.Getter;
//import lombok.Setter;
//
//@Setter
//@Getter
//public class SignupRequest {
//
//    @NotBlank(message = "Username is required")
//    @Size(min = 3, max = 20, message = "Username must be between 3 and 50 characters")
//    private String username;
//
//    @NotBlank(message = "Email is required")
//    @Email(message = "Email should be valid")
//    private String email;
//
//    @NotBlank(message = "Password is required")
//    @Size(min = 6, max = 20, message = "Password must be between 6 and 100 characters")
//    private String password;
//
//    @NotBlank(message = "Full name is required")
//    @Size(min = 2, max = 20, message = "Full name must be between 2 and 100 characters")
//    private String fullName;
//
//    // Constructors
//    public SignupRequest() {}
//    public String getFullName() {
//        return fullName != null ? fullName : "Default User";
//    }
//    @Override
//    public String toString() {
//        return STR."SignupRequest{username='\{username}', email='\{email}', password='[PROTECTED]', fullName='\{fullName}'}";
//    }
//}
//
////package spring_dog_backend.spring_dog_backend.dto.request;
////
////import lombok.Getter;
////import lombok.Setter;
////
////@Setter
////@Getter
////public class SignupRequest {
////    private String username;
////    private String email;
////    private String password;
////    private String fullName;
////
////    // Constructors
////    public SignupRequest() {}
////
////    @Override
////    public String toString() {
////        return STR."SignupRequest{username='\{username}', email='\{email}', password='[PROTECTED]', fullName='\{fullName}'}";
////    }
////}
////
//////package spring_dog_backend.spring_dog_backend.dto;
//////
//////import lombok.Getter;
//////import lombok.Setter;
//////
//////@Setter
//////@Getter
//////public class SignupRequest {
//////    // Getters and Setters
//////    private String username;
//////    private String email;
//////    private String password;
//////    private String fullName;
//////
//////    // Default constructor
//////    public SignupRequest() {}
//////
//////    // Constructor for login (username/password only)
//////    public SignupRequest(String username, String password) {
//////        this.username = username;
//////        this.password = password;
//////    }
//////
//////    // Constructor for registration (all fields)
//////    public SignupRequest(String username, String email, String password, String fullName) {
//////        this.username = username;
//////        this.email = email;
//////        this.password = password;
//////        this.fullName = fullName;
//////    }
//////
//////    @Override
//////    public String toString() {
//////        return STR."LoginRequest{username='\{username}', email='\{email}', password='[PROTECTED]', fullName='\{fullName}'}";
//////    }
//////}