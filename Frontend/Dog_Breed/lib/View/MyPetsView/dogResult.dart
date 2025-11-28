import 'dart:io';
import 'package:flutter/material.dart';

class DogResultScreen extends StatelessWidget {
  final String breedName;
  final double confidence;
  final File image;

  const DogResultScreen({
    super.key,
    required this.breedName,
    required this.confidence,
    required this.image,
  });

  String _formatBreedName(String name) {
    return name.replaceAll('-', ' ').split(' ').map((word) =>
    word[0].toUpperCase() + word.substring(1)).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
              child: Image.file(image, fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              color: Color(0xFF2C1B3E),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                const Text(
                  "It's a",
                  style: TextStyle(color: Colors.white70, fontSize: 24),
                ),
                const SizedBox(height: 10),
                Text(
                  _formatBreedName(breedName),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  "${(confidence * 100).toStringAsFixed(1)}% Confidence",
                  style: const TextStyle(color: Color(0xFF9B59B6), fontSize: 20),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Scan Another Dog"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9B59B6),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}