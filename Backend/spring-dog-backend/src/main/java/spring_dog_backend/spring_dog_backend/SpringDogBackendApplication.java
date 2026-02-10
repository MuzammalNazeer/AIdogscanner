package spring_dog_backend.spring_dog_backend;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.context.ServletWebServerInitializedEvent;
import org.springframework.context.annotation.Bean;
import org.springframework.context.event.EventListener;
import org.springframework.jdbc.core.JdbcTemplate;
import spring_dog_backend.spring_dog_backend.service.PredictionService;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.util.List;

@SpringBootApplication
public class SpringDogBackendApplication {

    public static void main(String[] args) {
        SpringApplication.run(SpringDogBackendApplication.class, args);
    }

    @EventListener
    public void onApplicationEvent(ServletWebServerInitializedEvent event) {
        int port = event.getWebServer().getPort();
        System.out.println(STR."\uD83D\uDE80 Spring Boot started on port: \{port}");
        System.out.println("🌐 Server is bound to all network interfaces (0.0.0.0)");
        System.out.println("🚀 Dog Breed Identification Backend Started!");
        System.out.println("📡 Health Check: http://localhost:" + port + "/api/v1/predict");
        System.out.println("📡 Health Check: http://localhost:" + port + "/api/v1/breeds");
        System.out.println("📡 Health Check: http://localhost:" + port + "/api/v1/health");
    }

    @Bean
    CommandLineRunner testData(JdbcTemplate jdbcTemplate, PredictionService service) {
        return args -> {
            try {
                assert jdbcTemplate.getDataSource() != null;
                try (Connection conn = jdbcTemplate.getDataSource().getConnection()) {
                    DatabaseMetaData meta = conn.getMetaData();
                    System.out.println("✅ Connected to Database!");
                    System.out.println("📦 URL: " + meta.getURL());
                    System.out.println("👤 User: " + meta.getUserName());
                    System.out.println("🧩 DB Product: " + meta.getDatabaseProductName());
                    System.out.println("🧩 DB Version: " + meta.getDatabaseProductVersion());

                    System.out.println("🔍 Testing DB connection successful / loaded breeds...");
                    List<String> breeds = service.getAllBreeds();
                    System.out.println("🐶 Total breeds fetched: " + breeds.size());
                    breeds.forEach(name -> System.out.println("🐶 Breed: " + name));
                }
            } catch (Exception e) {
                System.err.println("❌ Database connection failed: " + e.getMessage());
            }
        };
    }
}

//package spring_dog_backend.spring_dog_backend;
//
//import org.springframework.boot.CommandLineRunner;
//import org.springframework.boot.SpringApplication;
//import org.springframework.boot.autoconfigure.SpringBootApplication;
//import org.springframework.boot.web.servlet.context.ServletWebServerInitializedEvent;
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.event.EventListener;
//import org.springframework.jdbc.core.JdbcTemplate;
//import spring_dog_backend.spring_dog_backend.service.PredictionService;
//
//import java.sql.Connection;
//import java.sql.DatabaseMetaData;
//import java.util.List;
//
//@SpringBootApplication
//public class SpringDogBackendApplication {
//
//    // ✅ Correct entry point
//    public static void main(String[] args) {
//        SpringApplication.run(SpringDogBackendApplication.class, args);
//    }
//
//    // ✅ This runs when the embedded Tomcat server starts
//    @EventListener
//    public void onApplicationEvent(ServletWebServerInitializedEvent event) {
//        int port = event.getWebServer().getPort();
//        System.out.println("🚀 Spring Boot started on port: " + port);
//        System.out.println("🌐 Server is bound to all network interfaces (0.0.0.0)");
//        System.out.println("🚀 Dog Breed Identification Backend Started!");
//        System.out.println("📡 Health Check: http://localhost:" + port + "/api/v1/predict");
//        System.out.println("📡 Health Check: http://localhost:" + port + "/api/v1/breeds");
//        System.out.println("📡 Health Check: http://localhost:" + port + "/api/v1/health");
//        System.out.println("📡 Health Check: http://localhost:" + port + "/api/v1/cors-test");
//        System.out.println("📡 Health Check: http://localhost:" + port + "/api/v1/cors-headers");
//        System.out.println("📡 Health Check: http://localhost:" + port + "/api/auth/login");
//        System.out.println("📡 Health Check: http://localhost:" + port + "/api/auth/signup");
//    }
//
//
//    // ✅ Combined database testing that checks connection AND loads breeds
//    @Bean
//    CommandLineRunner testData(JdbcTemplate jdbcTemplate, PredictionService service) {
//        return args -> {
//            try {
//                assert jdbcTemplate.getDataSource() != null;
//                try (Connection conn = jdbcTemplate.getDataSource().getConnection()) {
//                    DatabaseMetaData meta = conn.getMetaData();
//                    System.out.println("✅ Connected to Database!");
//                    System.out.println("📦 URL: " + meta.getURL());
//                    System.out.println("👤 User: " + meta.getUserName());
//                    System.out.println("🧩 DB Product: " + meta.getDatabaseProductName());
//                    System.out.println("🧩 DB Version: " + meta.getDatabaseProductVersion());
//
//                    System.out.println("🔍 Testing DB connection successful / loaded breeds...");
//
//                    System.out.println("🔍 Fetching breeds from database...");
//                    service.getAllBreeds().forEach(name -> System.out.println("🐶 Breed: " + name));
//
//                    System.out.println("🔍 Fetching breeds from database again...");
//                    List<String> breeds = service.getAllBreeds();
//                    System.out.println("🐶 Total breeds fetched: " + breeds.size());
//                    breeds.forEach(name -> System.out.println("🐶 Breed: " + name));
//
//                }
//            } catch (Exception e) {
//                System.err.println("❌ Database connection failed: " + e.getMessage());
//            }
//        };
//    }
//
//
//}
//
//
////package spring_dog_backend.spring_dog_backend;
////
////import org.springframework.boot.CommandLineRunner;
////import org.springframework.boot.SpringApplication;
////import org.springframework.boot.autoconfigure.SpringBootApplication;
////import org.springframework.boot.web.servlet.context.ServletWebServerInitializedEvent;
////import org.springframework.context.annotation.Bean;
////import org.springframework.context.event.EventListener;
////import org.springframework.jdbc.core.JdbcTemplate;
////import spring_dog_backend.spring_dog_backend.service.PredictionService;
////
////import java.sql.Connection;
////import java.sql.DatabaseMetaData;
////import java.util.List;
////
////@SpringBootApplication
////public class SpringDogBackendApplication {
////
////    // ✅ Correct entry point
////    public static void main(String[] args) {
////        SpringApplication.run(SpringDogBackendApplication.class, args);
////    }
////
////    // ✅ This runs when the embedded Tomcat server starts
////    @EventListener
////    public void onApplicationEvent(ServletWebServerInitializedEvent event) {
////        int port = event.getWebServer().getPort();
////        System.out.println("🚀 Spring Boot started on port: " + port);
////        System.out.println("🌐 Server is bound to all network interfaces (0.0.0.0)");
////        System.out.println("🚀 Dog Breed Identification Backend Started!");
////        System.out.println("📡 Health Check: http://localhost:" + port + "/api/v1/predict");
////        System.out.println("📡 Health Check: http://localhost:" + port + "/api/v1/breeds");
////        System.out.println("📡 Health Check: http://localhost:" + port + "/api/v1/health");
////        System.out.println("📡 Health Check: http://localhost:" + port + "/api/v1/cors-test");
////        System.out.println("📡 Health Check: http://localhost:" + port + "/api/v1/cors-headers");
////        System.out.println("📡 Health Check: http://localhost:" + port + "/api/auth/login");
////        System.out.println("📡 Health Check: http://localhost:" + port + "/api/auth/signup");
////
////    }
////
////    // ✅ Check database connection and print sample breeds
////    @Bean
////    CommandLineRunner testDatabase(JdbcTemplate jdbcTemplate, PredictionService service) {
////        return args -> {
////            try (Connection conn = jdbcTemplate.getDataSource().getConnection()) {
////                DatabaseMetaData meta = conn.getMetaData();
////                System.out.println("✅ Connected to Database!");
////                System.out.println("📦 URL: " + meta.getURL());
////                System.out.println("👤 User: " + meta.getUserName());
////                System.out.println("🧩 DB Product: " + meta.getDatabaseProductName());
////                System.out.println("🧩 DB Version: " + meta.getDatabaseProductVersion());
////
////                System.out.println("🔍 Fetching breeds from database...");
////                service.getAllBreeds().forEach(name -> System.out.println("🐶 Breed: " + name));
////                System.out.println("🔍 Fetching breeds from database...");
////                List<String> breeds = service.getAllBreeds();
////                System.out.println("🐶 Total breeds fetched: " + breeds.size());
////                breeds.forEach(name -> System.out.println("🐶 Breed: " + name));
////
////
////            } catch (Exception e) {
////                System.err.println("❌ Database connection failed: " + e.getMessage());
////            }
////        };
////    }
////}
////
////
