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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
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
    Locale('tr')
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
  /// **'Notification language'**
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
  /// **'About us'**
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
  /// **'Measurement units'**
  String get measurementUnits;

  /// No description provided for @supportAnimalIdProject.
  ///
  /// In en, this message translates to:
  /// **'Support the Animal ID project'**
  String get supportAnimalIdProject;

  /// No description provided for @deleteOwnerProfile.
  ///
  /// In en, this message translates to:
  /// **'Delete owner\'s profile'**
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
  /// **'Delete Profile'**
  String get dialogDeleteProfileTitle;

  /// No description provided for @dialogDeleteProfileMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete your profile? This cannot be undone.'**
  String get dialogDeleteProfileMessage;

  /// No description provided for @dialogLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get dialogLogoutTitle;

  /// No description provided for @dialogLogoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get dialogLogoutMessage;

  /// No description provided for @manager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get manager;

  /// No description provided for @splashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Your Dog daily Activity, Health'**
  String get splashSubtitle;

  /// No description provided for @startLikeAPro.
  ///
  /// In en, this message translates to:
  /// **'Start Like A Pro'**
  String get startLikeAPro;

  /// No description provided for @unlockAllFeatures.
  ///
  /// In en, this message translates to:
  /// **'unlock All Features'**
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
  /// **'3-Days FREE Trial, Rs 2550/Week After'**
  String get trialOffer;

  /// No description provided for @startFreeTrial.
  ///
  /// In en, this message translates to:
  /// **'START FREE TRIAL'**
  String get startFreeTrial;

  /// No description provided for @subscriptionDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to our Terms and Privacy policy, subscription is billed after the trial ends and will auto-renew. Cancel subscription anytime before trial ends to avoid charges.'**
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
  /// **'Instantly scan and identify your dog using AI'**
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
  /// **'Schedule checkups and keep \n track of vet visits'**
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
  /// **'Track meals and manage your \n pet’s daily nutrition'**
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
  String savedScanMessage(String breedName, String confidence);

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorMessage(String error);

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
  /// **'Explore Nearby Places with GPS Satellite\nMapping & Find Satellite'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'We need your\n permission'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'We need camera permission so you can make live \nscans of your pet.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Maintain image quality'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Capture the full body if possible. The head must be \nvisible.'**
  String get onboardingDesc3;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Ensure your dog stays \n healthy and active.'**
  String get onboardingTitle4;

  /// No description provided for @onboardingDesc4.
  ///
  /// In en, this message translates to:
  /// **'Manage every detail of your dog—health, photos,\n activities, and more in one simple place.'**
  String get onboardingDesc4;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['cs', 'da', 'de', 'el', 'en', 'es', 'fi', 'fr', 'id', 'it', 'nl', 'pl', 'pt', 'sv', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs': return AppLocalizationsCs();
    case 'da': return AppLocalizationsDa();
    case 'de': return AppLocalizationsDe();
    case 'el': return AppLocalizationsEl();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fi': return AppLocalizationsFi();
    case 'fr': return AppLocalizationsFr();
    case 'id': return AppLocalizationsId();
    case 'it': return AppLocalizationsIt();
    case 'nl': return AppLocalizationsNl();
    case 'pl': return AppLocalizationsPl();
    case 'pt': return AppLocalizationsPt();
    case 'sv': return AppLocalizationsSv();
    case 'tr': return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
