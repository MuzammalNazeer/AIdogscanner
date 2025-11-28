package spring_dog_backend.spring_dog_backend.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;

@Entity
@Table(name = "users")
@Getter
@Setter
public class User implements UserDetails {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String username;

    @Column(unique = true, nullable = false)
    private String email;

    @Column(name = "password", nullable = false)
    private String password;

    @Column(name = "full_name", nullable = false) // This is critical
    private String fullName;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Constructors
    public User() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public User(String username, String email, String password, String fullName) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    public void setUpdatedAt() {
        this.updatedAt = LocalDateTime.now();
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of();
    }
}

//package spring_dog_backend.spring_dog_backend.model;
//
//import jakarta.persistence.*;
//import lombok.Setter;
//import org.springframework.security.core.Authentication;
//
//import java.time.LocalDateTime;
//
//@Entity
//@Table(name = "users")
//public class User {
//    @Setter
//    @Id
//    @GeneratedValue(strategy = GenerationType.IDENTITY)
//    private Long id;
//
//    @Setter
//    @Column(unique = true, nullable = false)
//    private String username;
//
//    @Setter
//    @Column(unique = true, nullable = false)
//    private String email;
//    @Setter
//    @Column(name = "password", nullable = false)
//    private String password;
//
//    @Setter
//    @Column(name = "full_name")
//    private String fullName;
//
//    @Setter
//    @Column(name = "created_at")
//    private LocalDateTime createdAt;
//
//    @Column(name = "updated_at")
//    private LocalDateTime updatedAt;
//
//    // Constructors
//    public User() {
//        this.createdAt = LocalDateTime.now();
//        this.updatedAt = LocalDateTime.now();
//    }
//
//    public User(String username, String email, String password, String fullName) {
//        this.username = username;
//        this.email = email;
//        this.password = password;
//        this.fullName = fullName;
//        this.createdAt = LocalDateTime.now();
//        this.updatedAt = LocalDateTime.now();
//    }
//
//    // Getters and Setters
//    public Long getId() { return id; }
//
//    public String getUsername() { return username; }
//
//    public String getEmail() { return email; }
//
//    public String getPassword() { return password; }
//
//    public String getFullName() { return fullName; }
//
//    public LocalDateTime getCreatedAt() { return createdAt; }
//
//    public LocalDateTime getUpdatedAt() { return updatedAt; }
//    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
//
//    @PreUpdate
//    public void setUpdatedAt() {
//        this.updatedAt = LocalDateTime.now();
//    }
//}
//
