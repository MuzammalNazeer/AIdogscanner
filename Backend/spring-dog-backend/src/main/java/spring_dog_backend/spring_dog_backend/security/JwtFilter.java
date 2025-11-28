package spring_dog_backend.spring_dog_backend.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.jetbrains.annotations.NotNull;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;
import spring_dog_backend.spring_dog_backend.model.User;
import spring_dog_backend.spring_dog_backend.repository.UserRepository;

import java.io.IOException;

@Component
public class JwtFilter extends OncePerRequestFilter {

    private static final Logger logger = LoggerFactory.getLogger(JwtFilter.class);

    private final JwtUtil jwtUtil;
    private final UserRepository userRepository;

    public JwtFilter(JwtUtil jwtUtil, UserRepository userRepository) {
        this.jwtUtil = jwtUtil;
        this.userRepository = userRepository;
        logger.info("✅ JwtFilter initialized with constructor injection");
    }

    @Override
    protected void doFilterInternal(@NotNull HttpServletRequest request,
                                    @NotNull HttpServletResponse response,
                                    @NotNull FilterChain filterChain) throws ServletException, IOException {
        try {
            String jwt = parseJwt(request);
            if (jwt != null && jwtUtil.validateJwtToken(jwt)) {
                String username = jwtUtil.getUsernameFromJwtToken(jwt);

                logger.info("🔍 JWT Filter - Valid token for user: {}", username);

                // Load your actual User entity
                User user = userRepository.findByUsername(username)
                        .orElseThrow(() -> new RuntimeException("User not found: " + username));

                logger.info("✅ Loaded User entity: {} (ID: {})", user.getUsername(), user.getId());

                // ✅ CRITICAL FIX: Use your actual User entity as the principal
                // NOT the Spring Security User builder
                UsernamePasswordAuthenticationToken authentication =
                        new UsernamePasswordAuthenticationToken(user, null, user.getAuthorities());
                authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                SecurityContextHolder.getContext().setAuthentication(authentication);

                logger.info("✅ Authentication set with User entity principal for: {}", username);
            }
        } catch (Exception e) {
            logger.error("❌ Cannot set user authentication: {}", e.getMessage());
        }

        filterChain.doFilter(request, response);
    }

    private String parseJwt(HttpServletRequest request) {
        String headerAuth = request.getHeader("Authorization");
        if (StringUtils.hasText(headerAuth) && headerAuth.startsWith("Bearer ")) {
            return headerAuth.substring(7);
        }
        return null;
    }

    // Optional: Add method to skip public endpoints
    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getServletPath();
        return path.startsWith("/api/auth/") ||
                path.startsWith("/h2-console/") ||
                path.equals("/error");
    }
}

//package spring_dog_backend.spring_dog_backend.security;
//
//import jakarta.servlet.FilterChain;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import org.jetbrains.annotations.NotNull;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
//import org.springframework.security.core.context.SecurityContextHolder;
//import org.springframework.security.core.userdetails.UserDetails;
//import org.springframework.security.core.userdetails.UsernameNotFoundException;
//import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
//import org.springframework.stereotype.Component;
//import org.springframework.util.StringUtils;
//import org.springframework.web.filter.OncePerRequestFilter;
//import spring_dog_backend.spring_dog_backend.model.User;
//import spring_dog_backend.spring_dog_backend.repository.UserRepository;
//
//import java.io.IOException;
//
//@Component
//public class JwtFilter extends OncePerRequestFilter {
//
//    private static final Logger logger = LoggerFactory.getLogger(JwtFilter.class);
//
//    private final JwtUtil jwtUtil;
//    private final UserRepository userRepository;
//
//    // ✅ Use constructor injection
//    public JwtFilter(JwtUtil jwtUtil, UserRepository userRepository) {
//        this.jwtUtil = jwtUtil;
//        this.userRepository = userRepository;
//        logger.info("✅ JwtFilter initialized with constructor injection");
//    }
//
//    @Override
//    protected void doFilterInternal(@NotNull HttpServletRequest request,
//                                    @NotNull HttpServletResponse response,
//                                    @NotNull FilterChain filterChain) throws ServletException, IOException {
//        try {
//            String jwt = parseJwt(request);
//            if (jwt != null && jwtUtil.validateJwtToken(jwt)) {
//                String username = jwtUtil.getUsernameFromJwtToken(jwt);
//
//                logger.info("🔍 JWT Filter - Valid token for user: {}", username);
//
//                User user = userRepository.findByUsername(username)
//                        .orElseThrow(() -> new UsernameNotFoundException("User not found: " + username));
//
//                UserDetails userDetails = org.springframework.security.core.userdetails.User.builder()
//                        .username(user.getUsername())
//                        .password(user.getPassword())
//                        .authorities(user.getAuthorities())
//                        .build();
//
//                UsernamePasswordAuthenticationToken authentication =
//                        new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
//                authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
//
//                SecurityContextHolder.getContext().setAuthentication(authentication);
//
//                logger.info("✅ Authentication set for user: {}", username);
//            }
//        } catch (Exception e) {
//            logger.error("❌ Cannot set user authentication: {}", e.getMessage());
//        }
//
//        filterChain.doFilter(request, response);
//    }
//
//    private String parseJwt(HttpServletRequest request) {
//        String headerAuth = request.getHeader("Authorization");
//        if (StringUtils.hasText(headerAuth) && headerAuth.startsWith("Bearer ")) {
//            return headerAuth.substring(7);
//        }
//        return null;
//    }
//}
//
////package spring_dog_backend.spring_dog_backend.security;
////
////import spring_dog_backend.spring_dog_backend.model.User;
////import spring_dog_backend.spring_dog_backend.repository.UserRepository;
////import jakarta.servlet.FilterChain;
////import jakarta.servlet.ServletException;
////import jakarta.servlet.http.HttpServletRequest;
////import jakarta.servlet.http.HttpServletResponse;
////import org.springframework.beans.factory.annotation.Autowired;
////import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
////import org.springframework.security.core.authority.SimpleGrantedAuthority;
////import org.springframework.security.core.context.SecurityContextHolder;
////import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
////import org.springframework.stereotype.Component;
////import org.springframework.util.StringUtils;
////import org.springframework.web.filter.OncePerRequestFilter;
////
////import java.io.IOException;
////import java.util.Collections;
////
////@Component
////public class JwtFilter extends OncePerRequestFilter {
////
////    @Autowired
////    private JwtUtil jwtUtil;
////
////    @Autowired
////    private UserRepository userRepository;
////
////    @Override
////    protected void doFilterInternal(HttpServletRequest request,
////                                    HttpServletResponse response,
////                                    FilterChain filterChain) throws ServletException, IOException {
////
////        String path = request.getServletPath();
////        String method = request.getMethod();
////
////        System.out.println("🔍 JWT Filter - " + method + " " + path);
////
////        // Skip JWT validation for public endpoints
////        if (isPublicEndpoint(path)) {
////            System.out.println("✅ Skipping JWT validation for public endpoint: " + path);
////            filterChain.doFilter(request, response);
////            return;
////        }
////
////        System.out.println("🔒 JWT validation required for: " + path);
////
////        try {
////            // Extract JWT token from Authorization header
////            String jwt = parseJwt(request);
////
////            if (jwt == null) {
////                System.out.println("❌ No JWT token found in request");
////                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "JWT token is missing");
////                return;
////            }
////
////            System.out.println("🔑 JWT Token found, validating...");
////
////            // Validate JWT token
////            if (!jwtUtil.validateJwtToken(jwt)) {
////                System.out.println("❌ JWT token validation failed");
////                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Invalid JWT token");
////                return;
////            }
////
////            // Extract username from JWT token
////            String username = jwtUtil.getUsernameFromJwtToken(jwt);
////            if (username == null) {
////                System.out.println("❌ Could not extract username from JWT token");
////                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Invalid JWT token");
////                return;
////            }
////
////            System.out.println("✅ JWT Token valid for user: " + username);
////
////            // Load user from database
////            User user = userRepository.findByUsername(username)
////                    .orElseThrow(() -> {
////                        System.out.println("❌ User not found in database: " + username);
////                        return new RuntimeException("User not found: " + username);
////                    });
////
////            System.out.println("✅ User found in database: " + user.getUsername());
////
////            // Create authentication object
////            UsernamePasswordAuthenticationToken authentication =
////                    new UsernamePasswordAuthenticationToken(
////                            user,
////                            null,
////                            Collections.singletonList(new SimpleGrantedAuthority("ROLE_USER"))
////                    );
////
////            authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
////
////            // Set authentication in SecurityContext
////            SecurityContextHolder.getContext().setAuthentication(authentication);
////
////            System.out.println("✅ Authentication set in SecurityContext for user: " + username);
////
////        } catch (Exception e) {
////            System.out.println("🚨 JWT Filter error: " + e.getMessage());
////            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Authentication failed: " + e.getMessage());
////            return;
////        }
////
////        // Continue with the filter chain
////        filterChain.doFilter(request, response);
////    }
////
////    private String parseJwt(HttpServletRequest request) {
////        String headerAuth = request.getHeader("Authorization");
////
////        if (StringUtils.hasText(headerAuth) && headerAuth.startsWith("Bearer ")) {
////            String token = headerAuth.substring(7);
////            System.out.println("📨 Extracted JWT Token: " + token.substring(0, Math.min(20, token.length())) + "...");
////            return token;
////        }
////
////        System.out.println("📭 No Authorization header found or malformed");
////        return null;
////    }
////
////    private boolean isPublicEndpoint(String path) {
////        return path.startsWith("/api/auth/") ||
////                path.startsWith("/api/v1/") ||
////                path.startsWith("/api/breeds/") ||
////                path.startsWith("/api/pets/") ||
////                path.startsWith("/api/reminders/") ||
////                path.startsWith("/api/reminder-categories/") ||
////                path.equals("/error") ||
////                path.startsWith("/h2-console/");
////    }
////
////    @Override
////    protected boolean shouldNotFilter(HttpServletRequest request) {
////        String path = request.getServletPath();
////        return isPublicEndpoint(path);
////    }
////}
