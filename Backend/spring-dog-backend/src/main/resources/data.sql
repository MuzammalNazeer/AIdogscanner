-- =============================================================================
-- COMPLETE PET CARE MANAGEMENT DATABASE - FULLY CORRECTED VERSION
-- =============================================================================

-- Create Database
DROP DATABASE IF EXISTS petcare_management;
CREATE DATABASE petcare_management;
USE petcare_management;

-- =============================================================================
-- TABLE CREATION
-- =============================================================================

-- 1. Core Tables
CREATE TABLE users (
                       id INT PRIMARY KEY AUTO_INCREMENT,
                       username VARCHAR(50) UNIQUE NOT NULL,
                       email VARCHAR(100) UNIQUE NOT NULL,
                       password_hash VARCHAR(255) NOT NULL,
                       full_name VARCHAR(100),
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS breeds (
                                      id INT PRIMARY KEY AUTO_INCREMENT,
                                      name VARCHAR(100) NOT NULL,
    size VARCHAR(50),
    weight VARCHAR(50),
    height VARCHAR(50),
    age VARCHAR(50),
    coat VARCHAR(100),
    color VARCHAR(100),
    headFace VARCHAR(255),
    body VARCHAR(255),
    purpose VARCHAR(255),
    temperament JSON,   -- store nested temperament as JSON
    image_url TEXT
    );


CREATE TABLE scan_history (
                              id INT PRIMARY KEY AUTO_INCREMENT,
                              user_id INT NOT NULL,
                              scan_id INT NOT NULL,
                              image_type ENUM('camera', 'gallery') NOT NULL,
                              scan_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              is_saved BOOLEAN DEFAULT TRUE,
                              FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE scan_results (
                              id INT PRIMARY KEY AUTO_INCREMENT,
                              scan_id INT NOT NULL,
                              breed_id INT NOT NULL,
                              confidence DECIMAL(5,4) NOT NULL,
                              is_primary BOOLEAN DEFAULT FALSE,
                              FOREIGN KEY (scan_id) REFERENCES scan_history(id) ON DELETE CASCADE,
                              FOREIGN KEY (breed_id) REFERENCES breeds(id) ON DELETE CASCADE,
                              UNIQUE KEY unique_scan_breed (scan_id, breed_id)
);

CREATE TABLE favourite_breeds (
                                  id INT PRIMARY KEY AUTO_INCREMENT,
                                  user_id INT NOT NULL,
                                  breed_id INT NOT NULL,
                                  added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                  notes TEXT,
                                  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                                  FOREIGN KEY (breed_id) REFERENCES breeds(id) ON DELETE CASCADE,
                                  UNIQUE KEY unique_user_favourite (user_id, breed_id)
);

-- 2. Pet Profile Management
CREATE TABLE pets (
                      id INT PRIMARY KEY AUTO_INCREMENT,
                      user_id INT NOT NULL,
                      name VARCHAR(100) NOT NULL,
                      species ENUM('Dog', 'Cat', 'Bird', 'Rabbit', 'Other') NOT NULL,
                      breed_id INT,
                      custom_breed VARCHAR(100),
                      birth_date DATE,
                      adoption_date DATE,
                      gender ENUM('Male', 'Female', 'Unknown'),
                      weight DECIMAL(6,2),
                      weight_unit ENUM('kg', 'lbs') DEFAULT 'kg',
                      color VARCHAR(100),
                      health_notes TEXT,
                      behavior_notes TEXT,
                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                      FOREIGN KEY (breed_id) REFERENCES breeds(id) ON DELETE SET NULL
);

CREATE TABLE pet_photos (
                            id INT PRIMARY KEY AUTO_INCREMENT,
                            pet_id INT NOT NULL,
                            caption VARCHAR(200),
                            taken_date DATE,
                            is_profile_picture BOOLEAN DEFAULT FALSE,
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                            FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE
);

-- 3. Unified Reminder System
CREATE TABLE reminder_categories (
                                     id INT PRIMARY KEY AUTO_INCREMENT,
                                     category_name VARCHAR(50) UNIQUE NOT NULL,
                                     color VARCHAR(20),
                                     description TEXT
);

CREATE TABLE reminders (
                           id INT PRIMARY KEY AUTO_INCREMENT,
                           pet_id INT NOT NULL,
                           category_id INT NOT NULL,
                           subcategory VARCHAR(100),
                           title VARCHAR(200) NOT NULL,
                           description TEXT,
                           due_datetime DATETIME NOT NULL,
                           repeat_pattern ENUM('none', 'daily', 'weekly', 'monthly', 'yearly') DEFAULT 'none',
                           repeat_interval INT DEFAULT 1,
                           priority ENUM('low', 'medium', 'high', 'critical') DEFAULT 'medium',
                           is_completed BOOLEAN DEFAULT FALSE,
                           completed_at DATETIME,
                           notes TEXT,
                           custom_data JSON,
                           created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                           FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE,
                           FOREIGN KEY (category_id) REFERENCES reminder_categories(id) ON DELETE CASCADE
);

-- 4. Hygiene Management
CREATE TABLE hygiene_logs (
                              id INT PRIMARY KEY AUTO_INCREMENT,
                              pet_id INT NOT NULL,
                              activity_type ENUM('bath', 'grooming', 'ears_cleaning', 'teeth_brushing', 'nail_clipping') NOT NULL,
                              performed_at DATETIME NOT NULL,
                              duration_minutes INT,
                              products_used JSON,
                              tools_used JSON,
                              notes TEXT,
                              next_recommended_date DATE,
                              cost DECIMAL(8,2),
                              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE
);

-- 5. Cleaning Management
CREATE TABLE cleaning_logs (
                               id INT PRIMARY KEY AUTO_INCREMENT,
                               pet_id INT NOT NULL,
                               item_type ENUM('food_bowl', 'water_bowl', 'bed', 'toys', 'water_fountain',
                  'leash_collar', 'litter_box', 'scratching_post', 'cage') NOT NULL,
                               cleaned_at DATETIME NOT NULL,
                               cleaning_method VARCHAR(100),
                               cleaning_products JSON,
                               notes TEXT,
                               next_due_date DATE,
                               created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE
);

-- 6. Activities & Exercise
CREATE TABLE activity_logs (
                               id INT PRIMARY KEY AUTO_INCREMENT,
                               pet_id INT NOT NULL,
                               activity_type ENUM('walking', 'training', 'play_time', 'socialization', 'rest') NOT NULL,
                               started_at DATETIME NOT NULL,
                               ended_at DATETIME,
                               duration_minutes INT,
                               calories_burned INT,
                               distance_km DECIMAL(6,2),
                               location VARCHAR(200),
                               gps_track JSON,
                               participants JSON,
                               toys_used JSON,
                               training_type VARCHAR(100),
                               training_notes TEXT,
                               progress_rating INT,
                               mood_rating INT,
                               notes TEXT,
                               created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE
);

-- 7. Medical Records
CREATE TABLE medical_records (
                                 id INT PRIMARY KEY AUTO_INCREMENT,
                                 pet_id INT NOT NULL,
                                 record_type ENUM('vaccination', 'medication', 'deworming', 'allergy',
                    'surgery', 'injury', 'chronic_condition') NOT NULL,
                                 subtype VARCHAR(100),
                                 title VARCHAR(200) NOT NULL,
                                 administered_date DATE NOT NULL,
                                 next_due_date DATE,
                                 veterinarian VARCHAR(100),
                                 clinic_name VARCHAR(200),
                                 dosage VARCHAR(100),
                                 medication_name VARCHAR(100),
                                 frequency VARCHAR(50),
                                 duration VARCHAR(50),
                                 notes TEXT,
                                 cost DECIMAL(8,2),
                                 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                 FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE
);

-- 8. Vet Visits
CREATE TABLE vet_visits (
                            id INT PRIMARY KEY AUTO_INCREMENT,
                            pet_id INT NOT NULL,
                            clinic_name VARCHAR(200) NOT NULL,
                            visit_date DATETIME NOT NULL,
                            purpose VARCHAR(200) NOT NULL,
                            veterinarian VARCHAR(100),
                            diagnosis TEXT,
                            treatment TEXT,
                            prescriptions JSON,
                            weight_kg DECIMAL(5,2),
                            temperature_celsius DECIMAL(4,2),
                            notes TEXT,
                            follow_up_date DATE,
                            cost DECIMAL(8,2),
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                            FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE
);

-- 9. Feeding & Nutrition
CREATE TABLE feeding_schedule (
                                  id INT PRIMARY KEY AUTO_INCREMENT,
                                  pet_id INT NOT NULL,
                                  meal_type ENUM('breakfast', 'lunch', 'dinner', 'snack') NOT NULL,
                                  scheduled_time TIME NOT NULL,
                                  food_type VARCHAR(100),
                                  brand VARCHAR(100),
                                  quantity DECIMAL(6,2),
                                  quantity_unit VARCHAR(20),
                                  nutritional_info JSON,
                                  is_active BOOLEAN DEFAULT TRUE,
                                  notes TEXT,
                                  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                  FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE
);

CREATE TABLE feeding_logs (
                              id INT PRIMARY KEY AUTO_INCREMENT,
                              pet_id INT NOT NULL,
                              schedule_id INT,
                              fed_at DATETIME NOT NULL,
                              food_type VARCHAR(100),
                              brand VARCHAR(100),
                              quantity DECIMAL(6,2),
                              quantity_unit VARCHAR(20),
                              ate_all BOOLEAN,
                              leftovers_percent INT,
                              water_intake_ml INT,
                              notes TEXT,
                              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE,
                              FOREIGN KEY (schedule_id) REFERENCES feeding_schedule(id) ON DELETE SET NULL
);

-- 10. Appointments & Bookings
CREATE TABLE appointments (
                              id INT PRIMARY KEY AUTO_INCREMENT,
                              pet_id INT NOT NULL,
                              appointment_type ENUM('grooming', 'vet', 'boarding', 'daycare', 'training') NOT NULL,
                              business_name VARCHAR(200) NOT NULL,
                              scheduled_datetime DATETIME NOT NULL,
                              duration_minutes INT,
                              purpose VARCHAR(200),
                              address TEXT,
                              contact_phone VARCHAR(20),
                              contact_email VARCHAR(100),
                              notes TEXT,
                              status ENUM('scheduled', 'confirmed', 'completed', 'cancelled', 'no_show') DEFAULT 'scheduled',
                              cost_estimate DECIMAL(8,2),
                              actual_cost DECIMAL(8,2),
                              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE
);

-- 11. General Notes & Attachments
CREATE TABLE general_notes (
                               id INT PRIMARY KEY AUTO_INCREMENT,
                               pet_id INT NOT NULL,
                               category VARCHAR(50),
                               title VARCHAR(200) NOT NULL,
                               content TEXT,
                               is_important BOOLEAN DEFAULT FALSE,
                               created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                               FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE
);

-- =============================================================================
-- CORRECTED INSERT STATEMENTS
-- =============================================================================

-- 1. Insert Users
INSERT IGNORE INTO users (username, email, password_hash, full_name) VALUES
('john_doe', 'john@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'John Doe'),
('jane_smith', 'jane@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Jane Smith'),
('mike_wilson', 'mike@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Mike Wilson');

-- 2. Insert Breeds
INSERT INTO breeds
(name, size, weight, height, age, coat, color, headFace, body, purpose, temperament, image_url)
VALUES
    (
        'Airedale',
        'Large',
        '20-30 kg',
        '56-61 cm',
        '10-13 years',
        'Wiry, dense, harsh',
        'Tan with black or grizzle saddle',
        'Long flat skull, small dark eyes',
        'Square proportion, muscular',
        'Hunting, versatile working dog',
        '{
            "Energy Level": "High",
            "Trainability": "Intelligent but independent",
            "Social Behavior": "Friendly, courageous",
            "Family Compatibility": "Excellent",
            "Child Friendliness": "Good"
        }',
        NULL
    );


-- 3. Insert Scan History
INSERT IGNORE INTO scan_history (user_id, scan_id, image_type, scan_timestamp, is_saved) VALUES
(1, 1001, 'camera', '2024-01-15 10:30:00', 1),
(1, 1002, 'gallery', '2024-01-16 14:20:00', 1),
(2, 1003, 'camera', '2024-01-17 09:15:00', 1),
(1, 1004, 'gallery', '2024-01-18 16:45:00', 0);

-- 4. Insert Scan Results
INSERT IGNORE INTO scan_results (scan_id, breed_id, confidence, is_primary) VALUES
(1, 1, 0.92, 1), (1, 2, 0.07, 0), (1, 3, 0.01, 0),
(2, 2, 0.85, 1), (2, 1, 0.12, 0), (2, 3, 0.03, 0),
(3, 4, 0.96, 1), (3, 1, 0.03, 0), (3, 2, 0.01, 0),
(4, 3, 0.78, 1), (4, 1, 0.15, 0), (4, 2, 0.07, 0);

-- 5. Insert Favorite Breeds
INSERT IGNORE INTO favourite_breeds (user_id, breed_id, notes) VALUES
(1, 1, 'My dream dog!'),
(1, 2, 'Family friendly breed'),
(2, 4, 'Love their blue eyes'),
(3, 3, 'Smart and protective');

-- 6. Insert Pets
INSERT IGNORE INTO pets (user_id, name, species, breed_id, birth_date, adoption_date, gender, weight, weight_unit, color, health_notes, behavior_notes) VALUES
(1, 'Buddy', 'Dog', 1, '2020-05-15', '2020-07-20', 'Male', 28.5, 'kg', 'Golden', 'Healthy, no issues', 'Friendly and energetic'),
(1, 'Max', 'Dog', 2, '2021-08-10', '2021-10-15', 'Male', 32.0, 'kg', 'Black', 'Allergy to chicken', 'Very active and playful'),
(2, 'Luna', 'Cat', 4, '2019-03-20', '2019-05-10', 'Female', 4.2, 'kg', 'Seal Point', 'Indoor cat, vaccinated', 'Vocal and affectionate'),
(3, 'Bella', 'Dog', 3, '2022-01-12', '2022-03-18', 'Female', 22.0, 'kg', 'Black/Tan', 'Healthy, all shots current', 'Protective and loyal');

-- 7. Insert Pet Photos
INSERT IGNORE INTO pet_photos (pet_id, caption, taken_date, is_profile_picture) VALUES
(1, 'Buddy at the park', '2024-01-10', 1),
(1, 'Sleeping buddy', '2024-01-12', 0),
(2, 'Max playing fetch', '2024-01-11', 1),
(2, 'Max with favorite toy', '2024-01-13', 0),
(3, 'Luna being cute', '2024-01-09', 1),
(4, 'Bella on guard', '2024-01-14', 1);

-- 8. Insert Reminder Categories
INSERT IGNORE INTO reminder_categories (category_name, color, description) VALUES
('Hygiene', '#4CAF50', 'Pet grooming and cleanliness reminders'),
('Cleaning', '#FF9800', 'Pet item cleaning and maintenance'),
('Activities', '#2196F3', 'Exercise and play activities'),
('Medical', '#F44336', 'Medical and health-related reminders'),
('Food', '#FF5722', 'Feeding schedule and nutrition'),
('Vet Visits', '#9C27B0', 'Veterinary appointments'),
('Booking', '#673AB7', 'Grooming and service bookings'),
('Others', '#607D8B', 'General pet care reminders');

-- 9. Insert Reminders
INSERT IGNORE INTO reminders (pet_id, category_id, subcategory, title, description, due_datetime, repeat_pattern, priority, custom_data) VALUES
(1, 4, 'Vaccination', 'Rabies Booster', 'Annual rabies vaccination due', '2024-02-15 10:00:00', 'yearly', 'high', '{"vaccine_type": "Rabies", "clinic": "City Vet"}'),
(1, 1, 'Bath', 'Monthly Bath', 'Regular grooming bath', '2024-01-25 14:00:00', 'monthly', 'medium', '{"shampoo": "Oatmeal", "duration": 30}'),
(2, 5, 'Feeding', 'Evening Meal', 'Dinner time', '2024-01-20 18:00:00', 'daily', 'medium', '{"food_type": "Dry", "quantity": "2 cups"}'),
(1, 3, 'Walking', 'Morning Walk', 'Daily exercise walk', '2024-01-19 07:30:00', 'daily', 'medium', '{"duration": 45, "route": "Park"}'),
(3, 4, 'Deworming', 'Flea Treatment', 'Monthly flea prevention', '2024-01-22 09:00:00', 'monthly', 'high', '{"product": "Frontline", "type": "Spot-on"}'),
(4, 6, 'Checkup', 'Annual Health Check', 'Complete physical examination', '2024-03-10 09:00:00', 'yearly', 'high', '{"clinic": "Animal Hospital", "tests": ["blood", "urine"]}');

-- 10. Insert Hygiene Logs
INSERT IGNORE INTO hygiene_logs (pet_id, activity_type, performed_at, duration_minutes, products_used, tools_used, notes, next_recommended_date, cost) VALUES
(1, 'bath', '2024-01-10 15:30:00', 45, '["Oatmeal Shampoo", "Conditioner"]', '["Brush", "Towels"]', 'Used oatmeal shampoo for sensitive skin', '2024-02-10', 0),
(1, 'nail_clipping', '2024-01-12 10:00:00', 15, '["Styptic Powder"]', '["Nail Clippers"]', 'Trimmed all nails carefully', '2024-02-12', 0),
(2, 'grooming', '2024-01-11 11:00:00', 60, '["Detangling Spray"]', '["Brush", "Comb"]', 'Full grooming session', '2024-02-11', 0),
(3, 'teeth_brushing', '2024-01-13 16:00:00', 10, '["Cat Toothpaste"]', '["Finger Brush"]', 'Teeth brushing session', '2024-01-27', 0);

-- 11. Insert Cleaning Logs
INSERT IGNORE INTO cleaning_logs (pet_id, item_type, cleaned_at, cleaning_method, cleaning_products, notes, next_due_date) VALUES
(1, 'food_bowl', '2024-01-18 08:00:00', 'Dishwasher', '["Dish Soap"]', 'Daily cleaning', '2024-01-19'),
(1, 'bed', '2024-01-15 14:00:00', 'Washing Machine', '["Laundry Detergent"]', 'Weekly bedding wash', '2024-01-29'),
(2, 'toys', '2024-01-17 16:30:00', 'Hand Wash', '["Pet-safe Disinfectant"]', 'Toy disinfection', '2024-01-24'),
(3, 'litter_box', '2024-01-16 10:00:00', 'Scrub and Replace', '["Litter Box Deodorizer"]', 'Complete litter change', '2024-01-17'),
(4, 'water_fountain', '2024-01-14 09:00:00', 'Vinegar Solution', '["Vinegar", "Water"]', 'Filter cleaning', '2024-01-28');

-- 12. Insert Activity Logs
INSERT IGNORE INTO activity_logs (pet_id, activity_type, started_at, ended_at, duration_minutes, calories_burned, distance_km, location, toys_used, training_type, progress_rating, mood_rating, notes) VALUES
(1, 'walking', '2024-01-18 07:00:00', '2024-01-18 07:45:00', 45, 180, 3.2, 'Central Park', '["Leash", "Collar"]', NULL, 4, 5, 'Morning walk with owner'),
(1, 'training', '2024-01-17 18:00:00', '2024-01-17 18:30:00', 30, 90, 0, 'Backyard', '["Treats", "Clicker"]', 'Obedience', 4, 4, 'Basic obedience training'),
(2, 'play_time', '2024-01-18 15:00:00', '2024-01-18 15:30:00', 30, 120, 0, 'Living Room', '["Ball", "Rope Toy"]', NULL, 5, 5, 'Play session with toys'),
(3, 'socialization', '2024-01-16 10:00:00', '2024-01-16 11:30:00', 90, 200, 0, 'Cat Cafe', '["Feather Toy"]', NULL, 4, 4, 'Played with other cats'),
(4, 'training', '2024-01-15 09:00:00', '2024-01-15 09:45:00', 45, 150, 0, 'Training Center', '["Treats", "Agility Equipment"]', 'Agility', 3, 4, 'Agility training session');

-- 13. Insert Medical Records
INSERT IGNORE INTO medical_records (pet_id, record_type, subtype, title, administered_date, next_due_date, veterinarian, clinic_name, dosage, medication_name, frequency, notes, cost) VALUES
(1, 'vaccination', 'Rabies', 'Rabies Vaccine', '2023-02-15', '2024-02-15', 'Dr. Smith', 'City Animal Hospital', '1 mL', 'Rabies Vaccine', 'Yearly', 'Annual rabies booster', 85.00),
(1, 'deworming', 'Internal', 'Heartworm Prevention', '2024-01-01', '2024-02-01', 'Dr. Smith', 'City Animal Hospital', '1 tablet', 'Heartgard', 'Monthly', 'Heartworm prevention', 25.00),
(2, 'vaccination', 'DHPP', 'Distemper Vaccine', '2023-11-20', '2024-11-20', 'Dr. Johnson', 'Paws & Claws Clinic', '1 mL', 'DHPP Vaccine', 'Yearly', 'Core vaccination', 75.00),
(3, 'medication', 'Antibiotic', 'Ear Infection Treatment', '2024-01-10', NULL, 'Dr. Wilson', 'Animal Care Center', '250mg twice daily', 'Amoxicillin', 'Daily for 10 days', 'Ear infection treatment', 45.50),
(4, 'deworming', 'External', 'Flea Treatment', '2024-01-05', '2024-02-05', 'Dr. Brown', 'Vet Clinic', 'Spot-on application', 'Frontline', 'Monthly', 'Flea and tick prevention', 35.00);

-- 14. Insert Vet Visits
INSERT IGNORE INTO vet_visits (pet_id, clinic_name, visit_date, purpose, veterinarian, diagnosis, treatment, weight_kg, temperature_celsius, notes, cost) VALUES
(1, 'City Animal Hospital', '2024-01-15 10:00:00', 'Annual Checkup', 'Dr. Smith', 'Healthy', 'Routine examination and vaccination', 28.5, 38.2, 'Pet in excellent health', 120.00),
(2, 'Paws & Claws Clinic', '2024-01-12 14:30:00', 'Vaccination', 'Dr. Johnson', 'Up to date on vaccines', 'Rabies and DHPP vaccines', 32.0, 38.1, 'All vaccinations current', 95.00),
(3, 'Animal Care Center', '2024-01-08 11:00:00', 'Ear Infection', 'Dr. Wilson', 'Otitis externa', 'Antibiotics and ear cleaner', 4.2, 38.5, 'Ear infection cleared after treatment', 75.50),
(4, 'German Shepherd Specialists', '2024-01-05 09:00:00', 'Hip Check', 'Dr. Brown', 'Good hip condition', 'X-rays and physical examination', 22.0, 38.3, 'No signs of hip dysplasia', 150.00);

-- 15. Insert Feeding Schedule
INSERT IGNORE INTO feeding_schedule (pet_id, meal_type, scheduled_time, food_type, brand, quantity, quantity_unit, nutritional_info, notes) VALUES
(1, 'breakfast', '07:00:00', 'Dry Food', 'Premium Dog Food', 1.5, 'cups', '{"calories": 350, "protein": "25%", "fat": "15%"}', 'Morning meal'),
(1, 'dinner', '18:00:00', 'Dry Food', 'Premium Dog Food', 1.5, 'cups', '{"calories": 350, "protein": "25%", "fat": "15%"}', 'Evening meal'),
(2, 'breakfast', '07:30:00', 'Wet Food', 'Gourmet Canine', 2, 'cans', '{"calories": 400, "protein": "30%", "fat": "12%"}', 'Special diet for allergies'),
(2, 'dinner', '18:30:00', 'Wet Food', 'Gourmet Canine', 2, 'cans', '{"calories": 400, "protein": "30%", "fat": "12%"}', 'Evening meal'),
(3, 'breakfast', '08:00:00', 'Dry Food', 'Premium Cat Food', 0.5, 'cups', '{"calories": 200, "protein": "35%", "fat": "18%"}', 'Indoor cat formula'),
(3, 'dinner', '19:00:00', 'Dry Food', 'Premium Cat Food', 0.5, 'cups', '{"calories": 200, "protein": "35%", "fat": "18%"}', 'Evening meal');

-- 16. Insert Feeding Logs
INSERT IGNORE INTO feeding_logs (pet_id, schedule_id, fed_at, food_type, brand, quantity, quantity_unit, ate_all, leftovers_percent, water_intake_ml, notes) VALUES
(1, 1, '2024-01-18 07:05:00', 'Dry Food', 'Premium Dog Food', 1.5, 'cups', 1, 0, 300, 'Ate all food quickly'),
(1, 2, '2024-01-17 18:10:00', 'Dry Food', 'Premium Dog Food', 1.5, 'cups', 1, 0, 350, 'Good appetite'),
(2, 3, '2024-01-18 07:35:00', 'Wet Food', 'Gourmet Canine', 2, 'cans', 1, 0, 400, 'Finished entire meal'),
(2, 4, '2024-01-17 18:40:00', 'Wet Food', 'Gourmet Canine', 2, 'cans', 0, 20, 380, 'Left some food, not very hungry'),
(3, 5, '2024-01-18 08:05:00', 'Dry Food', 'Premium Cat Food', 0.5, 'cups', 1, 0, 200, 'Ate normally'),
(3, 6, '2024-01-17 19:10:00', 'Dry Food', 'Premium Cat Food', 0.5, 'cups', 1, 0, 180, 'Good appetite');

-- 17. Insert Appointments
INSERT IGNORE INTO appointments (pet_id, appointment_type, business_name, scheduled_datetime, duration_minutes, purpose, address, contact_phone, status, cost_estimate) VALUES
(1, 'grooming', 'Pawsome Groomers', '2024-01-25 14:00:00', 120, 'Full grooming session', '123 Main St, City', '555-0101', 'scheduled', 60.00),
(2, 'vet', 'City Animal Hospital', '2024-02-01 10:30:00', 30, 'Vaccination booster', '456 Oak Ave, City', '555-0102', 'scheduled', 85.00),
(3, 'boarding', 'Happy Tails Boarding', '2024-01-20 08:00:00', 2880, 'Weekend boarding', '789 Pine Rd, City', '555-0103', 'completed', 120.00),
(4, 'training', 'K9 Training Center', '2024-01-22 09:00:00', 60, 'Obedience training', '321 Elm St, City', '555-0104', 'confirmed', 75.00);

-- 18. Insert General Notes
INSERT IGNORE INTO general_notes (pet_id, category, title, content, is_important) VALUES
(1, 'Behavior', 'Training Progress', 'Buddy has been responding well to sit and stay commands. Needs more work on recall training.', 1),
(1, 'Health', 'Allergy Notes', 'Shows signs of seasonal allergies in spring. Monitor for itching and sneezing.', 1),
(2, 'Preferences', 'Favorite Toys', 'Loves rubber balls and rope toys. Dislikes squeaky toys.', 0),
(3, 'Behavior', 'Socialization', 'Gets along well with other cats but nervous around dogs.', 0),
(4, 'Training', 'Agility Progress', 'Showing great potential in agility training. Excellent at jumps but needs work on weave poles.', 1);



-- =============================================================================
-- COMPLETE TABLE DATA VIEWING - ALL TABLES
-- =============================================================================

-- 1. Core User Tables
SELECT '=== 1. USERS ===' as '';
SELECT * FROM users;

SELECT '=== 2. BREEDS ===' as '';
SELECT * FROM breeds;

SELECT '=== 3. SCAN HISTORY ===' as '';
SELECT * FROM scan_history;

SELECT '=== 4. SCAN RESULTS ===' as '';
SELECT * FROM scan_results;

SELECT '=== 5. FAVOURITE BREEDS ===' as '';
SELECT * FROM favourite_breeds;

-- 2. Pet Profile Management
SELECT '=== 6. PETS ===' as '';
SELECT * FROM pets;

SELECT '=== 7. PET PHOTOS ===' as '';
SELECT * FROM pet_photos;

-- 3. Reminder System
SELECT '=== 8. REMINDER CATEGORIES ===' as '';
SELECT * FROM reminder_categories;

SELECT '=== 9. REMINDERS ===' as '';
SELECT * FROM reminders;

-- 4. Hygiene & Cleaning
SELECT '=== 10. HYGIENE LOGS ===' as '';
SELECT * FROM hygiene_logs;

SELECT '=== 11. CLEANING LOGS ===' as '';
SELECT * FROM cleaning_logs;

-- 5. Activities
SELECT '=== 12. ACTIVITY LOGS ===' as '';
SELECT * FROM activity_logs;

-- 6. Medical & Vet
SELECT '=== 13. MEDICAL RECORDS ===' as '';
SELECT * FROM medical_records;

SELECT '=== 14. VET VISITS ===' as '';
SELECT * FROM vet_visits;

-- 7. Feeding & Nutrition
SELECT '=== 15. FEEDING SCHEDULE ===' as '';
SELECT * FROM feeding_schedule;

SELECT '=== 16. FEEDING LOGS ===' as '';
SELECT * FROM feeding_logs;

-- 8. Appointments & Notes
SELECT '=== 17. APPOINTMENTS ===' as '';
SELECT * FROM appointments;

SELECT '=== 18. GENERAL NOTES ===' as '';
SELECT * FROM general_notes;

-- =============================================================================
-- VERIFICATION QUERIES
-- =============================================================================

SELECT '=== DATABASE STATUS ===' as '';
SELECT
    (SELECT COUNT(*) FROM users) as total_users,
    (SELECT COUNT(*) FROM breeds) as total_breeds,
    (SELECT COUNT(*) FROM pets) as total_pets,
    (SELECT COUNT(*) FROM scan_history) as total_scans,
    (SELECT COUNT(*) FROM reminders) as total_reminders,
    (SELECT COUNT(*) FROM medical_records) as total_medical_records,
    (SELECT COUNT(*) FROM appointments) as total_appointments;

SELECT '=== SAMPLE DATA VERIFICATION ===' as '';

-- Check users
SELECT 'Users:' as '';
SELECT id, username, email FROM users;

-- Check breeds
SELECT 'Breeds:' as '';
SELECT id, breed_name, species FROM breeds;

-- Check pets
SELECT 'Pets:' as '';
SELECT p.id, p.name, p.species, b.breed_name, u.username as owner
FROM pets p
         JOIN breeds b ON p.breed_id = b.id
         JOIN users u ON p.user_id = u.id;

-- Check reminders
SELECT 'Upcoming Reminders:' as '';
SELECT r.title, p.name as pet_name, rc.category_name, r.due_datetime
FROM reminders r
         JOIN pets p ON r.pet_id = p.id
         JOIN reminder_categories rc ON r.category_id = rc.id
WHERE r.is_completed = FALSE
ORDER BY r.due_datetime
    LIMIT 5;

-- =============================================================================
-- ENHANCED SELECT QUERIES WITH JOINED DATA
-- =============================================================================

SELECT '=== ENHANCED: SCAN HISTORY WITH USER INFO ===' as '';
SELECT
    sh.id,
    u.username,
    u.full_name,
    sh.image_type,
    sh.scan_timestamp,
    sh.is_saved
FROM scan_history sh
         JOIN users u ON sh.user_id = u.id
ORDER BY sh.scan_timestamp DESC;

SELECT '=== ENHANCED: SCAN RESULTS WITH BREED DETAILS ===' as '';
SELECT
    sr.id,
    b.breed_name,
    b.species,
    sr.confidence,
    sr.is_primary,
    u.username as scanned_by
FROM scan_results sr
         JOIN scan_history sh ON sr.scan_id = sh.id
         JOIN breeds b ON sr.breed_id = b.id
         JOIN users u ON sh.user_id = u.id
ORDER BY sr.confidence DESC;

SELECT '=== ENHANCED: PETS WITH OWNER AND BREED INFO ===' as '';
SELECT
    p.id,
    p.name as pet_name,
    p.species,
    b.breed_name,
    u.username as owner,
    p.gender,
    p.weight,
    p.weight_unit,
    p.birth_date,
    TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE()) as age_years,
    p.color
FROM pets p
         JOIN users u ON p.user_id = u.id
         LEFT JOIN breeds b ON p.breed_id = b.id
ORDER BY p.name;

SELECT '=== ENHANCED: REMINDERS WITH PET AND CATEGORY INFO ===' as '';
SELECT
    r.id,
    p.name as pet_name,
    rc.category_name,
    r.subcategory,
    r.title,
    r.due_datetime,
    r.priority,
    r.is_completed,
    CASE
        WHEN r.due_datetime < NOW() THEN 'Overdue'
        WHEN DATE(r.due_datetime) = CURDATE() THEN 'Today'
    WHEN DATE(r.due_datetime) = CURDATE() + INTERVAL 1 DAY THEN 'Tomorrow'
    ELSE 'Upcoming'
END as status,
    r.repeat_pattern
FROM reminders r
JOIN pets p ON r.pet_id = p.id
JOIN reminder_categories rc ON r.category_id = rc.id
ORDER BY r.due_datetime;

SELECT '=== ENHANCED: MEDICAL RECORDS SUMMARY ===' as '';
SELECT
    mr.id,
    p.name as pet_name,
    mr.record_type,
    mr.subtype,
    mr.title,
    mr.administered_date,
    mr.next_due_date,
    mr.medication_name,
    mr.dosage,
    mr.veterinarian,
    DATEDIFF(mr.next_due_date, CURDATE()) as days_until_due
FROM medical_records mr
         JOIN pets p ON mr.pet_id = p.id
ORDER BY mr.administered_date DESC;

SELECT '=== ENHANCED: VET VISITS DETAILS ===' as '';
SELECT
    vv.id,
    p.name as pet_name,
    vv.clinic_name,
    vv.visit_date,
    vv.purpose,
    vv.veterinarian,
    vv.diagnosis,
    vv.cost,
    vv.weight_kg,
    vv.temperature_celsius
FROM vet_visits vv
         JOIN pets p ON vv.pet_id = p.id
ORDER BY vv.visit_date DESC;

SELECT '=== ENHANCED: ACTIVITY LOGS SUMMARY ===' as '';
SELECT
    al.id,
    p.name as pet_name,
    al.activity_type,
    al.started_at,
    al.ended_at,
    al.duration_minutes,
    al.calories_burned,
    al.distance_km,
    al.location,
    al.training_type,
    al.progress_rating
FROM activity_logs al
         JOIN pets p ON al.pet_id = p.id
ORDER BY al.started_at DESC;

SELECT '=== ENHANCED: FEEDING SCHEDULE AND LOGS ===' as '';
SELECT
    p.name as pet_name,
    fs.meal_type,
    TIME_FORMAT(fs.scheduled_time, '%H:%i') as scheduled_time,
    fs.food_type,
    fs.brand,
    CONCAT(fs.quantity, ' ', fs.quantity_unit) as quantity,
    (SELECT COUNT(*) FROM feeding_logs fl WHERE fl.schedule_id = fs.id AND DATE(fl.fed_at) = CURDATE()) as fed_today
FROM feeding_schedule fs
    JOIN pets p ON fs.pet_id = p.id
WHERE fs.is_active = TRUE
ORDER BY p.name, fs.scheduled_time;

-- =============================================================================
-- DASHBOARD QUERIES
-- =============================================================================

SELECT '=== DASHBOARD: UPCOMING REMINDERS ===' as '';
SELECT
    r.id,
    p.name as pet_name,
    rc.category_name,
    r.title,
    DATE_FORMAT(r.due_datetime, '%Y-%m-%d %H:%i') as due_date,
    CASE
        WHEN r.due_datetime < NOW() THEN '🔴 Overdue'
        WHEN DATE(r.due_datetime) = CURDATE() THEN '🟡 Today'
    WHEN DATE(r.due_datetime) = CURDATE() + INTERVAL 1 DAY THEN '🟢 Tomorrow'
    ELSE '⚪ Upcoming'
END as status,
    r.priority
FROM reminders r
JOIN pets p ON r.pet_id = p.id
JOIN reminder_categories rc ON r.category_id = rc.id
WHERE r.is_completed = FALSE
ORDER BY r.due_datetime
LIMIT 10;

SELECT '=== DASHBOARD: RECENT ACTIVITIES ===' as '';
SELECT
    p.name as pet_name,
    al.activity_type,
    DATE_FORMAT(al.started_at, '%Y-%m-%d %H:%i') as activity_time,
    al.duration_minutes,
    al.calories_burned,
    al.location
FROM activity_logs al
         JOIN pets p ON al.pet_id = p.id
ORDER BY al.started_at DESC
    LIMIT 10;

SELECT '=== DASHBOARD: PET HEALTH SUMMARY ===' as '';
SELECT
    p.name as pet_name,
    p.species,
    COUNT(DISTINCT mr.id) as medical_records,
    COUNT(DISTINCT vv.id) as vet_visits,
    MAX(vv.visit_date) as last_vet_visit,
    COUNT(DISTINCT CASE WHEN r.category_id = 4 AND r.is_completed = FALSE THEN r.id END) as pending_medical_reminders
FROM pets p
         LEFT JOIN medical_records mr ON p.id = mr.pet_id
         LEFT JOIN vet_visits vv ON p.id = vv.pet_id
         LEFT JOIN reminders r ON p.id = r.pet_id AND r.category_id = 4
GROUP BY p.id, p.name, p.species
ORDER BY p.name;

SELECT '=== DASHBOARD: BREED POPULARITY ===' as '';
SELECT
    b.breed_name,
    b.species,
    COUNT(sr.id) as total_scans,
    COUNT(DISTINCT sr.scan_id) as unique_scans,
    ROUND(AVG(sr.confidence) * 100, 1) as avg_confidence_percent,
    COUNT(fb.id) as favorite_count
FROM breeds b
         LEFT JOIN scan_results sr ON b.id = sr.breed_id AND sr.is_primary = TRUE
         LEFT JOIN favourite_breeds fb ON b.id = fb.breed_id
GROUP BY b.id, b.breed_name, b.species
ORDER BY total_scans DESC, favorite_count DESC;

-- =============================================================================
-- STATISTICS AND SUMMARY QUERIES
-- =============================================================================

SELECT '=== STATISTICS: DATABASE OVERVIEW ===' as '';
SELECT
    (SELECT COUNT(*) FROM users) as total_users,
    (SELECT COUNT(*) FROM breeds) as total_breeds,
    (SELECT COUNT(*) FROM pets) as total_pets,
    (SELECT COUNT(*) FROM scan_history) as total_scans,
    (SELECT COUNT(*) FROM reminders WHERE is_completed = FALSE) as pending_reminders,
    (SELECT COUNT(*) FROM appointments WHERE status = 'scheduled') as upcoming_appointments,
    (SELECT COUNT(*) FROM medical_records) as medical_records,
    (SELECT COUNT(*) FROM activity_logs) as activity_logs,
    (SELECT COUNT(*) FROM feeding_logs WHERE DATE(fed_at) = CURDATE()) as meals_today;

SELECT '=== STATISTICS: PET SPECIES DISTRIBUTION ===' as '';
SELECT
    species,
    COUNT(*) as count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM pets)), 1) as percentage
FROM pets
GROUP BY species
ORDER BY count DESC;

SELECT '=== STATISTICS: REMINDER CATEGORY DISTRIBUTION ===' as '';
SELECT
    rc.category_name,
    COUNT(r.id) as total_reminders,
    COUNT(CASE WHEN r.is_completed = FALSE THEN r.id END) as pending_reminders
FROM reminder_categories rc
         LEFT JOIN reminders r ON rc.id = r.category_id
GROUP BY rc.id, rc.category_name
ORDER BY total_reminders DESC;

-- =============================================================================
-- FINAL DATABASE STATUS
-- =============================================================================

SELECT '=== DATABASE STATUS: COMPLETE ===' as '';
SELECT
    '✅ All tables created successfully' as status,
    NOW() as check_time,
    (SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'petcare_management') as total_tables,
    (SELECT SUM(TABLE_ROWS) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'petcare_management') as total_records;