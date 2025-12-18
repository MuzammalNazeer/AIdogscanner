package spring_dog_backend.spring_dog_backend.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.beans.factory.annotation.Autowired;
import spring_dog_backend.spring_dog_backend.security.JwtFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private JwtFilter jwtFilter;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        System.out.println(" Initializing Security Configuration...");

        http
                .csrf(AbstractHttpConfigurer::disable)
                .cors(cors -> {})
                .sessionManagement(sess -> sess.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(
                                "/api/auth/**",
                                "/api/v1/health",
                                "/api/v1/cors-test",
                                "/api/v1/predict",
                                "/api/v1/breeds",
                                "/api/v1/cors-headers",
                                "/api/auth/signup",
                                "/api/auth/login",
                                "/api/breeds/**",
                                "/api/pets/**",
                                "/api/reminders/**",
                                "/api/reminder-categories/**",
                                "/api/favorites/breeds/**",
                                "/api/hygiene-logs/**",
                                "/api/cleaning-logs/**",
                                "/api/medical-records**"

                        ).permitAll()
                        .anyRequest().authenticated()
                );

        http.addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);

        SecurityFilterChain chain = http.build();
        System.out.println("✅ Security Configuration Complete!");
        System.out.println("📋 Public endpoints configured for:");
        System.out.println("   - /api/breeds/**");
        System.out.println("   - /api/pets/**");
        System.out.println("   - /api/reminders/**");
        System.out.println("   - /api/reminder-categories/**");
        System.out.println("   - /api/favorites/breeds/**");
        System.out.println("   - /api/hygiene-logs**");
        System.out.println("   - /api/cleaning-logs**");

        return chain;
    }

    @Bean
    public AuthenticationManager authManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}


