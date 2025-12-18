package spring_dog_backend.spring_dog_backend.service;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import spring_dog_backend.spring_dog_backend.dto.request.MedicalRecordRequest;
import spring_dog_backend.spring_dog_backend.dto.response.MedicalRecordResponse;
import spring_dog_backend.spring_dog_backend.exception.MedicalRecordNotFoundException;
import spring_dog_backend.spring_dog_backend.exception.PetNotFoundException;
import spring_dog_backend.spring_dog_backend.model.MedicalRecord;
import spring_dog_backend.spring_dog_backend.model.Pet;
import spring_dog_backend.spring_dog_backend.repository.MedicalRecordRepository;
import spring_dog_backend.spring_dog_backend.repository.PetRepository;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class MedicalRecordServiceImpl implements MedicalRecordService {

    private final MedicalRecordRepository medicalRecordRepository;
    private final PetRepository petRepository;

    @Override
    public MedicalRecordResponse createMedicalRecord(MedicalRecordRequest request) {
        log.info("Creating new medical record for pet ID: {}", request.getPetId());

        Pet pet = petRepository.findById(request.getPetId())
                .orElseThrow(() -> new PetNotFoundException(request.getPetId()));

        MedicalRecord medicalRecord = new MedicalRecord();
        mapRequestToEntity(request, medicalRecord);
        medicalRecord.setPet(pet);
        MedicalRecord savedRecord = medicalRecordRepository.save(medicalRecord);
        log.info("Medical record created with ID: {}", savedRecord.getId());
        return convertToResponse(savedRecord);
    }

    @Override
    public MedicalRecordResponse getMedicalRecordById(Long id) {
        log.info("Fetching medical record with ID: {}", id);

        MedicalRecord medicalRecord = medicalRecordRepository.findById(id)
                .orElseThrow(() -> new MedicalRecordNotFoundException(id));

        return convertToResponse(medicalRecord);
    }

    @Override
    public List<MedicalRecordResponse> getAllMedicalRecords() {
        log.info("Fetching all medical records");

        return medicalRecordRepository.findAll()
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    @Override
    public List<MedicalRecordResponse> getMedicalRecordsByPetId(Long petId) {
        log.info("Fetching medical records for pet ID: {}", petId);

        return medicalRecordRepository.findByPetId(petId)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    @Override
    public List<MedicalRecordResponse> getMedicalRecordsByRecordType(MedicalRecord.RecordType recordType) {
        log.info("Fetching medical records of type: {}", recordType);

        return medicalRecordRepository.findByRecordType(recordType)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    @Override
    public List<MedicalRecordResponse> getMedicalRecordsByPetAndType(Long petId, MedicalRecord.RecordType recordType) {
        log.info("Fetching medical records for pet ID: {} of type: {}", petId, recordType);

        return medicalRecordRepository.findByPetIdAndRecordType(petId, recordType)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

//    @Override
//    public List<MedicalRecordResponse> getUpcomingDueRecords(int daysAhead) {
//        LocalDate today = LocalDate.now();
//        LocalDate endDate = today.plusDays(daysAhead);
//
//        log.info("Fetching medical records due between {} and {}", today, endDate);
//
//        return medicalRecordRepository.findUpcomingDueRecords(today, endDate)
//                .stream()
//                .map(this::convertToResponse)
//                .collect(Collectors.toList());
//    }

    @Override
    public List<MedicalRecordResponse> getDueRecords() {
        LocalDate today = LocalDate.now();
        log.info("Fetching due medical records as of {}", today);

        return medicalRecordRepository.findDueRecords(today)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    @Override
    public MedicalRecordResponse updateMedicalRecord(Long id, MedicalRecordRequest request) {
        log.info("Updating medical record with ID: {}", id);

        MedicalRecord medicalRecord = medicalRecordRepository.findById(id)
                .orElseThrow(() -> new MedicalRecordNotFoundException(id));

        if (request.getPetId() != null && !request.getPetId().equals(medicalRecord.getPet().getId())) {
            Pet pet = petRepository.findById(request.getPetId())
                    .orElseThrow(() -> new PetNotFoundException(request.getPetId()));
            medicalRecord.setPet(pet);
        }

        mapRequestToEntity(request, medicalRecord);
        MedicalRecord updatedRecord = medicalRecordRepository.save(medicalRecord);

        log.info("Medical record updated with ID: {}", updatedRecord.getId());
        return convertToResponse(updatedRecord);
    }

    @Override
    public void deleteMedicalRecord(Long id) {
        log.info("Deleting medical record with ID: {}", id);

        if (!medicalRecordRepository.existsById(id)) {
            throw new MedicalRecordNotFoundException(id);
        }

        medicalRecordRepository.deleteById(id);
        log.info("Medical record deleted with ID: {}", id);
    }

    @Override
    public List<MedicalRecordResponse> searchByVeterinarian(String veterinarian) {
        log.info("Searching medical records by veterinarian: {}", veterinarian);

        return medicalRecordRepository.findByVeterinarianContainingIgnoreCase(veterinarian)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    @Override
    public List<MedicalRecordResponse> searchByClinic(String clinicName) {
        log.info("Searching medical records by clinic: {}", clinicName);

        return medicalRecordRepository.findByClinicNameContainingIgnoreCase(clinicName)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    @Override
    public List<MedicalRecordResponse> searchByMedication(String medicationName, boolean exactMatch) {
        log.info("Searching medical records by medication: {}", medicationName);

        return medicalRecordRepository.findByMedicationNameContainingIgnoreCase(medicationName)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<MedicalRecordResponse> getUpcomingDueRecords(int daysAhead) {
        log.info("Fetching upcoming due medical records for next {} days", daysAhead);

        LocalDate today = LocalDate.now();
        LocalDate futureDate = today.plusDays(daysAhead);

        log.info("Searching for records due between {} and {}", today, futureDate);

        List<MedicalRecord> records = medicalRecordRepository
                .findUpcomingDueRecords(today, futureDate);

        log.info("Found {} upcoming due records", records.size());

        return records.stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }
//    @Transactional(readOnly = true)
//    public List<MedicalRecordResponse> getUpcomingDueRecords(int daysAhead) {
//        log.info("=== 🔍 DEBUG: getUpcomingDueRecords() called ===");
//        log.info("📅 Searching for records due in next {} days", daysAhead);
//
//        LocalDate today = LocalDate.now();
//        LocalDate futureDate = today.plusDays(daysAhead);
//
//        log.info("📊 Date range: {} to {}", today, futureDate);
//        log.info("📍 Current time: {}", LocalDateTime.now());
//
//        // Debug: Log what dates we're looking for
//        log.info("🔍 Looking for records where nextDueDate BETWEEN {} AND {}", today, futureDate);
//
//        // First, let's check what's in the database
//        List<MedicalRecord> allRecords = medicalRecordRepository.findAll();
//        log.info("📋 Total records in database: {}", allRecords.size());
//
//        // Log each record with its due date
//        allRecords.forEach(record -> {
//            log.info("   Record ID: {}, Title: {}, NextDueDate: {}",
//                    record.getId(),
//                    record.getTitle(),
//                    record.getNextDueDate());
//        });
//
//        // Now run the actual query
//        List<MedicalRecord> records = medicalRecordRepository
//                .findUpcomingDueRecords(today, futureDate);
//
//        log.info("✅ Query found {} records", records.size());
//
//        // Log each found record
//        records.forEach(record -> {
//            long daysUntilDue = ChronoUnit.DAYS.between(today, record.getNextDueDate());
//            log.info("   Found: {} - Due: {} ({} days from today)",
//                    record.getTitle(),
//                    record.getNextDueDate(),
//                    daysUntilDue);
//        });
//
//        // Convert to response
//        return records.stream()
//                .map(this::convertToResponse)
//                .collect(Collectors.toList());
//    }
    private void mapRequestToEntity(MedicalRecordRequest request, MedicalRecord medicalRecord) {
        medicalRecord.setRecordType(request.getRecordType());
        medicalRecord.setSubtype(request.getSubtype());
        medicalRecord.setTitle(request.getTitle());
        medicalRecord.setAdministeredDate(request.getAdministeredDate());
        medicalRecord.setNextDueDate(request.getNextDueDate());
        medicalRecord.setVeterinarian(request.getVeterinarian());
        medicalRecord.setClinicName(request.getClinicName());
        medicalRecord.setDosage(request.getDosage());
        medicalRecord.setMedicationName(request.getMedicationName());
        medicalRecord.setFrequency(request.getFrequency());
        medicalRecord.setDuration(request.getDuration());
        medicalRecord.setNotes(request.getNotes());
        medicalRecord.setCost(request.getCost());
    }

    private MedicalRecordResponse convertToResponse(MedicalRecord medicalRecord) {
        MedicalRecordResponse response = new MedicalRecordResponse();
        response.setId(medicalRecord.getId());
        response.setPetId(medicalRecord.getPet().getId());
        response.setPetName(medicalRecord.getPet().getName());
        response.setRecordType(medicalRecord.getRecordType());
        response.setSubtype(medicalRecord.getSubtype());
        response.setTitle(medicalRecord.getTitle());
        response.setAdministeredDate(medicalRecord.getAdministeredDate());
        response.setNextDueDate(medicalRecord.getNextDueDate());
        response.setVeterinarian(medicalRecord.getVeterinarian());
        response.setClinicName(medicalRecord.getClinicName());
        response.setDosage(medicalRecord.getDosage());
        response.setMedicationName(medicalRecord.getMedicationName());
        response.setFrequency(medicalRecord.getFrequency());
        response.setDuration(medicalRecord.getDuration());
        response.setNotes(medicalRecord.getNotes());
        response.setCost(medicalRecord.getCost());
        response.setCreatedAt(medicalRecord.getCreatedAt());
        response.setUpdatedAt(medicalRecord.getUpdatedAt());
        return response;
    }
}