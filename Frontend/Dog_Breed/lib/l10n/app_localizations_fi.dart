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
  String get notificationLanguageTitle => 'Ilmoituskieli';

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
  String get dialogDeleteProfileMessage =>
      'Haluatko varmasti poistaa profiilisi pysyvästi? Tätä toimintoa ei voi peruuttaa.';

  @override
  String get dialogLogoutTitle => 'Kirjaudu ulos';

  @override
  String get dialogLogoutMessage => 'Haluatko varmasti kirjautua ulos?';

  @override
  String get manager => 'Manageri';

  @override
  String get splashSubtitle =>
      'Hallitse koirasi päivittäistä toimintaa ja terveyttä';

  @override
  String get startLikeAPro => 'Aloita kuin ammattilainen';

  @override
  String get unlockAllFeatures => 'Avaa kaikki ominaisuudet';

  @override
  String get premium => 'Premium';

  @override
  String get free => 'Ilmainen';

  @override
  String get unlimitedDogScans => 'Rajoittamattomat koiraskannaukset';

  @override
  String get supportedBreedDetection => 'Tuettu rotujen tunnistus';

  @override
  String get multiplePetProfiles => 'Useita lemmikkiprofiileja';

  @override
  String get removeAds => 'Poista mainokset';

  @override
  String get vipCustomerSupport => 'VIP-asiakastuki';

  @override
  String get trialOffer =>
      '3 päivän ILMAINEN kokeilu, sen jälkeen Rs 2550/viikko';

  @override
  String get startFreeTrial => 'ALOITA ILMAINEN KOKEILU';

  @override
  String get subscriptionDisclaimer =>
      'Jatkamalla hyväksyt käyttöehdot ja tietosuojakäytännön. Tilaus laskutetaan kokeilujakson päätyttyä ja se uusiutuu automaattisesti. Peruuta tilaus milloin tahansa ennen kokeilujakson päättymistä välttääksesi veloitukset.';

  @override
  String get welcomeBack => 'Tervetuloa takaisin, ';

  @override
  String get searchForDog => 'Etsi koiraa';

  @override
  String get tryPremiumFeatures => 'Kokeile Premium-ominaisuuksia 🌵';

  @override
  String get premiumOfferDescription =>
      'Lunasta tarjouksesi nyt ja saat rajoittamattoman tunnistuksen, terveystarkastuksen ja paljon muuta';

  @override
  String get getIt => 'OTA SE';

  @override
  String get hygiene => 'Hygienia';

  @override
  String get cleaning => 'Siivous';

  @override
  String get medical => 'Lääkintä';

  @override
  String get booking => 'Varaus';

  @override
  String get identifyDog => 'Tunnista koira';

  @override
  String get identifyDogDescription =>
      'Skannaa ja tunnista koirasi välittömästi tekoälyn avulla';

  @override
  String get scanNow => 'Skannaa nyt';

  @override
  String get vetVisits => 'Eläinlääkärikäynnit';

  @override
  String get vetVisitsDescription =>
      'Suunnittele tarkastukset ja seuraa \n eläinlääkärikäyntejä';

  @override
  String get createVisit => 'Luo käynti';

  @override
  String get foodManagement => 'Ruokinnan hallinta';

  @override
  String get foodManagementDescription =>
      'Seuraa aterioita ja hallitse \n lemmikkisi päivittäistä ravintoa';

  @override
  String get checkSchedule => 'Tarkista aikataulu';

  @override
  String get unknownBreed => 'Tuntematon rotu';

  @override
  String savedScanMessage(Object breedName, Object confidence) {
    return '✅ Tallennettu: $breedName ($confidence% luottamus)';
  }

  @override
  String errorMessage(Object error) {
    return 'Virhe: $error';
  }

  @override
  String get skip => 'Ohita';

  @override
  String get next => 'Seuraava';

  @override
  String get getStarted => 'Aloita';

  @override
  String get onboardingTitle1 => 'Satelliittijohtaja';

  @override
  String get onboardingDesc1 =>
      'Tutki lähistön paikkoja GPS-satelliittikartoituksen avulla\nja löydä satelliitteja';

  @override
  String get onboardingTitle2 => 'Tarvitsemme lupasi';

  @override
  String get onboardingDesc2 =>
      'Tarvitsemme kameran käyttöoikeuden, jotta voit tehdä \nsuoria skannauksia lemmikistäsi.';

  @override
  String get onboardingTitle3 => 'Säilytä kuvan laatu';

  @override
  String get onboardingDesc3 =>
      'Ikuista koko keho, jos mahdollista. Pään on oltava \nnäkyvissä.';

  @override
  String get onboardingTitle4 =>
      'Varmista, että koirasi pysyy \n terveenä ja aktiivisena.';

  @override
  String get onboardingDesc4 =>
      'Hallitse koirasi kaikkia tietoja — terveyttä, kuvia,\n toimintaa ja muuta yhdessä helpossa paikassa.';

  @override
  String get calendarTabActivities => 'Toiminnot';

  @override
  String get calendarTabReminders => 'Muistutukset';

  @override
  String get calendarTabProgress => 'Edistyminen';

  @override
  String get calendarTabDocuments => 'Asiakirjat';

  @override
  String get calendarTabSettings => 'Aasetukset';

  @override
  String get activityVeterinary => 'Eläinlääkäri';

  @override
  String get activityPee => 'Pissaus';

  @override
  String get activityEat => 'Syöminen';

  @override
  String get activityDrink => 'Juominen';

  @override
  String get activityPlay => 'Leikki';

  @override
  String get activityPoop => 'Kakkaus';

  @override
  String get activityWalk => 'Kävely';

  @override
  String get activityCrate => 'Häkki';

  @override
  String get activitySleep => 'Uni';

  @override
  String get activityTraining => 'Koulutus';

  @override
  String get activityTreat => 'Herkku';

  @override
  String get activityGrooming => 'Trimmaus';

  @override
  String get activityCleaning => 'Siivous';

  @override
  String get activityMedication => 'Lääkitys';

  @override
  String get activityVaccination => 'Rokotus';

  @override
  String get activityWeight => 'Paino';

  @override
  String get activityHeight => 'Korkeus';

  @override
  String get activityTemperature => 'Lämpötila';

  @override
  String get activityHealthCondition => 'Terveydentila';

  @override
  String get activityAccident => 'Tapaturma';

  @override
  String get activityJournal => 'Päiväkirja';

  @override
  String get calendarManage => 'Hallitse';

  @override
  String get calendarMonth => 'Kuukausi';

  @override
  String get calendarComingSoon => 'Tulossa pian...';

  @override
  String get calendarNoActivityLogged => 'Ei kirjattuja toimintoja';

  @override
  String get calendarAddActivity => 'Lisää toiminto';

  @override
  String get progressTabCalendar => 'Kalender';

  @override
  String get progressTabChart => 'Kaavio';

  @override
  String get progressTabCompare => 'Vertaa';

  @override
  String get petSelectPet => 'Valitse lemmikki';

  @override
  String get petNoPetSelected => 'Ei lemmikkiä valittuna';

  @override
  String get petNoPetSelectedOption => 'Ei lemmikkiä valittuna';

  @override
  String get activityNote => 'Muistiinpano:';

  @override
  String get actionEdit => 'Muokkaa';

  @override
  String get actionDelete => 'Poista';

  @override
  String get dialogDeleteActivityTitle => 'Poista toiminto';

  @override
  String get calendarHeatmapTab => 'Lämpökartta';

  @override
  String get calendarTimelineTab => 'Aikajana';

  @override
  String get calendarActivityIntensity => 'Toiminnan intensiteetti';

  @override
  String get calendarErrorLoadingHeatmap => 'Virhe lämpökartan lataamisessa';

  @override
  String get calendarLegendNone => 'Ei mitään';

  @override
  String get calendarLegendLow => 'Alhainen';

  @override
  String get calendarLegendMedium => 'Keskitaso';

  @override
  String get calendarLegendHigh => 'Korkea';

  @override
  String get calendarLegendNow => 'Nyt';

  @override
  String get calendarChartAmount => 'Määrä ml';

  @override
  String get calendarChartFrequency => 'Taajuus';

  @override
  String get calendarShare => 'Jaa';

  @override
  String get calendarMostActiveDay => 'Aktiivisin päivä';

  @override
  String get calendarMostActiveTime => 'Aktiivisin aika';

  @override
  String dialogDeleteActivityContent(Object activityName) {
    return 'Haluatko varmasti poistaa toiminnon \"$activityName\"?';
  }

  @override
  String get dialogActionsRequired => 'Vaaditut toiminnot';

  @override
  String get dialogAddPetMessage =>
      'Lisää vähintään yksi lemmikki aloittaaksesi toimintojen ja muistutusten lisäämisen.';

  @override
  String get dialogGot_it => 'Got it';

  @override
  String get dialogGotIt => 'Selvä';

  @override
  String get dayMon => 'Ma';

  @override
  String get dayTue => 'Ti';

  @override
  String get dayWed => 'Ke';

  @override
  String get dayThu => 'To';

  @override
  String get dayFri => 'Pe';

  @override
  String get daySat => 'La';

  @override
  String get daySun => 'Su';

  @override
  String get walkDeleteTitle => 'Poistetaanko kävely?';

  @override
  String get walkDeleteContent => 'Tämä poistaa nykyisen kävelysession.';

  @override
  String get walkCancel => 'Peruuta';

  @override
  String get walkDelete => 'Poista';

  @override
  String get walkStartTimerWarning => 'Käynnistä ajastin ennen tallennusta.';

  @override
  String get walkNote => 'Muistiinpano';

  @override
  String get walkNoteHint => 'Muistiinpanosi tähän';

  @override
  String get walkSave => 'Tallenna';

  @override
  String get walkAddNote => 'Lisää muistiinpano';

  @override
  String get walkDefaultName => 'Kävely';

  @override
  String get walkLocationPermission =>
      'Sijaintilupa tarvitaan kävelyjen seuraamiseen.';

  @override
  String get walkLocationService => 'Sijaintipalvelut on poistettu käytöstä.';

  @override
  String get reminderAddTitle => 'Lisää muistutus';

  @override
  String get reminderNone => 'Ei muistutuksia';

  @override
  String get reminderDefaultTitle => 'Muistutus';

  @override
  String get actionUpdate => 'Päivitä';

  @override
  String get actionRemove => 'Poista';

  @override
  String errorUpdateFailed(Object error) {
    return 'Päivitys epäonnistui: $error';
  }

  @override
  String get errorUpdateNotFound =>
      'Päivitys ei onnistunut: Toimintoa ei löytynyt';

  @override
  String get durationHr => 't';

  @override
  String get durationMin => 'min';

  @override
  String get durationSec => 's';

  @override
  String get pickerTakePhoto => 'Ota kuva';

  @override
  String get pickerGallery => 'Valitse galleriasta';

  @override
  String get pickerRecordVideo => 'Tallenna video';

  @override
  String get errorSelectActivity => 'Valitse ensin toiminto';

  @override
  String get errorReminderFuture => 'Muistutusajan on oltava tulevaisuudessa';

  @override
  String get errorValidWeight => 'Anna kelvollinen paino';

  @override
  String get errorValidHeight => 'Anna kelvollinen korkeus';

  @override
  String get errorValidTemp => 'Anna kelvollinen lämpötila';

  @override
  String get errorEnterFood => 'Anna ruoan nimi tai tyyppi';

  @override
  String get successActivitySaved => 'Toiminto tallennettu onnistuneesti!';

  @override
  String get successActivitySavedReminder =>
      'Toiminto ja muistutus tallennettu onnistuneesti!';

  @override
  String errorSaveFailed(Object error) {
    return 'Tallennus epäonnistui: $error';
  }

  @override
  String get labelSelectedImage => 'Valittu kuva:';

  @override
  String get labelSelectedVideo => 'Valittu video:';

  @override
  String get unitOz => 'oz';

  @override
  String get unitMl => 'ml';

  @override
  String get unitLbs => 'paunaa';

  @override
  String get unitKg => 'kg';

  @override
  String get unitInches => 'tuumaa';

  @override
  String get unitCm => 'cm';

  @override
  String get unitF => '°F';

  @override
  String get unitC => '°C';

  @override
  String get unitKm => 'km';

  @override
  String get unitMi => 'mi';

  @override
  String get actionAdd => 'Lisää juoman nimi tai tyyppi';

  @override
  String get actionAddImage => '+ Lisää kuva';

  @override
  String get actionAddVideo => '+ Lisää video';

  @override
  String get hintAddNote => 'Lisää muistiinpano...';

  @override
  String get startedAt => 'Alkoi klo';

  @override
  String get endedAt => 'Päättyi klo';

  @override
  String get noActivitySelected => 'Ei toimintoa valittuna';

  @override
  String get actionAddTreat => '+ Lisää herkku';

  @override
  String get actionAddGrooming => '+ Lisää trimmaustyyppi';

  @override
  String get actionAddMedication => '+ Lisää lääkitys';

  @override
  String get actionAddVaccination => '+ Lisää rokotus';

  @override
  String get actionAddHealthCondition => '+ Lisää terveydentila';

  @override
  String get actionAddAccident => '+ Lisää tapaturmatyyppi';

  @override
  String get actionAddCleaning => '+ Lisää siivoustyyppi';

  @override
  String get actionAddFood => '+ Lisää ruoan nimi tai tyyppi';

  @override
  String get actionStartTimer => 'Tai käynnistä ajastin';

  @override
  String get labelDate => 'Päivämäärä';

  @override
  String get labelTime => 'Aika';

  @override
  String get labelName => 'Nimi';

  @override
  String get hintEnterName => 'Anna nimi';

  @override
  String get actionSave => 'Tallenna';

  @override
  String get pickerSelectDate => 'Valitse päivämäärä';

  @override
  String get pickerSelectTime => 'Valitse aika';

  @override
  String reminderSetFor(String date, String time) {
    return 'Muistutus asetettu: $date klo $time';
  }

  @override
  String get myPetsTitle => 'Omat lemmikit';

  @override
  String get noPetsAdded => 'Ei vielä lisättyjä lemmikkejä';

  @override
  String get addPetButton => '+ Lisää lemmikki';

  @override
  String get noPetsMatch => 'Hakuasi vastaavia lemmikkejä ei löytynyt';

  @override
  String get tryDifferentSearch => 'Kokeile eri hakusanaa';

  @override
  String get petUpdatedSuccess => 'Lemmikki päivitetty onnistuneesti!';

  @override
  String get deletePetTitle => 'Poista lemmikki';

  @override
  String deletePetMessage(String petName) {
    return 'Haluatko varmasti poistaa lemmikin $petName?';
  }

  @override
  String get cancelButton => 'Peruuta';

  @override
  String get deleteButton => 'Poista';

  @override
  String petDeletedSuccess(String petName) {
    return '$petName poistettu onnistuneesti';
  }

  @override
  String petDeleteFailed(String petName) {
    return 'Lemmikin $petName poistaminen epäonnistui';
  }

  @override
  String get unknown => 'Tuntematon';

  @override
  String get genderOther => 'Muu';

  @override
  String get editPetTitle => 'Muokkaa lemmikkiä';

  @override
  String get labelPhoto => 'Kuva';

  @override
  String get hintSelectBreed => 'Valitse rotu';

  @override
  String get hintSearchBreed => 'Etsi rotu...';

  @override
  String get noBreedsFound => 'Rotuja ei löytynyt';

  @override
  String get msgFillAllFields => 'Täytä kaikki kentät';

  @override
  String get msgUpdateFailed => 'Päivitys epäonnistui';

  @override
  String get msgAddFailed => 'Lisääminen epäonnistui';

  @override
  String msgImagePickFailed(Object error) {
    return 'Kuvan valinta epäonnistui: $error';
  }

  @override
  String get labelBreed => 'Rotu';

  @override
  String get labelGender => 'Sukupuoli';

  @override
  String get labelDOB => 'Syntymäaika';

  @override
  String get genderMale => 'Uros';

  @override
  String get genderFemale => 'Naaras';

  @override
  String get labelPetName => 'Lemmikin nimi';

  @override
  String get addPetTitle => 'Lisää lemmikki';

  @override
  String get labelRequired => '(Pakollinen)';

  @override
  String get hintEnterPetName => 'Anna nimi';

  @override
  String get hintSelectGender => 'Valitse sukupuoli';

  @override
  String get errorSelectGender => 'Valitse sukupuoli';

  @override
  String get errorFillRequired => 'Täytä kaikki pakolliset kentät';

  @override
  String get errorRequired => '(Pakollinen)';

  @override
  String get hintTapToScan => 'Napauta skannataksesi';

  @override
  String get msgBreedDetected => 'Rotu tunnistettu!';

  @override
  String get breedAffenpinscher => 'Affenpinscher';

  @override
  String get breedAfghanHound => 'Afghan Hound';

  @override
  String get breedAfricanHuntingDog => 'African Hunting Dog';

  @override
  String get breedAiredale => 'Airedale';

  @override
  String get breedAmericanStaffordshireTerrier =>
      'American Staffordshire Terrier';

  @override
  String get breedAppenzeller => 'Appenzeller';

  @override
  String get breedAustralianTerrier => 'Australian Terrier';

  @override
  String get breedBasenji => 'Basenji';

  @override
  String get breedBasset => 'Basset';

  @override
  String get breedBeagle => 'Beagle';

  @override
  String get breedBedlingtonTerrier => 'Bedlington Terrier';

  @override
  String get breedBerneseMountainDog => 'Bernese Mountain Dog';

  @override
  String get breedBlackAndTanCoonhound => 'Black-and-tan Coonhound';

  @override
  String get breedBlenheimSpaniel => 'Blenheim Spaniel';

  @override
  String get breedBloodhound => 'Bloodhound';

  @override
  String get breedBluetick => 'Bluetick';

  @override
  String get breedBorderCollie => 'Border Collie';

  @override
  String get breedBorderTerrier => 'Border Terrier';

  @override
  String get breedBorzoi => 'Borzoi';

  @override
  String get breedBostonBull => 'Boston Bull';

  @override
  String get breedBouvierDesFlandres => 'Bouvier Des Flandres';

  @override
  String get breedBoxer => 'Boxer';

  @override
  String get breedBrabanconGriffon => 'Brabancon Griffon';

  @override
  String get breedBriard => 'Briard';

  @override
  String get breedBrittanySpaniel => 'Brittany Spaniel';

  @override
  String get breedBullMastiff => 'Bull Mastiff';

  @override
  String get breedCairn => 'Cairn';

  @override
  String get breedCardigan => 'Cardigan';

  @override
  String get breedChesapeakeBayRetriever => 'Chesapeake Bay Retriever';

  @override
  String get breedChihuahua => 'Chihuahua';

  @override
  String get breedChow => 'Chow';

  @override
  String get breedClumber => 'Clumber';

  @override
  String get breedCockerSpaniel => 'Cocker Spaniel';

  @override
  String get breedCollie => 'Collie';

  @override
  String get breedCurlyCoatedRetriever => 'Curly-coated Retriever';

  @override
  String get breedDandieDinmont => 'Dandie Dinmont';

  @override
  String get breedDhole => 'Dhole';

  @override
  String get breedDingo => 'Dingo';

  @override
  String get breedDoberman => 'Doberman';

  @override
  String get breedEnglishFoxhound => 'English Foxhound';

  @override
  String get breedEnglishSetter => 'English Setter';

  @override
  String get breedEnglishSpringer => 'English Springer';

  @override
  String get breedEntleBucher => 'EntleBucher';

  @override
  String get breedEskimoDog => 'Eskimo Dog';

  @override
  String get breedFlatCoatedRetriever => 'Flat-coated Retriever';

  @override
  String get breedFrenchBulldog => 'French Bulldog';

  @override
  String get breedGermanShepherd => 'German Shepherd';

  @override
  String get breedGermanShortHairedPointer => 'German Short-haired Pointer';

  @override
  String get breedGiantSchnauzer => 'Giant Schnauzer';

  @override
  String get breedGoldenRetriever => 'Golden Retriever';

  @override
  String get breedGordonSetter => 'Gordon Setter';

  @override
  String get breedGreatDane => 'Great Dane';

  @override
  String get breedGreatPyrenees => 'Great Pyrenees';

  @override
  String get breedGreaterSwissMountainDog => 'Greater Swiss Mountain Dog';

  @override
  String get breedGroenendael => 'Groenendael';

  @override
  String get breedIbizanHound => 'Ibizan Hound';

  @override
  String get breedIrishSetter => 'Irish Setter';

  @override
  String get breedIrishTerrier => 'Irish Terrier';

  @override
  String get breedIrishWaterSpaniel => 'Irish Water Spaniel';

  @override
  String get breedIrishWolfhound => 'Irish Wolfhound';

  @override
  String get breedItalianGreyhound => 'Italian Greyhound';

  @override
  String get breedJapaneseSpaniel => 'Japanese Spaniel';

  @override
  String get breedKeeshond => 'Keeshond';

  @override
  String get breedKelpie => 'Kelpie';

  @override
  String get breedKerryBlueTerrier => 'Kerry Blue Terrier';

  @override
  String get breedKomondor => 'Komondor';

  @override
  String get breedKuvasz => 'Kuvasz';

  @override
  String get breedLabradorRetriever => 'Labrador Retriever';

  @override
  String get breedLakelandTerrier => 'Lakeland Terrier';

  @override
  String get breedLeonberg => 'Leonberg';

  @override
  String get breedLhasa => 'Lhasa';

  @override
  String get breedMalamute => 'Malamute';

  @override
  String get breedMalinois => 'Malinois';

  @override
  String get breedMalteseDog => 'Maltese Dog';

  @override
  String get breedMexicanHairless => 'Mexican Hairless';

  @override
  String get breedMiniaturePinscher => 'Miniature Pinscher';

  @override
  String get breedMiniaturePoodle => 'Miniature Poodle';

  @override
  String get breedMiniatureSchnauzer => 'Miniature Schnauzer';

  @override
  String get breedNewfoundland => 'Newfoundland';

  @override
  String get breedNorfolkTerrier => 'Norfolk Terrier';

  @override
  String get breedNorwegianElkhound => 'Norwegian Elkhound';

  @override
  String get breedNorwichTerrier => 'Norwich Terrier';

  @override
  String get breedOldEnglishSheepdog => 'Old English Sheepdog';

  @override
  String get breedOtterhound => 'Otterhound';

  @override
  String get breedPapillon => 'Papillon';

  @override
  String get breedPekinese => 'Pekinese';

  @override
  String get breedPembroke => 'Pembroke';

  @override
  String get breedPomeranian => 'Pomeranian';

  @override
  String get breedPug => 'Pug';

  @override
  String get breedRedbone => 'Redbone';

  @override
  String get breedRhodesianRidgeback => 'Rhodesian Ridgeback';

  @override
  String get breedRottweiler => 'Rottweiler';

  @override
  String get breedSaintBernard => 'Saint Bernard';

  @override
  String get breedSaluki => 'Saluki';

  @override
  String get breedSamoyed => 'Samoyed';

  @override
  String get breedSchipperke => 'Schipperke';

  @override
  String get breedScotchTerrier => 'Scotch Terrier';

  @override
  String get breedScottishDeerhound => 'Scottish Deerhound';

  @override
  String get breedSealyhamTerrier => 'Sealyham Terrier';

  @override
  String get breedShetlandSheepdog => 'Shetland Sheepdog';

  @override
  String get breedShihTzu => 'Shih-Tzu';

  @override
  String get breedSiberianHusky => 'Siberian Husky';

  @override
  String get breedSilkyTerrier => 'Silky Terrier';

  @override
  String get breedSoftCoatedWheatenTerrier => 'Soft-coated Wheaten Terrier';

  @override
  String get breedStaffordshireBullterrier => 'Staffordshire Bullterrier';

  @override
  String get breedStandardPoodle => 'Standard Poodle';

  @override
  String get breedStandardSchnauzer => 'Standard Schnauzer';

  @override
  String get breedSussexSpaniel => 'Sussex Spaniel';

  @override
  String get breedTibetanMastiff => 'Tibetan Mastiff';

  @override
  String get breedTibetanTerrier => 'Tibetan Terrier';

  @override
  String get breedToyPoodle => 'Toy Poodle';

  @override
  String get breedToyTerrier => 'Toy Terrier';

  @override
  String get breedVizsla => 'Vizsla';

  @override
  String get breedWalkerHound => 'Walker Hound';

  @override
  String get breedWeimaraner => 'Weimaraner';

  @override
  String get breedWelshSpringerSpaniel => 'Welsh Springer Spaniel';

  @override
  String get breedWestHighlandWhiteTerrier => 'West Highland White Terrier';

  @override
  String get breedWhippet => 'Whippet';

  @override
  String get breedWireHairedFoxTerrier => 'Wire-haired Fox Terrier';

  @override
  String get breedYorkshireTerrier => 'Yorkshire Terrier';

  @override
  String activityCount(int count) {
    return '$count';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navMyPets => 'My Pets';

  @override
  String get navProfile => 'Profile';

  @override
  String get aiIdentifyingYour => 'AI identifying Your ';

  @override
  String get dogText => 'DOG';

  @override
  String get identifyingTimeText => 'This usually takes up 1 minute...';

  @override
  String get analyzingImage => 'Analyzing image...';

  @override
  String get errorOccurred => 'Error Occurred';

  @override
  String get goBack => 'Go Back';

  @override
  String get noDogDetected => 'No Dog Detected';

  @override
  String get clearerPhotoPrompt => 'Please try with a clearer photo of a dog.';

  @override
  String get cancel => 'Cancel';

  @override
  String get tryAgain => 'Try Again';

  @override
  String lowConfidenceWarning(String confidence) {
    return 'Low confidence ($confidence%). Results may not be accurate.';
  }

  @override
  String get savingToRecentScans => 'Saving to recent scans...';

  @override
  String get dogResults => 'Dog Results';

  @override
  String get size => 'Size';

  @override
  String get shape => 'Shape';

  @override
  String get color => 'Color';

  @override
  String get coat => 'Coat';

  @override
  String get headAndFace => 'Head & Face';

  @override
  String get purpose => 'Purpose';

  @override
  String get body => 'Body';

  @override
  String get weight => 'Weight';

  @override
  String get temperamentAndCharacteristics => 'Temperament & Characteristics';

  @override
  String get energyLevel => 'Energy Level';

  @override
  String get trainability => 'Trainability';

  @override
  String get socialBehavior => 'Social Behavior';

  @override
  String get familyCompatibility => 'Family Compatibility';

  @override
  String get childFriendliness => 'Child Friendliness';

  @override
  String get addPet => '+add Pet';

  @override
  String get cannotSave => 'Cannot Save';

  @override
  String get saving => 'Saving...';

  @override
  String get saved => 'Saved';

  @override
  String get save => 'Save';

  @override
  String cannotSaveConfidence(String confidence) {
    return 'Cannot save: Confidence $confidence% < 40%';
  }

  @override
  String get noPredictionResult => 'No prediction result available';

  @override
  String get noImageDataToSave => 'No image data to save';

  @override
  String get failedToSaveResults => 'Failed to save results';

  @override
  String get moderate => 'Moderate';

  @override
  String get friendly => 'Friendly';

  @override
  String get good => 'Good';
}
