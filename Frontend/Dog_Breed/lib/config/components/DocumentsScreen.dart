import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/config/components/roundButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../View_model/DocumentViewModel.dart';

import 'Document.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({Key? key}) : super(key: key);

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final viewModel = Provider.of<DocumentViewModel>(context, listen: false);
    viewModel.searchDocuments(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Consumer<DocumentViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return _buildDocumentsList(context, viewModel);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: RoundButton(
                  title: 'Add Document',
                  isSelected: true,
                  backgroundColors: AppColors.vibrantPurple,
                  textColors: Colors.white,
                  onPress: () {
                    final viewModel = Provider.of<DocumentViewModel>(
                      context,
                      listen: false,
                    );
                    viewModel.pickAndUploadFile(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildDocumentsList(
      BuildContext context,
      DocumentViewModel viewModel,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(Icons.category, size: 20.sp, color: Colors.black54),
              SizedBox(width: 12.w),
              Expanded(
                child: InkWell(
                  onTap: () => _showCategoryBottomSheet(context, viewModel),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          viewModel.selectedCategory,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: viewModel.selectedCategory == 'All'
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 20.sp,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        if (viewModel.selectedCategory != 'All')
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  viewModel.selectedCategory,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '${viewModel.filteredDocuments.length} documents',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
              ],
            ),
          ),
        SizedBox(height: 12.h),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7F6),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: viewModel.filteredDocuments.isNotEmpty
                ? RefreshIndicator(
              onRefresh: () async {
                await viewModel.refresh();
              },
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: viewModel.filteredDocuments.length,
                separatorBuilder: (_, __) =>
                    Divider(
                        height: 1.h,
                        thickness: 0.2,
                        indent: 0,
                        color: const Color(0xFF686868)
                    ),
                itemBuilder: (context, index) {
                  final doc = viewModel.filteredDocuments[index];
                  return _buildDocumentItem(context, viewModel, doc);
                },
              ),
            )
                : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_open,
                    size: 64.sp,
                    color: Colors.grey.shade200,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    _searchController.text.isEmpty
                        ? 'No documents found'
                        : 'No matching documents',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    _searchController.text.isEmpty
                        ? 'Tap + to upload your first document'
                        : 'Try a different search term',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade200,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentItem(
      BuildContext context,
      DocumentViewModel viewModel,
      Document doc,
      ) {
    return Dismissible(
      key: Key(doc.id),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12.r),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        child: Icon(Icons.delete, color: Colors.white, size: 24.sp),
      ),
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmation(context, doc.title);
      },
      onDismissed: (direction) {
        viewModel.deleteDocument(doc.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Document deleted'),
            backgroundColor: Colors.red,
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () => viewModel.openDocument(doc),
          onLongPress: () => _showDocumentOptions(context, viewModel, doc),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: _getIconColor(doc.fileType),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(doc.icon, size: 24.sp, color: Colors.white),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        doc.fileName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18.sp,
                  color: Colors.black45,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods
  Color _getIconColor(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Colors.red.shade400;
      case 'doc':
      case 'docx':
        return Colors.blue.shade400;
      case 'xls':
      case 'xlsx':
        return Colors.green.shade400;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Colors.purple.shade400;
      default:
        return Colors.orange.shade400;
    }
  }

  Color _getFileTypeColor(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getShortCategory(String category) {
    final words = category.split(' ');
    if (words.length > 1) {
      return words.map((word) => word[0]).join();
    }
    return category.length > 3 ? category.substring(0, 3) : category;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  // Bottom Sheet and Dialogs
  void _showCategoryBottomSheet(
      BuildContext context,
      DocumentViewModel viewModel,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Text(
                'Select Category',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: viewModel.categories.length,
                  itemBuilder: (context, index) {
                    final category = viewModel.categories[index];
                    final isSelected = category == viewModel.selectedCategory;
                    final count = category == 'All'
                        ? viewModel.documents.length
                        : viewModel.getDocumentsByCategory(category).length;

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          viewModel.filterByCategory(category);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(0xFF820DFF).withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12.r),
                            border: isSelected
                                ? Border.all(color: Color(0xFF820DFF), width: 1)
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? Color(0xFF820DFF)
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Color(0xFF820DFF)
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  count.toString(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        );
      },
    );
  }

  void _showDocumentOptions(
      BuildContext context,
      DocumentViewModel viewModel,
      Document doc,
      ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.open_in_new, color: Color(0xFF820DFF)),
                title: Text('Open Document'),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.openDocument(doc);
                },
              ),
              ListTile(
                leading: Icon(Icons.info, color: Colors.blue),
                title: Text('View Details'),
                onTap: () {
                  Navigator.pop(context);
                  _showDocumentDetails(context, doc);
                },
              ),
              ListTile(
                leading: Icon(Icons.edit, color: Colors.orange),
                title: Text('Edit Document'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditDialog(context, viewModel, doc);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete Document'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDeleteDocument(context, viewModel, doc);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _showDeleteConfirmation(
      BuildContext context,
      String title,
      ) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Document'),
        content: Text('Are you sure you want to delete "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ??
        false;
  }

  void _confirmDeleteDocument(
      BuildContext context,
      DocumentViewModel viewModel,
      Document doc,
      ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Document'),
        content: Text('Are you sure you want to delete "${doc.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              viewModel.deleteDocument(doc.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Document deleted successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDocumentDetails(BuildContext context, Document doc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Document Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(doc.icon),
                title: Text(doc.title),
                subtitle: Text(doc.fileName),
              ),
              Divider(),
              _buildDetailItem('Category', doc.category),
              _buildDetailItem('File Type', doc.fileType.toUpperCase()),
              _buildDetailItem('File Size', doc.fileSize),
              _buildDetailItem('Upload Date', _formatFullDate(doc.uploadDate)),
              _buildDetailItem(
                'File Path',
                doc.filePath.isEmpty ? 'Not saved locally' : doc.filePath,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showEditDialog(
      BuildContext context,
      DocumentViewModel viewModel,
      Document doc,
      ) {
    final titleController = TextEditingController(text: doc.title);
    String? selectedCategory = doc.category;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Edit Document'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Document Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: viewModel.categories
                        .where((cat) => cat != 'All')
                        .map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    })
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      selectedCategory != null) {
                    final updatedDoc = doc.copyWith(
                      title: titleController.text,
                      category: selectedCategory!,
                    );
                    viewModel.updateDocument(updatedDoc);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Document updated successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }
}
