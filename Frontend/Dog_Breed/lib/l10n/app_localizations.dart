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
  /// **'This usually takes up 1 minute...'**
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
