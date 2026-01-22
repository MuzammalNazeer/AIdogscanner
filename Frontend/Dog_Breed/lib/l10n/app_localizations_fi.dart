// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'Koirarotu';

  @override
  String get settingsTitle => 'Asetukset';

  @override
  String get appLanguageTitle => 'Sovelluksen kieli';

  @override
  String get notificationLanguageTitle => 'Ilmoitusten kieli';

  @override
  String get editProfile => 'Muokkaa profiilia';

  @override
  String get changePassword => 'Vaihda salasana';

  @override
  String get notifications => 'Ilmoitukset';

  @override
  String get premiumSubscription => 'Premium-tilaus';

  @override
  String get aboutUs => 'Tietoa meistä';

  @override
  String get faq => 'UKK';

  @override
  String get termsOfUse => 'Käyttöehdot';

  @override
  String get customerCare => 'Asiakaspalvelu';

  @override
  String get measurementUnits => 'Mittayksiköt';

  @override
  String get supportAnimalIdProject => 'Tue Animal ID -projektia';

  @override
  String get deleteOwnerProfile => 'Poista omistajan profiili';

  @override
  String get logout => 'Kirjaudu ulos';

  @override
  String get dialogCancel => 'Peruuta';

  @override
  String get dialogDelete => 'Poista';

  @override
  String get dialogDeleteProfileTitle => 'Poista profiili';

  @override
  String get dialogDeleteProfileMessage => 'Haluatko varmasti poistaa profiilisi pysyvästi? Tätä toimintoa ei voi perua.';

  @override
  String get dialogLogoutTitle => 'Kirjaudu ulos';

  @override
  String get dialogLogoutMessage => 'Haluatko varmasti kirjautua ulos?';

  @override
  String get manager => 'Johtaja';

  @override
  String get splashSubtitle => 'Hallitse koirasi päivittäistä toimintaa ja terveyttä';

  @override
  String get startLikeAPro => 'Aloita kuin ammattilainen';

  @override
  String get unlockAllFeatures => 'Avaa kaikki ominaisuudet';

  @override
  String get premium => 'Premium';

  @override
  String get free => 'Ilmainen';

  @override
  String get unlimitedDogScans => 'Rajoittamattomat koiran skannaukset';

  @override
  String get supportedBreedDetection => 'Tuettu rodun tunnistus';

  @override
  String get multiplePetProfiles => 'Useita lemmikkiprofiileja';

  @override
  String get removeAds => 'Poista mainokset';

  @override
  String get vipCustomerSupport => 'VIP-asiakastuki';

  @override
  String get trialOffer => '3 päivän ILMAINEN kokeilu, sen jälkeen Rs 2550/viikko';

  @override
  String get startFreeTrial => 'ALOITA ILMAINEN KOKEILU';

  @override
  String get subscriptionDisclaimer => 'Jatkamalla hyväksyt ehtomme ja tietosuojakäytäntömme. Tilaus laskutetaan kokeilujakson päätyttyä ja uusiutuu automaattisesti. Peruuta tilaus milloin tahansa ennen kokeilujakson päättymistä välttääksesi maksut.';

  @override
  String get welcomeBack => 'Tervetuloa takaisin, ';

  @override
  String get searchForDog => 'Etsi koiraa';

  @override
  String get tryPremiumFeatures => 'Kokeile Premium-ominaisuuksia 🌵';

  @override
  String get premiumOfferDescription => 'Lunasta tarjouksesi nyt ja saat rajoittamattoman tunnistuksen, terveystarkastuksen ja muuta';

  @override
  String get getIt => 'HANKI SE';

  @override
  String get hygiene => 'Hygienia';

  @override
  String get cleaning => 'Siivous';

  @override
  String get medical => 'Lääkinnällinen';

  @override
  String get booking => 'Varaus';

  @override
  String get identifyDog => 'Tunnista koira';

  @override
  String get identifyDogDescription => 'Skannaa ja tunnista koirasi välittömästi tekoälyn avulla';

  @override
  String get scanNow => 'Skannaa nyt';

  @override
  String get vetVisits => 'Eläinlääkärikäynnit';

  @override
  String get vetVisitsDescription => 'Aikatauluta tarkastukset ja pidä \n kirjaa eläinlääkärikäynneistä';

  @override
  String get createVisit => 'Luo käynti';

  @override
  String get foodManagement => 'Ruokinnan hallinta';

  @override
  String get foodManagementDescription => 'Seuraa aterioita ja hallitse \n lemmikkisi päivittäistä ravitsemusta';

  @override
  String get checkSchedule => 'Tarkista aikataulu';

  @override
  String get unknownBreed => 'Tuntematon rotu';

  @override
  String savedScanMessage(String breedName, String confidence) {
    return '✅ Tallennettu: $breedName ($confidence% varmuus)';
  }

  @override
  String errorMessage(String error) {
    return 'Virhe: $error';
  }

  @override
  String get skip => 'Ohita';

  @override
  String get next => 'Seuraava';

  @override
  String get getStarted => 'Aloita';

  @override
  String get onboardingTitle1 => 'Satelliittiohjaaja';

  @override
  String get onboardingDesc1 => 'Tutki lähellä olevia paikkoja GPS-satelliittikartoituksella\nja löydä satelliitteja';

  @override
  String get onboardingTitle2 => 'Tarvitsemme\n lupasi';

  @override
  String get onboardingDesc2 => 'Tarvitsemme kameran käyttöoikeuden, jotta voit tehdä \nlive-skannauksia lemmikistäsi.';

  @override
  String get onboardingTitle3 => 'Säilytä kuvanlaatu';

  @override
  String get onboardingDesc3 => 'Kuvaa koko vartalo, jos mahdollista. Pään on oltava \nnäkyvissä.';

  @override
  String get onboardingTitle4 => 'Varmista, että koirasi pysyy \n terveenä ja aktiivisena.';

  @override
  String get onboardingDesc4 => 'Hallitse koirasi kaikkia yksityiskohtia—terveyttä, kuvia,\n aktiviteetteja ja muuta yhdessä yksinkertaisessa paikassa.';
}
