// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class AppLocalizationsKk extends AppLocalizations {
  AppLocalizationsKk([String locale = 'kk']) : super(locale);

  @override
  String get navHome => 'Басты бет';

  @override
  String get navAiLawyer => 'Жасанды интеллект (AI)';

  @override
  String get navLawyers => 'Заңгерлер';

  @override
  String get navProfile => 'Профиль';

  @override
  String get authAppName => 'LegalHelp KZ';

  @override
  String get authSubtitleSignIn => 'Қайта оралуыңызбен';

  @override
  String get authSubtitleSignUp => 'Тіркелу';

  @override
  String get authEmailLabel => 'Электрондық пошта (Email)';

  @override
  String get authEmailError => 'Дұрыс пошта енгізіңіз';

  @override
  String get authPasswordLabel => 'Құпия сөз';

  @override
  String get authPasswordError => 'Кем дегенде 6 таңба';

  @override
  String get authEmptyFieldsError => 'Барлық өрістерді толтырыңыз';

  @override
  String get authSignIn => 'Кіру';

  @override
  String get authSignUp => 'Тіркелу';

  @override
  String get authSocialDivider => 'Немесе арқылы кіріңіз';

  @override
  String get authNoAccount => 'Аккаунтыңыз жоқ па? ';

  @override
  String get authHasAccount => 'Аккаунтыңыз бар ма? ';

  @override
  String get authSwitchToSignUp => 'Тіркелу';

  @override
  String get authSwitchToSignIn => 'Кіру';

  @override
  String get dashboardMorning => 'Қайырлы таң';

  @override
  String get dashboardDay => 'Қайырлы күн';

  @override
  String get dashboardEvening => 'Қайырлы кеш';

  @override
  String get dashboardNight => 'Қайырлы түн';

  @override
  String get dashboardAiHelp => 'Бүгін AI қалай көмектесе алады?';

  @override
  String get dashboardQuickActions => 'Жылдам әрекеттер';

  @override
  String get dashboardDocs => 'Құжаттар';

  @override
  String get dashboardViewAll => 'Барлығын көру';

  @override
  String get dashboardCases => 'Істер';

  @override
  String dashboardError(String error) {
    return 'Жүктеу қатесі: $error';
  }

  @override
  String get dashboardRetry => 'Қайталау';

  @override
  String get quickScanner => 'Паспортты сканерлеу';

  @override
  String get quickScannerSub => 'OCR Тану';

  @override
  String get quickFindLawyer => 'Заңгерді табу';

  @override
  String get quickFindLawyerSub => 'Маркетплейс';

  @override
  String get quickSos => 'Шұғыл қоңырау';

  @override
  String get quickSosSub => 'Адвокатты шақыру';

  @override
  String get aiSearchTitle => 'ЖИ-ға құқықтық сұрақ қою...';

  @override
  String get aiSearchSubtitle => 'Тегін • 2 секундта жауап';

  @override
  String get scannerTitle => 'Ақылды Сканер';

  @override
  String get scannerEmptyTitle => 'Сканерлеуге дайын';

  @override
  String get scannerEmptyDesc =>
      'Мәтінді және деректерді автоматты түрде тану үшін камераңызды құжатқа немесе паспортқа (ҚР ЖСН) бағыттаңыз.';

  @override
  String get scannerButton => 'СКАНЕРЛЕУ';

  @override
  String get scannerProcessing => 'ЖИ құжатты талдауда...';

  @override
  String get scannerAuthRequired => 'Құжатты сақтау үшін кіріңіз';

  @override
  String get scannerDocTitle => 'Сканерленген құжат';

  @override
  String get scannerSaved => 'Құжат сәтті сақталды';

  @override
  String scannerSaveError(String error) {
    return 'Сақтау қатесі: $error';
  }

  @override
  String get scannerNoText => 'Мәтін табылмады. Қайта көріңіз.';

  @override
  String get scannerCopy => 'Көшіру';

  @override
  String get scannerCopied => 'Мәтін алмасу буферіне көшірілді';

  @override
  String get scannerSave => 'Сақтау';

  @override
  String get scannerReset => 'Болдырмау және қайта сканерлеу';

  @override
  String get chatTitle => 'ЖИ-Кеңесші';

  @override
  String get chatTyping => 'ЖИ жазуда...';

  @override
  String get chatEmptyTitle => 'Диалогты бастаңыз';

  @override
  String get chatEmptySubtitle =>
      'Құқықтық мәселеңізді жазыңыз.\nЖИ ҚР заңдарын талдап, нақты жауап береді.';

  @override
  String get chatInputHint => 'Мәселеңізді сипаттаңыз...';

  @override
  String get paywallTitle => 'Премиум рұқсат';

  @override
  String get paywallSubtitle => 'ЖИ кеңестерін шектеусіз алыңыз';

  @override
  String get paywallBenefit1 => 'Шектеусіз хабарламалар';

  @override
  String get paywallBenefit2 => 'Басым жауап';

  @override
  String get paywallBenefit3 => 'Сот тәжірибесін талдау';

  @override
  String get paywallCta => 'Жазылуды ресімдеу';

  @override
  String get paywallDismiss => 'Кейінірек';

  @override
  String get marketplaceTitle => 'Заңгерді табу';

  @override
  String marketplaceError(String error) {
    return 'Жүктеу қатесі: $error';
  }

  @override
  String get marketplaceEmpty => 'Қолжетімді заңгерлер жоқ';

  @override
  String marketplaceReviews(int count) {
    return '$count пікір';
  }

  @override
  String marketplaceRate(int rate) {
    return '$rate ₸/сағ';
  }

  @override
  String get marketplaceContact => 'БАЙЛАНЫСУ';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileGuestInitial => 'Қ';

  @override
  String get profileGuest => 'Қонақ';

  @override
  String get profileUser => 'Пайдаланушы';

  @override
  String get profileGuestEmail => 'Деректерді сақтау үшін кіріңіз';

  @override
  String get profileBasicPlan => 'Негізгі тариф';

  @override
  String get profileFreeQueries => 'Билет саны: 3';

  @override
  String get profileUpgrade => 'Pro алу';

  @override
  String get profileMyDocuments => 'Менің құжаттарым';

  @override
  String get profileHistory => 'Қызметтер тарихы';

  @override
  String get profileSubscription => 'Жазылымды басқару';

  @override
  String get profileSupport => 'Қолдау қызметі';

  @override
  String get profileLogin => 'Аккаунтқа кіру';

  @override
  String get profileLogout => 'Шығу';

  @override
  String get settingsTitle => 'Баптаулар';

  @override
  String get settingsSectionMain => 'НЕГІЗГІ';

  @override
  String get settingsPushTitle => 'Push-хабарламалар';

  @override
  String get settingsPushSubtitle => 'Заңгерлер мен ЖИ жауаптарын алу';

  @override
  String get settingsLanguageTitle => 'Интерфейс тілі';

  @override
  String get settingsLanguageKazakh => 'Қазақша';

  @override
  String get settingsLanguageRussian => 'Русский';

  @override
  String get settingsChooseLanguage => 'Тілді таңдаңыз';

  @override
  String get settingsSectionDesign => 'РЕСІМДЕУ';

  @override
  String get settingsDarkThemeTitle => 'Қараңғы тақырып (Gold Premium)';

  @override
  String get settingsDarkThemeSubtitle => 'OLED экрандарға оңтайландырылған';

  @override
  String get settingsSectionInfo => 'АҚПАРАТ';

  @override
  String get settingsPrivacy => 'Құпиялылық саясаты';

  @override
  String get settingsTerms => 'Пайдаланушы келісімі';

  @override
  String get docsTitle => 'Менің құжаттарым';

  @override
  String get docsFab => 'Жаңа сканерлеу';

  @override
  String get docsFabSnackbar => 'Сканер ашылуда...';

  @override
  String docsError(String error) {
    return 'Қате: $error';
  }

  @override
  String get docsEmpty => 'Сізде әлі сақталған құжаттар жоқ';

  @override
  String get docsUntitled => 'Атаусыз';

  @override
  String get docsJustNow => 'Жаңа ғана';

  @override
  String docsAdded(String date) {
    return 'Қосылды $date';
  }

  @override
  String get historyTitle => 'Қызметтер тарихы';

  @override
  String historyError(String error) {
    return 'Қате: $error';
  }

  @override
  String get historyEmpty => 'Кеңес беру тарихы бос';

  @override
  String get historyAiConsult => 'ЖИ-мен кеңес';

  @override
  String get historyLawyerConsult => 'Заңгермен кеңес';

  @override
  String get historySoon => 'Жақында';

  @override
  String get historyPending => 'Өңделуде';

  @override
  String get historyCompleted => 'Аяқталды';

  @override
  String get subTitle => 'Жазылым';

  @override
  String get subChoosePlan => 'Тарифіңізді таңдаңыз';

  @override
  String get subDescription =>
      'ЖИ-ді тегін қолданып көріңіз немесе Premium арқылы барлық мүмкіндіктерді ашыңыз';

  @override
  String get subPerMonth => '/ ай';

  @override
  String get subFreeDesc => 'Күніне 3 сұрауға дейін, негізгі функциялар.';

  @override
  String get subProDesc =>
      'Шектеусіз ЖИ-кеңесшісі, басым жауаптар және толық құпиялылық.';

  @override
  String get subBusinessDesc =>
      'API интеграциясы, келісімшарт үлгілері және командалық қолжетімділік.';

  @override
  String get subPaymentInDev => 'Қап... Төлем жүйесі (Kaspi) әзірленуде';

  @override
  String get subB2bInDev => 'B2B шешімдері үшін бізбен байланысыңыз';

  @override
  String get subRecommended => '🔥 ҰСЫНАМЫЗ';

  @override
  String get subCurrentPlan => 'АҒЫМДАҒЫ';

  @override
  String get subUpgrade => 'ӨТУ';

  @override
  String get supportTitle => 'Қолдау';

  @override
  String get supportHeader => 'Мәселе бар ма?';

  @override
  String get supportContactOp => 'Операторға жазу';

  @override
  String get supportTelegramSnack => 'Telegram қолдау чаты ашылуда...';

  @override
  String get supportFaqHeader => 'ЖИІ ҚОЙЫЛАТЫН СҰРАҚТАР';

  @override
  String get supportFaq1Q => 'ЖИ-кеңесшісі қалай жұмыс істейді?';

  @override
  String get supportFaq1A =>
      'Біздің ЖИ ҚР заңнамалық базасы мен сот тәжірибесінде оқытылған. Ол сұрағыңызды талдайды және заңдарға сілтемелер береді.';

  @override
  String get supportFaq2Q => 'Мен нақты заңгерді жалдай аламын ба?';

  @override
  String get supportFaq2A =>
      'Иә, егер ЖИ жауабы жеткіліксіз болса, \"Заңгерлер\" бөліміне өтіп, маман таңдай аласыз.';

  @override
  String get supportFaq3Q => 'Жазылымды қалай тоқтатуға болады?';

  @override
  String get supportFaq3A =>
      'Жазылымды профиліңіздегі \"Жазылым басқармасы\" бөлімінен тоқтата аласыз.';

  @override
  String get supportFaq4Q => 'Менің деректерім қорғалған ба?';

  @override
  String get supportFaq4A =>
      'Біз AES-256 шифрлауын қолданамыз және деректерді қорғалған серверлерде сақтаймыз.';

  @override
  String get sosTitle => 'SOS Шұғыл көмек';

  @override
  String get sosDialerError => 'Қоңырау шалу бағдарламасы ашылмады';

  @override
  String sosCallError(String error) {
    return 'Қоңырау шалу қатесі: $error';
  }

  @override
  String get sosButton => 'АДВОКАТҚА\nҚОҢЫРАУ ШАЛУ';

  @override
  String get sosOfflineHeader => 'ҰСТАУ КЕЗІНДЕГІ ОФФЛАЙН ЖАДНАМА';

  @override
  String get sosRule1Title => 'Сіздің қоңырау шалу құқығыңыз бар';

  @override
  String get sosRule1Content =>
      'ҚР ҚІЖК 131-бабына сәйкес, ұсталғаннан кейін адвокатқа немесе туыстарыңызға дереу телефон соғуға құқығыңыз бар.';

  @override
  String get sosRule2Title => 'Үндемеу құқығы';

  @override
  String get sosRule2Content =>
      'ҚР Конституциясының 77-бабына сәйкес, өзіңізге қарсы түсініктеме бермеуге құқығыңыз бар. Адвокаттың қатысуын талап етіңіз.';

  @override
  String get sosRule3Title => 'Хаттаманы мұқият оқыңыз';

  @override
  String get sosRule3Content =>
      'Ешқашан бос парақтарға немесе сіз келіспеген құжаттарға қол қоймаңыз. Келіспесеңіз — жазбаша «Келіспеймін» деп жазыңыз.';

  @override
  String get dashboardTitle => 'Басты бет';

  @override
  String get dashboardOfflineBanner =>
      'Офлайн режим. Тек сақталған құжаттар мен SOS қолжетімді.';

  @override
  String get dashboardSectionUrgent => 'Шұғыл';

  @override
  String get dashboardSectionAdvice => 'Кеңестер';

  @override
  String get dashboardSectionActivity => 'Белсенділік';

  @override
  String get dashboardGreetingNight => 'Қайырлы түн';

  @override
  String get dashboardGreetingMorning => 'Қайырлы таң';

  @override
  String get dashboardGreetingAfternoon => 'Қайырлы күн';

  @override
  String get dashboardGreetingEvening => 'Қайырлы кеш';

  @override
  String get dashboardUser => 'Пайдаланушы';

  @override
  String dashboardSubtitle(String name) {
    return 'Қош келдіңіз, $name';
  }

  @override
  String get dashboardFreePlan => 'Базалық жоспар';

  @override
  String dashboardAvailable(int available, int maxQueries) {
    return 'Қолжетімді: $maxQueries ішінен $available';
  }

  @override
  String get adviceTitle1 => 'ЖШС қалай ашуға болады';

  @override
  String get adviceSubtitle1 => 'Қадамдық нұсқаулық';

  @override
  String get adviceTitle2 => '2026 жылғы салықтар';

  @override
  String get adviceSubtitle2 => 'Не өзгерді?';

  @override
  String get adviceTitle3 => 'Еңбек шарты';

  @override
  String get adviceSubtitle3 => 'Үлгілер мен ережелер';

  @override
  String get activityConsultation => 'ЖИ-мен кеңесу';

  @override
  String get activityContractAnalysis => 'Шартты талдау';

  @override
  String get activityToday => 'Бүгін';

  @override
  String get activityYesterday => 'Кеше';

  @override
  String get dashboardErrorTitle => 'Деректерді жүктеу қатесі';

  @override
  String get subFreeFeat1 => 'ЖИ-ға 10 сұрауға дейін';

  @override
  String get subFreeFeat2 => 'Заңгерлерді негізгі іздеу';

  @override
  String get subFreeFeat3 => 'Құжат сканері';

  @override
  String get subProFeat1 => 'Шексіз ЖИ-Кеңесші';

  @override
  String get subProFeat2 => 'Шарттар мен құжаттарды талдау';

  @override
  String get subProFeat3 => '2 секундтағы басымдықты жауаптар';

  @override
  String get subProFeat4 => 'Толық құпиялылық';

  @override
  String get subBizFeat1 => 'Pro-дан бәрі';

  @override
  String get subBizFeat2 => 'API интеграциясы';

  @override
  String get subBizFeat3 => 'Шарт үлгілері';

  @override
  String get subBizFeat4 => '10 заңгерге дейін командалық қолжетімділік';

  @override
  String get paywallLimitReached => 'Тегін сұраулар лимиті таусылды';

  @override
  String get paywallUpgradeHint =>
      'ЖИ-ға шексіз қолжетімділік үшін PRO-ға көшіңіз';
}
