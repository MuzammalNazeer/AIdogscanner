package spring_dog_backend.spring_dog_backend.service;

import spring_dog_backend.spring_dog_backend.dto.request.MedicalRecordRequest;
import spring_dog_backend.spring_dog_backend.dto.response.MedicalRecordResponse;
import spring_dog_backend.spring_dog_backend.model.MedicalRecord.RecordType;
import java.util.List;

public interface MedicalRecordService {

    MedicalRecordResponse createMedicalRecord(MedicalRecordRequest request);
    MedicalRecordResponse getMedicalRecordById(Long id);
    List<MedicalRecordResponse> getAllMedicalRecords();
    List<MedicalRecordResponse> getMedicalRecordsByPetId(Long petId);
    List<MedicalRecordResponse> getMedicalRecordsByRecordType(RecordType recordType);
    List<MedicalRecordResponse> getMedicalRecordsByPetAndType(Long petId, RecordType recordType);
    List<MedicalRecordResponse> getUpcomingDueRecords(int daysAhead);
    List<MedicalRecordResponse> getDueRecords();
    MedicalRecordResponse updateMedicalRecord(Long id, MedicalRecordRequest request);
    void deleteMedicalRecord(Long id);
    List<MedicalRecordResponse> searchByVeterinarian(String veterinarian);
    List<MedicalRecordResponse> searchByClinic(String clinicName);
    List<MedicalRecordResponse> searchByMedication(String medicationName, boolean exactMatch);
}