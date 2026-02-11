
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/config/components/roundButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../View_model/DocumentViewModel.dart';

import '../../l10n/app_localizations.dart';
import 'Document.dart';

class DocumentsScreen extends StatefulWidget {
  final String? selectedPetId;
  const DocumentsScreen({Key? key, this.selectedPetId}) : super(key: key);

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _categorySearchController = TextEditingController();

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
    _categorySearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  title: AppLocalizations.of(context)!.addDocument,
                  isSelected: true,
                  backgroundColors: AppColors.vibrantPurple,
                  textColors: Colors.white,
                  onPress: () {
                    final viewModel = Provider.of<DocumentViewModel>(
                      context,
                      listen: false,
                    );
                    viewModel.pickAndUploadFile(context, petId: widget.selectedPetId);
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
    // Filter documents by pet ID
    final filteredDocs = viewModel.filteredDocuments.where((doc) {
      if (widget.selectedPetId != null) {
        return doc.petId == widget.selectedPetId;
      }
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 46.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: InkWell(
            onTap: () => _showCategoryBottomSheet(
              context,
              viewModel,
              _categorySearchController,
            ),
            borderRadius: BorderRadius.circular(16.r),
            child: Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Icon(
                    _getCategoryIcon(viewModel.selectedCategory),
                    size: 18.sp,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    viewModel.selectedCategory == 'All'
                      ? AppLocalizations.of(context)!.catAll
                      : viewModel.selectedCategory,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 20.sp,
                  color: Theme.of(context).hintColor,
                ),
              ],
            ),
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
                  _getLocalizedCategory(context, viewModel.selectedCategory),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.documentCount(filteredDocs.length),
                  style: TextStyle(fontSize: 14.sp, color: Theme.of(context).hintColor),
                ),
              ],
            ),
          ),
        SizedBox(height: 12.h),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: filteredDocs.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                    },
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filteredDocs.length,
                      separatorBuilder: (_, __) => Divider(
                        color: Theme.of(context).dividerColor,
                        height: 0,
                        thickness: 1,
                        indent: 0.w,
                      ),
                      itemBuilder: (context, index) {
                        final doc = filteredDocs[index];
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
                    color: Theme.of(context).disabledColor,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    _searchController.text.isEmpty
                        ? AppLocalizations.of(context)!.noDocumentsFound
                        : AppLocalizations.of(context)!.noMatchingDocuments,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    _searchController.text.isEmpty
                        ? AppLocalizations.of(context)!.uploadFirstDocument
                        : AppLocalizations.of(context)!.tryDifferentSearchTerm,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).disabledColor,
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
          color: Theme.of(context).colorScheme.error,
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
          SnackBar(
            content: Text(AppLocalizations.of(context)!.documentDeleted),
            backgroundColor: Theme.of(context).colorScheme.error,
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
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getIconColor(doc.fileType),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      doc.icon,
                      size: 24.sp,
                      color: _getIconColor(doc.fileType),
                    ),
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
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        doc.fileName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Theme.of(context).hintColor,
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
                  color: Theme.of(context).hintColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getLocalizedCategory(BuildContext context, String category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case 'Medical & Care':
        return l10n.catMedicalCare;
      case 'Legal & Licensing':
        return l10n.catLegalLicensing;
      case 'Coverage & Finance':
        return l10n.catCoverageFinance;
      case 'Learning & Behavior':
        return l10n.catLearningBehavior;
      case 'Transit & Boarding':
        return l10n.catTransitBoarding;
      case 'Critical & Support':
        return l10n.catCriticalSupport;
      case 'Bloodline and stock':
        return l10n.catBloodlineStock;
      case 'Nutrition and intake':
        return l10n.catNutritionIntake;
      case 'Maintenance and look':
        return l10n.catMaintenanceLook;
      case 'Other Documents':
        return l10n.catOtherDocuments;
      case 'All':
        return l10n.catAll;
      default:
        return category;
    }
  }

  // Helper methods
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Medical & Care':
        return Icons.vaccines;
      case 'Legal & Licensing':
        return Icons.assignment;
      case 'Coverage & Finance':
        return Icons.health_and_safety;
      case 'Learning & Behavior':
        return Icons.school;
      case 'Transit & Boarding':
        return Icons.travel_explore;
      case 'Critical & Support':
        return Icons.emergency;
      case 'Bloodline and stock':
        return Icons.biotech;
      case 'Nutrition and intake':
        return Icons.restaurant;
      case 'Maintenance and look':
        return Icons.pets;
      case 'Other Documents':
        return Icons.insert_drive_file;
      case 'All':
      default:
        return Icons.all_inclusive;
    }
  }

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

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    final l10n = AppLocalizations.of(context)!;

    if (difference.inDays == 0) {
      return l10n.today;
    } else if (difference.inDays == 1) {
      return l10n.yesterday;
    } else if (difference.inDays < 7) {
      return l10n.daysAgoShort(difference.inDays);
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return l10n.weeksAgo(weeks);
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  // Bottom Sheet and Dialogs
  void _showCategoryBottomSheet(
      BuildContext context,
      DocumentViewModel viewModel,
      TextEditingController searchController,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        final allCategories = List<String>.from(viewModel.categories);
        String searchQuery = '';
        searchController.text = '';

        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredCategories = allCategories
                .where(
                  (category) => category
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()),
                )
                .toList();

            return SizedBox(
              height: 720.h,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    Container(
                      width: 40.w,
                      height: 4.h,
                      margin: EdgeInsets.only(bottom: 12.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    Container(
                      height: 44.h,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            size: 20.sp,
                            color: Theme.of(context).hintColor,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              onChanged: (value) {
                                setModalState(() {
                                  searchQuery = value;
                                });
                              },
                              decoration: InputDecoration(
                                isCollapsed: true,
                                border: InputBorder.none,
                                hintText: AppLocalizations.of(context)!.searchPlaceholder,
                                hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              textInputAction: TextInputAction.search,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          itemCount: filteredCategories.length,
                          separatorBuilder: (context, index) => Divider(
                            color: Theme.of(context).dividerColor,
                            height: 0,
                            thickness: 1,
                            indent: 0.w,
                          ),
                          itemBuilder: (context, index) {
                            final category = filteredCategories[index];
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
                                    vertical: 10.h,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 32.w,
                                        height: 32.h,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context).cardColor,
                                        ),
                                        child: Icon(
                                          _getCategoryIcon(category),
                                          size: 18.sp,
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Text(
                                          _getLocalizedCategory(context, category),
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context).colorScheme.onSurface,
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
                    ),

                  ],
                ),
              ),
            );
          },
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
                leading: const Icon(Icons.open_in_new, color: AppColors.vibrantPurple),
                title: Text(AppLocalizations.of(context)!.openDocument, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.openDocument(doc);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.blue),
                title: Text(AppLocalizations.of(context)!.viewDetails, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                onTap: () {
                  Navigator.pop(context);
                  _showDocumentDetails(context, doc);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.orange),
                title: Text(AppLocalizations.of(context)!.editDocument, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                onTap: () {
                  Navigator.pop(context);
                  _showEditDialog(context, viewModel, doc);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                title: Text(AppLocalizations.of(context)!.deleteDocument, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
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
        backgroundColor: Theme.of(context).cardColor,
        title: Text(AppLocalizations.of(context)!.deleteDocument, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        content: Text(AppLocalizations.of(context)!.deleteDocumentConfirmation(title), style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.dialogCancel, style: TextStyle(color: Theme.of(context).hintColor)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.dialogDelete, style: TextStyle(color: Theme.of(context).colorScheme.error)),
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
        backgroundColor: Theme.of(context).cardColor,
        title: Text(AppLocalizations.of(context)!.deleteDocument, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        content: Text(AppLocalizations.of(context)!.deleteDocumentConfirmation(doc.title), style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.dialogCancel, style: TextStyle(color: Theme.of(context).hintColor)),
          ),
          TextButton(
            onPressed: () {
              viewModel.deleteDocument(doc.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.documentDeletedSuccess),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            },
            child: Text(AppLocalizations.of(context)!.dialogDelete, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  void _showDocumentDetails(BuildContext context, Document doc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(AppLocalizations.of(context)!.documentDetails, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(doc.icon, color: _getIconColor(doc.fileType)),
                title: Text(doc.title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                subtitle: Text(doc.fileName, style: TextStyle(color: Theme.of(context).hintColor)),
              ),
              const Divider(),
              _buildDetailItem(AppLocalizations.of(context)!.category, _getLocalizedCategory(context, doc.category)),
              _buildDetailItem(AppLocalizations.of(context)!.fileType, doc.fileType.toUpperCase()),
              _buildDetailItem(AppLocalizations.of(context)!.fileSize, doc.fileSize),
              _buildDetailItem(AppLocalizations.of(context)!.uploadDate, _formatFullDate(doc.uploadDate)),
              _buildDetailItem(
                AppLocalizations.of(context)!.filePath,
                doc.filePath.isEmpty ? AppLocalizations.of(context)!.notSavedLocally : doc.filePath,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: Theme.of(context).colorScheme.onSurface),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: 14.sp, color: Theme.of(context).colorScheme.onSurface)),
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
            backgroundColor: Theme.of(context).cardColor,
            title: Text(AppLocalizations.of(context)!.editDocument, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.documentTitle,
                      labelStyle: TextStyle(color: Theme.of(context).hintColor),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor)),
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.vibrantPurple)),
                    ),
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  ),
                  SizedBox(height: 16.h),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.category,
                      labelStyle: TextStyle(color: Theme.of(context).hintColor),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor)),
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.vibrantPurple)),
                    ),
                    dropdownColor: Theme.of(context).cardColor,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    items: viewModel.categories
                        .where((cat) => cat != 'All')
                        .map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(_getLocalizedCategory(context, category), style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
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
                child: Text(AppLocalizations.of(context)!.dialogCancel, style: TextStyle(color: Theme.of(context).hintColor)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.vibrantPurple),
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
                        content: Text(AppLocalizations.of(context)!.documentUpdatedSuccess),
                        backgroundColor: AppColors.vibrantPurple,
                      ),
                    );
                  }
                },
                child: Text(AppLocalizations.of(context)!.save, style: const TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }
}


