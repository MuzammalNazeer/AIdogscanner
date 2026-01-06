import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  final String _databaseName = 'petcare.db';
  final int _databaseVersion = 2; // Incremented for cleaning_logs table

  // ==================== TABLE NAMES ====================
  final String tableUsers = 'users';
  final String tableBreeds = 'breeds';
  final String tablePets = 'pets';
  final String tablePetPhotos = 'pet_photos';
  final String tableReminderCategories = 'reminder_categories';
  final String tableReminders = 'reminders';
  final String tableHygieneLogs = 'hygiene_logs';
  final String tableCleaningLogs = 'cleaning_logs'; // NEW TABLE
  final String tableMedicalRecords = 'medical_records';
  final String tableVetVisits = 'vet_visits';
  final String tableFeedingSchedule = 'feeding_schedule';
  final String tableFeedingLogs = 'feeding_logs';
  final String tableActivityLogs = 'activity_logs';
  final String tableAppointments = 'appointments';
  final String tableScanHistory = 'scan_history';
  final String tableScanResults = 'scan_results';
  final String tableFavouriteBreeds = 'favourite_breeds';
  final String tableGeneralNotes = 'general_notes';

  // ==================== COLUMN NAMES ====================
  // Common columns
  final String colId = 'id';
  final String colCreatedAt = 'created_at';
  final String colUpdatedAt = 'updated_at';
  final String colNotes = 'notes';

  // Users table columns
  final String colUsername = 'username';
  final String colEmail = 'email';
  final String colPassword = 'password';
  final String colFullName = 'full_name';
  final String colPhoneNumber = 'phone_number';
  final String colAddress = 'address';
  final String colProfileImage = 'profile_image';

  // Pets table columns
  final String colUserId = 'user_id';
  final String colPetId = 'pet_id';
  final String colPetName = 'name';
  final String colSpecies = 'species';
  final String colBreedId = 'breed_id';
  final String colCustomBreed = 'custom_breed';
  final String colBirthDate = 'birth_date';
  final String colAdoptionDate = 'adoption_date';
  final String colGender = 'gender';
  final String colWeight = 'weight';
  final String colWeightUnit = 'weight_unit';
  final String colColor = 'color';
  final String colMicrochipId = 'microchip_id';
  final String colSpayedNeutered = 'spayed_neutered';
  final String colHealthNotes = 'health_notes';
  final String colBehaviorNotes = 'behavior_notes';

  // Reminders table columns
  final String colCategoryId = 'category_id';
  final String colSubcategory = 'subcategory';
  final String colTitle = 'title';
  final String colDescription = 'description';
  final String colDueDatetime = 'due_datetime';
  final String colRepeatPattern = 'repeat_pattern';
  final String colRepeatInterval = 'repeat_interval';
  final String colPriority = 'priority';
  final String colIsCompleted = 'is_completed';
  final String colCompletedAt = 'completed_at';
  final String colCustomData = 'custom_data';

  // Cleaning logs columns
  final String colItemType = 'item_type';
  final String colCleanedAt = 'cleaned_at';
  final String colCleaningMethod = 'cleaning_method';
  final String colCleaningProducts = 'cleaning_products';
  final String colNextDueDate = 'next_due_date';

  // Medical records columns
  final String colRecordType = 'record_type';
  final String colAdministeredDate = 'administered_date';
  final String colNextDueDateMed = 'next_due_date';
  final String colVeterinarian = 'veterinarian';
  final String colClinicName = 'clinic_name';
  final String colDosage = 'dosage';
  final String colMedicationName = 'medication_name';
  final String colFrequency = 'frequency';
  final String colDuration = 'duration';
  final String colCost = 'cost';

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // ==================== CREATE ALL TABLES ====================

    // 1. USERS TABLE
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableUsers (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colUsername TEXT UNIQUE NOT NULL,
        $colEmail TEXT UNIQUE NOT NULL,
        $colPassword TEXT NOT NULL,
        $colFullName TEXT,
        $colPhoneNumber TEXT,
        $colAddress TEXT,
        $colProfileImage TEXT,
        $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
        $colUpdatedAt TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // 2. BREEDS TABLE
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableBreeds (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        species TEXT CHECK(species IN ('DOG', 'CAT', 'BIRD', 'RABBIT', 'OTHER')),
        size TEXT CHECK(size IN ('SMALL', 'MEDIUM', 'LARGE', 'GIANT')),
        weight_range TEXT,
        height_range TEXT,
        life_expectancy TEXT,
        coat_type TEXT,
        colors TEXT,
        temperament TEXT,
        description TEXT,
        image_url TEXT
      )
    ''');

    // 3. PETS TABLE
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tablePets (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colUserId INTEGER NOT NULL,
        $colPetName TEXT NOT NULL,
        $colSpecies TEXT CHECK(species IN ('DOG', 'CAT', 'BIRD', 'RABBIT', 'OTHER')),
        $colBreedId INTEGER,
        $colCustomBreed TEXT,
        $colBirthDate TEXT,
        $colAdoptionDate TEXT,
        $colGender TEXT CHECK(gender IN ('MALE', 'FEMALE', 'UNKNOWN')),
        $colWeight REAL,
        $colWeightUnit TEXT CHECK(weight_unit IN ('KG', 'LBS')) DEFAULT 'KG',
        $colColor TEXT,
        $colMicrochipId TEXT UNIQUE,
        $colSpayedNeutered INTEGER DEFAULT 0,
        $colHealthNotes TEXT,
        $colBehaviorNotes TEXT,
        $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
        $colUpdatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY ($colUserId) REFERENCES $tableUsers($colId) ON DELETE CASCADE,
        FOREIGN KEY ($colBreedId) REFERENCES $tableBreeds($colId) ON DELETE SET NULL
      )
    ''');

    // 4. PET PHOTOS TABLE
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tablePetPhotos (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colPetId INTEGER NOT NULL,
        image_path TEXT NOT NULL,
        caption TEXT,
        taken_date TEXT,
        is_profile_picture INTEGER DEFAULT 0,
        $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
      )
    ''');

    // 5. REMINDER CATEGORIES TABLE
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableReminderCategories (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        category_name TEXT UNIQUE NOT NULL,
        color TEXT,
        icon TEXT,
        description TEXT
      )
    ''');

    // 6. REMINDERS TABLE
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableReminders (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colPetId INTEGER NOT NULL,
        $colCategoryId INTEGER NOT NULL,
        $colSubcategory TEXT,
        $colTitle TEXT NOT NULL,
        $colDescription TEXT,
        $colDueDatetime TEXT NOT NULL,
        $colRepeatPattern TEXT CHECK(repeat_pattern IN ('NONE', 'DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY')) DEFAULT 'NONE',
        $colRepeatInterval INTEGER DEFAULT 1,
        $colPriority TEXT CHECK(priority IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')) DEFAULT 'MEDIUM',
        $colIsCompleted INTEGER DEFAULT 0,
        $colCompletedAt TEXT,
        $colNotes TEXT,
        $colCustomData TEXT,
        $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
        $colUpdatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE,
        FOREIGN KEY ($colCategoryId) REFERENCES $tableReminderCategories($colId) ON DELETE CASCADE
      )
    ''');

    // 7. HYGIENE LOGS TABLE
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableHygieneLogs (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colPetId INTEGER NOT NULL,
        activity_type TEXT CHECK(activity_type IN ('BATH', 'GROOMING', 'EARS_CLEANING', 'TEETH_BRUSHING', 'NAIL_CLIPPING')) NOT NULL,
        performed_at TEXT NOT NULL,
        duration_minutes INTEGER,
        products_used TEXT,
        tools_used TEXT,
        $colNotes TEXT,
        next_recommended_date TEXT,
        cost REAL,
        $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
      )
    ''');

    // 8. CLEANING LOGS TABLE
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableCleaningLogs (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colPetId INTEGER NOT NULL,
        $colItemType TEXT CHECK(item_type IN ('FOOD_PLATE', 'BED', 'TOYS', 'WATER_FOUNTAIN', 'LEASH_COLLAR')) NOT NULL,
        $colCleanedAt TEXT NOT NULL,
        $colCleaningMethod TEXT,
        $colCleaningProducts TEXT,
        $colNotes TEXT,
        $colNextDueDate TEXT,
        $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
      )
    ''');

    // 9. MEDICAL RECORDS TABLE
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableMedicalRecords (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colPetId INTEGER NOT NULL,
        $colRecordType TEXT CHECK(record_type IN ('VACCINATION', 'MEDICATION', 'DEWORMING', 'ALLERGY', 'SURGERY', 'INJURY', 'CHRONIC_CONDITION')) NOT NULL,
        subtype TEXT,
        $colTitle TEXT NOT NULL,
        $colAdministeredDate TEXT NOT NULL,
        $colNextDueDateMed TEXT,
        $colVeterinarian TEXT,
        $colClinicName TEXT,
        $colDosage TEXT,
        $colMedicationName TEXT,
        $colFrequency TEXT,
        $colDuration TEXT,
        $colNotes TEXT,
        $colCost REAL,
        $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
      )
    ''');

    // 10. VET VISITS TABLE
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableVetVisits (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colPetId INTEGER NOT NULL,
        $colClinicName TEXT NOT NULL,
        visit_date TEXT NOT NULL,
        purpose TEXT NOT NULL,
        $colVeterinarian TEXT,
        diagnosis TEXT,
        treatment TEXT,
        prescriptions TEXT,
        weight_kg REAL,
        temperature_celsius REAL,
        $colNotes TEXT,
        follow_up_date TEXT,
        $colCost REAL,
        $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
      )
    ''');

    // 11. FEEDING SCHEDULE TABLE
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableFeedingSchedule (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colPetId INTEGER NOT NULL,
        meal_type TEXT CHECK(meal_type IN ('BREAKFAST', 'LUNCH', 'DINNER', 'SNACK')) NOT NULL,
        scheduled_time TEXT NOT NULL,
        food_type TEXT,
        brand TEXT,
        quantity REAL,
        quantity_unit TEXT,
        nutritional_info TEXT,
        is_active INTEGER DEFAULT 1,
        $colNotes TEXT,
        $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
      )
    ''');

    // 12. FEEDING LOGS TABLE
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableFeedingLogs (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colPetId INTEGER NOT NULL,
        schedule_id INTEGER,
        fed_at TEXT NOT NULL,
        food_type TEXT,
        brand TEXT,
        quantity REAL,
        quantity_unit TEXT,
        ate_all INTEGER,
        leftovers_percent INTEGER,
        water_intake_ml INTEGER,
        $colNotes TEXT,
        $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE,
        FOREIGN KEY (schedule_id) REFERENCES $tableFeedingSchedule($colId) ON DELETE SET NULL
      )
    ''');

    // 13. ACTIVITY LOGS TABLE
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableActivityLogs (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colPetId INTEGER NOT NULL,
        activity_type TEXT CHECK(activity_type IN ('WALKING', 'TRAINING', 'PLAY_TIME', 'SOCIALIZATION', 'REST')) NOT NULL,
        started_at TEXT NOT NULL,
        ended_at TEXT,
        duration_minutes INTEGER,
        calories_burned INTEGER,
        distance_km REAL,
        location TEXT,
        $colNotes TEXT,
        $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
      )
    ''');

    // 14. APPOINTMENTS TABLE
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableAppointments (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colPetId INTEGER NOT NULL,
        appointment_type TEXT CHECK(appointment_type IN ('GROOMING', 'VET', 'BOARDING', 'DAYCARE', 'TRAINING')) NOT NULL,
        business_name TEXT NOT NULL,
        scheduled_datetime TEXT NOT NULL,
        duration_minutes INTEGER,
        purpose TEXT,
        address TEXT,
        contact_phone TEXT,
        contact_email TEXT,
        $colNotes TEXT,
        status TEXT CHECK(status IN ('SCHEDULED', 'CONFIRMED', 'COMPLETED', 'CANCELLED', 'NO_SHOW')) DEFAULT 'SCHEDULED',
        cost_estimate REAL,
        actual_cost REAL,
        $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
      )
    ''');

    // 15. SCAN HISTORY TABLE
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableScanHistory (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colUserId INTEGER NOT NULL,
        image_path TEXT NOT NULL,
        image_type TEXT CHECK(image_type IN ('CAMERA', 'GALLERY')) NOT NULL,
        scan_timestamp TEXT DEFAULT CURRENT_TIMESTAMP,
        is_saved INTEGER DEFAULT 1,
        FOREIGN KEY ($colUserId) REFERENCES $tableUsers($colId) ON DELETE CASCADE
      )
    ''');

    // 16. SCAN RESULTS TABLE
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableScanResults (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        scan_id INTEGER NOT NULL,
        breed_id INTEGER NOT NULL,
        confidence REAL NOT NULL,
        is_primary INTEGER DEFAULT 0,
        FOREIGN KEY (scan_id) REFERENCES $tableScanHistory($colId) ON DELETE CASCADE,
        FOREIGN KEY (breed_id) REFERENCES $tableBreeds($colId) ON DELETE CASCADE,
        UNIQUE(scan_id, breed_id)
      )
    ''');

    // 17. FAVORITE BREEDS TABLE
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableFavouriteBreeds (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colUserId INTEGER NOT NULL,
        breed_id INTEGER NOT NULL,
        added_at TEXT DEFAULT CURRENT_TIMESTAMP,
        $colNotes TEXT,
        FOREIGN KEY ($colUserId) REFERENCES $tableUsers($colId) ON DELETE CASCADE,
        FOREIGN KEY (breed_id) REFERENCES $tableBreeds($colId) ON DELETE CASCADE,
        UNIQUE($colUserId, breed_id)
      )
    ''');

    // 18. GENERAL NOTES TABLE
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableGeneralNotes (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colPetId INTEGER NOT NULL,
        category TEXT,
        $colTitle TEXT NOT NULL,
        content TEXT,
        is_important INTEGER DEFAULT 0,
        $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
        $colUpdatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
      )
    ''');

    // ==================== CREATE INDEXES ====================
    await db.execute('CREATE INDEX IF NOT EXISTS idx_pets_user_id ON $tablePets($colUserId);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_pets_breed_id ON $tablePets($colBreedId);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_reminders_pet_id ON $tableReminders($colPetId);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_reminders_due_datetime ON $tableReminders($colDueDatetime);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_medical_records_pet_id ON $tableMedicalRecords($colPetId);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_feeding_schedule_pet_id ON $tableFeedingSchedule($colPetId);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_activity_logs_pet_id ON $tableActivityLogs($colPetId);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_cleaning_logs_pet_id ON $tableCleaningLogs($colPetId);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_cleaning_logs_item_type ON $tableCleaningLogs($colItemType);');

    // ==================== INSERT SAMPLE DATA ====================
    await _insertSampleData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('Upgrading database from version $oldVersion to $newVersion');

    if (oldVersion < 2) {
      // Add cleaning_logs table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableCleaningLogs (
          $colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colPetId INTEGER NOT NULL,
          $colItemType TEXT CHECK(item_type IN ('FOOD_PLATE', 'BED', 'TOYS', 'WATER_FOUNTAIN', 'LEASH_COLLAR')) NOT NULL,
          $colCleanedAt TEXT NOT NULL,
          $colCleaningMethod TEXT,
          $colCleaningProducts TEXT,
          $colNotes TEXT,
          $colNextDueDate TEXT,
          $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
        )
      ''');

      // Create indexes for cleaning_logs
      await db.execute('CREATE INDEX IF NOT EXISTS idx_cleaning_logs_pet_id ON $tableCleaningLogs($colPetId);');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_cleaning_logs_item_type ON $tableCleaningLogs($colItemType);');

      print('Added cleaning_logs table');
    }
  }

  Future<void> _insertSampleData(Database db) async {
    // Insert Users
    await db.insert(tableUsers, {
      colUsername: 'john_doe',
      colEmail: 'john@email.com',
      colPassword: 'password123',
      colFullName: 'John Doe',
      colPhoneNumber: '+1234567890',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

    await db.insert(tableUsers, {
      colUsername: 'jane_smith',
      colEmail: 'jane@email.com',
      colPassword: 'password123',
      colFullName: 'Jane Smith',
      colPhoneNumber: '+0987654321',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

    // Insert Reminder Categories
    await db.insert(tableReminderCategories, {
      'category_name': 'Medical',
      'color': '#FF5252',
      'icon': 'medical_services',
      'description': 'Medical and health-related reminders',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

    await db.insert(tableReminderCategories, {
      'category_name': 'Food',
      'color': '#FF9800',
      'icon': 'restaurant',
      'description': 'Feeding schedule and nutrition',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

    await db.insert(tableReminderCategories, {
      'category_name': 'Cleaning',
      'color': '#4CAF50',
      'icon': 'cleaning_services',
      'description': 'Pet item cleaning reminders',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  // ==================== CRUD OPERATIONS ====================

  // 1. USERS CRUD
  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert(tableUsers, user);
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    Database db = await database;
    return await db.query(tableUsers);
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      tableUsers,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    Database db = await database;
    user[colUpdatedAt] = DateTime.now().toIso8601String();
    return await db.update(
      tableUsers,
      user,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete(
      tableUsers,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  // 2. PETS CRUD
  Future<int> insertPet(Map<String, dynamic> pet) async {
    Database db = await database;
    return await db.insert(tablePets, pet);
  }

  Future<List<Map<String, dynamic>>> getAllPets() async {
    Database db = await database;
    return await db.query(tablePets);
  }

  Future<List<Map<String, dynamic>>> getPetsByUser(int userId) async {
    Database db = await database;
    return await db.query(
      tablePets,
      where: '$colUserId = ?',
      whereArgs: [userId],
    );
  }

  Future<Map<String, dynamic>?> getPetById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      tablePets,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updatePet(int id, Map<String, dynamic> pet) async {
    Database db = await database;
    pet[colUpdatedAt] = DateTime.now().toIso8601String();
    return await db.update(
      tablePets,
      pet,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletePet(int id) async {
    Database db = await database;
    return await db.delete(
      tablePets,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  // 3. REMINDERS CRUD
  Future<int> insertReminder(Map<String, dynamic> reminder) async {
    Database db = await database;
    return await db.insert(tableReminders, reminder);
  }

  Future<List<Map<String, dynamic>>> getAllReminders() async {
    Database db = await database;
    return await db.query(tableReminders);
  }

  Future<List<Map<String, dynamic>>> getRemindersByPet(int petId) async {
    Database db = await database;
    return await db.query(
      tableReminders,
      where: '$colPetId = ?',
      whereArgs: [petId],
      orderBy: colDueDatetime,
    );
  }

  Future<List<Map<String, dynamic>>> getUpcomingReminders() async {
    Database db = await database;
    return await db.rawQuery('''
      SELECT r.*, p.$colPetName as pet_name, rc.category_name, rc.color as category_color
      FROM $tableReminders r
      JOIN $tablePets p ON r.$colPetId = p.$colId
      JOIN $tableReminderCategories rc ON r.$colCategoryId = rc.$colId
      WHERE r.$colIsCompleted = 0 
      AND r.$colDueDatetime > datetime('now')
      ORDER BY r.$colDueDatetime
    ''');
  }

  Future<int> updateReminder(int id, Map<String, dynamic> reminder) async {
    Database db = await database;
    reminder[colUpdatedAt] = DateTime.now().toIso8601String();
    return await db.update(
      tableReminders,
      reminder,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteReminder(int id) async {
    Database db = await database;
    return await db.delete(
      tableReminders,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<int> completeReminder(int id) async {
    Database db = await database;
    return await db.update(
      tableReminders,
      {
        colIsCompleted: 1,
        colCompletedAt: DateTime.now().toIso8601String(),
        colUpdatedAt: DateTime.now().toIso8601String(),
      },
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  // 4. CLEANING LOGS CRUD (NEW)
  Future<int> insertCleaningLog(Map<String, dynamic> log) async {
    Database db = await database;
    return await db.insert(tableCleaningLogs, log);
  }

  Future<List<Map<String, dynamic>>> getCleaningLogsByPet(int petId) async {
    Database db = await database;
    return await db.query(
      tableCleaningLogs,
      where: '$colPetId = ?',
      whereArgs: [petId],
      orderBy: '$colCleanedAt DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getCleaningLogsByItemType(int petId, String itemType) async {
    Database db = await database;
    return await db.query(
      tableCleaningLogs,
      where: '$colPetId = ? AND $colItemType = ?',
      whereArgs: [petId, itemType],
      orderBy: '$colCleanedAt DESC',
    );
  }

  Future<Map<String, dynamic>?> getLastCleaningLog(int petId, String itemType) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      tableCleaningLogs,
      where: '$colPetId = ? AND $colItemType = ?',
      whereArgs: [petId, itemType],
      orderBy: '$colCleanedAt DESC',
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateCleaningLog(int id, Map<String, dynamic> log) async {
    Database db = await database;
    return await db.update(
      tableCleaningLogs,
      log,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCleaningLog(int id) async {
    Database db = await database;
    return await db.delete(
      tableCleaningLogs,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  // 5. MEDICAL RECORDS CRUD
  Future<int> insertMedicalRecord(Map<String, dynamic> record) async {
    Database db = await database;
    return await db.insert(tableMedicalRecords, record);
  }

  Future<List<Map<String, dynamic>>> getMedicalRecordsByPet(int petId) async {
    Database db = await database;
    return await db.query(
      tableMedicalRecords,
      where: '$colPetId = ?',
      whereArgs: [petId],
      orderBy: '$colAdministeredDate DESC',
    );
  }

  // 6. VET VISITS CRUD
  Future<int> insertVetVisit(Map<String, dynamic> visit) async {
    Database db = await database;
    return await db.insert(tableVetVisits, visit);
  }

  Future<List<Map<String, dynamic>>> getVetVisitsByPet(int petId) async {
    Database db = await database;
    return await db.query(
      tableVetVisits,
      where: '$colPetId = ?',
      whereArgs: [petId],
      orderBy: 'visit_date DESC',
    );
  }

  // 7. FEEDING SCHEDULE CRUD
  Future<int> insertFeedingSchedule(Map<String, dynamic> schedule) async {
    Database db = await database;
    return await db.insert(tableFeedingSchedule, schedule);
  }

  Future<List<Map<String, dynamic>>> getFeedingScheduleByPet(int petId) async {
    Database db = await database;
    return await db.query(
      tableFeedingSchedule,
      where: '$colPetId = ?',
      whereArgs: [petId],
      orderBy: 'scheduled_time',
    );
  }

  // 8. ACTIVITY LOGS CRUD
  Future<int> insertActivityLog(Map<String, dynamic> log) async {
    Database db = await database;
    return await db.insert(tableActivityLogs, log);
  }

  Future<List<Map<String, dynamic>>> getActivityLogsByPet(int petId) async {
    Database db = await database;
    return await db.query(
      tableActivityLogs,
      where: '$colPetId = ?',
      whereArgs: [petId],
      orderBy: 'started_at DESC',
    );
  }

  // 9. APPOINTMENTS CRUD
  Future<int> insertAppointment(Map<String, dynamic> appointment) async {
    Database db = await database;
    return await db.insert(tableAppointments, appointment);
  }

  Future<List<Map<String, dynamic>>> getAppointmentsByPet(int petId) async {
    Database db = await database;
    return await db.query(
      tableAppointments,
      where: '$colPetId = ?',
      whereArgs: [petId],
      orderBy: 'scheduled_datetime',
    );
  }

  // 10. PET PHOTOS CRUD
  Future<int> insertPetPhoto(Map<String, dynamic> photo) async {
    Database db = await database;
    return await db.insert(tablePetPhotos, photo);
  }

  Future<List<Map<String, dynamic>>> getPetPhotos(int petId) async {
    Database db = await database;
    return await db.query(
      tablePetPhotos,
      where: '$colPetId = ?',
      whereArgs: [petId],
      orderBy: '$colCreatedAt DESC',
    );
  }

  // 11. HYGIENE LOGS CRUD
  Future<int> insertHygieneLog(Map<String, dynamic> log) async {
    Database db = await database;
    return await db.insert(tableHygieneLogs, log);
  }

  Future<List<Map<String, dynamic>>> getHygieneLogsByPet(int petId) async {
    Database db = await database;
    return await db.query(
      tableHygieneLogs,
      where: '$colPetId = ?',
      whereArgs: [petId],
      orderBy: 'performed_at DESC',
    );
  }

  // 12. GENERAL NOTES CRUD
  Future<int> insertGeneralNote(Map<String, dynamic> note) async {
    Database db = await database;
    return await db.insert(tableGeneralNotes, note);
  }

  Future<List<Map<String, dynamic>>> getGeneralNotesByPet(int petId) async {
    Database db = await database;
    return await db.query(
      tableGeneralNotes,
      where: '$colPetId = ?',
      whereArgs: [petId],
      orderBy: '$colCreatedAt DESC',
    );
  }

  // ==================== ADVANCED QUERIES ====================

  Future<List<Map<String, dynamic>>> getPetsWithDetails() async {
    Database db = await database;
    return await db.rawQuery('''
      SELECT p.*, b.name as breed_name, b.species as breed_species, 
             b.size as breed_size, u.username as owner_name
      FROM $tablePets p
      LEFT JOIN $tableBreeds b ON p.$colBreedId = b.$colId
      LEFT JOIN $tableUsers u ON p.$colUserId = u.$colId
      ORDER BY p.$colPetName
    ''');
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    Database db = await database;

    Map<String, dynamic> stats = {};

    // Total users
    var usersResult = await db.rawQuery('SELECT COUNT(*) as count FROM $tableUsers');
    stats['totalUsers'] = usersResult.first['count'];

    // Total pets
    var petsResult = await db.rawQuery('SELECT COUNT(*) as count FROM $tablePets');
    stats['totalPets'] = petsResult.first['count'];

    // Total reminders
    var remindersResult = await db.rawQuery('SELECT COUNT(*) as count FROM $tableReminders');
    stats['totalReminders'] = remindersResult.first['count'];

    // Pending reminders
    var pendingResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $tableReminders WHERE $colIsCompleted = 0'
    );
    stats['pendingReminders'] = pendingResult.first['count'];

    // Pets by species
    var speciesResult = await db.rawQuery('''
      SELECT $colSpecies, COUNT(*) as count 
      FROM $tablePets 
      GROUP BY $colSpecies
    ''');
    stats['petsBySpecies'] = speciesResult;

    // Cleaning logs count
    var cleaningResult = await db.rawQuery('SELECT COUNT(*) as count FROM $tableCleaningLogs');
    stats['totalCleaningLogs'] = cleaningResult.first['count'];

    return stats;
  }

  Future<List<Map<String, dynamic>>> getCleaningReminders(int petId) async {
    Database db = await database;
    return await db.rawQuery('''
      SELECT r.*, p.$colPetName as pet_name
      FROM $tableReminders r
      JOIN $tablePets p ON r.$colPetId = p.$colId
      JOIN $tableReminderCategories rc ON r.$colCategoryId = rc.$colId
      WHERE r.$colPetId = ?
      AND rc.category_name = 'Cleaning'
      AND r.$colIsCompleted = 0
      ORDER BY r.$colDueDatetime
    ''', [petId]);
  }

  Future<List<Map<String, dynamic>>> searchPets(String query) async {
    Database db = await database;
    return await db.rawQuery('''
      SELECT p.*, b.name as breed_name
      FROM $tablePets p
      LEFT JOIN $tableBreeds b ON p.$colBreedId = b.$colId
      WHERE p.$colPetName LIKE ? OR p.$colSpecies LIKE ? OR b.name LIKE ?
      ORDER BY p.$colPetName
    ''', ['%$query%', '%$query%', '%$query%']);
  }

  // ==================== UTILITY METHODS ====================

  Future<void> resetDatabase() async {
    Database db = await database;
    await db.execute('DROP TABLE IF EXISTS $tableGeneralNotes');
    await db.execute('DROP TABLE IF EXISTS $tableFavouriteBreeds');
    await db.execute('DROP TABLE IF EXISTS $tableScanResults');
    await db.execute('DROP TABLE IF EXISTS $tableScanHistory');
    await db.execute('DROP TABLE IF EXISTS $tableAppointments');
    await db.execute('DROP TABLE IF EXISTS $tableActivityLogs');
    await db.execute('DROP TABLE IF EXISTS $tableFeedingLogs');
    await db.execute('DROP TABLE IF EXISTS $tableFeedingSchedule');
    await db.execute('DROP TABLE IF EXISTS $tableVetVisits');
    await db.execute('DROP TABLE IF EXISTS $tableMedicalRecords');
    await db.execute('DROP TABLE IF EXISTS $tableCleaningLogs'); // NEW
    await db.execute('DROP TABLE IF EXISTS $tableHygieneLogs');
    await db.execute('DROP TABLE IF EXISTS $tableReminders');
    await db.execute('DROP TABLE IF EXISTS $tableReminderCategories');
    await db.execute('DROP TABLE IF EXISTS $tablePetPhotos');
    await db.execute('DROP TABLE IF EXISTS $tablePets');
    await db.execute('DROP TABLE IF EXISTS $tableBreeds');
    await db.execute('DROP TABLE IF EXISTS $tableUsers');

    // Recreate tables
    await _onCreate(db, _databaseVersion);
  }

  Future<void> backupDatabase() async {
    Database db = await database;
    final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");

    for (var table in tables) {
      final tableName = table['name'] as String;
      final data = await db.query(tableName);
      print('Table: $tableName, Records: ${data.length}');
    }
  }

  Future<void> close() async {
    Database db = await database;
    await db.close();
  }
}







// import 'dart:async';
// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
//
// class DatabaseHelper {
//   // Singleton pattern
//   static final DatabaseHelper _instance = DatabaseHelper._internal();
//   factory DatabaseHelper() => _instance;
//   DatabaseHelper._internal();
//
//   static Database? _database;
//   final String _databaseName = 'petcare.db';
//   final int _databaseVersion = 2; // Incremented for cleaning_logs table
//
//   // ==================== TABLE NAMES ====================
//   final String tableUsers = 'users';
//   final String tableBreeds = 'breeds';
//   final String tablePets = 'pets';
//   final String tablePetPhotos = 'pet_photos';
//   final String tableReminderCategories = 'reminder_categories';
//   final String tableReminders = 'reminders';
//   final String tableHygieneLogs = 'hygiene_logs';
//   final String tableCleaningLogs = 'cleaning_logs'; // NEW TABLE
//   final String tableMedicalRecords = 'medical_records';
//   final String tableVetVisits = 'vet_visits';
//   final String tableFeedingSchedule = 'feeding_schedule';
//   final String tableFeedingLogs = 'feeding_logs';
//   final String tableActivityLogs = 'activity_logs';
//   final String tableAppointments = 'appointments';
//   final String tableScanHistory = 'scan_history';
//   final String tableScanResults = 'scan_results';
//   final String tableFavouriteBreeds = 'favourite_breeds';
//   final String tableGeneralNotes = 'general_notes';
//
//   // ==================== COLUMN NAMES ====================
//   // Common columns
//   final String colId = 'id';
//   final String colCreatedAt = 'created_at';
//   final String colUpdatedAt = 'updated_at';
//   final String colNotes = 'notes';
//
//   // Users table columns
//   final String colUsername = 'username';
//   final String colEmail = 'email';
//   final String colPassword = 'password';
//   final String colFullName = 'full_name';
//   final String colPhoneNumber = 'phone_number';
//   final String colAddress = 'address';
//   final String colProfileImage = 'profile_image';
//
//   // Pets table columns
//   final String colUserId = 'user_id';
//   final String colPetId = 'pet_id';
//   final String colPetName = 'name';
//   final String colSpecies = 'species';
//   final String colBreedId = 'breed_id';
//   final String colCustomBreed = 'custom_breed';
//   final String colBirthDate = 'birth_date';
//   final String colAdoptionDate = 'adoption_date';
//   final String colGender = 'gender';
//   final String colWeight = 'weight';
//   final String colWeightUnit = 'weight_unit';
//   final String colColor = 'color';
//   final String colMicrochipId = 'microchip_id';
//   final String colSpayedNeutered = 'spayed_neutered';
//   final String colHealthNotes = 'health_notes';
//   final String colBehaviorNotes = 'behavior_notes';
//
//   // Reminders table columns
//   final String colCategoryId = 'category_id';
//   final String colSubcategory = 'subcategory';
//   final String colTitle = 'title';
//   final String colDescription = 'description';
//   final String colDueDatetime = 'due_datetime';
//   final String colRepeatPattern = 'repeat_pattern';
//   final String colRepeatInterval = 'repeat_interval';
//   final String colPriority = 'priority';
//   final String colIsCompleted = 'is_completed';
//   final String colCompletedAt = 'completed_at';
//   final String colCustomData = 'custom_data';
//
//   // Cleaning logs columns
//   final String colItemType = 'item_type';
//   final String colCleanedAt = 'cleaned_at';
//   final String colCleaningMethod = 'cleaning_method';
//   final String colCleaningProducts = 'cleaning_products';
//   final String colNextDueDate = 'next_due_date';
//
//   // Medical records columns
//   final String colRecordType = 'record_type';
//   final String colAdministeredDate = 'administered_date';
//   final String colNextDueDateMed = 'next_due_date';
//   final String colVeterinarian = 'veterinarian';
//   final String colClinicName = 'clinic_name';
//   final String colDosage = 'dosage';
//   final String colMedicationName = 'medication_name';
//   final String colFrequency = 'frequency';
//   final String colDuration = 'duration';
//   final String colCost = 'cost';
//
//   // Get database instance
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }
//
//   Future<Database> _initDatabase() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, _databaseName);
//
//     return await openDatabase(
//       path,
//       version: _databaseVersion,
//       onCreate: _onCreate,
//       onUpgrade: _onUpgrade,
//       onConfigure: (db) async {
//         await db.execute('PRAGMA foreign_keys = ON');
//       },
//     );
//   }
//
//   Future<void> _onCreate(Database db, int version) async {
//     // ==================== CREATE ALL TABLES ====================
//
//     // 1. USERS TABLE
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS $tableUsers (
//         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
//         $colUsername TEXT UNIQUE NOT NULL,
//         $colEmail TEXT UNIQUE NOT NULL,
//         $colPassword TEXT NOT NULL,
//         $colFullName TEXT,
//         $colPhoneNumber TEXT,
//         $colAddress TEXT,
//         $colProfileImage TEXT,
//         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
//         $colUpdatedAt TEXT DEFAULT CURRENT_TIMESTAMP
//       )
//     ''');
//
//     // 2. BREEDS TABLE
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS $tableBreeds (
//         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
//         name TEXT NOT NULL,
//         species TEXT CHECK(species IN ('DOG', 'CAT', 'BIRD', 'RABBIT', 'OTHER')),
//         size TEXT CHECK(size IN ('SMALL', 'MEDIUM', 'LARGE', 'GIANT')),
//         weight_range TEXT,
//         height_range TEXT,
//         life_expectancy TEXT,
//         coat_type TEXT,
//         colors TEXT,
//         temperament TEXT,
//         description TEXT,
//         image_url TEXT
//       )
//     ''');
//
//     // 3. PETS TABLE
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS $tablePets (
//         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
//         $colUserId INTEGER NOT NULL,
//         $colPetName TEXT NOT NULL,
//         $colSpecies TEXT CHECK(species IN ('DOG', 'CAT', 'BIRD', 'RABBIT', 'OTHER')),
//         $colBreedId INTEGER,
//         $colCustomBreed TEXT,
//         $colBirthDate TEXT,
//         $colAdoptionDate TEXT,
//         $colGender TEXT CHECK(gender IN ('MALE', 'FEMALE', 'UNKNOWN')),
//         $colWeight REAL,
//         $colWeightUnit TEXT CHECK(weight_unit IN ('KG', 'LBS')) DEFAULT 'KG',
//         $colColor TEXT,
//         $colMicrochipId TEXT UNIQUE,
//         $colSpayedNeutered INTEGER DEFAULT 0,
//         $colHealthNotes TEXT,
//         $colBehaviorNotes TEXT,
//         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
//         $colUpdatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
//         FOREIGN KEY ($colUserId) REFERENCES $tableUsers($colId) ON DELETE CASCADE,
//         FOREIGN KEY ($colBreedId) REFERENCES $tableBreeds($colId) ON DELETE SET NULL
//       )
//     ''');
//
//     // 4. PET PHOTOS TABLE
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS $tablePetPhotos (
//         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
//         $colPetId INTEGER NOT NULL,
//         image_path TEXT NOT NULL,
//         caption TEXT,
//         taken_date TEXT,
//         is_profile_picture INTEGER DEFAULT 0,
//         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
//         FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
//       )
//     ''');
//
//     // 5. REMINDER CATEGORIES TABLE
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS $tableReminderCategories (
//         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
//         category_name TEXT UNIQUE NOT NULL,
//         color TEXT,
//         icon TEXT,
//         description TEXT
//       )
//     ''');
//
//     // 6. REMINDERS TABLE
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS $tableReminders (
//         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
//         $colPetId INTEGER NOT NULL,
//         $colCategoryId INTEGER NOT NULL,
//         $colSubcategory TEXT,
//         $colTitle TEXT NOT NULL,
//         $colDescription TEXT,
//         $colDueDatetime TEXT NOT NULL,
//         $colRepeatPattern TEXT CHECK(repeat_pattern IN ('NONE', 'DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY')) DEFAULT 'NONE',
//         $colRepeatInterval INTEGER DEFAULT 1,
//         $colPriority TEXT CHECK(priority IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')) DEFAULT 'MEDIUM',
//         $colIsCompleted INTEGER DEFAULT 0,
//         $colCompletedAt TEXT,
//         $colNotes TEXT,
//         $colCustomData TEXT,
//         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
//         $colUpdatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
//         FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE,
//         FOREIGN KEY ($colCategoryId) REFERENCES $tableReminderCategories($colId) ON DELETE CASCADE
//       )
//     ''');
//
//     // 7. HYGIENE LOGS TABLE
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS $tableHygieneLogs (
//         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
//         $colPetId INTEGER NOT NULL,
//         activity_type TEXT CHECK(activity_type IN ('BATH', 'GROOMING', 'EARS_CLEANING', 'TEETH_BRUSHING', 'NAIL_CLIPPING')) NOT NULL,
//         performed_at TEXT NOT NULL,
//         duration_minutes INTEGER,
//         products_used TEXT,
//         tools_used TEXT,
//         $colNotes TEXT,
//         next_recommended_date TEXT,
//         cost REAL,
//         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
//         FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
//       )
//     ''');
//
//     // 8. CLEANING LOGS TABLE
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS $tableCleaningLogs (
//         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
//         $colPetId INTEGER NOT NULL,
//         $colItemType TEXT CHECK(item_type IN ('FOOD_PLATE', 'BED', 'TOYS', 'WATER_FOUNTAIN', 'LEASH_COLLAR')) NOT NULL,
//         $colCleanedAt TEXT NOT NULL,
//         $colCleaningMethod TEXT,
//         $colCleaningProducts TEXT,
//         $colNotes TEXT,
//         $colNextDueDate TEXT,
//         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
//         FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
//       )
//     ''');
//
//     // 9. MEDICAL RECORDS TABLE
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS $tableMedicalRecords (
//         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
//         $colPetId INTEGER NOT NULL,
//         $colRecordType TEXT CHECK(record_type IN ('VACCINATION', 'MEDICATION', 'DEWORMING', 'ALLERGY', 'SURGERY', 'INJURY', 'CHRONIC_CONDITION')) NOT NULL,
//         subtype TEXT,
//         $colTitle TEXT NOT NULL,
//         $colAdministeredDate TEXT NOT NULL,
//         $colNextDueDateMed TEXT,
//         $colVeterinarian TEXT,
//         $colClinicName TEXT,
//         $colDosage TEXT,
//         $colMedicationName TEXT,
//         $colFrequency TEXT,
//         $colDuration TEXT,
//         $colNotes TEXT,
//         $colCost REAL,
//         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
//         FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
//       )
//     ''');
//
//     // 10. VET VISITS TABLE
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS $tableVetVisits (
//         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
//         $colPetId INTEGER NOT NULL,
//         $colClinicName TEXT NOT NULL,
//         visit_date TEXT NOT NULL,
//         purpose TEXT NOT NULL,
//         $colVeterinarian TEXT,
//         diagnosis TEXT,
//         treatment TEXT,
//         prescriptions TEXT,
//         weight_kg REAL,
//         temperature_celsius REAL,
//         $colNotes TEXT,
//         follow_up_date TEXT,
//         $colCost REAL,
//         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
//         FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
//       )
//     ''');
//
//     // 11. FEEDING SCHEDULE TABLE
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS $tableFeedingSchedule (
//         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
//         $colPetId INTEGER NOT NULL,
//         meal_type TEXT CHECK(meal_type IN ('BREAKFAST', 'LUNCH', 'DINNER', 'SNACK')) NOT NULL,
//         scheduled_time TEXT NOT NULL,
//         food_type TEXT,
//         brand TEXT,
//         quantity REAL,
//         quantity_unit TEXT,
//         nutritional_info TEXT,
//         is_active INTEGER DEFAULT 1,
//         $colNotes TEXT,
//         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
//         FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
//       )
//     ''');
//
//     // 12. FEEDING LOGS TABLE
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS $tableFeedingLogs (
//         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
//         $colPetId INTEGER NOT NULL,
//         schedule_id INTEGER,
//         fed_at TEXT NOT NULL,
//         food_type TEXT,
//         brand TEXT,
//         quantity REAL,
//         quantity_unit TEXT,
//         ate_all INTEGER,
//         leftovers_percent INTEGER,
//         water_intake_ml INTEGER,
//         $colNotes TEXT,
//         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
//         FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE,
//         FOREIGN KEY (schedule_id) REFERENCES $tableFeedingSchedule($colId) ON DELETE SET NULL
//       )
//     ''');
//
//     // 13. ACTIVITY LOGS TABLE
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS $tableActivityLogs (
//         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
//         $colPetId INTEGER NOT NULL,
//         activity_type TEXT CHECK(activity_type IN ('WALKING', 'TRAINING', 'PLAY_TIME', 'SOCIALIZATION', 'REST')) NOT NULL,
//         started_at TEXT NOT NULL,
//         ended_at TEXT,
//         duration_minutes INTEGER,
//         calories_burned INTEGER,
//         distance_km REAL,
//         location TEXT,
//         $colNotes TEXT,
//         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
//         FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
//       )
//     ''');
//
//     // 14. APPOINTMENTS TABLE
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS $tableAppointments (
//         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
//         $colPetId INTEGER NOT NULL,
//         appointment_type TEXT CHECK(appointment_type IN ('GROOMING', 'VET', 'BOARDING', 'DAYCARE', 'TRAINING')) NOT NULL,
//         business_name TEXT NOT NULL,
//         scheduled_datetime TEXT NOT NULL,
//         duration_minutes INTEGER,
//         purpose TEXT,
//         address TEXT,
//         contact_phone TEXT,
//         contact_email TEXT,
//         $colNotes TEXT,
//         status TEXT CHECK(status IN ('SCHEDULED', 'CONFIRMED', 'COMPLETED', 'CANCELLED', 'NO_SHOW')) DEFAULT 'SCHEDULED',
//         cost_estimate REAL,
//         actual_cost REAL,
//         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
//         FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
//       )
//     ''');
//
//     // 15. SCAN HISTORY TABLE
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS $tableScanHistory (
//         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
//         $colUserId INTEGER NOT NULL,
//         image_path TEXT NOT NULL,
//         image_type TEXT CHECK(image_type IN ('CAMERA', 'GALLERY')) NOT NULL,
//         scan_timestamp TEXT DEFAULT CURRENT_TIMESTAMP,
//         is_saved INTEGER DEFAULT 1,
//         FOREIGN KEY ($colUserId) REFERENCES $tableUsers($colId) ON DELETE CASCADE
//       )
//     ''');
//
//     // 16. SCAN RESULTS TABLE
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS $tableScanResults (
//         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
//         scan_id INTEGER NOT NULL,
//         breed_id INTEGER NOT NULL,
//         confidence REAL NOT NULL,
//         is_primary INTEGER DEFAULT 0,
//         FOREIGN KEY (scan_id) REFERENCES $tableScanHistory($colId) ON DELETE CASCADE,
//         FOREIGN KEY (breed_id) REFERENCES $tableBreeds($colId) ON DELETE CASCADE,
//         UNIQUE(scan_id, breed_id)
//       )
//     ''');
//
//     // 17. FAVORITE BREEDS TABLE
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS $tableFavouriteBreeds (
//         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
//         $colUserId INTEGER NOT NULL,
//         breed_id INTEGER NOT NULL,
//         added_at TEXT DEFAULT CURRENT_TIMESTAMP,
//         $colNotes TEXT,
//         FOREIGN KEY ($colUserId) REFERENCES $tableUsers($colId) ON DELETE CASCADE,
//         FOREIGN KEY (breed_id) REFERENCES $tableBreeds($colId) ON DELETE CASCADE,
//         UNIQUE($colUserId, breed_id)
//       )
//     ''');
//
//     // 18. GENERAL NOTES TABLE
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS $tableGeneralNotes (
//         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
//         $colPetId INTEGER NOT NULL,
//         category TEXT,
//         $colTitle TEXT NOT NULL,
//         content TEXT,
//         is_important INTEGER DEFAULT 0,
//         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
//         $colUpdatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
//         FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
//       )
//     ''');
//
//     // ==================== CREATE INDEXES ====================
//     await db.execute('CREATE INDEX IF NOT EXISTS idx_pets_user_id ON $tablePets($colUserId);');
//     await db.execute('CREATE INDEX IF NOT EXISTS idx_pets_breed_id ON $tablePets($colBreedId);');
//     await db.execute('CREATE INDEX IF NOT EXISTS idx_reminders_pet_id ON $tableReminders($colPetId);');
//     await db.execute('CREATE INDEX IF NOT EXISTS idx_reminders_due_datetime ON $tableReminders($colDueDatetime);');
//     await db.execute('CREATE INDEX IF NOT EXISTS idx_medical_records_pet_id ON $tableMedicalRecords($colPetId);');
//     await db.execute('CREATE INDEX IF NOT EXISTS idx_feeding_schedule_pet_id ON $tableFeedingSchedule($colPetId);');
//     await db.execute('CREATE INDEX IF NOT EXISTS idx_activity_logs_pet_id ON $tableActivityLogs($colPetId);');
//     await db.execute('CREATE INDEX IF NOT EXISTS idx_cleaning_logs_pet_id ON $tableCleaningLogs($colPetId);');
//     await db.execute('CREATE INDEX IF NOT EXISTS idx_cleaning_logs_item_type ON $tableCleaningLogs($colItemType);');
//
//     // ==================== INSERT SAMPLE DATA ====================
//     await _insertSampleData(db);
//   }
//
//   Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
//     print('Upgrading database from version $oldVersion to $newVersion');
//
//     if (oldVersion < 2) {
//       // Add cleaning_logs table
//       await db.execute('''
//         CREATE TABLE IF NOT EXISTS $tableCleaningLogs (
//           $colId INTEGER PRIMARY KEY AUTOINCREMENT,
//           $colPetId INTEGER NOT NULL,
//           $colItemType TEXT CHECK(item_type IN ('FOOD_PLATE', 'BED', 'TOYS', 'WATER_FOUNTAIN', 'LEASH_COLLAR')) NOT NULL,
//           $colCleanedAt TEXT NOT NULL,
//           $colCleaningMethod TEXT,
//           $colCleaningProducts TEXT,
//           $colNotes TEXT,
//           $colNextDueDate TEXT,
//           $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
//           FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
//         )
//       ''');
//
//       // Create indexes for cleaning_logs
//       await db.execute('CREATE INDEX IF NOT EXISTS idx_cleaning_logs_pet_id ON $tableCleaningLogs($colPetId);');
//       await db.execute('CREATE INDEX IF NOT EXISTS idx_cleaning_logs_item_type ON $tableCleaningLogs($colItemType);');
//
//       print('Added cleaning_logs table');
//     }
//   }
//
//   Future<void> _insertSampleData(Database db) async {
//     // Insert Users
//     await db.insert(tableUsers, {
//       colUsername: 'john_doe',
//       colEmail: 'john@email.com',
//       colPassword: 'password123',
//       colFullName: 'John Doe',
//       colPhoneNumber: '+1234567890',
//     }, conflictAlgorithm: ConflictAlgorithm.ignore);
//
//     await db.insert(tableUsers, {
//       colUsername: 'jane_smith',
//       colEmail: 'jane@email.com',
//       colPassword: 'password123',
//       colFullName: 'Jane Smith',
//       colPhoneNumber: '+0987654321',
//     }, conflictAlgorithm: ConflictAlgorithm.ignore);
//
//     // Insert Reminder Categories
//     await db.insert(tableReminderCategories, {
//       'category_name': 'Medical',
//       'color': '#FF5252',
//       'icon': 'medical_services',
//       'description': 'Medical and health-related reminders',
//     }, conflictAlgorithm: ConflictAlgorithm.ignore);
//
//     await db.insert(tableReminderCategories, {
//       'category_name': 'Food',
//       'color': '#FF9800',
//       'icon': 'restaurant',
//       'description': 'Feeding schedule and nutrition',
//     }, conflictAlgorithm: ConflictAlgorithm.ignore);
//
//     await db.insert(tableReminderCategories, {
//       'category_name': 'Cleaning',
//       'color': '#4CAF50',
//       'icon': 'cleaning_services',
//       'description': 'Pet item cleaning reminders',
//     }, conflictAlgorithm: ConflictAlgorithm.ignore);
//   }
//
//   // ==================== CRUD OPERATIONS ====================
//
//   // 1. USERS CRUD
//   Future<int> insertUser(Map<String, dynamic> user) async {
//     Database db = await database;
//     return await db.insert(tableUsers, user);
//   }
//
//   Future<List<Map<String, dynamic>>> getAllUsers() async {
//     Database db = await database;
//     return await db.query(tableUsers);
//   }
//
//   Future<Map<String, dynamic>?> getUserById(int id) async {
//     Database db = await database;
//     List<Map<String, dynamic>> result = await db.query(
//       tableUsers,
//       where: '$colId = ?',
//       whereArgs: [id],
//     );
//     return result.isNotEmpty ? result.first : null;
//   }
//
//   Future<int> updateUser(int id, Map<String, dynamic> user) async {
//     Database db = await database;
//     user[colUpdatedAt] = DateTime.now().toIso8601String();
//     return await db.update(
//       tableUsers,
//       user,
//       where: '$colId = ?',
//       whereArgs: [id],
//     );
//   }
//
//   Future<int> deleteUser(int id) async {
//     Database db = await database;
//     return await db.delete(
//       tableUsers,
//       where: '$colId = ?',
//       whereArgs: [id],
//     );
//   }
//
//   // 2. PETS CRUD
//   Future<int> insertPet(Map<String, dynamic> pet) async {
//     Database db = await database;
//     return await db.insert(tablePets, pet);
//   }
//
//   Future<List<Map<String, dynamic>>> getAllPets() async {
//     Database db = await database;
//     return await db.query(tablePets);
//   }
//
//   Future<List<Map<String, dynamic>>> getPetsByUser(int userId) async {
//     Database db = await database;
//     return await db.query(
//       tablePets,
//       where: '$colUserId = ?',
//       whereArgs: [userId],
//     );
//   }
//
//   Future<Map<String, dynamic>?> getPetById(int id) async {
//     Database db = await database;
//     List<Map<String, dynamic>> result = await db.query(
//       tablePets,
//       where: '$colId = ?',
//       whereArgs: [id],
//     );
//     return result.isNotEmpty ? result.first : null;
//   }
//
//   Future<int> updatePet(int id, Map<String, dynamic> pet) async {
//     Database db = await database;
//     pet[colUpdatedAt] = DateTime.now().toIso8601String();
//     return await db.update(
//       tablePets,
//       pet,
//       where: '$colId = ?',
//       whereArgs: [id],
//     );
//   }
//
//   Future<int> deletePet(int id) async {
//     Database db = await database;
//     return await db.delete(
//       tablePets,
//       where: '$colId = ?',
//       whereArgs: [id],
//     );
//   }
//
//   // 3. REMINDERS CRUD
//   Future<int> insertReminder(Map<String, dynamic> reminder) async {
//     Database db = await database;
//     return await db.insert(tableReminders, reminder);
//   }
//
//   Future<List<Map<String, dynamic>>> getAllReminders() async {
//     Database db = await database;
//     return await db.query(tableReminders);
//   }
//
//   Future<List<Map<String, dynamic>>> getRemindersByPet(int petId) async {
//     Database db = await database;
//     return await db.query(
//       tableReminders,
//       where: '$colPetId = ?',
//       whereArgs: [petId],
//       orderBy: colDueDatetime,
//     );
//   }
//
//   Future<List<Map<String, dynamic>>> getUpcomingReminders() async {
//     Database db = await database;
//     return await db.rawQuery('''
//       SELECT r.*, p.$colPetName as pet_name, rc.category_name, rc.color as category_color
//       FROM $tableReminders r
//       JOIN $tablePets p ON r.$colPetId = p.$colId
//       JOIN $tableReminderCategories rc ON r.$colCategoryId = rc.$colId
//       WHERE r.$colIsCompleted = 0
//       AND r.$colDueDatetime > datetime('now')
//       ORDER BY r.$colDueDatetime
//     ''');
//   }
//
//   Future<int> updateReminder(int id, Map<String, dynamic> reminder) async {
//     Database db = await database;
//     reminder[colUpdatedAt] = DateTime.now().toIso8601String();
//     return await db.update(
//       tableReminders,
//       reminder,
//       where: '$colId = ?',
//       whereArgs: [id],
//     );
//   }
//
//   Future<int> deleteReminder(int id) async {
//     Database db = await database;
//     return await db.delete(
//       tableReminders,
//       where: '$colId = ?',
//       whereArgs: [id],
//     );
//   }
//
//   Future<int> completeReminder(int id) async {
//     Database db = await database;
//     return await db.update(
//       tableReminders,
//       {
//         colIsCompleted: 1,
//         colCompletedAt: DateTime.now().toIso8601String(),
//         colUpdatedAt: DateTime.now().toIso8601String(),
//       },
//       where: '$colId = ?',
//       whereArgs: [id],
//     );
//   }
//
//   // 4. CLEANING LOGS CRUD (NEW)
//   Future<int> insertCleaningLog(Map<String, dynamic> log) async {
//     Database db = await database;
//     return await db.insert(tableCleaningLogs, log);
//   }
//
//   Future<List<Map<String, dynamic>>> getCleaningLogsByPet(int petId) async {
//     Database db = await database;
//     return await db.query(
//       tableCleaningLogs,
//       where: '$colPetId = ?',
//       whereArgs: [petId],
//       orderBy: '$colCleanedAt DESC',
//     );
//   }
//
//   Future<List<Map<String, dynamic>>> getCleaningLogsByItemType(int petId, String itemType) async {
//     Database db = await database;
//     return await db.query(
//       tableCleaningLogs,
//       where: '$colPetId = ? AND $colItemType = ?',
//       whereArgs: [petId, itemType],
//       orderBy: '$colCleanedAt DESC',
//     );
//   }
//
//   Future<Map<String, dynamic>?> getLastCleaningLog(int petId, String itemType) async {
//     Database db = await database;
//     List<Map<String, dynamic>> result = await db.query(
//       tableCleaningLogs,
//       where: '$colPetId = ? AND $colItemType = ?',
//       whereArgs: [petId, itemType],
//       orderBy: '$colCleanedAt DESC',
//       limit: 1,
//     );
//     return result.isNotEmpty ? result.first : null;
//   }
//
//   Future<int> updateCleaningLog(int id, Map<String, dynamic> log) async {
//     Database db = await database;
//     return await db.update(
//       tableCleaningLogs,
//       log,
//       where: '$colId = ?',
//       whereArgs: [id],
//     );
//   }
//
//   Future<int> deleteCleaningLog(int id) async {
//     Database db = await database;
//     return await db.delete(
//       tableCleaningLogs,
//       where: '$colId = ?',
//       whereArgs: [id],
//     );
//   }
//
//   // 5. MEDICAL RECORDS CRUD
//   Future<int> insertMedicalRecord(Map<String, dynamic> record) async {
//     Database db = await database;
//     return await db.insert(tableMedicalRecords, record);
//   }
//
//   Future<List<Map<String, dynamic>>> getMedicalRecordsByPet(int petId) async {
//     Database db = await database;
//     return await db.query(
//       tableMedicalRecords,
//       where: '$colPetId = ?',
//       whereArgs: [petId],
//       orderBy: '$colAdministeredDate DESC',
//     );
//   }
//
//   // 6. VET VISITS CRUD
//   Future<int> insertVetVisit(Map<String, dynamic> visit) async {
//     Database db = await database;
//     return await db.insert(tableVetVisits, visit);
//   }
//
//   Future<List<Map<String, dynamic>>> getVetVisitsByPet(int petId) async {
//     Database db = await database;
//     return await db.query(
//       tableVetVisits,
//       where: '$colPetId = ?',
//       whereArgs: [petId],
//       orderBy: 'visit_date DESC',
//     );
//   }
//
//   // 7. FEEDING SCHEDULE CRUD
//   Future<int> insertFeedingSchedule(Map<String, dynamic> schedule) async {
//     Database db = await database;
//     return await db.insert(tableFeedingSchedule, schedule);
//   }
//
//   Future<List<Map<String, dynamic>>> getFeedingScheduleByPet(int petId) async {
//     Database db = await database;
//     return await db.query(
//       tableFeedingSchedule,
//       where: '$colPetId = ?',
//       whereArgs: [petId],
//       orderBy: 'scheduled_time',
//     );
//   }
//
//   // 8. ACTIVITY LOGS CRUD
//   Future<int> insertActivityLog(Map<String, dynamic> log) async {
//     Database db = await database;
//     return await db.insert(tableActivityLogs, log);
//   }
//
//   Future<List<Map<String, dynamic>>> getActivityLogsByPet(int petId) async {
//     Database db = await database;
//     return await db.query(
//       tableActivityLogs,
//       where: '$colPetId = ?',
//       whereArgs: [petId],
//       orderBy: 'started_at DESC',
//     );
//   }
//
//   // 9. APPOINTMENTS CRUD
//   Future<int> insertAppointment(Map<String, dynamic> appointment) async {
//     Database db = await database;
//     return await db.insert(tableAppointments, appointment);
//   }
//
//   Future<List<Map<String, dynamic>>> getAppointmentsByPet(int petId) async {
//     Database db = await database;
//     return await db.query(
//       tableAppointments,
//       where: '$colPetId = ?',
//       whereArgs: [petId],
//       orderBy: 'scheduled_datetime',
//     );
//   }
//
//   // 10. PET PHOTOS CRUD
//   Future<int> insertPetPhoto(Map<String, dynamic> photo) async {
//     Database db = await database;
//     return await db.insert(tablePetPhotos, photo);
//   }
//
//   Future<List<Map<String, dynamic>>> getPetPhotos(int petId) async {
//     Database db = await database;
//     return await db.query(
//       tablePetPhotos,
//       where: '$colPetId = ?',
//       whereArgs: [petId],
//       orderBy: '$colCreatedAt DESC',
//     );
//   }
//
//   // 11. HYGIENE LOGS CRUD
//   Future<int> insertHygieneLog(Map<String, dynamic> log) async {
//     Database db = await database;
//     return await db.insert(tableHygieneLogs, log);
//   }
//
//   Future<List<Map<String, dynamic>>> getHygieneLogsByPet(int petId) async {
//     Database db = await database;
//     return await db.query(
//       tableHygieneLogs,
//       where: '$colPetId = ?',
//       whereArgs: [petId],
//       orderBy: 'performed_at DESC',
//     );
//   }
//
//   // 12. GENERAL NOTES CRUD
//   Future<int> insertGeneralNote(Map<String, dynamic> note) async {
//     Database db = await database;
//     return await db.insert(tableGeneralNotes, note);
//   }
//
//   Future<List<Map<String, dynamic>>> getGeneralNotesByPet(int petId) async {
//     Database db = await database;
//     return await db.query(
//       tableGeneralNotes,
//       where: '$colPetId = ?',
//       whereArgs: [petId],
//       orderBy: '$colCreatedAt DESC',
//     );
//   }
//
//   // ==================== ADVANCED QUERIES ====================
//
//   Future<List<Map<String, dynamic>>> getPetsWithDetails() async {
//     Database db = await database;
//     return await db.rawQuery('''
//       SELECT p.*, b.name as breed_name, b.species as breed_species,
//              b.size as breed_size, u.username as owner_name
//       FROM $tablePets p
//       LEFT JOIN $tableBreeds b ON p.$colBreedId = b.$colId
//       LEFT JOIN $tableUsers u ON p.$colUserId = u.$colId
//       ORDER BY p.$colPetName
//     ''');
//   }
//
//   Future<Map<String, dynamic>> getDashboardStats() async {
//     Database db = await database;
//
//     Map<String, dynamic> stats = {};
//
//     // Total users
//     var usersResult = await db.rawQuery('SELECT COUNT(*) as count FROM $tableUsers');
//     stats['totalUsers'] = usersResult.first['count'];
//
//     // Total pets
//     var petsResult = await db.rawQuery('SELECT COUNT(*) as count FROM $tablePets');
//     stats['totalPets'] = petsResult.first['count'];
//
//     // Total reminders
//     var remindersResult = await db.rawQuery('SELECT COUNT(*) as count FROM $tableReminders');
//     stats['totalReminders'] = remindersResult.first['count'];
//
//     // Pending reminders
//     var pendingResult = await db.rawQuery(
//         'SELECT COUNT(*) as count FROM $tableReminders WHERE $colIsCompleted = 0'
//     );
//     stats['pendingReminders'] = pendingResult.first['count'];
//
//     // Pets by species
//     var speciesResult = await db.rawQuery('''
//       SELECT $colSpecies, COUNT(*) as count
//       FROM $tablePets
//       GROUP BY $colSpecies
//     ''');
//     stats['petsBySpecies'] = speciesResult;
//
//     // Cleaning logs count
//     var cleaningResult = await db.rawQuery('SELECT COUNT(*) as count FROM $tableCleaningLogs');
//     stats['totalCleaningLogs'] = cleaningResult.first['count'];
//
//     return stats;
//   }
//
//   Future<List<Map<String, dynamic>>> getCleaningReminders(int petId) async {
//     Database db = await database;
//     return await db.rawQuery('''
//       SELECT r.*, p.$colPetName as pet_name
//       FROM $tableReminders r
//       JOIN $tablePets p ON r.$colPetId = p.$colId
//       JOIN $tableReminderCategories rc ON r.$colCategoryId = rc.$colId
//       WHERE r.$colPetId = ?
//       AND rc.category_name = 'Cleaning'
//       AND r.$colIsCompleted = 0
//       ORDER BY r.$colDueDatetime
//     ''', [petId]);
//   }
//
//   Future<List<Map<String, dynamic>>> searchPets(String query) async {
//     Database db = await database;
//     return await db.rawQuery('''
//       SELECT p.*, b.name as breed_name
//       FROM $tablePets p
//       LEFT JOIN $tableBreeds b ON p.$colBreedId = b.$colId
//       WHERE p.$colPetName LIKE ? OR p.$colSpecies LIKE ? OR b.name LIKE ?
//       ORDER BY p.$colPetName
//     ''', ['%$query%', '%$query%', '%$query%']);
//   }
//
//   // ==================== UTILITY METHODS ====================
//
//   Future<void> resetDatabase() async {
//     Database db = await database;
//     await db.execute('DROP TABLE IF EXISTS $tableGeneralNotes');
//     await db.execute('DROP TABLE IF EXISTS $tableFavouriteBreeds');
//     await db.execute('DROP TABLE IF EXISTS $tableScanResults');
//     await db.execute('DROP TABLE IF EXISTS $tableScanHistory');
//     await db.execute('DROP TABLE IF EXISTS $tableAppointments');
//     await db.execute('DROP TABLE IF EXISTS $tableActivityLogs');
//     await db.execute('DROP TABLE IF EXISTS $tableFeedingLogs');
//     await db.execute('DROP TABLE IF EXISTS $tableFeedingSchedule');
//     await db.execute('DROP TABLE IF EXISTS $tableVetVisits');
//     await db.execute('DROP TABLE IF EXISTS $tableMedicalRecords');
//     await db.execute('DROP TABLE IF EXISTS $tableCleaningLogs'); // NEW
//     await db.execute('DROP TABLE IF EXISTS $tableHygieneLogs');
//     await db.execute('DROP TABLE IF EXISTS $tableReminders');
//     await db.execute('DROP TABLE IF EXISTS $tableReminderCategories');
//     await db.execute('DROP TABLE IF EXISTS $tablePetPhotos');
//     await db.execute('DROP TABLE IF EXISTS $tablePets');
//     await db.execute('DROP TABLE IF EXISTS $tableBreeds');
//     await db.execute('DROP TABLE IF EXISTS $tableUsers');
//
//     // Recreate tables
//     await _onCreate(db, _databaseVersion);
//   }
//
//   Future<void> backupDatabase() async {
//     Database db = await database;
//     final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
//
//     for (var table in tables) {
//       final tableName = table['name'] as String;
//       final data = await db.query(tableName);
//       print('Table: $tableName, Records: ${data.length}');
//     }
//   }
//
//   Future<void> close() async {
//     Database db = await database;
//     await db.close();
//   }
// }
//
// // import 'dart:async';
// // import 'dart:io';
// // import 'package:path/path.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:sqflite/sqflite.dart';
// //
// // class DatabaseHelper {
// //   static final DatabaseHelper _instance = DatabaseHelper._internal();
// //   factory DatabaseHelper() => _instance;
// //   DatabaseHelper._internal();
// //
// //   static Database? _database;
// //   final String _databaseName = 'petcare.db';
// //   final int _databaseVersion = 1;
// //
// //   // ==================== TABLE NAMES ====================
// //   final String tableUsers = 'users';
// //   final String tableBreeds = 'breeds';
// //   final String tablePets = 'pets';
// //   final String tablePetPhotos = 'pet_photos';
// //   final String tableReminderCategories = 'reminder_categories';
// //   final String tableReminders = 'reminders';
// //   final String tableHygieneLogs = 'hygiene_logs';
// //   final String tableMedicalRecords = 'medical_records';
// //   final String tableVetVisits = 'vet_visits';
// //   final String tableFeedingSchedule = 'feeding_schedule';
// //   final String tableFeedingLogs = 'feeding_logs';
// //   final String tableActivityLogs = 'activity_logs';
// //   final String tableAppointments = 'appointments';
// //   final String tableScanHistory = 'scan_history';
// //   final String tableScanResults = 'scan_results';
// //   final String tableFavouriteBreeds = 'favourite_breeds';
// //
// //   // ==================== COLUMN NAMES ====================
// //   // Common columns
// //   final String colId = 'id';
// //   final String colCreatedAt = 'created_at';
// //   final String colUpdatedAt = 'updated_at';
// //
// //   // Users table columns
// //   final String colUsername = 'username';
// //   final String colEmail = 'email';
// //   final String colPassword = 'password';
// //   final String colFullName = 'full_name';
// //   final String colPhoneNumber = 'phone_number';
// //   final String colAddress = 'address';
// //   final String colProfileImage = 'profile_image';
// //
// //   // Pets table columns
// //   final String colUserId = 'user_id';
// //   final String colPetName = 'name';
// //   final String colSpecies = 'species';
// //   final String colBreedId = 'breed_id';
// //   final String colCustomBreed = 'custom_breed';
// //   final String colBirthDate = 'birth_date';
// //   final String colAdoptionDate = 'adoption_date';
// //   final String colGender = 'gender';
// //   final String colWeight = 'weight';
// //   final String colWeightUnit = 'weight_unit';
// //   final String colColor = 'color';
// //   final String colMicrochipId = 'microchip_id';
// //   final String colSpayedNeutered = 'spayed_neutered';
// //   final String colHealthNotes = 'health_notes';
// //   final String colBehaviorNotes = 'behavior_notes';
// //
// //   // Reminders table columns
// //   final String colPetId = 'pet_id';
// //   final String colCategoryId = 'category_id';
// //   final String colSubcategory = 'subcategory';
// //   final String colTitle = 'title';
// //   final String colDescription = 'description';
// //   final String colDueDatetime = 'due_datetime';
// //   final String colRepeatPattern = 'repeat_pattern';
// //   final String colRepeatInterval = 'repeat_interval';
// //   final String colPriority = 'priority';
// //   final String colIsCompleted = 'is_completed';
// //   final String colCompletedAt = 'completed_at';
// //   final String colNotes = 'notes';
// //   final String colCustomData = 'custom_data';
// //
// //   // ... (other table column definitions would follow the same pattern)
// //
// //   Future<Database> get database async {
// //     if (_database != null) return _database!;
// //     _database = await _initDatabase();
// //     return _database!;
// //   }
// //
// //   Future<Database> _initDatabase() async {
// //     Directory documentsDirectory = await getApplicationDocumentsDirectory();
// //     String path = join(documentsDirectory.path, _databaseName);
// //
// //     return await openDatabase(
// //       path,
// //       version: _databaseVersion,
// //       onCreate: _onCreate,
// //       onConfigure: (db) async {
// //         await db.execute('PRAGMA foreign_keys = ON');
// //       },
// //     );
// //   }
// //
// //   Future<void> _onCreate(Database db, int version) async {
// //     // ==================== CREATE ALL TABLES ====================
// //
// //     // 1. USERS TABLE
// //     await db.execute('''
// //       CREATE TABLE IF NOT EXISTS $tableUsers (
// //         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
// //         $colUsername TEXT UNIQUE NOT NULL,
// //         $colEmail TEXT UNIQUE NOT NULL,
// //         $colPassword TEXT NOT NULL,
// //         $colFullName TEXT,
// //         $colPhoneNumber TEXT,
// //         $colAddress TEXT,
// //         $colProfileImage TEXT,
// //         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
// //         $colUpdatedAt TEXT DEFAULT CURRENT_TIMESTAMP
// //       )
// //     ''');
// //
// //     // 2. BREEDS TABLE
// //     await db.execute('''
// //       CREATE TABLE IF NOT EXISTS $tableBreeds (
// //         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
// //         name TEXT NOT NULL,
// //         species TEXT CHECK(species IN ('DOG', 'CAT', 'BIRD', 'RABBIT', 'OTHER')),
// //         size TEXT CHECK(size IN ('SMALL', 'MEDIUM', 'LARGE', 'GIANT')),
// //         weight_range TEXT,
// //         height_range TEXT,
// //         life_expectancy TEXT,
// //         coat_type TEXT,
// //         colors TEXT,
// //         temperament TEXT,
// //         description TEXT,
// //         image_url TEXT
// //       )
// //     ''');
// //
// //     // 3. PETS TABLE
// //     await db.execute('''
// //       CREATE TABLE IF NOT EXISTS $tablePets (
// //         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
// //         $colUserId INTEGER NOT NULL,
// //         $colPetName TEXT NOT NULL,
// //         $colSpecies TEXT CHECK(species IN ('DOG', 'CAT', 'BIRD', 'RABBIT', 'OTHER')),
// //         $colBreedId INTEGER,
// //         $colCustomBreed TEXT,
// //         $colBirthDate TEXT,
// //         $colAdoptionDate TEXT,
// //         $colGender TEXT CHECK(gender IN ('MALE', 'FEMALE', 'UNKNOWN')),
// //         $colWeight REAL,
// //         $colWeightUnit TEXT CHECK(weight_unit IN ('KG', 'LBS')) DEFAULT 'KG',
// //         $colColor TEXT,
// //         $colMicrochipId TEXT UNIQUE,
// //         $colSpayedNeutered INTEGER DEFAULT 0,
// //         $colHealthNotes TEXT,
// //         $colBehaviorNotes TEXT,
// //         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
// //         $colUpdatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
// //         FOREIGN KEY ($colUserId) REFERENCES $tableUsers($colId) ON DELETE CASCADE,
// //         FOREIGN KEY ($colBreedId) REFERENCES $tableBreeds($colId) ON DELETE SET NULL
// //       )
// //     ''');
// //
// //     // 4. PET PHOTOS TABLE
// //     await db.execute('''
// //       CREATE TABLE IF NOT EXISTS $tablePetPhotos (
// //         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
// //         $colPetId INTEGER NOT NULL,
// //         image_path TEXT NOT NULL,
// //         caption TEXT,
// //         taken_date TEXT,
// //         is_profile_picture INTEGER DEFAULT 0,
// //         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
// //         FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
// //       )
// //     ''');
// //
// //     // 5. REMINDER CATEGORIES TABLE
// //     await db.execute('''
// //       CREATE TABLE IF NOT EXISTS $tableReminderCategories (
// //         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
// //         category_name TEXT UNIQUE NOT NULL,
// //         color TEXT,
// //         icon TEXT,
// //         description TEXT
// //       )
// //     ''');
// //
// //     // 6. REMINDERS TABLE
// //     await db.execute('''
// //       CREATE TABLE IF NOT EXISTS $tableReminders (
// //         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
// //         $colPetId INTEGER NOT NULL,
// //         $colCategoryId INTEGER NOT NULL,
// //         $colSubcategory TEXT,
// //         $colTitle TEXT NOT NULL,
// //         $colDescription TEXT,
// //         $colDueDatetime TEXT NOT NULL,
// //         $colRepeatPattern TEXT CHECK(repeat_pattern IN ('NONE', 'DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY')) DEFAULT 'NONE',
// //         $colRepeatInterval INTEGER DEFAULT 1,
// //         $colPriority TEXT CHECK(priority IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')) DEFAULT 'MEDIUM',
// //         $colIsCompleted INTEGER DEFAULT 0,
// //         $colCompletedAt TEXT,
// //         $colNotes TEXT,
// //         $colCustomData TEXT,
// //         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
// //         $colUpdatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
// //         FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE,
// //         FOREIGN KEY ($colCategoryId) REFERENCES $tableReminderCategories($colId) ON DELETE CASCADE
// //       )
// //     ''');
// //
// //     // 7. HYGIENE LOGS TABLE
// //     await db.execute('''
// //       CREATE TABLE IF NOT EXISTS $tableHygieneLogs (
// //         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
// //         $colPetId INTEGER NOT NULL,
// //         activity_type TEXT CHECK(activity_type IN ('BATH', 'GROOMING', 'EARS_CLEANING', 'TEETH_BRUSHING', 'NAIL_CLIPPING')) NOT NULL,
// //         performed_at TEXT NOT NULL,
// //         duration_minutes INTEGER,
// //         products_used TEXT,
// //         tools_used TEXT,
// //         $colNotes TEXT,
// //         next_recommended_date TEXT,
// //         cost REAL,
// //         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
// //         FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
// //       )
// //     ''');
// //
// //     // 8. MEDICAL RECORDS TABLE
// //     await db.execute('''
// //       CREATE TABLE IF NOT EXISTS $tableMedicalRecords (
// //         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
// //         $colPetId INTEGER NOT NULL,
// //         record_type TEXT CHECK(record_type IN ('VACCINATION', 'MEDICATION', 'DEWORMING', 'ALLERGY', 'SURGERY', 'INJURY', 'CHRONIC_CONDITION')) NOT NULL,
// //         subtype TEXT,
// //         $colTitle TEXT NOT NULL,
// //         administered_date TEXT NOT NULL,
// //         next_due_date TEXT,
// //         veterinarian TEXT,
// //         clinic_name TEXT,
// //         dosage TEXT,
// //         medication_name TEXT,
// //         frequency TEXT,
// //         duration TEXT,
// //         $colNotes TEXT,
// //         cost REAL,
// //         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
// //         FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
// //       )
// //     ''');
// //
// //     // 9. VET VISITS TABLE
// //     await db.execute('''
// //       CREATE TABLE IF NOT EXISTS $tableVetVisits (
// //         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
// //         $colPetId INTEGER NOT NULL,
// //         clinic_name TEXT NOT NULL,
// //         visit_date TEXT NOT NULL,
// //         purpose TEXT NOT NULL,
// //         veterinarian TEXT,
// //         diagnosis TEXT,
// //         treatment TEXT,
// //         prescriptions TEXT,
// //         weight_kg REAL,
// //         temperature_celsius REAL,
// //         $colNotes TEXT,
// //         follow_up_date TEXT,
// //         cost REAL,
// //         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
// //         FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
// //       )
// //     ''');
// //
// //     // 10. FEEDING SCHEDULE TABLE
// //     await db.execute('''
// //       CREATE TABLE IF NOT EXISTS $tableFeedingSchedule (
// //         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
// //         $colPetId INTEGER NOT NULL,
// //         meal_type TEXT CHECK(meal_type IN ('BREAKFAST', 'LUNCH', 'DINNER', 'SNACK')) NOT NULL,
// //         scheduled_time TEXT NOT NULL,
// //         food_type TEXT,
// //         brand TEXT,
// //         quantity REAL,
// //         quantity_unit TEXT,
// //         nutritional_info TEXT,
// //         is_active INTEGER DEFAULT 1,
// //         $colNotes TEXT,
// //         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
// //         FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
// //       )
// //     ''');
// //
// //     // 11. FEEDING LOGS TABLE
// //     await db.execute('''
// //       CREATE TABLE IF NOT EXISTS $tableFeedingLogs (
// //         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
// //         $colPetId INTEGER NOT NULL,
// //         schedule_id INTEGER,
// //         fed_at TEXT NOT NULL,
// //         food_type TEXT,
// //         brand TEXT,
// //         quantity REAL,
// //         quantity_unit TEXT,
// //         ate_all INTEGER,
// //         leftovers_percent INTEGER,
// //         water_intake_ml INTEGER,
// //         $colNotes TEXT,
// //         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
// //         FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE,
// //         FOREIGN KEY (schedule_id) REFERENCES $tableFeedingSchedule($colId) ON DELETE SET NULL
// //       )
// //     ''');
// //
// //     // 12. ACTIVITY LOGS TABLE
// //     await db.execute('''
// //       CREATE TABLE IF NOT EXISTS $tableActivityLogs (
// //         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
// //         $colPetId INTEGER NOT NULL,
// //         activity_type TEXT CHECK(activity_type IN ('WALKING', 'TRAINING', 'PLAY_TIME', 'SOCIALIZATION', 'REST')) NOT NULL,
// //         started_at TEXT NOT NULL,
// //         ended_at TEXT,
// //         duration_minutes INTEGER,
// //         calories_burned INTEGER,
// //         distance_km REAL,
// //         location TEXT,
// //         $colNotes TEXT,
// //         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
// //         FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
// //       )
// //     ''');
// //
// //     // 13. APPOINTMENTS TABLE
// //     await db.execute('''
// //       CREATE TABLE IF NOT EXISTS $tableAppointments (
// //         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
// //         $colPetId INTEGER NOT NULL,
// //         appointment_type TEXT CHECK(appointment_type IN ('GROOMING', 'VET', 'BOARDING', 'DAYCARE', 'TRAINING')) NOT NULL,
// //         business_name TEXT NOT NULL,
// //         scheduled_datetime TEXT NOT NULL,
// //         duration_minutes INTEGER,
// //         purpose TEXT,
// //         address TEXT,
// //         contact_phone TEXT,
// //         contact_email TEXT,
// //         $colNotes TEXT,
// //         status TEXT CHECK(status IN ('SCHEDULED', 'CONFIRMED', 'COMPLETED', 'CANCELLED', 'NO_SHOW')) DEFAULT 'SCHEDULED',
// //         cost_estimate REAL,
// //         actual_cost REAL,
// //         $colCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
// //         FOREIGN KEY ($colPetId) REFERENCES $tablePets($colId) ON DELETE CASCADE
// //       )
// //     ''');
// //
// //     // 14. SCAN HISTORY TABLE
// //     await db.execute('''
// //       CREATE TABLE IF NOT EXISTS $tableScanHistory (
// //         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
// //         $colUserId INTEGER NOT NULL,
// //         image_path TEXT NOT NULL,
// //         image_type TEXT CHECK(image_type IN ('CAMERA', 'GALLERY')) NOT NULL,
// //         scan_timestamp TEXT DEFAULT CURRENT_TIMESTAMP,
// //         is_saved INTEGER DEFAULT 1,
// //         FOREIGN KEY ($colUserId) REFERENCES $tableUsers($colId) ON DELETE CASCADE
// //       )
// //     ''');
// //
// //     // 15. SCAN RESULTS TABLE
// //     await db.execute('''
// //       CREATE TABLE IF NOT EXISTS $tableScanResults (
// //         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
// //         scan_id INTEGER NOT NULL,
// //         breed_id INTEGER NOT NULL,
// //         confidence REAL NOT NULL,
// //         is_primary INTEGER DEFAULT 0,
// //         FOREIGN KEY (scan_id) REFERENCES $tableScanHistory($colId) ON DELETE CASCADE,
// //         FOREIGN KEY (breed_id) REFERENCES $tableBreeds($colId) ON DELETE CASCADE,
// //         UNIQUE(scan_id, breed_id)
// //       )
// //     ''');
// //
// //     // 16. FAVORITE BREEDS TABLE
// //     await db.execute('''
// //       CREATE TABLE IF NOT EXISTS $tableFavouriteBreeds (
// //         $colId INTEGER PRIMARY KEY AUTOINCREMENT,
// //         $colUserId INTEGER NOT NULL,
// //         breed_id INTEGER NOT NULL,
// //         added_at TEXT DEFAULT CURRENT_TIMESTAMP,
// //         $colNotes TEXT,
// //         FOREIGN KEY ($colUserId) REFERENCES $tableUsers($colId) ON DELETE CASCADE,
// //         FOREIGN KEY (breed_id) REFERENCES $tableBreeds($colId) ON DELETE CASCADE,
// //         UNIQUE($colUserId, breed_id)
// //       )
// //     ''');
// //
// //     // ==================== CREATE INDEXES ====================
// //     await db.execute('CREATE INDEX IF NOT EXISTS idx_pets_user_id ON $tablePets($colUserId);');
// //     await db.execute('CREATE INDEX IF NOT EXISTS idx_pets_breed_id ON $tablePets($colBreedId);');
// //     await db.execute('CREATE INDEX IF NOT EXISTS idx_reminders_pet_id ON $tableReminders($colPetId);');
// //     await db.execute('CREATE INDEX IF NOT EXISTS idx_reminders_due_datetime ON $tableReminders($colDueDatetime);');
// //     await db.execute('CREATE INDEX IF NOT EXISTS idx_medical_records_pet_id ON $tableMedicalRecords($colPetId);');
// //     await db.execute('CREATE INDEX IF NOT EXISTS idx_feeding_schedule_pet_id ON $tableFeedingSchedule($colPetId);');
// //     await db.execute('CREATE INDEX IF NOT EXISTS idx_activity_logs_pet_id ON $tableActivityLogs($colPetId);');
// //
// //     // ==================== INSERT SAMPLE DATA ====================
// //     await _insertSampleData(db);
// //   }
// //
// //   Future<void> _insertSampleData(Database db) async {
// //     // Insert Users
// //     await db.insert(tableUsers, {
// //       colUsername: 'john_doe',
// //       colEmail: 'john@email.com',
// //       colPassword: 'password123',
// //       colFullName: 'John Doe',
// //       colPhoneNumber: '+1234567890',
// //     }, conflictAlgorithm: ConflictAlgorithm.ignore);
// //
// //     await db.insert(tableUsers, {
// //       colUsername: 'jane_smith',
// //       colEmail: 'jane@email.com',
// //       colPassword: 'password123',
// //       colFullName: 'Jane Smith',
// //       colPhoneNumber: '+0987654321',
// //     }, conflictAlgorithm: ConflictAlgorithm.ignore);
// //
// //     await db.insert(tableUsers, {
// //       colUsername: 'mike_wilson',
// //       colEmail: 'mike@email.com',
// //       colPassword: 'password123',
// //       colFullName: 'Mike Wilson',
// //       colPhoneNumber: '+1122334455',
// //     }, conflictAlgorithm: ConflictAlgorithm.ignore);
// //
// //     // Insert Breeds
// //     await db.insert(tableBreeds, {
// //       'name': 'Golden Retriever',
// //       'species': 'DOG',
// //       'size': 'LARGE',
// //       'weight_range': '25-34 kg',
// //       'temperament': 'Friendly, Intelligent, Devoted',
// //     }, conflictAlgorithm: ConflictAlgorithm.ignore);
// //
// //     await db.insert(tableBreeds, {
// //       'name': 'Siamese',
// //       'species': 'CAT',
// //       'size': 'MEDIUM',
// //       'weight_range': '3.5-5.5 kg',
// //       'temperament': 'Social, Vocal, Active',
// //     }, conflictAlgorithm: ConflictAlgorithm.ignore);
// //
// //     // Insert Reminder Categories
// //     await db.insert(tableReminderCategories, {
// //       'category_name': 'Medical',
// //       'color': '#FF5252',
// //       'icon': 'medical_services',
// //       'description': 'Medical and health-related reminders',
// //     }, conflictAlgorithm: ConflictAlgorithm.ignore);
// //
// //     await db.insert(tableReminderCategories, {
// //       'category_name': 'Food',
// //       'color': '#FF9800',
// //       'icon': 'restaurant',
// //       'description': 'Feeding schedule and nutrition',
// //     }, conflictAlgorithm: ConflictAlgorithm.ignore);
// //   }
// //
// //   // ==================== CRUD OPERATIONS ====================
// //
// //   // USERS CRUD
// //   Future<int> insertUser(Map<String, dynamic> user) async {
// //     Database db = await database;
// //     return await db.insert(tableUsers, user);
// //   }
// //
// //   Future<List<Map<String, dynamic>>> getAllUsers() async {
// //     Database db = await database;
// //     return await db.query(tableUsers);
// //   }
// //
// //   Future<Map<String, dynamic>?> getUserById(int id) async {
// //     Database db = await database;
// //     List<Map<String, dynamic>> result = await db.query(
// //       tableUsers,
// //       where: '$colId = ?',
// //       whereArgs: [id],
// //     );
// //     return result.isNotEmpty ? result.first : null;
// //   }
// //
// //   Future<int> updateUser(int id, Map<String, dynamic> user) async {
// //     Database db = await database;
// //     user[colUpdatedAt] = DateTime.now().toIso8601String();
// //     return await db.update(
// //       tableUsers,
// //       user,
// //       where: '$colId = ?',
// //       whereArgs: [id],
// //     );
// //   }
// //
// //   Future<int> deleteUser(int id) async {
// //     Database db = await database;
// //     return await db.delete(
// //       tableUsers,
// //       where: '$colId = ?',
// //       whereArgs: [id],
// //     );
// //   }
// //
// //   // PETS CRUD
// //   Future<int> insertPet(Map<String, dynamic> pet) async {
// //     Database db = await database;
// //     return await db.insert(tablePets, pet);
// //   }
// //
// //   Future<List<Map<String, dynamic>>> getAllPets() async {
// //     Database db = await database;
// //     return await db.query(tablePets);
// //   }
// //
// //   Future<List<Map<String, dynamic>>> getPetsByUser(int userId) async {
// //     Database db = await database;
// //     return await db.query(
// //       tablePets,
// //       where: '$colUserId = ?',
// //       whereArgs: [userId],
// //     );
// //   }
// //
// //   Future<Map<String, dynamic>?> getPetById(int id) async {
// //     Database db = await database;
// //     List<Map<String, dynamic>> result = await db.query(
// //       tablePets,
// //       where: '$colId = ?',
// //       whereArgs: [id],
// //     );
// //     return result.isNotEmpty ? result.first : null;
// //   }
// //
// //   Future<int> updatePet(int id, Map<String, dynamic> pet) async {
// //     Database db = await database;
// //     pet[colUpdatedAt] = DateTime.now().toIso8601String();
// //     return await db.update(
// //       tablePets,
// //       pet,
// //       where: '$colId = ?',
// //       whereArgs: [id],
// //     );
// //   }
// //
// //   Future<int> deletePet(int id) async {
// //     Database db = await database;
// //     return await db.delete(
// //       tablePets,
// //       where: '$colId = ?',
// //       whereArgs: [id],
// //     );
// //   }
// //
// //   // REMINDERS CRUD
// //   Future<int> insertReminder(Map<String, dynamic> reminder) async {
// //     Database db = await database;
// //     return await db.insert(tableReminders, reminder);
// //   }
// //
// //   Future<List<Map<String, dynamic>>> getAllReminders() async {
// //     Database db = await database;
// //     return await db.query(tableReminders);
// //   }
// //
// //   Future<List<Map<String, dynamic>>> getRemindersByPet(int petId) async {
// //     Database db = await database;
// //     return await db.query(
// //       tableReminders,
// //       where: '$colPetId = ?',
// //       whereArgs: [petId],
// //       orderBy: colDueDatetime,
// //     );
// //   }
// //
// //   Future<List<Map<String, dynamic>>> getUpcomingReminders() async {
// //     Database db = await database;
// //     return await db.rawQuery('''
// //       SELECT r.*, p.$colPetName as pet_name, rc.category_name, rc.color as category_color
// //       FROM $tableReminders r
// //       JOIN $tablePets p ON r.$colPetId = p.$colId
// //       JOIN $tableReminderCategories rc ON r.$colCategoryId = rc.$colId
// //       WHERE r.$colIsCompleted = 0
// //       AND r.$colDueDatetime > datetime('now')
// //       ORDER BY r.$colDueDatetime
// //     ''');
// //   }
// //
// //   Future<int> completeReminder(int id) async {
// //     Database db = await database;
// //     return await db.update(
// //       tableReminders,
// //       {
// //         colIsCompleted: 1,
// //         colCompletedAt: DateTime.now().toIso8601String(),
// //         colUpdatedAt: DateTime.now().toIso8601String(),
// //       },
// //       where: '$colId = ?',
// //       whereArgs: [id],
// //     );
// //   }
// //
// //   // MEDICAL RECORDS CRUD
// //   Future<int> insertMedicalRecord(Map<String, dynamic> record) async {
// //     Database db = await database;
// //     return await db.insert(tableMedicalRecords, record);
// //   }
// //
// //   Future<List<Map<String, dynamic>>> getMedicalRecordsByPet(int petId) async {
// //     Database db = await database;
// //     return await db.query(
// //       tableMedicalRecords,
// //       where: '$colPetId = ?',
// //       whereArgs: [petId],
// //       orderBy: 'administered_date DESC',
// //     );
// //   }
// //
// //   // VET VISITS CRUD
// //   Future<int> insertVetVisit(Map<String, dynamic> visit) async {
// //     Database db = await database;
// //     return await db.insert(tableVetVisits, visit);
// //   }
// //
// //   Future<List<Map<String, dynamic>>> getVetVisitsByPet(int petId) async {
// //     Database db = await database;
// //     return await db.query(
// //       tableVetVisits,
// //       where: '$colPetId = ?',
// //       whereArgs: [petId],
// //       orderBy: 'visit_date DESC',
// //     );
// //   }
// //
// //   // FEEDING SCHEDULE CRUD
// //   Future<int> insertFeedingSchedule(Map<String, dynamic> schedule) async {
// //     Database db = await database;
// //     return await db.insert(tableFeedingSchedule, schedule);
// //   }
// //
// //   Future<List<Map<String, dynamic>>> getFeedingScheduleByPet(int petId) async {
// //     Database db = await database;
// //     return await db.query(
// //       tableFeedingSchedule,
// //       where: '$colPetId = ?',
// //       whereArgs: [petId],
// //       orderBy: 'scheduled_time',
// //     );
// //   }
// //
// //   // ACTIVITY LOGS CRUD
// //   Future<int> insertActivityLog(Map<String, dynamic> log) async {
// //     Database db = await database;
// //     return await db.insert(tableActivityLogs, log);
// //   }
// //
// //   Future<List<Map<String, dynamic>>> getActivityLogsByPet(int petId) async {
// //     Database db = await database;
// //     return await db.query(
// //       tableActivityLogs,
// //       where: '$colPetId = ?',
// //       whereArgs: [petId],
// //       orderBy: 'started_at DESC',
// //     );
// //   }
// //
// //   // APPOINTMENTS CRUD
// //   Future<int> insertAppointment(Map<String, dynamic> appointment) async {
// //     Database db = await database;
// //     return await db.insert(tableAppointments, appointment);
// //   }
// //
// //   Future<List<Map<String, dynamic>>> getAppointmentsByPet(int petId) async {
// //     Database db = await database;
// //     return await db.query(
// //       tableAppointments,
// //       where: '$colPetId = ?',
// //       whereArgs: [petId],
// //       orderBy: 'scheduled_datetime',
// //     );
// //   }
// //
// //   // ==================== UTILITY METHODS ====================
// //
// //   Future<Map<String, dynamic>> getDashboardStats() async {
// //     Database db = await database;
// //
// //     Map<String, dynamic> stats = {};
// //
// //     // Total users
// //     var usersResult = await db.rawQuery('SELECT COUNT(*) as count FROM $tableUsers');
// //     stats['totalUsers'] = usersResult.first['count'];
// //
// //     // Total pets
// //     var petsResult = await db.rawQuery('SELECT COUNT(*) as count FROM $tablePets');
// //     stats['totalPets'] = petsResult.first['count'];
// //
// //     // Total reminders
// //     var remindersResult = await db.rawQuery('SELECT COUNT(*) as count FROM $tableReminders');
// //     stats['totalReminders'] = remindersResult.first['count'];
// //
// //     // Pending reminders
// //     var pendingResult = await db.rawQuery(
// //         'SELECT COUNT(*) as count FROM $tableReminders WHERE $colIsCompleted = 0'
// //     );
// //     stats['pendingReminders'] = pendingResult.first['count'];
// //
// //     // Pets by species
// //     var speciesResult = await db.rawQuery('''
// //       SELECT $colSpecies, COUNT(*) as count
// //       FROM $tablePets
// //       GROUP BY $colSpecies
// //     ''');
// //     stats['petsBySpecies'] = speciesResult;
// //
// //     return stats;
// //   }
// //
// //   Future<void> resetDatabase() async {
// //     Database db = await database;
// //     await db.execute('DROP TABLE IF EXISTS $tableFavouriteBreeds');
// //     await db.execute('DROP TABLE IF EXISTS $tableScanResults');
// //     await db.execute('DROP TABLE IF EXISTS $tableScanHistory');
// //     await db.execute('DROP TABLE IF EXISTS $tableAppointments');
// //     await db.execute('DROP TABLE IF EXISTS $tableActivityLogs');
// //     await db.execute('DROP TABLE IF EXISTS $tableFeedingLogs');
// //     await db.execute('DROP TABLE IF EXISTS $tableFeedingSchedule');
// //     await db.execute('DROP TABLE IF EXISTS $tableVetVisits');
// //     await db.execute('DROP TABLE IF EXISTS $tableMedicalRecords');
// //     await db.execute('DROP TABLE IF EXISTS $tableHygieneLogs');
// //     await db.execute('DROP TABLE IF EXISTS $tableReminders');
// //     await db.execute('DROP TABLE IF EXISTS $tableReminderCategories');
// //     await db.execute('DROP TABLE IF EXISTS $tablePetPhotos');
// //     await db.execute('DROP TABLE IF EXISTS $tablePets');
// //     await db.execute('DROP TABLE IF EXISTS $tableBreeds');
// //     await db.execute('DROP TABLE IF EXISTS $tableUsers');
// //
// //     // Recreate tables
// //     await _onCreate(db, _databaseVersion);
// //   }
// //
// //   Future<void> close() async {
// //     Database db = await database;
// //     await db.close();
// //   }
// //
// //
// //
// //   // Add these methods to your DatabaseHelper class
// //
// // // CLEANING LOGS CRUD (add this table first)
// //   Future<int> insertCleaningLog(Map<String, dynamic> log) async {
// //     Database db = await database;
// //     return await db.insert('cleaning_logs', log);
// //   }
// //
// //   Future<List<Map<String, dynamic>>> getCleaningLogsByPet(int petId) async {
// //     Database db = await database;
// //     return await db.query(
// //       'cleaning_logs',
// //       where: 'pet_id = ?',
// //       whereArgs: [petId],
// //       orderBy: 'cleaned_at DESC',
// //     );
// //   }
// //
// //   Future<int> updateCleaningLog(int id, Map<String, dynamic> log) async {
// //     Database db = await database;
// //     return await db.update(
// //       'cleaning_logs',
// //       log,
// //       where: 'id = ?',
// //       whereArgs: [id],
// //     );
// //   }
// //
// //   Future<int> deleteCleaningLog(int id) async {
// //     Database db = await database;
// //     return await db.delete(
// //       'cleaning_logs',
// //       where: 'id = ?',
// //       whereArgs: [id],
// //     );
// //   }
// //
// // // Additional reminder methods
// //   Future<int> updateReminder(int id, Map<String, dynamic> reminder) async {
// //     Database db = await database;
// //     reminder['updated_at'] = DateTime.now().toIso8601String();
// //     return await db.update(
// //       'reminders',
// //       reminder,
// //       where: 'id = ?',
// //       whereArgs: [id],
// //     );
// //   }
// //
// //   Future<int> deleteReminder(int id) async {
// //     Database db = await database;
// //     return await db.delete(
// //       'reminders',
// //       where: 'id = ?',
// //       whereArgs: [id],
// //     );
// //   }
// //
// //
// //
// // }
// //
// // // import 'dart:async';
// // // import 'dart:io';
// // // import 'package:path/path.dart';
// // // import 'package:path_provider/path_provider.dart';
// // // import 'package:sqflite/sqflite.dart';
// // //
// // // class DatabaseHelper {
// // //   static final DatabaseHelper _instance = DatabaseHelper._internal();
// // //   factory DatabaseHelper() => _instance;
// // //   DatabaseHelper._internal();
// // //
// // //   static Database? _database;
// // //   final String _databaseName = 'petcare.db';
// // //   final int _databaseVersion = 1;
// // //
// // //   // Table names
// // //   final String tableUsers = 'users';
// // //   final String tableBreeds = 'breeds';
// // //   final String tablePets = 'pets';
// // //   final String tableReminders = 'reminders';
// // //   final String tableMedicalRecords = 'medical_records';
// // //   final String tableVetVisits = 'vet_visits';
// // //   final String tableFeedingSchedule = 'feeding_schedule';
// // //   final String tableFeedingLogs = 'feeding_logs';
// // //   final String tableActivityLogs = 'activity_logs';
// // //   final String tableAppointments = 'appointments';
// // //
// // //   // Get database path on Desktop/sqlite folder
// // //   Future<String> get _databasePath async {
// // //     // For mobile: use app documents directory
// // //     if (Platform.isAndroid || Platform.isIOS) {
// // //       Directory documentsDirectory = await getApplicationDocumentsDirectory();
// // //       return join(documentsDirectory.path, _databaseName);
// // //     }
// // //     // For desktop/web: create sqlite folder on desktop
// // //     else {
// // //       // Get desktop path
// // //       String desktopPath;
// // //       if (Platform.isWindows) {
// // //         desktopPath = Platform.environment['USERPROFILE']! + '\\Desktop';
// // //       } else if (Platform.isMacOS || Platform.isLinux) {
// // //         desktopPath = Platform.environment['HOME']! + '/Desktop';
// // //       } else {
// // //         desktopPath = (await getApplicationDocumentsDirectory()).path;
// // //       }
// // //
// // //       // Create sqlite folder if it doesn't exist
// // //       String sqliteFolder = join(desktopPath, 'sqlite');
// // //       Directory(sqliteFolder).createSync(recursive: true);
// // //
// // //       return join(sqliteFolder, _databaseName);
// // //     }
// // //   }
// // //
// // //   Future<Database> get database async {
// // //     if (_database != null) return _database!;
// // //     _database = await _initDatabase();
// // //     return _database!;
// // //   }
// // //
// // //   Future<Database> _initDatabase() async {
// // //     String path = await _databasePath;
// // //     print('Database path: $path');
// // //
// // //     return await openDatabase(
// // //       path,
// // //       version: _databaseVersion,
// // //       onCreate: _onCreate,
// // //       onConfigure: (db) async {
// // //         await db.execute('PRAGMA foreign_keys = ON');
// // //       },
// // //     );
// // //   }
// // //
// // //   Future<void> _onCreate(Database db, int version) async {
// // //     // Create all tables from the SQL script
// // //     await _createTables(db);
// // //   }
// // //
// // //   Future<void> _createTables(Database db) async {
// // //     // Users table
// // //     await db.execute('''
// // //       CREATE TABLE IF NOT EXISTS $tableUsers (
// // //         id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //         username TEXT UNIQUE NOT NULL,
// // //         email TEXT UNIQUE NOT NULL,
// // //         password TEXT NOT NULL,
// // //         full_name TEXT,
// // //         phone_number TEXT,
// // //         address TEXT,
// // //         profile_image TEXT,
// // //         created_at TEXT DEFAULT CURRENT_TIMESTAMP,
// // //         updated_at TEXT DEFAULT CURRENT_TIMESTAMP
// // //       )
// // //     ''');
// // //
// // //     // Breeds table
// // //     await db.execute('''
// // //       CREATE TABLE IF NOT EXISTS $tableBreeds (
// // //         id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //         name TEXT NOT NULL,
// // //         species TEXT CHECK(species IN ('DOG', 'CAT', 'BIRD', 'RABBIT', 'OTHER')),
// // //         size TEXT CHECK(size IN ('SMALL', 'MEDIUM', 'LARGE', 'GIANT')),
// // //         weight_range TEXT,
// // //         height_range TEXT,
// // //         life_expectancy TEXT,
// // //         coat_type TEXT,
// // //         colors TEXT,
// // //         temperament TEXT,
// // //         description TEXT,
// // //         image_url TEXT
// // //       )
// // //     ''');
// // //
// // //     // Pets table
// // //     await db.execute('''
// // //       CREATE TABLE IF NOT EXISTS $tablePets (
// // //         id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //         user_id INTEGER NOT NULL,
// // //         name TEXT NOT NULL,
// // //         species TEXT CHECK(species IN ('DOG', 'CAT', 'BIRD', 'RABBIT', 'OTHER')),
// // //         breed_id INTEGER,
// // //         custom_breed TEXT,
// // //         birth_date TEXT,
// // //         adoption_date TEXT,
// // //         gender TEXT CHECK(gender IN ('MALE', 'FEMALE', 'UNKNOWN')),
// // //         weight REAL,
// // //         weight_unit TEXT CHECK(weight_unit IN ('KG', 'LBS')) DEFAULT 'KG',
// // //         color TEXT,
// // //         microchip_id TEXT UNIQUE,
// // //         spayed_neutered INTEGER DEFAULT 0,
// // //         health_notes TEXT,
// // //         behavior_notes TEXT,
// // //         created_at TEXT DEFAULT CURRENT_TIMESTAMP,
// // //         updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
// // //         FOREIGN KEY (user_id) REFERENCES $tableUsers(id) ON DELETE CASCADE,
// // //         FOREIGN KEY (breed_id) REFERENCES $tableBreeds(id) ON DELETE SET NULL
// // //       )
// // //     ''');
// // //
// // //     // Reminders table
// // //     await db.execute('''
// // //       CREATE TABLE IF NOT EXISTS $tableReminders (
// // //         id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //         pet_id INTEGER NOT NULL,
// // //         category_id INTEGER NOT NULL,
// // //         subcategory TEXT,
// // //         title TEXT NOT NULL,
// // //         description TEXT,
// // //         due_datetime TEXT NOT NULL,
// // //         repeat_pattern TEXT CHECK(repeat_pattern IN ('NONE', 'DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY')) DEFAULT 'NONE',
// // //         repeat_interval INTEGER DEFAULT 1,
// // //         priority TEXT CHECK(priority IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')) DEFAULT 'MEDIUM',
// // //         is_completed INTEGER DEFAULT 0,
// // //         completed_at TEXT,
// // //         notes TEXT,
// // //         custom_data TEXT,
// // //         created_at TEXT DEFAULT CURRENT_TIMESTAMP,
// // //         updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
// // //         FOREIGN KEY (pet_id) REFERENCES $tablePets(id) ON DELETE CASCADE
// // //       )
// // //     ''');
// // //
// // //     // Medical Records table
// // //     await db.execute('''
// // //       CREATE TABLE IF NOT EXISTS $tableMedicalRecords (
// // //         id INTEGER PRIMARY KEY AUTOINCREMENT,
// // //         pet_id INTEGER NOT NULL,
// // //         record_type TEXT CHECK(record_type IN ('VACCINATION', 'MEDICATION', 'DEWORMING', 'ALLERGY', 'SURGERY', 'INJURY', 'CHRONIC_CONDITION')) NOT NULL,
// // //         subtype TEXT,
// // //         title TEXT NOT NULL,
// // //         administered_date TEXT NOT NULL,
// // //         next_due_date TEXT,
// // //         veterinarian TEXT,
// // //         clinic_name TEXT,
// // //         dosage TEXT,
// // //         medication_name TEXT,
// // //         frequency TEXT,
// // //         duration TEXT,
// // //         notes TEXT,
// // //         cost REAL,
// // //         created_at TEXT DEFAULT CURRENT_TIMESTAMP,
// // //         FOREIGN KEY (pet_id) REFERENCES $tablePets(id) ON DELETE CASCADE
// // //       )
// // //     ''');
// // //
// // //     // Create other tables similarly...
// // //     // Add the remaining table creation statements from the SQL script
// // //   }
// // //
// // //   // ====================
// // //   // CRUD Operations
// // //   // ====================
// // //
// // //   // User Operations
// // //   Future<int> insertUser(Map<String, dynamic> user) async {
// // //     Database db = await database;
// // //     return await db.insert(tableUsers, user);
// // //   }
// // //
// // //   Future<List<Map<String, dynamic>>> getAllUsers() async {
// // //     Database db = await database;
// // //     return await db.query(tableUsers);
// // //   }
// // //
// // //   // Pet Operations
// // //   Future<int> insertPet(Map<String, dynamic> pet) async {
// // //     Database db = await database;
// // //     return await db.insert(tablePets, pet);
// // //   }
// // //
// // //   Future<List<Map<String, dynamic>>> getAllPets() async {
// // //     Database db = await database;
// // //     return await db.query(tablePets);
// // //   }
// // //
// // //   Future<List<Map<String, dynamic>>> getPetsByUser(int userId) async {
// // //     Database db = await database;
// // //     return await db.query(
// // //       tablePets,
// // //       where: 'user_id = ?',
// // //       whereArgs: [userId],
// // //     );
// // //   }
// // //
// // //   // Reminder Operations
// // //   Future<int> insertReminder(Map<String, dynamic> reminder) async {
// // //     Database db = await database;
// // //     return await db.insert(tableReminders, reminder);
// // //   }
// // //
// // //   Future<List<Map<String, dynamic>>> getUpcomingReminders() async {
// // //     Database db = await database;
// // //     return await db.rawQuery('''
// // //       SELECT r.*, p.name as pet_name
// // //       FROM $tableReminders r
// // //       JOIN $tablePets p ON r.pet_id = p.id
// // //       WHERE r.is_completed = 0
// // //       AND r.due_datetime > datetime('now')
// // //       ORDER BY r.due_datetime ASC
// // //     ''');
// // //   }
// // //
// // //   // Medical Records Operations
// // //   Future<int> insertMedicalRecord(Map<String, dynamic> record) async {
// // //     Database db = await database;
// // //     return await db.insert(tableMedicalRecords, record);
// // //   }
// // //
// // //   Future<List<Map<String, dynamic>>> getMedicalRecordsByPet(int petId) async {
// // //     Database db = await database;
// // //     return await db.query(
// // //       tableMedicalRecords,
// // //       where: 'pet_id = ?',
// // //       whereArgs: [petId],
// // //       orderBy: 'administered_date DESC',
// // //     );
// // //   }
// // //
// // //   // Statistics
// // //   Future<Map<String, dynamic>> getDashboardStats() async {
// // //     Database db = await database;
// // //
// // //     Map<String, dynamic> stats = {};
// // //
// // //     // Total pets
// // //     var petsResult = await db.rawQuery('SELECT COUNT(*) as count FROM $tablePets');
// // //     stats['totalPets'] = petsResult.first['count'];
// // //
// // //     // Total reminders
// // //     var remindersResult = await db.rawQuery('SELECT COUNT(*) as count FROM $tableReminders');
// // //     stats['totalReminders'] = remindersResult.first['count'];
// // //
// // //     // Pending reminders
// // //     var pendingResult = await db.rawQuery(
// // //         'SELECT COUNT(*) as count FROM $tableReminders WHERE is_completed = 0'
// // //     );
// // //     stats['pendingReminders'] = pendingResult.first['count'];
// // //
// // //     // Pets by species
// // //     var speciesResult = await db.rawQuery('''
// // //       SELECT species, COUNT(*) as count
// // //       FROM $tablePets
// // //       GROUP BY species
// // //     ''');
// // //     stats['petsBySpecies'] = speciesResult;
// // //
// // //     return stats;
// // //   }
// // //
// // //   // Import existing database from desktop
// // //   Future<void> importFromDesktop() async {
// // //     String desktopPath;
// // //     if (Platform.isWindows) {
// // //       desktopPath = Platform.environment['USERPROFILE']! + '\\Desktop\\sqlite\\petcare.db';
// // //     } else {
// // //       desktopPath = Platform.environment['HOME']! + '/Desktop/sqlite/petcare.db';
// // //     }
// // //
// // //     File sourceFile = File(desktopPath);
// // //     if (await sourceFile.exists()) {
// // //       String dbPath = await _databasePath;
// // //       await sourceFile.copy(dbPath);
// // //       print('Database imported from desktop');
// // //     } else {
// // //       print('No database found on desktop');
// // //     }
// // //   }
// // //
// // //   // Export database to desktop
// // //   Future<void> exportToDesktop() async {
// // //     String desktopPath;
// // //     if (Platform.isWindows) {
// // //       desktopPath = Platform.environment['USERPROFILE']! + '\\Desktop\\sqlite\\petcare_backup.db';
// // //     } else {
// // //       desktopPath = Platform.environment['HOME']! + '/Desktop/sqlite/petcare_backup.db';
// // //     }
// // //
// // //     String dbPath = await _databasePath;
// // //     File sourceFile = File(dbPath);
// // //     if (await sourceFile.exists()) {
// // //       await sourceFile.copy(desktopPath);
// // //       print('Database exported to desktop');
// // //     }
// // //   }
// // //
// // //   // Close database
// // //   Future<void> close() async {
// // //     Database db = await database;
// // //     await db.close();
// // //   }
// // // }