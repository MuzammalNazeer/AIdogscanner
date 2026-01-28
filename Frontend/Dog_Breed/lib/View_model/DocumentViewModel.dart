import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../config/components/Document.dart';
import '../l10n/app_localizations.dart';

class DocumentViewModel extends ChangeNotifier {
  List<Document> _documents = [];
  List<Document> _filteredDocuments = [];
  String _selectedCategory = 'All';
  bool _isLoading = false;
  final List<String> _categories = [
    'All',
    'Medical & Care',
    'Legal & Licensing',
    'Coverage & Finance',
    'Learning & Behavior',
    'Transit & Boarding',
    'Critical & Support',
    'Bloodline and stock',
    'Nutrition and intake',
    'Maintenance and look',
    'Other Documents',
  ];

  // Getters
  List<Document> get documents => List.unmodifiable(_documents);
  List<Document> get filteredDocuments => List.unmodifiable(_filteredDocuments);
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  List<String> get categories => List.unmodifiable(_categories);

  DocumentViewModel() {
    _initializeDocuments();
  }

  // Initialize and load documents
  Future<void> _initializeDocuments() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadDocumentsFromStorage();
      if (_documents.isEmpty) {
        await _createDefaultDocuments();
      }
      _filterDocuments();
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing documents: $e');
      }
      await _createDefaultDocuments();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load documents from SharedPreferences
  Future<void> _loadDocumentsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final documentsJson = prefs.getStringList('documents') ?? [];

    if (documentsJson.isNotEmpty) {
      _documents = documentsJson
          .map((json) => Document.fromJson(jsonDecode(json)))
          .toList();
    }
  }

  // Create default documents
  Future<void> _createDefaultDocuments() async {
    _documents = [
      Document(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Vaccination Records',
        fileName: 'vaccination_records.pdf',
        filePath: '',
        category: 'Medical & Care',
        uploadDate: DateTime.now(),
        fileSize: '2.5 MB',
        fileType: 'pdf',
        icon: Icons.vaccines,
      ),
      Document(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        title: 'Pet Insurance Policy',
        fileName: 'pet_insurance.pdf',
        filePath: '',
        category: 'Coverage & Finance',
        uploadDate: DateTime.now().subtract(const Duration(days: 1)),
        fileSize: '1.8 MB',
        fileType: 'pdf',
        icon: Icons.health_and_safety,
      ),
      Document(
        id: (DateTime.now().millisecondsSinceEpoch + 2).toString(),
        title: 'Adoption Certificate',
        fileName: 'adoption_certificate.pdf',
        filePath: '',
        category: 'Legal & Licensing',
        uploadDate: DateTime.now().subtract(const Duration(days: 2)),
        fileSize: '3.2 MB',
        fileType: 'pdf',
        icon: Icons.assignment,
      ),
      Document(
        id: (DateTime.now().millisecondsSinceEpoch + 3).toString(),
        title: 'Training Certificate',
        fileName: 'training_certificate.pdf',
        filePath: '',
        category: 'Learning & Behavior',
        uploadDate: DateTime.now().subtract(const Duration(days: 3)),
        fileSize: '1.5 MB',
        fileType: 'pdf',
        icon: Icons.school,
      ),
      Document(
        id: (DateTime.now().millisecondsSinceEpoch + 4).toString(),
        title: 'Medical Checkup Report',
        fileName: 'checkup_report.docx',
        filePath: '',
        category: 'Medical & Care',
        uploadDate: DateTime.now().subtract(const Duration(days: 4)),
        fileSize: '1.2 MB',
        fileType: 'docx',
        icon: Icons.medical_services,
      ),
    ];
    await _saveDocuments();
  }

  // Save documents to SharedPreferences
  Future<void> _saveDocuments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final documentsJson = _documents
          .map((doc) => jsonEncode(doc.toJson()))
          .toList();
      await prefs.setStringList('documents', documentsJson);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving documents: $e');
      }
    }
  }

  // Filter documents by category
  void filterByCategory(String category) {
    _selectedCategory = category;
    _filterDocuments();
    notifyListeners();
  }

  void _filterDocuments() {
    if (_selectedCategory == 'All') {
      _filteredDocuments = List.from(_documents);
    } else {
      _filteredDocuments = _documents
          .where((doc) => doc.category == _selectedCategory)
          .toList();
    }
  }

  // Pick and upload file
  Future<void> pickAndUploadFile(BuildContext context, {String? petId}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'jpg', 'jpeg', 'png', 'txt'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        // Get file size
        final fileSize = _formatFileSize(file.size);

        // Get file extension
        final extension = file.extension?.toLowerCase() ?? 'file';

        // Get icon based on file type
        final icon = _getIconForFileType(extension);

        // Show dialog for document details
        final document = await _showAddDocumentDialog(
          context,
          file.name,
          fileSize,
          extension,
          icon,
        );

        if (document != null) {
          // Save file to storage if path exists
          String? filePath;
          if (file.path != null) {
            filePath = await _saveFileToStorage(File(file.path!), file.name);
          }

          final newDocument = document.copyWith(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            filePath: filePath ?? '',
            petId: petId,
          );

          _documents.insert(0, newDocument);
          await _saveDocuments();
          _filterDocuments();
          notifyListeners();

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.documentUploadedSuccess),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: kBottomNavigationBarHeight + 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error picking file: $e');
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.documentUploadFailed(e.toString())),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: kBottomNavigationBarHeight + 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  // Save file to app storage
  Future<String> _saveFileToStorage(File file, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final appDocDir = Directory('${directory.path}/pet_documents');
      if (!await appDocDir.exists()) {
        await appDocDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = fileName.split('.').last;
      final newFileName = 'document_$timestamp.$extension';
      final newFilePath = '${appDocDir.path}/$newFileName';

      await file.copy(newFilePath);
      return newFilePath;
    } catch (e) {
      if (kDebugMode) {
        print('Error saving file: $e');
      }
      return '';
    }
  }

  // Get localized category name
  String getLocalizedCategory(BuildContext context, String category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case 'Medical & Care': return l10n.catMedicalCare;
      case 'Legal & Licensing': return l10n.catLegalLicensing;
      case 'Coverage & Finance': return l10n.catCoverageFinance;
      case 'Learning & Behavior': return l10n.catLearningBehavior;
      case 'Transit & Boarding': return l10n.catTransitBoarding;
      case 'Critical & Support': return l10n.catCriticalSupport;
      case 'Bloodline and stock': return l10n.catBloodlineStock;
      case 'Nutrition and intake': return l10n.catNutritionIntake;
      case 'Maintenance and look': return l10n.catMaintenanceLook;
      case 'Other Documents': return l10n.catOtherDocuments;
      case 'All': return l10n.catAll;
      default: return category;
    }
  }

  // Show dialog to add document details
  Future<Document?> _showAddDocumentDialog(
      BuildContext context,
      String fileName,
      String fileSize,
      String fileType,
      IconData icon,
      ) async {
    final titleController = TextEditingController(text: fileName.split('.').first);
    String? selectedCategory = 'Medical & Care';

    return showDialog<Document>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(AppLocalizations.of(context)!.addDocumentDetails),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.documentTitle,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  dropdownColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.category,
                    border: const OutlineInputBorder(),
                  ),
                  items: _categories
                      .where((cat) => cat != 'All')
                      .map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(getLocalizedCategory(context, category)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedCategory = value;
                  },
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: Icon(icon),
                  title: Text(fileName),
                  subtitle: Text('${AppLocalizations.of(context)!.fileSize}: $fileSize | ${AppLocalizations.of(context)!.fileType}: $fileType'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && selectedCategory != null) {
                  final document = Document(
                    id: '', // Will be set later
                    title: titleController.text,
                    fileName: fileName,
                    filePath: '', // Will be set later
                    category: selectedCategory!,
                    uploadDate: DateTime.now(),
                    fileSize: fileSize,
                    fileType: fileType,
                    icon: icon,
                  );
                  Navigator.pop(context, document);
                }
              },
              child: Text(AppLocalizations.of(context)!.addDocument),
            ),
          ],
        );
      },
    );
  }

  // Open document
  Future<void> openDocument(Document document) async {
    try {
      if (document.filePath.isNotEmpty) {
        await OpenFile.open(document.filePath);
      } else {
        if (kDebugMode) {
          print('Document path is empty');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error opening file: $e');
      }
    }
  }

  // Delete document
  Future<void> deleteDocument(String documentId) async {
    try {
      final document = _documents.firstWhere((doc) => doc.id == documentId);

      // Delete file from storage
      if (document.filePath.isNotEmpty) {
        final file = File(document.filePath);
        if (await file.exists()) {
          await file.delete();
        }
      }

      // Remove from list
      _documents.removeWhere((doc) => doc.id == documentId);
      await _saveDocuments();
      _filterDocuments();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting document: $e');
      }
    }
  }

  // Get icon for file type
  IconData _getIconForFileType(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      case 'txt':
        return Icons.text_fields;
      default:
        return Icons.insert_drive_file;
    }
  }

  // Format file size
  String _formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    int i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  // Clear all documents
  Future<void> clearAllDocuments() async {
    try {
      // Delete all files from storage
      for (final document in _documents) {
        if (document.filePath.isNotEmpty) {
          final file = File(document.filePath);
          if (await file.exists()) {
            await file.delete();
          }
        }
      }

      // Clear from memory and storage
      _documents.clear();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('documents');

      _filterDocuments();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing documents: $e');
      }
    }
  }

  // Get statistics
  Map<String, int> getDocumentStats() {
    final stats = <String, int>{};
    for (final doc in _documents) {
      stats[doc.category] = (stats[doc.category] ?? 0) + 1;
    }
    return stats;
  }

  // Search documents
  void searchDocuments(String query) {
    if (query.isEmpty) {
      _filterDocuments();
    } else {
      _filteredDocuments = _documents
          .where((doc) =>
      doc.title.toLowerCase().contains(query.toLowerCase()) ||
          doc.fileName.toLowerCase().contains(query.toLowerCase()) ||
          doc.category.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // Refresh documents
  Future<void> refresh() async {
    await _initializeDocuments();
  }

  // Get documents by category
  List<Document> getDocumentsByCategory(String category) {
    return _documents
        .where((doc) => doc.category == category)
        .toList();
  }

  // Update document
  Future<void> updateDocument(Document updatedDocument) async {
    final index = _documents.indexWhere((doc) => doc.id == updatedDocument.id);
    if (index != -1) {
      _documents[index] = updatedDocument;
      await _saveDocuments();
      _filterDocuments();
      notifyListeners();
    }
  }
}
