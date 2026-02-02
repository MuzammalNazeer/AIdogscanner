import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fi'),
    Locale('fr'),
    Locale('id'),
    Locale('it'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('sv'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Dog Breed'**
  String get appTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @appLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguageTitle;

  /// No description provided for @notificationLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Language'**
  String get notificationLanguageTitle;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @premiumSubscription.
  ///
  /// In en, this message translates to:
  /// **'Premium Subscription'**
  String get premiumSubscription;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @customerCare.
  ///
  /// In en, this message translates to:
  /// **'Customer Care'**
  String get customerCare;

  /// No description provided for @measurementUnits.
  ///
  /// In en, this message translates to:
  /// **'Measurement Units'**
  String get measurementUnits;

  /// No description provided for @supportAnimalIdProject.
  ///
  /// In en, this message translates to:
  /// **'Support Animal ID project'**
  String get supportAnimalIdProject;

  /// No description provided for @deleteOwnerProfile.
  ///
  /// In en, this message translates to:
  /// **'Delete owner profile'**
  String get deleteOwnerProfile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @dialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dialogCancel;

  /// No description provided for @dialogDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get dialogDelete;

  /// No description provided for @dialogDeleteProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete profile'**
  String get dialogDeleteProfileTitle;

  /// No description provided for @dialogDeleteProfileMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete your profile? This action cannot be undone.'**
  String get dialogDeleteProfileMessage;

  /// No description provided for @dialogLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get dialogLogoutTitle;

  /// No description provided for @dialogLogoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get dialogLogoutMessage;

  /// No description provided for @manager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get manager;

  /// No description provided for @splashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your Dog Daily Activity and Health'**
  String get splashSubtitle;

  /// No description provided for @startLikeAPro.
  ///
  /// In en, this message translates to:
  /// **'Start Like a Pro'**
  String get startLikeAPro;

  /// No description provided for @unlockAllFeatures.
  ///
  /// In en, this message translates to:
  /// **'Unlock All Features'**
  String get unlockAllFeatures;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @unlimitedDogScans.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Dog Scans'**
  String get unlimitedDogScans;

  /// No description provided for @supportedBreedDetection.
  ///
  /// In en, this message translates to:
  /// **'Supported Breed Detection'**
  String get supportedBreedDetection;

  /// No description provided for @multiplePetProfiles.
  ///
  /// In en, this message translates to:
  /// **'Multiple Pet Profiles'**
  String get multiplePetProfiles;

  /// No description provided for @removeAds.
  ///
  /// In en, this message translates to:
  /// **'Remove Ads'**
  String get removeAds;

  /// No description provided for @vipCustomerSupport.
  ///
  /// In en, this message translates to:
  /// **'VIP Customer Support'**
  String get vipCustomerSupport;

  /// No description provided for @trialOffer.
  ///
  /// In en, this message translates to:
  /// **'3 Days FREE Trial, after that Rs 2550/Week'**
  String get trialOffer;

  /// No description provided for @startFreeTrial.
  ///
  /// In en, this message translates to:
  /// **'START FREE TRIAL'**
  String get startFreeTrial;

  /// No description provided for @subscriptionDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to our Terms and Privacy Policy, subscription billed after trial ends and will renew automatically. Cancel subscription anytime before trial ends to avoid charges.'**
  String get subscriptionDisclaimer;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, '**
  String get welcomeBack;

  /// No description provided for @searchForDog.
  ///
  /// In en, this message translates to:
  /// **'Search for Dog'**
  String get searchForDog;

  /// No description provided for @tryPremiumFeatures.
  ///
  /// In en, this message translates to:
  /// **'Try Premium Features 🌵'**
  String get tryPremiumFeatures;

  /// No description provided for @premiumOfferDescription.
  ///
  /// In en, this message translates to:
  /// **'Claim your offer now and get unlimited recognition, health check and more'**
  String get premiumOfferDescription;

  /// No description provided for @getIt.
  ///
  /// In en, this message translates to:
  /// **'GET IT'**
  String get getIt;

  /// No description provided for @hygiene.
  ///
  /// In en, this message translates to:
  /// **'Hygiene'**
  String get hygiene;

  /// No description provided for @cleaning.
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get cleaning;

  /// No description provided for @medical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get medical;

  /// No description provided for @booking.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get booking;

  /// No description provided for @identifyDog.
  ///
  /// In en, this message translates to:
  /// **'Identify Dog'**
  String get identifyDog;

  /// No description provided for @identifyDogDescription.
  ///
  /// In en, this message translates to:
  /// **'Scan and identify your dog instantly using AI'**
  String get identifyDogDescription;

  /// No description provided for @scanNow.
  ///
  /// In en, this message translates to:
  /// **'Scan Now'**
  String get scanNow;

  /// No description provided for @vetVisits.
  ///
  /// In en, this message translates to:
  /// **'Vet Visits'**
  String get vetVisits;

  /// No description provided for @vetVisitsDescription.
  ///
  /// In en, this message translates to:
  /// **'Schedule check-ups and keep \n track of vet visits'**
  String get vetVisitsDescription;

  /// No description provided for @createVisit.
  ///
  /// In en, this message translates to:
  /// **'Create Visit'**
  String get createVisit;

  /// No description provided for @foodManagement.
  ///
  /// In en, this message translates to:
  /// **'Food Management'**
  String get foodManagement;

  /// No description provided for @foodManagementDescription.
  ///
  /// In en, this message translates to:
  /// **'Track meals and manage your \n pet\'s daily nutrition'**
  String get foodManagementDescription;

  /// No description provided for @checkSchedule.
  ///
  /// In en, this message translates to:
  /// **'Check Schedule'**
  String get checkSchedule;

  /// No description provided for @unknownBreed.
  ///
  /// In en, this message translates to:
  /// **'Unknown Breed'**
  String get unknownBreed;

  /// No description provided for @savedScanMessage.
  ///
  /// In en, this message translates to:
  /// **'✅ Saved: {breedName} ({confidence}% confidence)'**
  String savedScanMessage(Object breedName, Object confidence);

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorMessage(Object error);

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Satellite Director'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Explore Nearby Place with GPS Satellite\nMapping & Find Satellites'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'We Need Your\n Permission'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'We need camera permission so that you can take \nlive scans of your pet.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Maintain Image Quality'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Capture the whole body if possible. Head should be \nvisible.'**
  String get onboardingDesc3;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Ensure Your Dog Stays \n Healthy and Active.'**
  String get onboardingTitle4;

  /// No description provided for @onboardingDesc4.
  ///
  /// In en, this message translates to:
  /// **'Manage every detail of your dog—health, photos,\n activities and more in one simple place.'**
  String get onboardingDesc4;

  /// No description provided for @calendarTabActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get calendarTabActivities;

  /// No description provided for @calendarTabReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get calendarTabReminders;

  /// No description provided for @calendarTabProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get calendarTabProgress;

  /// No description provided for @calendarTabDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get calendarTabDocuments;

  /// No description provided for @calendarTabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get calendarTabSettings;

  /// No description provided for @activityVeterinary.
  ///
  /// In en, this message translates to:
  /// **'Veterinary'**
  String get activityVeterinary;

  /// No description provided for @activityPee.
  ///
  /// In en, this message translates to:
  /// **'Pee'**
  String get activityPee;

  /// No description provided for @activityEat.
  ///
  /// In en, this message translates to:
  /// **'Eat'**
  String get activityEat;

  /// No description provided for @activityDrink.
  ///
  /// In en, this message translates to:
  /// **'Drink'**
  String get activityDrink;

  /// No description provided for @activityPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get activityPlay;

  /// No description provided for @activityPoop.
  ///
  /// In en, this message translates to:
  /// **'Poop'**
  String get activityPoop;

  /// No description provided for @activityWalk.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get activityWalk;

  /// No description provided for @activityCrate.
  ///
  /// In en, this message translates to:
  /// **'Crate'**
  String get activityCrate;

  /// No description provided for @activitySleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get activitySleep;

  /// No description provided for @activityTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get activityTraining;

  /// No description provided for @activityTreat.
  ///
  /// In en, this message translates to:
  /// **'Treat'**
  String get activityTreat;

  /// No description provided for @activityGrooming.
  ///
  /// In en, this message translates to:
  /// **'Grooming'**
  String get activityGrooming;

  /// No description provided for @activityCleaning.
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get activityCleaning;

  /// No description provided for @activityMedication.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get activityMedication;

  /// No description provided for @activityVaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination'**
  String get activityVaccination;

  /// No description provided for @activityWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get activityWeight;

  /// No description provided for @activityHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get activityHeight;

  /// No description provided for @activityTemperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get activityTemperature;

  /// No description provided for @activityHealthCondition.
  ///
  /// In en, this message translates to:
  /// **'Health Condition'**
  String get activityHealthCondition;

  /// No description provided for @activityAccident.
  ///
  /// In en, this message translates to:
  /// **'Accident'**
  String get activityAccident;

  /// No description provided for @activityJournal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get activityJournal;

  /// No description provided for @calendarManage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get calendarManage;

  /// No description provided for @calendarMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get calendarMonth;

  /// No description provided for @calendarComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon...'**
  String get calendarComingSoon;

  /// No description provided for @calendarNoActivityLogged.
  ///
  /// In en, this message translates to:
  /// **'No Activity Logged'**
  String get calendarNoActivityLogged;

  /// No description provided for @calendarAddActivity.
  ///
  /// In en, this message translates to:
  /// **'Add Activity'**
  String get calendarAddActivity;

  /// No description provided for @progressTabCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get progressTabCalendar;

  /// No description provided for @progressTabChart.
  ///
  /// In en, this message translates to:
  /// **'Chart'**
  String get progressTabChart;

  /// No description provided for @progressTabCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get progressTabCompare;

  /// No description provided for @petSelectPet.
  ///
  /// In en, this message translates to:
  /// **'Select Pet'**
  String get petSelectPet;

  /// No description provided for @petNoPetSelected.
  ///
  /// In en, this message translates to:
  /// **'No Pet Selected'**
  String get petNoPetSelected;

  /// No description provided for @petNoPetSelectedOption.
  ///
  /// In en, this message translates to:
  /// **'No pet selected'**
  String get petNoPetSelectedOption;

  /// No description provided for @activityNote.
  ///
  /// In en, this message translates to:
  /// **'Note:'**
  String get activityNote;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @dialogDeleteActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Activity'**
  String get dialogDeleteActivityTitle;

  /// No description provided for @calendarHeatmapTab.
  ///
  /// In en, this message translates to:
  /// **'Heatmap'**
  String get calendarHeatmapTab;

  /// No description provided for @calendarTimelineTab.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get calendarTimelineTab;

  /// No description provided for @calendarActivityIntensity.
  ///
  /// In en, this message translates to:
  /// **'Activity Intensity'**
  String get calendarActivityIntensity;

  /// No description provided for @calendarErrorLoadingHeatmap.
  ///
  /// In en, this message translates to:
  /// **'Error loading heatmap'**
  String get calendarErrorLoadingHeatmap;

  /// No description provided for @calendarLegendNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get calendarLegendNone;

  /// No description provided for @calendarLegendLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get calendarLegendLow;

  /// No description provided for @calendarLegendMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get calendarLegendMedium;

  /// No description provided for @calendarLegendHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get calendarLegendHigh;

  /// No description provided for @calendarLegendNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get calendarLegendNow;

  /// No description provided for @calendarChartAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount in ml'**
  String get calendarChartAmount;

  /// No description provided for @calendarChartFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get calendarChartFrequency;

  /// No description provided for @calendarShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get calendarShare;

  /// No description provided for @calendarMostActiveDay.
  ///
  /// In en, this message translates to:
  /// **'Most Active Day'**
  String get calendarMostActiveDay;

  /// No description provided for @calendarMostActiveTime.
  ///
  /// In en, this message translates to:
  /// **'Most Active Time'**
  String get calendarMostActiveTime;

  /// No description provided for @dialogDeleteActivityContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{activityName}\"?'**
  String dialogDeleteActivityContent(Object activityName);

  /// No description provided for @dialogActionsRequired.
  ///
  /// In en, this message translates to:
  /// **'Actions Required'**
  String get dialogActionsRequired;

  /// No description provided for @dialogAddPetMessage.
  ///
  /// In en, this message translates to:
  /// **'Add at least one pet to start adding activities and reminders.'**
  String get dialogAddPetMessage;

  /// No description provided for @dialogGot_it.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get dialogGot_it;

  /// No description provided for @dialogGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get dialogGotIt;

  /// No description provided for @dayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get daySat;

  /// No description provided for @daySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get daySun;

  /// No description provided for @walkDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Walk?'**
  String get walkDeleteTitle;

  /// No description provided for @walkDeleteContent.
  ///
  /// In en, this message translates to:
  /// **'This will discard the current walk session.'**
  String get walkDeleteContent;

  /// No description provided for @walkCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get walkCancel;

  /// No description provided for @walkDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get walkDelete;

  /// No description provided for @walkStartTimerWarning.
  ///
  /// In en, this message translates to:
  /// **'Please start timer before saving.'**
  String get walkStartTimerWarning;

  /// No description provided for @walkNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get walkNote;

  /// No description provided for @walkNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Your notes here'**
  String get walkNoteHint;

  /// No description provided for @walkSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get walkSave;

  /// No description provided for @walkAddNote.
  ///
  /// In en, this message translates to:
  /// **'Add a note'**
  String get walkAddNote;

  /// No description provided for @walkDefaultName.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get walkDefaultName;

  /// No description provided for @walkLocationPermission.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required to track walks.'**
  String get walkLocationPermission;

  /// No description provided for @walkLocationService.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled.'**
  String get walkLocationService;

  /// No description provided for @reminderAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Reminder'**
  String get reminderAddTitle;

  /// No description provided for @reminderNone.
  ///
  /// In en, this message translates to:
  /// **'No Reminders'**
  String get reminderNone;

  /// No description provided for @reminderDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminderDefaultTitle;

  /// No description provided for @actionUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get actionUpdate;

  /// No description provided for @actionRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get actionRemove;

  /// No description provided for @errorUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update failed: {error}'**
  String errorUpdateFailed(Object error);

  /// No description provided for @errorUpdateNotFound.
  ///
  /// In en, this message translates to:
  /// **'Unable to update: Activity not found'**
  String get errorUpdateNotFound;

  /// No description provided for @durationHr.
  ///
  /// In en, this message translates to:
  /// **'hr'**
  String get durationHr;

  /// No description provided for @durationMin.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get durationMin;

  /// No description provided for @durationSec.
  ///
  /// In en, this message translates to:
  /// **'sec'**
  String get durationSec;

  /// No description provided for @pickerTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get pickerTakePhoto;

  /// No description provided for @pickerGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get pickerGallery;

  /// No description provided for @pickerRecordVideo.
  ///
  /// In en, this message translates to:
  /// **'Record Video'**
  String get pickerRecordVideo;

  /// No description provided for @errorSelectActivity.
  ///
  /// In en, this message translates to:
  /// **'Please select an activity first'**
  String get errorSelectActivity;

  /// No description provided for @errorReminderFuture.
  ///
  /// In en, this message translates to:
  /// **'Reminder time must be in the future'**
  String get errorReminderFuture;

  /// No description provided for @errorValidWeight.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid weight'**
  String get errorValidWeight;

  /// No description provided for @errorValidHeight.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid height'**
  String get errorValidHeight;

  /// No description provided for @errorValidTemp.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid temperature'**
  String get errorValidTemp;

  /// No description provided for @errorEnterFood.
  ///
  /// In en, this message translates to:
  /// **'Please enter food name or type'**
  String get errorEnterFood;

  /// No description provided for @successActivitySaved.
  ///
  /// In en, this message translates to:
  /// **'Activity saved successfully!'**
  String get successActivitySaved;

  /// No description provided for @successActivitySavedReminder.
  ///
  /// In en, this message translates to:
  /// **'Activity with reminder saved successfully!'**
  String get successActivitySavedReminder;

  /// No description provided for @errorSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed: {error}'**
  String errorSaveFailed(Object error);

  /// No description provided for @labelSelectedImage.
  ///
  /// In en, this message translates to:
  /// **'Selected Image:'**
  String get labelSelectedImage;

  /// No description provided for @labelSelectedVideo.
  ///
  /// In en, this message translates to:
  /// **'Selected Video:'**
  String get labelSelectedVideo;

  /// No description provided for @unitOz.
  ///
  /// In en, this message translates to:
  /// **'oz'**
  String get unitOz;

  /// No description provided for @unitMl.
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get unitMl;

  /// No description provided for @unitLbs.
  ///
  /// In en, this message translates to:
  /// **'lbs'**
  String get unitLbs;

  /// No description provided for @unitKg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get unitKg;

  /// No description provided for @unitInches.
  ///
  /// In en, this message translates to:
  /// **'inches'**
  String get unitInches;

  /// No description provided for @unitCm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get unitCm;

  /// No description provided for @unitF.
  ///
  /// In en, this message translates to:
  /// **'°F'**
  String get unitF;

  /// No description provided for @unitC.
  ///
  /// In en, this message translates to:
  /// **'°C'**
  String get unitC;

  /// No description provided for @unitKm.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get unitKm;

  /// No description provided for @unitMi.
  ///
  /// In en, this message translates to:
  /// **'mi'**
  String get unitMi;

  /// No description provided for @actionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add drink name or type'**
  String get actionAdd;

  /// No description provided for @actionAddImage.
  ///
  /// In en, this message translates to:
  /// **'+ Add Image'**
  String get actionAddImage;

  /// No description provided for @actionAddVideo.
  ///
  /// In en, this message translates to:
  /// **'+ Add Video'**
  String get actionAddVideo;

  /// No description provided for @hintAddNote.
  ///
  /// In en, this message translates to:
  /// **'Add note...'**
  String get hintAddNote;

  /// No description provided for @startedAt.
  ///
  /// In en, this message translates to:
  /// **'Started at'**
  String get startedAt;

  /// No description provided for @endedAt.
  ///
  /// In en, this message translates to:
  /// **'Ended at'**
  String get endedAt;

  /// No description provided for @noActivitySelected.
  ///
  /// In en, this message translates to:
  /// **'No activity selected'**
  String get noActivitySelected;

  /// No description provided for @actionAddTreat.
  ///
  /// In en, this message translates to:
  /// **'+ Add treat'**
  String get actionAddTreat;

  /// No description provided for @actionAddGrooming.
  ///
  /// In en, this message translates to:
  /// **'+ Add grooming type'**
  String get actionAddGrooming;

  /// No description provided for @actionAddMedication.
  ///
  /// In en, this message translates to:
  /// **'+ Add medication'**
  String get actionAddMedication;

  /// No description provided for @actionAddVaccination.
  ///
  /// In en, this message translates to:
  /// **'+ Add vaccination'**
  String get actionAddVaccination;

  /// No description provided for @actionAddHealthCondition.
  ///
  /// In en, this message translates to:
  /// **'+ Add health condition'**
  String get actionAddHealthCondition;

  /// No description provided for @actionAddAccident.
  ///
  /// In en, this message translates to:
  /// **'+ Add accident type'**
  String get actionAddAccident;

  /// No description provided for @actionAddCleaning.
  ///
  /// In en, this message translates to:
  /// **'+ Add cleaning type'**
  String get actionAddCleaning;

  /// No description provided for @actionAddVeterinary.
  ///
  /// In en, this message translates to:
  /// **'+ Add veterinary'**
  String get actionAddVeterinary;

  /// No description provided for @actionAddFood.
  ///
  /// In en, this message translates to:
  /// **'+ Add food name or type'**
  String get actionAddFood;

  /// No description provided for @actionStartTimer.
  ///
  /// In en, this message translates to:
  /// **'Or start a timer'**
  String get actionStartTimer;

  /// No description provided for @labelDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get labelDate;

  /// No description provided for @labelTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get labelTime;

  /// No description provided for @labelName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get labelName;

  /// No description provided for @hintEnterName.
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get hintEnterName;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @pickerSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get pickerSelectDate;

  /// No description provided for @pickerSelectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get pickerSelectTime;

  /// No description provided for @reminderSetFor.
  ///
  /// In en, this message translates to:
  /// **'Reminder set for {date} at {time}'**
  String reminderSetFor(String date, String time);

  /// No description provided for @myPetsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Pets'**
  String get myPetsTitle;

  /// No description provided for @noPetsAdded.
  ///
  /// In en, this message translates to:
  /// **'No pets added yet'**
  String get noPetsAdded;

  /// No description provided for @addPetButton.
  ///
  /// In en, this message translates to:
  /// **'+ Add pet'**
  String get addPetButton;

  /// No description provided for @noPetsMatch.
  ///
  /// In en, this message translates to:
  /// **'No pets match your search'**
  String get noPetsMatch;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearch;

  /// No description provided for @petUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Pet updated successfully!'**
  String get petUpdatedSuccess;

  /// No description provided for @deletePetTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete pet'**
  String get deletePetTitle;

  /// No description provided for @deletePetMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {petName}?'**
  String deletePetMessage(String petName);

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @petDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'{petName} deleted successfully'**
  String petDeletedSuccess(String petName);

  /// No description provided for @petDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete {petName}'**
  String petDeleteFailed(String petName);

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @genderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// No description provided for @editPetTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Pet'**
  String get editPetTitle;

  /// No description provided for @labelPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get labelPhoto;

  /// No description provided for @hintSelectBreed.
  ///
  /// In en, this message translates to:
  /// **'Select Breed'**
  String get hintSelectBreed;

  /// No description provided for @hintSearchBreed.
  ///
  /// In en, this message translates to:
  /// **'Search breed...'**
  String get hintSearchBreed;

  /// No description provided for @noBreedsFound.
  ///
  /// In en, this message translates to:
  /// **'No breeds found'**
  String get noBreedsFound;

  /// No description provided for @msgFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get msgFillAllFields;

  /// No description provided for @msgUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update pet'**
  String get msgUpdateFailed;

  /// No description provided for @msgAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add pet'**
  String get msgAddFailed;

  /// No description provided for @msgImagePickFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image: {error}'**
  String msgImagePickFailed(Object error);

  /// No description provided for @labelBreed.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get labelBreed;

  /// No description provided for @labelGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get labelGender;

  /// No description provided for @labelDOB.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get labelDOB;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @labelPetName.
  ///
  /// In en, this message translates to:
  /// **'Pet Name'**
  String get labelPetName;

  /// No description provided for @addPetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Pet'**
  String get addPetTitle;

  /// No description provided for @labelRequired.
  ///
  /// In en, this message translates to:
  /// **'(Required)'**
  String get labelRequired;

  /// No description provided for @hintEnterPetName.
  ///
  /// In en, this message translates to:
  /// **'Enter pet name'**
  String get hintEnterPetName;

  /// No description provided for @hintSelectGender.
  ///
  /// In en, this message translates to:
  /// **'Select gender'**
  String get hintSelectGender;

  /// No description provided for @errorSelectGender.
  ///
  /// In en, this message translates to:
  /// **'Please select gender'**
  String get errorSelectGender;

  /// No description provided for @errorFillRequired.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get errorFillRequired;

  /// No description provided for @errorRequired.
  ///
  /// In en, this message translates to:
  /// **'(Required)'**
  String get errorRequired;

  /// No description provided for @hintTapToScan.
  ///
  /// In en, this message translates to:
  /// **'Tap to scan or select'**
  String get hintTapToScan;

  /// No description provided for @msgBreedDetected.
  ///
  /// In en, this message translates to:
  /// **'Breed detected!'**
  String get msgBreedDetected;

  /// No description provided for @breedAffenpinscher.
  ///
  /// In en, this message translates to:
  /// **'Affenpinscher'**
  String get breedAffenpinscher;

  /// No description provided for @breedAfghanHound.
  ///
  /// In en, this message translates to:
  /// **'Afghan Hound'**
  String get breedAfghanHound;

  /// No description provided for @breedAfricanHuntingDog.
  ///
  /// In en, this message translates to:
  /// **'African Hunting Dog'**
  String get breedAfricanHuntingDog;

  /// No description provided for @breedAiredale.
  ///
  /// In en, this message translates to:
  /// **'Airedale'**
  String get breedAiredale;

  /// No description provided for @breedAmericanStaffordshireTerrier.
  ///
  /// In en, this message translates to:
  /// **'American Staffordshire Terrier'**
  String get breedAmericanStaffordshireTerrier;

  /// No description provided for @breedAppenzeller.
  ///
  /// In en, this message translates to:
  /// **'Appenzeller'**
  String get breedAppenzeller;

  /// No description provided for @breedAustralianTerrier.
  ///
  /// In en, this message translates to:
  /// **'Australian Terrier'**
  String get breedAustralianTerrier;

  /// No description provided for @breedBasenji.
  ///
  /// In en, this message translates to:
  /// **'Basenji'**
  String get breedBasenji;

  /// No description provided for @breedBasset.
  ///
  /// In en, this message translates to:
  /// **'Basset'**
  String get breedBasset;

  /// No description provided for @breedBeagle.
  ///
  /// In en, this message translates to:
  /// **'Beagle'**
  String get breedBeagle;

  /// No description provided for @breedBedlingtonTerrier.
  ///
  /// In en, this message translates to:
  /// **'Bedlington Terrier'**
  String get breedBedlingtonTerrier;

  /// No description provided for @breedBerneseMountainDog.
  ///
  /// In en, this message translates to:
  /// **'Bernese Mountain Dog'**
  String get breedBerneseMountainDog;

  /// No description provided for @breedBlackAndTanCoonhound.
  ///
  /// In en, this message translates to:
  /// **'Black-and-tan Coonhound'**
  String get breedBlackAndTanCoonhound;

  /// No description provided for @breedBlenheimSpaniel.
  ///
  /// In en, this message translates to:
  /// **'Blenheim Spaniel'**
  String get breedBlenheimSpaniel;

  /// No description provided for @breedBloodhound.
  ///
  /// In en, this message translates to:
  /// **'Bloodhound'**
  String get breedBloodhound;

  /// No description provided for @breedBluetick.
  ///
  /// In en, this message translates to:
  /// **'Bluetick'**
  String get breedBluetick;

  /// No description provided for @breedBorderCollie.
  ///
  /// In en, this message translates to:
  /// **'Border Collie'**
  String get breedBorderCollie;

  /// No description provided for @breedBorderTerrier.
  ///
  /// In en, this message translates to:
  /// **'Border Terrier'**
  String get breedBorderTerrier;

  /// No description provided for @breedBorzoi.
  ///
  /// In en, this message translates to:
  /// **'Borzoi'**
  String get breedBorzoi;

  /// No description provided for @breedBostonBull.
  ///
  /// In en, this message translates to:
  /// **'Boston Bull'**
  String get breedBostonBull;

  /// No description provided for @breedBouvierDesFlandres.
  ///
  /// In en, this message translates to:
  /// **'Bouvier Des Flandres'**
  String get breedBouvierDesFlandres;

  /// No description provided for @breedBoxer.
  ///
  /// In en, this message translates to:
  /// **'Boxer'**
  String get breedBoxer;

  /// No description provided for @breedBrabanconGriffon.
  ///
  /// In en, this message translates to:
  /// **'Brabancon Griffon'**
  String get breedBrabanconGriffon;

  /// No description provided for @breedBriard.
  ///
  /// In en, this message translates to:
  /// **'Briard'**
  String get breedBriard;

  /// No description provided for @breedBrittanySpaniel.
  ///
  /// In en, this message translates to:
  /// **'Brittany Spaniel'**
  String get breedBrittanySpaniel;

  /// No description provided for @breedBullMastiff.
  ///
  /// In en, this message translates to:
  /// **'Bull Mastiff'**
  String get breedBullMastiff;

  /// No description provided for @breedCairn.
  ///
  /// In en, this message translates to:
  /// **'Cairn'**
  String get breedCairn;

  /// No description provided for @breedCardigan.
  ///
  /// In en, this message translates to:
  /// **'Cardigan'**
  String get breedCardigan;

  /// No description provided for @breedChesapeakeBayRetriever.
  ///
  /// In en, this message translates to:
  /// **'Chesapeake Bay Retriever'**
  String get breedChesapeakeBayRetriever;

  /// No description provided for @breedChihuahua.
  ///
  /// In en, this message translates to:
  /// **'Chihuahua'**
  String get breedChihuahua;

  /// No description provided for @breedChow.
  ///
  /// In en, this message translates to:
  /// **'Chow'**
  String get breedChow;

  /// No description provided for @breedClumber.
  ///
  /// In en, this message translates to:
  /// **'Clumber'**
  String get breedClumber;

  /// No description provided for @breedCockerSpaniel.
  ///
  /// In en, this message translates to:
  /// **'Cocker Spaniel'**
  String get breedCockerSpaniel;

  /// No description provided for @breedCollie.
  ///
  /// In en, this message translates to:
  /// **'Collie'**
  String get breedCollie;

  /// No description provided for @breedCurlyCoatedRetriever.
  ///
  /// In en, this message translates to:
  /// **'Curly-coated Retriever'**
  String get breedCurlyCoatedRetriever;

  /// No description provided for @breedDandieDinmont.
  ///
  /// In en, this message translates to:
  /// **'Dandie Dinmont'**
  String get breedDandieDinmont;

  /// No description provided for @breedDhole.
  ///
  /// In en, this message translates to:
  /// **'Dhole'**
  String get breedDhole;

  /// No description provided for @breedDingo.
  ///
  /// In en, this message translates to:
  /// **'Dingo'**
  String get breedDingo;

  /// No description provided for @breedDoberman.
  ///
  /// In en, this message translates to:
  /// **'Doberman'**
  String get breedDoberman;

  /// No description provided for @breedEnglishFoxhound.
  ///
  /// In en, this message translates to:
  /// **'English Foxhound'**
  String get breedEnglishFoxhound;

  /// No description provided for @breedEnglishSetter.
  ///
  /// In en, this message translates to:
  /// **'English Setter'**
  String get breedEnglishSetter;

  /// No description provided for @breedEnglishSpringer.
  ///
  /// In en, this message translates to:
  /// **'English Springer'**
  String get breedEnglishSpringer;

  /// No description provided for @breedEntleBucher.
  ///
  /// In en, this message translates to:
  /// **'EntleBucher'**
  String get breedEntleBucher;

  /// No description provided for @breedEskimoDog.
  ///
  /// In en, this message translates to:
  /// **'Eskimo Dog'**
  String get breedEskimoDog;

  /// No description provided for @breedFlatCoatedRetriever.
  ///
  /// In en, this message translates to:
  /// **'Flat-coated Retriever'**
  String get breedFlatCoatedRetriever;

  /// No description provided for @breedFrenchBulldog.
  ///
  /// In en, this message translates to:
  /// **'French Bulldog'**
  String get breedFrenchBulldog;

  /// No description provided for @breedGermanShepherd.
  ///
  /// In en, this message translates to:
  /// **'German Shepherd'**
  String get breedGermanShepherd;

  /// No description provided for @breedGermanShortHairedPointer.
  ///
  /// In en, this message translates to:
  /// **'German Short-haired Pointer'**
  String get breedGermanShortHairedPointer;

  /// No description provided for @breedGiantSchnauzer.
  ///
  /// In en, this message translates to:
  /// **'Giant Schnauzer'**
  String get breedGiantSchnauzer;

  /// No description provided for @breedGoldenRetriever.
  ///
  /// In en, this message translates to:
  /// **'Golden Retriever'**
  String get breedGoldenRetriever;

  /// No description provided for @breedGordonSetter.
  ///
  /// In en, this message translates to:
  /// **'Gordon Setter'**
  String get breedGordonSetter;

  /// No description provided for @breedGreatDane.
  ///
  /// In en, this message translates to:
  /// **'Great Dane'**
  String get breedGreatDane;

  /// No description provided for @breedGreatPyrenees.
  ///
  /// In en, this message translates to:
  /// **'Great Pyrenees'**
  String get breedGreatPyrenees;

  /// No description provided for @breedGreaterSwissMountainDog.
  ///
  /// In en, this message translates to:
  /// **'Greater Swiss Mountain Dog'**
  String get breedGreaterSwissMountainDog;

  /// No description provided for @breedGroenendael.
  ///
  /// In en, this message translates to:
  /// **'Groenendael'**
  String get breedGroenendael;

  /// No description provided for @breedIbizanHound.
  ///
  /// In en, this message translates to:
  /// **'Ibizan Hound'**
  String get breedIbizanHound;

  /// No description provided for @breedIrishSetter.
  ///
  /// In en, this message translates to:
  /// **'Irish Setter'**
  String get breedIrishSetter;

  /// No description provided for @breedIrishTerrier.
  ///
  /// In en, this message translates to:
  /// **'Irish Terrier'**
  String get breedIrishTerrier;

  /// No description provided for @breedIrishWaterSpaniel.
  ///
  /// In en, this message translates to:
  /// **'Irish Water Spaniel'**
  String get breedIrishWaterSpaniel;

  /// No description provided for @breedIrishWolfhound.
  ///
  /// In en, this message translates to:
  /// **'Irish Wolfhound'**
  String get breedIrishWolfhound;

  /// No description provided for @breedItalianGreyhound.
  ///
  /// In en, this message translates to:
  /// **'Italian Greyhound'**
  String get breedItalianGreyhound;

  /// No description provided for @breedJapaneseSpaniel.
  ///
  /// In en, this message translates to:
  /// **'Japanese Spaniel'**
  String get breedJapaneseSpaniel;

  /// No description provided for @breedKeeshond.
  ///
  /// In en, this message translates to:
  /// **'Keeshond'**
  String get breedKeeshond;

  /// No description provided for @breedKelpie.
  ///
  /// In en, this message translates to:
  /// **'Kelpie'**
  String get breedKelpie;

  /// No description provided for @breedKerryBlueTerrier.
  ///
  /// In en, this message translates to:
  /// **'Kerry Blue Terrier'**
  String get breedKerryBlueTerrier;

  /// No description provided for @breedKomondor.
  ///
  /// In en, this message translates to:
  /// **'Komondor'**
  String get breedKomondor;

  /// No description provided for @breedKuvasz.
  ///
  /// In en, this message translates to:
  /// **'Kuvasz'**
  String get breedKuvasz;

  /// No description provided for @breedLabradorRetriever.
  ///
  /// In en, this message translates to:
  /// **'Labrador Retriever'**
  String get breedLabradorRetriever;

  /// No description provided for @breedLakelandTerrier.
  ///
  /// In en, this message translates to:
  /// **'Lakeland Terrier'**
  String get breedLakelandTerrier;

  /// No description provided for @breedLeonberg.
  ///
  /// In en, this message translates to:
  /// **'Leonberg'**
  String get breedLeonberg;

  /// No description provided for @breedLhasa.
  ///
  /// In en, this message translates to:
  /// **'Lhasa'**
  String get breedLhasa;

  /// No description provided for @breedMalamute.
  ///
  /// In en, this message translates to:
  /// **'Malamute'**
  String get breedMalamute;

  /// No description provided for @breedMalinois.
  ///
  /// In en, this message translates to:
  /// **'Malinois'**
  String get breedMalinois;

  /// No description provided for @breedMalteseDog.
  ///
  /// In en, this message translates to:
  /// **'Maltese Dog'**
  String get breedMalteseDog;

  /// No description provided for @breedMexicanHairless.
  ///
  /// In en, this message translates to:
  /// **'Mexican Hairless'**
  String get breedMexicanHairless;

  /// No description provided for @breedMiniaturePinscher.
  ///
  /// In en, this message translates to:
  /// **'Miniature Pinscher'**
  String get breedMiniaturePinscher;

  /// No description provided for @breedMiniaturePoodle.
  ///
  /// In en, this message translates to:
  /// **'Miniature Poodle'**
  String get breedMiniaturePoodle;

  /// No description provided for @breedMiniatureSchnauzer.
  ///
  /// In en, this message translates to:
  /// **'Miniature Schnauzer'**
  String get breedMiniatureSchnauzer;

  /// No description provided for @breedNewfoundland.
  ///
  /// In en, this message translates to:
  /// **'Newfoundland'**
  String get breedNewfoundland;

  /// No description provided for @breedNorfolkTerrier.
  ///
  /// In en, this message translates to:
  /// **'Norfolk Terrier'**
  String get breedNorfolkTerrier;

  /// No description provided for @breedNorwegianElkhound.
  ///
  /// In en, this message translates to:
  /// **'Norwegian Elkhound'**
  String get breedNorwegianElkhound;

  /// No description provided for @breedNorwichTerrier.
  ///
  /// In en, this message translates to:
  /// **'Norwich Terrier'**
  String get breedNorwichTerrier;

  /// No description provided for @breedOldEnglishSheepdog.
  ///
  /// In en, this message translates to:
  /// **'Old English Sheepdog'**
  String get breedOldEnglishSheepdog;

  /// No description provided for @breedOtterhound.
  ///
  /// In en, this message translates to:
  /// **'Otterhound'**
  String get breedOtterhound;

  /// No description provided for @breedPapillon.
  ///
  /// In en, this message translates to:
  /// **'Papillon'**
  String get breedPapillon;

  /// No description provided for @breedPekinese.
  ///
  /// In en, this message translates to:
  /// **'Pekinese'**
  String get breedPekinese;

  /// No description provided for @breedPembroke.
  ///
  /// In en, this message translates to:
  /// **'Pembroke'**
  String get breedPembroke;

  /// No description provided for @breedPomeranian.
  ///
  /// In en, this message translates to:
  /// **'Pomeranian'**
  String get breedPomeranian;

  /// No description provided for @breedPug.
  ///
  /// In en, this message translates to:
  /// **'Pug'**
  String get breedPug;

  /// No description provided for @breedRedbone.
  ///
  /// In en, this message translates to:
  /// **'Redbone'**
  String get breedRedbone;

  /// No description provided for @breedRhodesianRidgeback.
  ///
  /// In en, this message translates to:
  /// **'Rhodesian Ridgeback'**
  String get breedRhodesianRidgeback;

  /// No description provided for @breedRottweiler.
  ///
  /// In en, this message translates to:
  /// **'Rottweiler'**
  String get breedRottweiler;

  /// No description provided for @breedSaintBernard.
  ///
  /// In en, this message translates to:
  /// **'Saint Bernard'**
  String get breedSaintBernard;

  /// No description provided for @breedSaluki.
  ///
  /// In en, this message translates to:
  /// **'Saluki'**
  String get breedSaluki;

  /// No description provided for @breedSamoyed.
  ///
  /// In en, this message translates to:
  /// **'Samoyed'**
  String get breedSamoyed;

  /// No description provided for @breedSchipperke.
  ///
  /// In en, this message translates to:
  /// **'Schipperke'**
  String get breedSchipperke;

  /// No description provided for @breedScotchTerrier.
  ///
  /// In en, this message translates to:
  /// **'Scotch Terrier'**
  String get breedScotchTerrier;

  /// No description provided for @breedScottishDeerhound.
  ///
  /// In en, this message translates to:
  /// **'Scottish Deerhound'**
  String get breedScottishDeerhound;

  /// No description provided for @breedSealyhamTerrier.
  ///
  /// In en, this message translates to:
  /// **'Sealyham Terrier'**
  String get breedSealyhamTerrier;

  /// No description provided for @breedShetlandSheepdog.
  ///
  /// In en, this message translates to:
  /// **'Shetland Sheepdog'**
  String get breedShetlandSheepdog;

  /// No description provided for @breedShihTzu.
  ///
  /// In en, this message translates to:
  /// **'Shih-Tzu'**
  String get breedShihTzu;

  /// No description provided for @breedSiberianHusky.
  ///
  /// In en, this message translates to:
  /// **'Siberian Husky'**
  String get breedSiberianHusky;

  /// No description provided for @breedSilkyTerrier.
  ///
  /// In en, this message translates to:
  /// **'Silky Terrier'**
  String get breedSilkyTerrier;

  /// No description provided for @breedSoftCoatedWheatenTerrier.
  ///
  /// In en, this message translates to:
  /// **'Soft-coated Wheaten Terrier'**
  String get breedSoftCoatedWheatenTerrier;

  /// No description provided for @breedStaffordshireBullterrier.
  ///
  /// In en, this message translates to:
  /// **'Staffordshire Bullterrier'**
  String get breedStaffordshireBullterrier;

  /// No description provided for @breedStandardPoodle.
  ///
  /// In en, this message translates to:
  /// **'Standard Poodle'**
  String get breedStandardPoodle;

  /// No description provided for @breedStandardSchnauzer.
  ///
  /// In en, this message translates to:
  /// **'Standard Schnauzer'**
  String get breedStandardSchnauzer;

  /// No description provided for @breedSussexSpaniel.
  ///
  /// In en, this message translates to:
  /// **'Sussex Spaniel'**
  String get breedSussexSpaniel;

  /// No description provided for @breedTibetanMastiff.
  ///
  /// In en, this message translates to:
  /// **'Tibetan Mastiff'**
  String get breedTibetanMastiff;

  /// No description provided for @breedTibetanTerrier.
  ///
  /// In en, this message translates to:
  /// **'Tibetan Terrier'**
  String get breedTibetanTerrier;

  /// No description provided for @breedToyPoodle.
  ///
  /// In en, this message translates to:
  /// **'Toy Poodle'**
  String get breedToyPoodle;

  /// No description provided for @breedToyTerrier.
  ///
  /// In en, this message translates to:
  /// **'Toy Terrier'**
  String get breedToyTerrier;

  /// No description provided for @breedVizsla.
  ///
  /// In en, this message translates to:
  /// **'Vizsla'**
  String get breedVizsla;

  /// No description provided for @breedWalkerHound.
  ///
  /// In en, this message translates to:
  /// **'Walker Hound'**
  String get breedWalkerHound;

  /// No description provided for @breedWeimaraner.
  ///
  /// In en, this message translates to:
  /// **'Weimaraner'**
  String get breedWeimaraner;

  /// No description provided for @breedWelshSpringerSpaniel.
  ///
  /// In en, this message translates to:
  /// **'Welsh Springer Spaniel'**
  String get breedWelshSpringerSpaniel;

  /// No description provided for @breedWestHighlandWhiteTerrier.
  ///
  /// In en, this message translates to:
  /// **'West Highland White Terrier'**
  String get breedWestHighlandWhiteTerrier;

  /// No description provided for @breedWhippet.
  ///
  /// In en, this message translates to:
  /// **'Whippet'**
  String get breedWhippet;

  /// No description provided for @breedWireHairedFoxTerrier.
  ///
  /// In en, this message translates to:
  /// **'Wire-haired Fox Terrier'**
  String get breedWireHairedFoxTerrier;

  /// No description provided for @breedYorkshireTerrier.
  ///
  /// In en, this message translates to:
  /// **'Yorkshire Terrier'**
  String get breedYorkshireTerrier;

  /// No description provided for @activityCount.
  ///
  /// In en, this message translates to:
  /// **'{count}'**
  String activityCount(int count);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get navCalendar;

  /// No description provided for @navMyPets.
  ///
  /// In en, this message translates to:
  /// **'My Pets'**
  String get navMyPets;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @aiIdentifyingYour.
  ///
  /// In en, this message translates to:
  /// **'AI identifying Your '**
  String get aiIdentifyingYour;

  /// No description provided for @dogText.
  ///
  /// In en, this message translates to:
  /// **'DOG'**
  String get dogText;

  /// No description provided for @identifyingTimeText.
  ///
  /// In en, this message translates to:
  /// **'This usually takes up to 1 minute...'**
  String get identifyingTimeText;

  /// No description provided for @analyzingImage.
  ///
  /// In en, this message translates to:
  /// **'Analyzing image...'**
  String get analyzingImage;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Error Occurred'**
  String get errorOccurred;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @noDogDetected.
  ///
  /// In en, this message translates to:
  /// **'No Dog Detected'**
  String get noDogDetected;

  /// No description provided for @clearerPhotoPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please try with a clearer photo of a dog.'**
  String get clearerPhotoPrompt;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @lowConfidenceWarning.
  ///
  /// In en, this message translates to:
  /// **'Low confidence ({confidence}%). Results may not be accurate.'**
  String lowConfidenceWarning(String confidence);

  /// No description provided for @savingToRecentScans.
  ///
  /// In en, this message translates to:
  /// **'Saving to recent scans...'**
  String get savingToRecentScans;

  /// No description provided for @dogResults.
  ///
  /// In en, this message translates to:
  /// **'Dog Results'**
  String get dogResults;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @shape.
  ///
  /// In en, this message translates to:
  /// **'Shape'**
  String get shape;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @coat.
  ///
  /// In en, this message translates to:
  /// **'Coat'**
  String get coat;

  /// No description provided for @headAndFace.
  ///
  /// In en, this message translates to:
  /// **'Head & Face'**
  String get headAndFace;

  /// No description provided for @purpose.
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get purpose;

  /// No description provided for @body.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get body;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @temperamentAndCharacteristics.
  ///
  /// In en, this message translates to:
  /// **'Temperament & Characteristics'**
  String get temperamentAndCharacteristics;

  /// No description provided for @energyLevel.
  ///
  /// In en, this message translates to:
  /// **'Energy Level'**
  String get energyLevel;

  /// No description provided for @trainability.
  ///
  /// In en, this message translates to:
  /// **'Trainability'**
  String get trainability;

  /// No description provided for @socialBehavior.
  ///
  /// In en, this message translates to:
  /// **'Social Behavior'**
  String get socialBehavior;

  /// No description provided for @familyCompatibility.
  ///
  /// In en, this message translates to:
  /// **'Family Compatibility'**
  String get familyCompatibility;

  /// No description provided for @childFriendliness.
  ///
  /// In en, this message translates to:
  /// **'Child Friendliness'**
  String get childFriendliness;

  /// No description provided for @addPet.
  ///
  /// In en, this message translates to:
  /// **'+add Pet'**
  String get addPet;

  /// No description provided for @cannotSave.
  ///
  /// In en, this message translates to:
  /// **'Cannot Save'**
  String get cannotSave;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cannotSaveConfidence.
  ///
  /// In en, this message translates to:
  /// **'Cannot save: Confidence {confidence}% < 40%'**
  String cannotSaveConfidence(String confidence);

  /// No description provided for @noPredictionResult.
  ///
  /// In en, this message translates to:
  /// **'No prediction result available'**
  String get noPredictionResult;

  /// No description provided for @noImageDataToSave.
  ///
  /// In en, this message translates to:
  /// **'No image data to save'**
  String get noImageDataToSave;

  /// No description provided for @failedToSaveResults.
  ///
  /// In en, this message translates to:
  /// **'Failed to save results'**
  String get failedToSaveResults;

  /// No description provided for @moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// No description provided for @friendly.
  ///
  /// In en, this message translates to:
  /// **'Friendly'**
  String get friendly;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @sizeSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get sizeSmall;

  /// No description provided for @sizeMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get sizeMedium;

  /// No description provided for @sizeLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get sizeLarge;

  /// No description provided for @sizeGiant.
  ///
  /// In en, this message translates to:
  /// **'Giant'**
  String get sizeGiant;

  /// No description provided for @sizeToy.
  ///
  /// In en, this message translates to:
  /// **'Toy'**
  String get sizeToy;

  /// No description provided for @sizeMiniature.
  ///
  /// In en, this message translates to:
  /// **'Miniature'**
  String get sizeMiniature;

  /// No description provided for @sizeStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get sizeStandard;

  /// No description provided for @sizeSmallToMedium.
  ///
  /// In en, this message translates to:
  /// **'Small to Medium'**
  String get sizeSmallToMedium;

  /// No description provided for @sizeMediumToLarge.
  ///
  /// In en, this message translates to:
  /// **'Medium to Large'**
  String get sizeMediumToLarge;

  /// No description provided for @levelLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get levelLow;

  /// No description provided for @levelHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get levelHigh;

  /// No description provided for @levelVeryHigh.
  ///
  /// In en, this message translates to:
  /// **'Very High'**
  String get levelVeryHigh;

  /// No description provided for @levelLowToModerate.
  ///
  /// In en, this message translates to:
  /// **'Low to Moderate'**
  String get levelLowToModerate;

  /// No description provided for @levelModerateToHigh.
  ///
  /// In en, this message translates to:
  /// **'Moderate to High'**
  String get levelModerateToHigh;

  /// No description provided for @levelHighToVeryHigh.
  ///
  /// In en, this message translates to:
  /// **'High to Very High'**
  String get levelHighToVeryHigh;

  /// No description provided for @traitIntelligent.
  ///
  /// In en, this message translates to:
  /// **'Intelligent'**
  String get traitIntelligent;

  /// No description provided for @traitAlert.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get traitAlert;

  /// No description provided for @traitLoyal.
  ///
  /// In en, this message translates to:
  /// **'Loyal'**
  String get traitLoyal;

  /// No description provided for @traitProtective.
  ///
  /// In en, this message translates to:
  /// **'Protective'**
  String get traitProtective;

  /// No description provided for @traitCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get traitCalm;

  /// No description provided for @traitGentle.
  ///
  /// In en, this message translates to:
  /// **'Gentle'**
  String get traitGentle;

  /// No description provided for @traitActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get traitActive;

  /// No description provided for @traitIndependent.
  ///
  /// In en, this message translates to:
  /// **'Independent'**
  String get traitIndependent;

  /// No description provided for @traitConfident.
  ///
  /// In en, this message translates to:
  /// **'Confident'**
  String get traitConfident;

  /// No description provided for @traitBrave.
  ///
  /// In en, this message translates to:
  /// **'Brave'**
  String get traitBrave;

  /// No description provided for @traitPlayful.
  ///
  /// In en, this message translates to:
  /// **'Playful'**
  String get traitPlayful;

  /// No description provided for @traitAffectionate.
  ///
  /// In en, this message translates to:
  /// **'Affectionate'**
  String get traitAffectionate;

  /// No description provided for @traitStubborn.
  ///
  /// In en, this message translates to:
  /// **'Stubborn'**
  String get traitStubborn;

  /// No description provided for @traitEagerToPlease.
  ///
  /// In en, this message translates to:
  /// **'Eager to please'**
  String get traitEagerToPlease;

  /// No description provided for @ratingExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get ratingExcellent;

  /// No description provided for @ratingAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get ratingAverage;

  /// No description provided for @ratingFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get ratingFair;

  /// No description provided for @ratingPoor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get ratingPoor;

  /// No description provided for @goodWithChildren.
  ///
  /// In en, this message translates to:
  /// **'Good with children'**
  String get goodWithChildren;

  /// No description provided for @goodWithFamily.
  ///
  /// In en, this message translates to:
  /// **'Good with family'**
  String get goodWithFamily;

  /// No description provided for @excellentWithChildren.
  ///
  /// In en, this message translates to:
  /// **'Excellent with children'**
  String get excellentWithChildren;

  /// No description provided for @excellentWithFamily.
  ///
  /// In en, this message translates to:
  /// **'Excellent with family'**
  String get excellentWithFamily;

  /// No description provided for @coatShort.
  ///
  /// In en, this message translates to:
  /// **'Short'**
  String get coatShort;

  /// No description provided for @coatLong.
  ///
  /// In en, this message translates to:
  /// **'Long'**
  String get coatLong;

  /// No description provided for @coatMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get coatMedium;

  /// No description provided for @coatDouble.
  ///
  /// In en, this message translates to:
  /// **'Double coat'**
  String get coatDouble;

  /// No description provided for @coatWire.
  ///
  /// In en, this message translates to:
  /// **'Wire'**
  String get coatWire;

  /// No description provided for @coatSilky.
  ///
  /// In en, this message translates to:
  /// **'Silky'**
  String get coatSilky;

  /// No description provided for @coatSmooth.
  ///
  /// In en, this message translates to:
  /// **'Smooth'**
  String get coatSmooth;

  /// No description provided for @coatDense.
  ///
  /// In en, this message translates to:
  /// **'Dense'**
  String get coatDense;

  /// No description provided for @coatFlat.
  ///
  /// In en, this message translates to:
  /// **'Flat'**
  String get coatFlat;

  /// No description provided for @coatCurly.
  ///
  /// In en, this message translates to:
  /// **'Curly'**
  String get coatCurly;

  /// No description provided for @coatWavy.
  ///
  /// In en, this message translates to:
  /// **'Wavy'**
  String get coatWavy;

  /// No description provided for @colorBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get colorBlack;

  /// No description provided for @colorWhite.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get colorWhite;

  /// No description provided for @colorBrown.
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get colorBrown;

  /// No description provided for @colorRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get colorRed;

  /// No description provided for @colorTan.
  ///
  /// In en, this message translates to:
  /// **'Tan'**
  String get colorTan;

  /// No description provided for @colorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorBlue;

  /// No description provided for @colorGray.
  ///
  /// In en, this message translates to:
  /// **'Gray'**
  String get colorGray;

  /// No description provided for @colorFawn.
  ///
  /// In en, this message translates to:
  /// **'Fawn'**
  String get colorFawn;

  /// No description provided for @colorBrindle.
  ///
  /// In en, this message translates to:
  /// **'Brindle'**
  String get colorBrindle;

  /// No description provided for @colorCream.
  ///
  /// In en, this message translates to:
  /// **'Cream'**
  String get colorCream;

  /// No description provided for @colorGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get colorGold;

  /// No description provided for @colorLiver.
  ///
  /// In en, this message translates to:
  /// **'Liver'**
  String get colorLiver;

  /// No description provided for @colorTriColor.
  ///
  /// In en, this message translates to:
  /// **'Tri-color'**
  String get colorTriColor;

  /// No description provided for @colorMerle.
  ///
  /// In en, this message translates to:
  /// **'Merle'**
  String get colorMerle;

  /// No description provided for @colorSable.
  ///
  /// In en, this message translates to:
  /// **'Sable'**
  String get colorSable;

  /// No description provided for @chooseProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose Profile Photo'**
  String get chooseProfilePhoto;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @ownersProfile.
  ///
  /// In en, this message translates to:
  /// **'Owner\'s Profile'**
  String get ownersProfile;

  /// No description provided for @petOwner.
  ///
  /// In en, this message translates to:
  /// **'Pet Owner'**
  String get petOwner;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @ownerContacts.
  ///
  /// In en, this message translates to:
  /// **'Owner Contacts'**
  String get ownerContacts;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @mainPhone.
  ///
  /// In en, this message translates to:
  /// **'Main Phone'**
  String get mainPhone;

  /// No description provided for @instantGpsAlerts.
  ///
  /// In en, this message translates to:
  /// **'Instant Gps Alerts Upon Tag Scan'**
  String get instantGpsAlerts;

  /// No description provided for @gpsAlertsDescription.
  ///
  /// In en, this message translates to:
  /// **'Get instant pet location updates, avoiding the hassle of traditional emails'**
  String get gpsAlertsDescription;

  /// No description provided for @emergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get emergencyContacts;

  /// No description provided for @vetContactsDescription.
  ///
  /// In en, this message translates to:
  /// **'Contacts of the vet, co-owner, and caretaker in \n case the main phone isn\'t available'**
  String get vetContactsDescription;

  /// No description provided for @messenger.
  ///
  /// In en, this message translates to:
  /// **'Messenger'**
  String get messenger;

  /// No description provided for @messengerDescription.
  ///
  /// In en, this message translates to:
  /// **'An alternative way to contact the owner if it is impossible to call them'**
  String get messengerDescription;

  /// No description provided for @petsResidence.
  ///
  /// In en, this message translates to:
  /// **'Pets Place of Residence'**
  String get petsResidence;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @addAddress.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get addAddress;

  /// No description provided for @labelAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get labelAdd;

  /// No description provided for @getPremium.
  ///
  /// In en, this message translates to:
  /// **'GET PREMIUM'**
  String get getPremium;

  /// No description provided for @recentScansTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Scans'**
  String get recentScansTitle;

  /// No description provided for @scansCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Scans'**
  String scansCount(int count);

  /// No description provided for @zeroResults.
  ///
  /// In en, this message translates to:
  /// **'0 Results'**
  String get zeroResults;

  /// No description provided for @noScansMessage.
  ///
  /// In en, this message translates to:
  /// **'As soon as you’ve made your first scan,\nyour results will be logged here.'**
  String get noScansMessage;

  /// No description provided for @scanLooksLike.
  ///
  /// In en, this message translates to:
  /// **'Your dog you scanned looks like this.'**
  String get scanLooksLike;

  /// No description provided for @returnAction.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get returnAction;

  /// No description provided for @showAction.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get showAction;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(int count);

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String minutesAgo(int count);

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @rescannedSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ Re-scanned: {breedName} ({confidence}% confidence)'**
  String rescannedSuccess(String breedName, String confidence);

  /// No description provided for @errorRescanning.
  ///
  /// In en, this message translates to:
  /// **'Error re-scanning: {error}'**
  String errorRescanning(Object error);

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a strong, secure password to keep your account protected and accessible.'**
  String get changePasswordSubtitle;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @repeatPassword.
  ///
  /// In en, this message translates to:
  /// **'Repeat Password'**
  String get repeatPassword;

  /// No description provided for @faqQuestion1.
  ///
  /// In en, this message translates to:
  /// **'How can I register a pet?'**
  String get faqQuestion1;

  /// No description provided for @faqAnswer1.
  ///
  /// In en, this message translates to:
  /// **'You can register your pet by going to the \"Add Pet\" section, filling in the required details (name, breed, age, etc.), and attaching a photo. Once registered, you’ll receive a unique QR pet tag ID.'**
  String get faqAnswer1;

  /// No description provided for @faqQuestion2.
  ///
  /// In en, this message translates to:
  /// **'Why should I register my pet?'**
  String get faqQuestion2;

  /// No description provided for @faqAnswer2.
  ///
  /// In en, this message translates to:
  /// **'Registering your pet helps in case they get lost. Anyone who finds your pet can scan the QR tag and instantly contact you with the pet’s location.'**
  String get faqAnswer2;

  /// No description provided for @faqQuestion3.
  ///
  /// In en, this message translates to:
  /// **'QR pet tag activation?'**
  String get faqQuestion3;

  /// No description provided for @faqAnswer3.
  ///
  /// In en, this message translates to:
  /// **'After registering, you’ll get a digital or physical QR tag. Scan it with any phone camera to link it to your pet’s profile. No app needed for finders!'**
  String get faqAnswer3;

  /// No description provided for @faqQuestion4.
  ///
  /// In en, this message translates to:
  /// **'How does QR code scanning work?'**
  String get faqQuestion4;

  /// No description provided for @faqAnswer4.
  ///
  /// In en, this message translates to:
  /// **'Anyone can scan the QR tag using their phone’s camera. It opens a web page with your contact info and pet details so they can reach you immediately.'**
  String get faqAnswer4;

  /// No description provided for @faqQuestion5.
  ///
  /// In en, this message translates to:
  /// **'Who can register a pet?'**
  String get faqQuestion5;

  /// No description provided for @faqAnswer5.
  ///
  /// In en, this message translates to:
  /// **'Any pet owner can register their dog, cat, or other companion animal.'**
  String get faqAnswer5;

  /// No description provided for @faqQuestion6.
  ///
  /// In en, this message translates to:
  /// **'How can I change my data?'**
  String get faqQuestion6;

  /// No description provided for @faqAnswer6.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile → tap any field (Name, Email, Phone, etc.) to edit and save.'**
  String get faqAnswer6;

  /// No description provided for @faqQuestion7.
  ///
  /// In en, this message translates to:
  /// **'How can I change my pet\'s data?'**
  String get faqQuestion7;

  /// No description provided for @faqAnswer7.
  ///
  /// In en, this message translates to:
  /// **'Go to your pet’s profile and tap the edit button to update name, breed, photos, etc.'**
  String get faqAnswer7;

  /// No description provided for @faqQuestion8.
  ///
  /// In en, this message translates to:
  /// **'What is a pet ID number?'**
  String get faqQuestion8;

  /// No description provided for @faqAnswer8.
  ///
  /// In en, this message translates to:
  /// **'It’s a unique identifier linked to your pet’s QR tag for quick identification.'**
  String get faqAnswer8;

  /// No description provided for @faqQuestion9.
  ///
  /// In en, this message translates to:
  /// **'My pet is lost what should I do?'**
  String get faqQuestion9;

  /// No description provided for @faqAnswer9.
  ///
  /// In en, this message translates to:
  /// **'Mark your pet as \"Lost\" in the app. This alerts anyone who scans the tag and shows your emergency contact info.'**
  String get faqAnswer9;

  /// No description provided for @savedActivities.
  ///
  /// In en, this message translates to:
  /// **'Saved Activities'**
  String get savedActivities;

  /// No description provided for @deleteProfileWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning! The profile and all its content will be deleted permanently and cannot be recovered. If you have an active Premium Subscription, deactivate it in your App Store Subscription settings'**
  String get deleteProfileWarning;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'NO'**
  String get no;

  /// No description provided for @enterAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter Address'**
  String get enterAddress;

  /// No description provided for @errorEnterAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter your address'**
  String get errorEnterAddress;

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Enter the first name'**
  String get enterFirstName;

  /// No description provided for @allowNotifications.
  ///
  /// In en, this message translates to:
  /// **'Allow Notifications'**
  String get allowNotifications;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get enterEmail;

  /// No description provided for @errorEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get errorEnterValidEmail;

  /// No description provided for @genderPreferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'I don’t want to indicate'**
  String get genderPreferNotToSay;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter the Last Name'**
  String get enterLastName;

  /// No description provided for @errorEnterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get errorEnterValidPhone;

  /// No description provided for @drinkCalculator.
  ///
  /// In en, this message translates to:
  /// **'Drink Calculator'**
  String get drinkCalculator;

  /// No description provided for @drinkFrequencyChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequency (times per day)'**
  String get drinkFrequencyChartTitle;

  /// No description provided for @drinkCalcDescription.
  ///
  /// In en, this message translates to:
  /// **'Calculate daily water intake your dog needs\naccording to weight and activity level for\nhealthy hydration every day'**
  String get drinkCalcDescription;

  /// No description provided for @currentWeight.
  ///
  /// In en, this message translates to:
  /// **'Current Weight'**
  String get currentWeight;

  /// No description provided for @hintWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get hintWeight;

  /// No description provided for @yourDogWillNeed.
  ///
  /// In en, this message translates to:
  /// **'Your Dog will need'**
  String get yourDogWillNeed;

  /// No description provided for @perDay.
  ///
  /// In en, this message translates to:
  /// **'/ day'**
  String get perDay;

  /// No description provided for @unitPounds.
  ///
  /// In en, this message translates to:
  /// **'Pounds'**
  String get unitPounds;

  /// No description provided for @unitKilograms.
  ///
  /// In en, this message translates to:
  /// **'Kilograms'**
  String get unitKilograms;

  /// No description provided for @unitOunces.
  ///
  /// In en, this message translates to:
  /// **'Ounces'**
  String get unitOunces;

  /// No description provided for @unitGrams.
  ///
  /// In en, this message translates to:
  /// **'Grams'**
  String get unitGrams;

  /// No description provided for @unitMilliliters.
  ///
  /// In en, this message translates to:
  /// **'Milliliters'**
  String get unitMilliliters;

  /// No description provided for @unitCentiliters.
  ///
  /// In en, this message translates to:
  /// **'Centiliters'**
  String get unitCentiliters;

  /// No description provided for @unitLiters.
  ///
  /// In en, this message translates to:
  /// **'Liters'**
  String get unitLiters;

  /// No description provided for @unitUSFluidOunces.
  ///
  /// In en, this message translates to:
  /// **'US Fluid Ounces'**
  String get unitUSFluidOunces;

  /// No description provided for @unitUKFluidOunces.
  ///
  /// In en, this message translates to:
  /// **'UK Fluid Ounces'**
  String get unitUKFluidOunces;

  /// No description provided for @activityLevel.
  ///
  /// In en, this message translates to:
  /// **'Activity level'**
  String get activityLevel;

  /// No description provided for @unitSymbolMl.
  ///
  /// In en, this message translates to:
  /// **'mL'**
  String get unitSymbolMl;

  /// No description provided for @unitSymbolCl.
  ///
  /// In en, this message translates to:
  /// **'cL'**
  String get unitSymbolCl;

  /// No description provided for @unitSymbolL.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get unitSymbolL;

  /// No description provided for @unitSymbolUsFlOz.
  ///
  /// In en, this message translates to:
  /// **'US fl oz'**
  String get unitSymbolUsFlOz;

  /// No description provided for @unitSymbolUkFlOz.
  ///
  /// In en, this message translates to:
  /// **'UK fl oz'**
  String get unitSymbolUkFlOz;

  /// No description provided for @breedAnalysisTitle.
  ///
  /// In en, this message translates to:
  /// **'Breed Analysis'**
  String get breedAnalysisTitle;

  /// No description provided for @viewHistoryTooltip.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistoryTooltip;

  /// No description provided for @newScanTooltip.
  ///
  /// In en, this message translates to:
  /// **'New Scan'**
  String get newScanTooltip;

  /// No description provided for @scanAnotherButton.
  ///
  /// In en, this message translates to:
  /// **'Scan Another'**
  String get scanAnotherButton;

  /// No description provided for @confidentLabel.
  ///
  /// In en, this message translates to:
  /// **'Confident'**
  String get confidentLabel;

  /// No description provided for @aiAnalysisComplete.
  ///
  /// In en, this message translates to:
  /// **'AI Analysis Complete'**
  String get aiAnalysisComplete;

  /// No description provided for @breedIdentified.
  ///
  /// In en, this message translates to:
  /// **'Breed Identified'**
  String get breedIdentified;

  /// No description provided for @primaryPurpose.
  ///
  /// In en, this message translates to:
  /// **'Primary Purpose: {purpose}'**
  String primaryPurpose(String purpose);

  /// No description provided for @confidenceLevel.
  ///
  /// In en, this message translates to:
  /// **'Confidence Level'**
  String get confidenceLevel;

  /// No description provided for @physicalCharacteristicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Physical Characteristics'**
  String get physicalCharacteristicsTitle;

  /// No description provided for @coatType.
  ///
  /// In en, this message translates to:
  /// **'Coat Type'**
  String get coatType;

  /// No description provided for @bodyStructure.
  ///
  /// In en, this message translates to:
  /// **'Body Structure'**
  String get bodyStructure;

  /// No description provided for @temperamentAndBehaviorTitle.
  ///
  /// In en, this message translates to:
  /// **'Temperament & Behavior'**
  String get temperamentAndBehaviorTitle;

  /// No description provided for @additionalInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInfoTitle;

  /// No description provided for @ageGroup.
  ///
  /// In en, this message translates to:
  /// **'Age Group'**
  String get ageGroup;

  /// No description provided for @weightRange.
  ///
  /// In en, this message translates to:
  /// **'Weight Range'**
  String get weightRange;

  /// No description provided for @documentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documentsTitle;

  /// No description provided for @addDocument.
  ///
  /// In en, this message translates to:
  /// **'Add Document'**
  String get addDocument;

  /// No description provided for @documentCount.
  ///
  /// In en, this message translates to:
  /// **'{count} documents'**
  String documentCount(int count);

  /// No description provided for @noDocumentsFound.
  ///
  /// In en, this message translates to:
  /// **'No documents found'**
  String get noDocumentsFound;

  /// No description provided for @noMatchingDocuments.
  ///
  /// In en, this message translates to:
  /// **'No matching documents'**
  String get noMatchingDocuments;

  /// No description provided for @uploadFirstDocument.
  ///
  /// In en, this message translates to:
  /// **'Tap + to upload your first document'**
  String get uploadFirstDocument;

  /// No description provided for @tryDifferentSearchTerm.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearchTerm;

  /// No description provided for @documentDeleted.
  ///
  /// In en, this message translates to:
  /// **'Document deleted'**
  String get documentDeleted;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchPlaceholder;

  /// No description provided for @openDocument.
  ///
  /// In en, this message translates to:
  /// **'Open Document'**
  String get openDocument;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @editDocument.
  ///
  /// In en, this message translates to:
  /// **'Edit Document'**
  String get editDocument;

  /// No description provided for @deleteDocument.
  ///
  /// In en, this message translates to:
  /// **'Delete Document'**
  String get deleteDocument;

  /// No description provided for @deleteDocumentConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?'**
  String deleteDocumentConfirmation(String title);

  /// No description provided for @documentDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Document deleted successfully'**
  String get documentDeletedSuccess;

  /// No description provided for @documentDetails.
  ///
  /// In en, this message translates to:
  /// **'Document Details'**
  String get documentDetails;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @fileType.
  ///
  /// In en, this message translates to:
  /// **'File Type'**
  String get fileType;

  /// No description provided for @fileSize.
  ///
  /// In en, this message translates to:
  /// **'File Size'**
  String get fileSize;

  /// No description provided for @uploadDate.
  ///
  /// In en, this message translates to:
  /// **'Upload Date'**
  String get uploadDate;

  /// No description provided for @filePath.
  ///
  /// In en, this message translates to:
  /// **'File Path'**
  String get filePath;

  /// No description provided for @notSavedLocally.
  ///
  /// In en, this message translates to:
  /// **'Not saved locally'**
  String get notSavedLocally;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @documentTitle.
  ///
  /// In en, this message translates to:
  /// **'Document Title'**
  String get documentTitle;

  /// No description provided for @documentUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Document updated successfully'**
  String get documentUpdatedSuccess;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @daysAgoShort.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String daysAgoShort(int count);

  /// No description provided for @weeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}w ago'**
  String weeksAgo(int count);

  /// No description provided for @catMedicalCare.
  ///
  /// In en, this message translates to:
  /// **'Medical & Care'**
  String get catMedicalCare;

  /// No description provided for @catLegalLicensing.
  ///
  /// In en, this message translates to:
  /// **'Legal & Licensing'**
  String get catLegalLicensing;

  /// No description provided for @catCoverageFinance.
  ///
  /// In en, this message translates to:
  /// **'Coverage & Finance'**
  String get catCoverageFinance;

  /// No description provided for @catLearningBehavior.
  ///
  /// In en, this message translates to:
  /// **'Learning & Behavior'**
  String get catLearningBehavior;

  /// No description provided for @catTransitBoarding.
  ///
  /// In en, this message translates to:
  /// **'Transit & Boarding'**
  String get catTransitBoarding;

  /// No description provided for @catCriticalSupport.
  ///
  /// In en, this message translates to:
  /// **'Critical & Support'**
  String get catCriticalSupport;

  /// No description provided for @catBloodlineStock.
  ///
  /// In en, this message translates to:
  /// **'Bloodline and stock'**
  String get catBloodlineStock;

  /// No description provided for @catNutritionIntake.
  ///
  /// In en, this message translates to:
  /// **'Nutrition and intake'**
  String get catNutritionIntake;

  /// No description provided for @catMaintenanceLook.
  ///
  /// In en, this message translates to:
  /// **'Maintenance and look'**
  String get catMaintenanceLook;

  /// No description provided for @catOtherDocuments.
  ///
  /// In en, this message translates to:
  /// **'Other Documents'**
  String get catOtherDocuments;

  /// No description provided for @catAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get catAll;

  /// No description provided for @documentUploadedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Document uploaded successfully!'**
  String get documentUploadedSuccess;

  /// No description provided for @documentUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload document: {error}'**
  String documentUploadFailed(Object error);

  /// No description provided for @addDocumentDetails.
  ///
  /// In en, this message translates to:
  /// **'Add Document Details'**
  String get addDocumentDetails;

  /// No description provided for @docVaccinationRecords.
  ///
  /// In en, this message translates to:
  /// **'Vaccination Records'**
  String get docVaccinationRecords;

  /// No description provided for @docPetInsurancePolicy.
  ///
  /// In en, this message translates to:
  /// **'Pet Insurance Policy'**
  String get docPetInsurancePolicy;

  /// No description provided for @docAdoptionCertificate.
  ///
  /// In en, this message translates to:
  /// **'Adoption Certificate'**
  String get docAdoptionCertificate;

  /// No description provided for @docTrainingCertificate.
  ///
  /// In en, this message translates to:
  /// **'Training Certificate'**
  String get docTrainingCertificate;

  /// No description provided for @docMedicalCheckupReport.
  ///
  /// In en, this message translates to:
  /// **'Medical Checkup Report'**
  String get docMedicalCheckupReport;

  /// No description provided for @labelCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get labelCountry;

  /// No description provided for @labelCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get labelCity;

  /// No description provided for @hintEnterCity.
  ///
  /// In en, this message translates to:
  /// **'Enter your city'**
  String get hintEnterCity;

  /// No description provided for @errorEnterCity.
  ///
  /// In en, this message translates to:
  /// **'Please enter your city'**
  String get errorEnterCity;

  /// No description provided for @addMoreActivities.
  ///
  /// In en, this message translates to:
  /// **'+ Add more activities'**
  String get addMoreActivities;

  /// No description provided for @selectDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDateTitle;

  /// No description provided for @enterDate.
  ///
  /// In en, this message translates to:
  /// **'Enter Date'**
  String get enterDate;

  /// No description provided for @dateHint.
  ///
  /// In en, this message translates to:
  /// **'MM/DD/YYYY'**
  String get dateHint;

  /// No description provided for @okAction.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okAction;

  /// No description provided for @dateRangeError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a date between 2020-2030'**
  String get dateRangeError;

  /// No description provided for @enjoyingApp.
  ///
  /// In en, this message translates to:
  /// **'Enjoying the app?'**
  String get enjoyingApp;

  /// No description provided for @tapToRate.
  ///
  /// In en, this message translates to:
  /// **'Tap to rate:'**
  String get tapToRate;

  /// No description provided for @rateUsAction.
  ///
  /// In en, this message translates to:
  /// **'Rate Us'**
  String get rateUsAction;

  /// No description provided for @selectStars.
  ///
  /// In en, this message translates to:
  /// **'Select Stars'**
  String get selectStars;

  /// No description provided for @sorryToHear.
  ///
  /// In en, this message translates to:
  /// **'We\'re sorry to hear that'**
  String get sorryToHear;

  /// No description provided for @feedbackImprove.
  ///
  /// In en, this message translates to:
  /// **'What can we do better? Your feedback helps us improve.'**
  String get feedbackImprove;

  /// No description provided for @feedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us what we can improve...'**
  String get feedbackHint;

  /// No description provided for @submitFeedback.
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get submitFeedback;

  /// No description provided for @errorAppStore.
  ///
  /// In en, this message translates to:
  /// **'Could not open app store. Please try again later.'**
  String get errorAppStore;

  /// No description provided for @errorOpenStore.
  ///
  /// In en, this message translates to:
  /// **'Error opening app store.'**
  String get errorOpenStore;

  /// No description provided for @errorShare.
  ///
  /// In en, this message translates to:
  /// **'Unable to open share options. Error: {error}'**
  String errorShare(Object error);

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard! You can now paste and share it.'**
  String get linkCopied;

  /// No description provided for @copyFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to copy to clipboard.'**
  String get copyFailed;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy Link'**
  String get copyLink;

  /// No description provided for @shareWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Share via WhatsApp'**
  String get shareWhatsApp;

  /// No description provided for @shareEmail.
  ///
  /// In en, this message translates to:
  /// **'Share via Email'**
  String get shareEmail;

  /// No description provided for @shareSMS.
  ///
  /// In en, this message translates to:
  /// **'Share via SMS'**
  String get shareSMS;

  /// No description provided for @chooseShare.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to share:'**
  String get chooseShare;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @feedbackThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get feedbackThanks;

  /// No description provided for @themeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeTitle;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @myFavorites.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get myFavorites;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedbackTitle;

  /// No description provided for @rateUsTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate us'**
  String get rateUsTitle;

  /// No description provided for @shareTitle.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareTitle;

  /// No description provided for @myPremiumService.
  ///
  /// In en, this message translates to:
  /// **'My Premium Service'**
  String get myPremiumService;

  /// No description provided for @shareMessageBody.
  ///
  /// In en, this message translates to:
  /// **'Check out Dog Breed - an amazing app for dog lovers!'**
  String get shareMessageBody;

  /// No description provided for @shareIOS.
  ///
  /// In en, this message translates to:
  /// **'📱 Discover Dog Breed on the App Store!'**
  String get shareIOS;

  /// No description provided for @shareAndroid.
  ///
  /// In en, this message translates to:
  /// **'📱 Get Dog Breed on Google Play!'**
  String get shareAndroid;

  /// No description provided for @shareDefault.
  ///
  /// In en, this message translates to:
  /// **'📱 Check out Dog Breed!'**
  String get shareDefault;

  /// No description provided for @shareSubject.
  ///
  /// In en, this message translates to:
  /// **'Dog Breed App'**
  String get shareSubject;

  /// No description provided for @dashboardHome.
  ///
  /// In en, this message translates to:
  /// **'Dashboard Home'**
  String get dashboardHome;

  /// No description provided for @saveResults.
  ///
  /// In en, this message translates to:
  /// **'Save Results'**
  String get saveResults;

  /// No description provided for @addAsPet.
  ///
  /// In en, this message translates to:
  /// **'Add as Pet'**
  String get addAsPet;

  /// No description provided for @analyzingWithAI.
  ///
  /// In en, this message translates to:
  /// **'Analyzing with AI Model...'**
  String get analyzingWithAI;

  /// No description provided for @connectingToServer.
  ///
  /// In en, this message translates to:
  /// **'Connecting to Server...'**
  String get connectingToServer;

  /// No description provided for @offlineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode - Local AI'**
  String get offlineMode;

  /// No description provided for @onlineMode.
  ///
  /// In en, this message translates to:
  /// **'Online Mode - Server API'**
  String get onlineMode;

  /// No description provided for @totalBreeds.
  ///
  /// In en, this message translates to:
  /// **'Total Breeds: {count}'**
  String totalBreeds(int count);

  /// No description provided for @switchToOnline.
  ///
  /// In en, this message translates to:
  /// **'Switch to Online'**
  String get switchToOnline;

  /// No description provided for @switchToOffline.
  ///
  /// In en, this message translates to:
  /// **'Switch to Offline'**
  String get switchToOffline;

  /// No description provided for @dogIdentifierTitle.
  ///
  /// In en, this message translates to:
  /// **'Dog Identifier'**
  String get dogIdentifierTitle;

  /// No description provided for @selectDogImage.
  ///
  /// In en, this message translates to:
  /// **'Select a dog image'**
  String get selectDogImage;

  /// No description provided for @errorOfflineModelNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Offline model not available. Please check if model files are in place.'**
  String get errorOfflineModelNotAvailable;

  /// No description provided for @errorNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection available.\n\nPlease switch to Offline Mode to analyze images.'**
  String get errorNoInternet;

  /// No description provided for @errorOnlinePredictionFailed.
  ///
  /// In en, this message translates to:
  /// **'Online prediction failed: {error}\n\nPlease switch to Offline Mode for local analysis.'**
  String errorOnlinePredictionFailed(Object error);

  /// No description provided for @errorOfflinePredictionFailed.
  ///
  /// In en, this message translates to:
  /// **'Offline prediction failed: {error}'**
  String errorOfflinePredictionFailed(Object error);

  /// No description provided for @adult.
  ///
  /// In en, this message translates to:
  /// **'Adult'**
  String get adult;

  /// No description provided for @variesByBreed.
  ///
  /// In en, this message translates to:
  /// **'Varies by Breed'**
  String get variesByBreed;

  /// No description provided for @breedSpecific.
  ///
  /// In en, this message translates to:
  /// **'Breed-Specific'**
  String get breedSpecific;

  /// No description provided for @balanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get balanced;

  /// No description provided for @doubleCoat.
  ///
  /// In en, this message translates to:
  /// **'Double Coat'**
  String get doubleCoat;

  /// No description provided for @wellProportioned.
  ///
  /// In en, this message translates to:
  /// **'Well Proportioned'**
  String get wellProportioned;

  /// No description provided for @various.
  ///
  /// In en, this message translates to:
  /// **'Various'**
  String get various;

  /// No description provided for @companion.
  ///
  /// In en, this message translates to:
  /// **'Companion'**
  String get companion;

  /// No description provided for @noRecentScans.
  ///
  /// In en, this message translates to:
  /// **'No recent scans'**
  String get noRecentScans;

  /// No description provided for @scanDogPrompt.
  ///
  /// In en, this message translates to:
  /// **'Scan a dog to see results here'**
  String get scanDogPrompt;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get deleteAll;

  /// No description provided for @deleteAllPetsConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all pets? This action cannot be undone.'**
  String get deleteAllPetsConfirmation;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'cs',
    'da',
    'de',
    'el',
    'en',
    'es',
    'fi',
    'fr',
    'id',
    'it',
    'nl',
    'pl',
    'pt',
    'sv',
    'tr',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'sv':
      return AppLocalizationsSv();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
