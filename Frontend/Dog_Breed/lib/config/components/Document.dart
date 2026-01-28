import 'package:flutter/material.dart';

class Document {
  final String id;
  final String title;
  final String fileName;
  final String filePath;
  final String category;
  final DateTime uploadDate;
  final String fileSize;
  final String fileType;
  final IconData icon;

  final String? petId;

  Document({
    required this.id,
    required this.title,
    required this.fileName,
    required this.filePath,
    required this.category,
    required this.uploadDate,
    required this.fileSize,
    required this.fileType,
    required this.icon,
    this.petId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'fileName': fileName,
      'filePath': filePath,
      'category': category,
      'uploadDate': uploadDate.toIso8601String(),
      'fileSize': fileSize,
      'fileType': fileType,
      'icon': _iconToCode(icon),
      'petId': petId,
    };
  }

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      title: json['title'],
      fileName: json['fileName'],
      filePath: json['filePath'],
      category: json['category'],
      uploadDate: DateTime.parse(json['uploadDate']),
      fileSize: json['fileSize'],
      fileType: json['fileType'],
      icon: _codeToIcon(json['icon']),
      petId: json['petId'],
    );
  }

  static String _iconToCode(IconData icon) {
    if (icon == Icons.vaccines) return 'vaccines';
    if (icon == Icons.health_and_safety) return 'health_and_safety';
    if (icon == Icons.assignment) return 'assignment';
    if (icon == Icons.school) return 'school';
    if (icon == Icons.medical_services) return 'medical_services';
    if (icon == Icons.description) return 'description';
    if (icon == Icons.badge) return 'badge';
    if (icon == Icons.picture_as_pdf) return 'picture_as_pdf';
    if (icon == Icons.insert_drive_file) return 'insert_drive_file';
    if (icon == Icons.image) return 'image';
    if (icon == Icons.table_chart) return 'table_chart';
    return 'description';
  }

  static IconData _codeToIcon(String code) {
    switch (code) {
      case 'vaccines':
        return Icons.vaccines;
      case 'health_and_safety':
        return Icons.health_and_safety;
      case 'assignment':
        return Icons.assignment;
      case 'school':
        return Icons.school;
      case 'medical_services':
        return Icons.medical_services;
      case 'description':
        return Icons.description;
      case 'badge':
        return Icons.badge;
      case 'picture_as_pdf':
        return Icons.picture_as_pdf;
      case 'insert_drive_file':
        return Icons.insert_drive_file;
      case 'image':
        return Icons.image;
      case 'table_chart':
        return Icons.table_chart;
      default:
        return Icons.description;
    }
  }

  Document copyWith({
    String? id,
    String? title,
    String? fileName,
    String? filePath,
    String? category,
    DateTime? uploadDate,
    String? fileSize,
    String? fileType,
    IconData? icon,
    String? petId,
  }) {
    return Document(
      id: id ?? this.id,
      title: title ?? this.title,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      category: category ?? this.category,
      uploadDate: uploadDate ?? this.uploadDate,
      fileSize: fileSize ?? this.fileSize,
      fileType: fileType ?? this.fileType,
      icon: icon ?? this.icon,
      petId: petId ?? this.petId,
    );
  }
}