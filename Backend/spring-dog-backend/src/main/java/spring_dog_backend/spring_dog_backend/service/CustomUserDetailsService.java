package spring_dog_backend.spring_dog_backend.service;

import spring_dog_backend.spring_dog_backend.model.User;
import spring_dog_backend.spring_dog_backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.*;
import org.springframework.stereotype.Service;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired private UserRepository repo;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = repo.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + username));
        return org.springframework.security.core.userdetails.User.builder()
                .username(String.valueOf(user.getUsername()))
                .password(user.getPassword())
                .roles("USER")
                .build();
    }
}
