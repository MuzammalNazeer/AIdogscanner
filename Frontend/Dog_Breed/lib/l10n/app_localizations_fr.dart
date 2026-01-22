// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Race de chien';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get appLanguageTitle => 'Langue de l’application';

  @override
  String get notificationLanguageTitle => 'Langue des notifications';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get notifications => 'Notifications';

  @override
  String get premiumSubscription => 'Abonnement Premium';

  @override
  String get aboutUs => 'À propos de nous';

  @override
  String get faq => 'FAQ';

  @override
  String get termsOfUse => 'Conditions d’utilisation';

  @override
  String get customerCare => 'Service client';

  @override
  String get measurementUnits => 'Unités de mesure';

  @override
  String get supportAnimalIdProject => 'Soutenir le projet Animal ID';

  @override
  String get deleteOwnerProfile => 'Supprimer le profil du propriétaire';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get dialogCancel => 'Annuler';

  @override
  String get dialogDelete => 'Supprimer';

  @override
  String get dialogDeleteProfileTitle => 'Supprimer le profil';

  @override
  String get dialogDeleteProfileMessage => 'Êtes-vous sûr de vouloir supprimer définitivement votre profil ? Cette action est irréversible.';

  @override
  String get dialogLogoutTitle => 'Déconnexion';

  @override
  String get dialogLogoutMessage => 'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get manager => 'Directeur';

  @override
  String get splashSubtitle => 'Gérez l\'activité quotidienne et la santé de votre chien';

  @override
  String get startLikeAPro => 'Commencez comme un pro';

  @override
  String get unlockAllFeatures => 'Débloquez toutes les fonctionnalités';

  @override
  String get premium => 'Premium';

  @override
  String get free => 'Gratuit';

  @override
  String get unlimitedDogScans => 'Scans de chiens illimités';

  @override
  String get supportedBreedDetection => 'Détection de race prise en charge';

  @override
  String get multiplePetProfiles => 'Profils d\'animaux multiples';

  @override
  String get removeAds => 'Supprimer les publicités';

  @override
  String get vipCustomerSupport => 'Support client VIP';

  @override
  String get trialOffer => 'Essai GRATUIT de 3 jours, puis Rs 2550/semaine';

  @override
  String get startFreeTrial => 'COMMENCER L\'ESSAI GRATUIT';

  @override
  String get subscriptionDisclaimer => 'En continuant, vous acceptez nos conditions et notre politique de confidentialité. L\'abonnement est facturé après la fin de l\'essai et sera renouvelé automatiquement. Annulez l\'abonnement à tout moment avant la fin de l\'essai pour éviter des frais.';

  @override
  String get welcomeBack => 'Bon retour, ';

  @override
  String get searchForDog => 'Rechercher un chien';

  @override
  String get tryPremiumFeatures => 'Essayer les fonctionnalités Premium 🌵';

  @override
  String get premiumOfferDescription => 'Réclamez votre offre maintenant et obtenez une reconnaissance illimitée, un bilan de santé et plus encore';

  @override
  String get getIt => 'OBTENIR';

  @override
  String get hygiene => 'Hygiène';

  @override
  String get cleaning => 'Nettoyage';

  @override
  String get medical => 'Médical';

  @override
  String get booking => 'Réservation';

  @override
  String get identifyDog => 'Identifier le chien';

  @override
  String get identifyDogDescription => 'Scannez et identifiez instantanément votre chien grâce à l\'IA';

  @override
  String get scanNow => 'Scanner maintenant';

  @override
  String get vetVisits => 'Visites vétérinaires';

  @override
  String get vetVisitsDescription => 'Planifiez des examens et suivez \n les visites vétérinaires';

  @override
  String get createVisit => 'Créer une visite';

  @override
  String get foodManagement => 'Gestion de l\'alimentation';

  @override
  String get foodManagementDescription => 'Suivez les repas et gérez la \n nutrition quotidienne de votre animal';

  @override
  String get checkSchedule => 'Vérifier le programme';

  @override
  String get unknownBreed => 'Race inconnue';

  @override
  String savedScanMessage(String breedName, String confidence) {
    return '✅ Enregistré : $breedName ($confidence% de confiance)';
  }

  @override
  String errorMessage(String error) {
    return 'Erreur : $error';
  }

  @override
  String get skip => 'Passer';

  @override
  String get next => 'Suivant';

  @override
  String get getStarted => 'Commencer';

  @override
  String get onboardingTitle1 => 'Directeur Satellite';

  @override
  String get onboardingDesc1 => 'Explorez les lieux à proximité avec la cartographie\nsatellite GPS et trouvez des satellites';

  @override
  String get onboardingTitle2 => 'Nous avons besoin de votre\n permission';

  @override
  String get onboardingDesc2 => 'Nous avons besoin de la permission de la caméra pour que vous puissiez effectuer des \nscans en direct de votre animal.';

  @override
  String get onboardingTitle3 => 'Maintenir la qualité de l\'image';

  @override
  String get onboardingDesc3 => 'Capturez le corps entier si possible. La tête doit être \nvisible.';

  @override
  String get onboardingTitle4 => 'Assurez-vous que votre chien reste \n en bonne santé et actif.';

  @override
  String get onboardingDesc4 => 'Gérez chaque détail de votre chien : santé, photos,\n activités et plus encore en un seul endroit simple.';
}
