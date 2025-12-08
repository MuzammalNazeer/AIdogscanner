// feedback_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({Key? key}) : super(key: key);

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  String? _selectedIssue;
  final TextEditingController _detailsController = TextEditingController();

  final List<String> _issues = [
    'Lagging Issue',
    'App Crashes',
    'Too Many Ads',
    'Other Problem',
    "Doesn't Work",
  ];

  void _submitFeedback() {
    if (_selectedIssue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an issue')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thank you for your feedback!')),
    );

    // Optional: Navigate back or reset form
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Feedback',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             SizedBox(height: 20.h),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3D4FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.chat_bubble_outline,
                      size: 40,
                      color: Color(0xFF9C27B0),
                    ),
                  ),
                   SizedBox(height: 24.h),
                  const Text(
                    "Could You Describe The Issue\nYou're Experiencing",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
             SizedBox(height: 40.h),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _issues.map((issue) {
                final bool isSelected = _selectedIssue == issue;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIssue = issue;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFE3D4FF) : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF9C27B0) : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      issue,
                      style: TextStyle(
                        color: isSelected ? const Color(0xFF9C27B0) : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

             SizedBox(height: 40.h),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F5FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _detailsController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Please Tell Us More Details...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
             SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}