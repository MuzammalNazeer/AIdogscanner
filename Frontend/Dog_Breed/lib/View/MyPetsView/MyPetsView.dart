import 'package:dog_breed/Valid/AppColors.dart';
import 'package:dog_breed/config/components/pet_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../View_model/PetProvider.dart';
import '../../View_model/activity_provider.dart';
import '../../View_model/ReminderNotifier.dart';
import '../../View_model/DocumentViewModel.dart';
import '../../View_model/home/Pet.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/routes/routes_name.dart';

class Mypetsview extends StatefulWidget {
  final void Function(String message)? onShowSnackBar;

  const Mypetsview({super.key, this.onShowSnackBar});

  @override
  State<Mypetsview> createState() => _MypetsviewState();
}

class _MypetsviewState extends State<Mypetsview> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load pets when the view initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final petProvider = Provider.of<PetProvider>(context, listen: false);
      if (petProvider.pets.isEmpty) {
        petProvider.loadPets();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final activityNotifier = Provider.of<ActivityNotifier>(context);
    final l10n = AppLocalizations.of(context)!;
    final pets = petProvider.pets;

    // Get activities - check the actual type from your ActivityNotifier
    final allActivities = activityNotifier.activities;

    final filteredPets = _searchQuery.isEmpty
        ? pets
        : pets.where((pet) =>
    pet.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (pet.breed.toLowerCase()).contains(_searchQuery.toLowerCase())
    ).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_pet_button',
        onPressed: () {
          Navigator.pushNamed(
            context,
            RoutesName.edit,
            arguments: {
              'isEditing': false, // This is for adding a new pet
            },
          );
        },
        backgroundColor: AppColors.vibrantPurple,
        elevation: 8,
        shape: const CircleBorder(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 32.sp,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      l10n.myPetsTitle,
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w400,
                        fontSize: 29.75.sp,
                        color: const Color(0xFF272727),
                      ),
                    ),
                  ),
                ),
                if (pets.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: PopupMenuButton<String>(
                      icon: Container(
                        height: 41.h,
                        width: 41.w,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F6F3),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.more_vert,
                            color: Color(0xFF272727),
                          ),
                        ),
                      ),
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      onSelected: (value) {
                        if (value == 'deleteAll') {
                          _showDeleteAllDialog(l10n);
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'deleteAll',
                          child: Text(
                            l10n.deleteAll,
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontSize: 16.sp,
                              color: const Color(0xFF371B34),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: CupertinoSearchTextField(
                placeholder: l10n.searchForDog,
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    CupertinoIcons.search,
                    color: Colors.black,
                    size: 32.h,
                  ),
                ),
                padding:  EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 22.h,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Expanded(
              child: pets.isEmpty
                  ? _buildEmptyState(l10n)
                  : filteredPets.isEmpty
                  ? _buildNoResultsState(l10n)
                  : _buildPetsList(filteredPets, allActivities, l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            'assets/images/pet.png',
            height: 85.h,
            width: 85.w,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          l10n.noPetsAdded,
          style: TextStyle(
            fontSize: 18.sp,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        // SizedBox(height: 20.h),
        // RoundButton(
        //   height: 51.h,
        //   width: 150.w,
        //   isSelected: true,
        //   title: l10n.addPetButton,
        //   backgroundColors: AppColors.vibrantPurple,
        //   textColors: Colors.white,
        //   onPress: () {
        //     Navigator.pushNamed(
        //       context,
        //       RoutesName.edit,
        //       arguments: {'isEditing': false},
        //     );
        //   },
        // ),
      ],
    );
  }

  Widget _buildNoResultsState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 60.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            l10n.noPetsMatch,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.tryDifferentSearch,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetsList(List<Pet> pets, List<dynamic> allActivities, AppLocalizations l10n) {
    return RefreshIndicator(
      onRefresh: () async {
        final petProvider = Provider.of<PetProvider>(context, listen: false);
        await petProvider.loadPets();
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount: pets.length,
        itemBuilder: (context, index) {
          final pet = pets[index];

          // Filter activities for this specific pet
          // Check the actual structure of your activity objects
          final petActivities = allActivities.where((activity) {
            // Try different property names based on your Activity model
            if (activity is Map) {
              return activity['petId'] == pet.id ||
                  activity['pet_id'] == pet.id;
            } else {
              // Try to access petId property dynamically
            try {
              return activity.petId == pet.id ||
                  activity.pet_id == pet.id ||
                  activity.pet?.id == pet.id;
            } catch (e) {
              return false;
            }
            }

          }).toList();

          // Count activities by type
          final Map<String, int> activityCounts = {};
          for (var activity in petActivities) {
            String? activityName;

            if (activity is Map) {
              activityName = activity['name'] ?? activity['type'];
            } else {
              try {
              activityName = activity.name ?? activity.type;
            } catch (e) {
              activityName = l10n.unknown;
            }
            }


            if (activityName != null) {
              activityCounts[activityName] = (activityCounts[activityName] ?? 0) + 1;
            }
          }

          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: PetCard(
              key: ValueKey('pet_${pet.id}_${pet.name}_${pet.imageBytes?.hashCode ?? 0}'),
              imageUrl: (pet.imageUrl != null && pet.imageUrl!.isNotEmpty)
                  ? pet.imageUrl
                  : _getPetImage(index),
              imageBytes: pet.imageBytes,
              name: pet.name,
              petId: pet.id,
              activityCounts: activityCounts,
              onEditPressed: () {
                _navigateToEditPet(pet, l10n);
              },
              onDeletePressed: () {
                _showDeleteDialog(pet, l10n);
              },
            ),
          );
        },
      ),
    );
  }

  String _getPetImage(int index) {
    final images = [
      'assets/images/Ellipse 77 (2).png',
      'assets/images/Ellipse 77 (1).png',
      'assets/images/Ellipse 77.png',
    ];
    return images[index % images.length];
  }

  void _navigateToEditPet(Pet pet, AppLocalizations l10n) {
    Navigator.pushNamed(
      context,
      RoutesName.edit,
      arguments: {
        'isEditing': true,
        'petName': pet.name,
        'petId': pet.id,
        'imageBytes': pet.imageBytes,
        'imageUrl': pet.imageUrl,
      },
    ).then((value) {
      // This callback runs when returning from edit screen
      if (value == true) {
        // Pet was updated, force refresh just in case
        setState(() {});
        if (widget.onShowSnackBar != null) {
          widget.onShowSnackBar!(l10n.petUpdatedSuccess);
        }
      }
    });
  }

  void _showDeleteAllDialog(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAll),
        backgroundColor: Colors.white,
        content: Text(l10n.deleteAllPetsConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () async {
              final petProvider = Provider.of<PetProvider>(context, listen: false);
              final activityNotifier = Provider.of<ActivityNotifier>(context, listen: false);
              final reminderNotifier = Provider.of<ReminderNotifier>(context, listen: false);
              final documentViewModel = Provider.of<DocumentViewModel>(context, listen: false);

              // Clear all related data
              activityNotifier.clear();
              await reminderNotifier.cancelAllReminders();
              await documentViewModel.clearAllDocuments();

              final success = await petProvider.clearPets();
              if (success) {
                if (widget.onShowSnackBar != null) {
                  widget.onShowSnackBar!(l10n.petDeletedSuccess("All pets"));
                }
              }
              Navigator.pop(context);
            },
            child: Text(
              l10n.deleteButton,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // Optional: Add a method to handle pet deletion
  void _showDeleteDialog(Pet pet, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deletePetTitle),
        backgroundColor: Colors.white,
        content: Text(l10n.deletePetMessage(pet.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () async {
              final petProvider = Provider.of<PetProvider>(context, listen: false);
              final activityNotifier = Provider.of<ActivityNotifier>(context, listen: false);
              final reminderNotifier = Provider.of<ReminderNotifier>(context, listen: false);
              final documentViewModel = Provider.of<DocumentViewModel>(context, listen: false);

              // Delete related data first
              if (pet.id != null) {
                activityNotifier.deleteActivitiesForPet(pet.id!);
                await reminderNotifier.cancelRemindersForPet(pet.id!);
                await documentViewModel.deleteDocumentsForPet(pet.id!);
              }

              final success = await petProvider.deletePet(pet.id!); // Add null check
              if (success) {
                if (widget.onShowSnackBar != null) {
                  widget.onShowSnackBar!(l10n.petDeletedSuccess(pet.name));
                }
              } else {
                if (widget.onShowSnackBar != null) {
                  widget.onShowSnackBar!(l10n.petDeleteFailed(pet.name));
                }
              }
              Navigator.pop(context);
            },
            child: Text(
              l10n.deleteButton,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
