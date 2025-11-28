package spring_dog_backend.spring_dog_backend.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import javax.crypto.SecretKey;
import java.util.Date;

@Component
public class JwtUtil {
    private static final Logger logger = LoggerFactory.getLogger(JwtUtil.class);

    @Value("${app.jwt.secret:yourSuperSecretKeyThatIsLongEnoughForHS512AlgorithmSecurity}")
    private String jwtSecret;

    @Value("${app.jwt.expiration:86400000}") // 24 hours
    private int jwtExpirationMs;

    public String generateJwtToken(String username) {
        try {
            SecretKey key = getSigningKey();

            String token = Jwts.builder()
                    .setSubject(username)
                    .setIssuedAt(new Date())
                    .setExpiration(new Date((new Date()).getTime() + jwtExpirationMs))
                    .signWith(key, SignatureAlgorithm.HS256)
                    .compact();

            logger.info("✅ JWT Token generated for user: {}", username);
            return token;

        } catch (Exception e) {
            logger.error("❌ Error generating JWT token: {}", e.getMessage());
            throw new RuntimeException("Failed to generate JWT token", e);
        }
    }

    // Alias for backward compatibility
    public String generateTokenFromUsername(String username) {
        return generateJwtToken(username);
    }

    public String getUsernameFromJwtToken(String token) {
        try {
            SecretKey key = getSigningKey();
            return Jwts.parserBuilder()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(token)
                    .getBody()
                    .getSubject();
        } catch (Exception e) {
            logger.error("❌ Error extracting username from JWT: {}", e.getMessage());
            return null;
        }
    }

    public boolean validateJwtToken(String authToken) {
        try {
            SecretKey key = getSigningKey();
            Jwts.parserBuilder()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(authToken);
            logger.debug("✅ JWT Token is valid");
            return true;
        } catch (SecurityException e) {
            logger.error("❌ Invalid JWT signature: {}", e.getMessage());
        } catch (MalformedJwtException e) {
            logger.error("❌ Invalid JWT token: {}", e.getMessage());
        } catch (ExpiredJwtException e) {
            logger.error("❌ JWT token is expired: {}", e.getMessage());
        } catch (UnsupportedJwtException e) {
            logger.error("❌ JWT token is unsupported: {}", e.getMessage());
        } catch (IllegalArgumentException e) {
            logger.error("❌ JWT claims string is empty: {}", e.getMessage());
        }
        return false;
    }

    // Utility methods
    public String parseJwtFromHeader(String header) {
        if (StringUtils.hasText(header) && header.startsWith("Bearer ")) {
            return header.substring(7);
        }
        return null;
    }

    public boolean isTokenExpired(String token) {
        try {
            SecretKey key = getSigningKey();
            Date expiration = Jwts.parserBuilder()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(token)
                    .getBody()
                    .getExpiration();
            return expiration.before(new Date());
        } catch (Exception e) {
            return true;
        }
    }

    public Date getTokenIssuedAt(String token) {
        try {
            SecretKey key = getSigningKey();
            return Jwts.parserBuilder()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(token)
                    .getBody()
                    .getIssuedAt();
        } catch (Exception e) {
            return null;
        }
    }

    // Alias methods for compatibility
    public boolean validateToken(String token) {
        return validateJwtToken(token);
    }

    public String extractUsername(String token) {
        return getUsernameFromJwtToken(token);
    }

    private SecretKey getSigningKey() {
        byte[] keyBytes = jwtSecret.getBytes();
        return Keys.hmacShaKeyFor(keyBytes);
    }
}

//
//package spring_dog_backend.spring_dog_backend.security;
//
//import io.jsonwebtoken.*;
//import io.jsonwebtoken.security.Keys;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.security.core.Authentication;
//import org.springframework.stereotype.Component;
//
//import javax.crypto.SecretKey;
//import java.util.Date;
//
//@Component
//public class JwtUtil {
//    private static final Logger logger = LoggerFactory.getLogger(JwtUtil.class);
//
//    @Value("${app.jwt.secret:yourSuperSecretKeyThatIsLongEnoughForHS512AlgorithmSecurity}")
//    private String jwtSecret;
//
//    @Value("${app.jwt.expiration:86400000}")
//    private int jwtExpirationMs;
//
//    // ✅ METHOD 1: Accepts Authentication object
//// In JwtUtil class
//    public String generateJwtToken(String username) {
//        try {
//            SecretKey key = getSigningKey();
//
//            String token = Jwts.builder()
//                    .setSubject(username)
//                    .setIssuedAt(new Date())
//                    .setExpiration(new Date((new Date()).getTime() + jwtExpirationMs))
//                    .signWith(key, SignatureAlgorithm.HS256)
//                    .compact();
//
//            logger.info("✅ JWT Token generated for user: {}", username);
//            return token;
//
//        } catch (Exception e) {
//            logger.error("❌ Error generating JWT token: {}", e.getMessage());
//            throw new RuntimeException("Failed to generate JWT token", e);
//        }
//    }
//    // ✅ METHOD 2: Also keep the String version for backward compatibility
//    public String generateTokenFromUsername(String username) {
//        try {
//            SecretKey key = getSigningKey();
//
//            String token = Jwts.builder()
//                    .setSubject(username)
//                    .setIssuedAt(new Date())
//                    .setExpiration(new Date((new Date()).getTime() + jwtExpirationMs))
//                    .signWith(key, SignatureAlgorithm.HS256)
//                    .compact();
//
//            logger.info("✅ JWT Token generated from username: {}", username);
//            return token;
//
//        } catch (Exception e) {
//            logger.error("❌ Error generating JWT token from username: {}", e.getMessage());
//            throw new RuntimeException("Failed to generate JWT token", e);
//        }
//    }
//
//    public String getUsernameFromJwtToken(String token) {
//        try {
//            SecretKey key = getSigningKey();
//
//            return Jwts.parserBuilder()
//                    .setSigningKey(key)
//                    .build()
//                    .parseClaimsJws(token)
//                    .getBody()
//                    .getSubject();
//
//        } catch (Exception e) {
//            logger.error("❌ Error extracting username from JWT: {}", e.getMessage());
//            return null;
//        }
//    }
//
//    public boolean validateJwtToken(String authToken) {
//        try {
//            SecretKey key = getSigningKey();
//            Jwts.parserBuilder()
//                    .setSigningKey(key)
//                    .build()
//                    .parseClaimsJws(authToken);
//
//            logger.debug("✅ JWT Token is valid");
//            return true;
//
//        } catch (SecurityException e) {
//            logger.error("❌ Invalid JWT signature: {}", e.getMessage());
//        } catch (MalformedJwtException e) {
//            logger.error("❌ Invalid JWT token: {}", e.getMessage());
//        } catch (ExpiredJwtException e) {
//            logger.error("❌ JWT token is expired: {}", e.getMessage());
//        } catch (UnsupportedJwtException e) {
//            logger.error("❌ JWT token is unsupported: {}", e.getMessage());
//        } catch (IllegalArgumentException e) {
//            logger.error("❌ JWT claims string is empty: {}", e.getMessage());
//        }
//
//        return false;
//    }
//
//    // Alias methods for compatibility
//    public boolean validateToken(String token) {
//        return validateJwtToken(token);
//    }
//
//    public String extractUsername(String token) {
//        return getUsernameFromJwtToken(token);
//    }
//
//    private SecretKey getSigningKey() {
//        byte[] keyBytes = jwtSecret.getBytes();
//        return Keys.hmacShaKeyFor(keyBytes);
//    }
//}
