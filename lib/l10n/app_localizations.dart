import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_kk.dart';
import 'app_localizations_ru.dart';

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
    Locale('kk'),
    Locale('ru'),
  ];

  /// No description provided for @navHome.
  ///
  /// In ru, this message translates to:
  /// **'Главная'**
  String get navHome;

  /// No description provided for @navAiLawyer.
  ///
  /// In ru, this message translates to:
  /// **'ИИ-Юрист'**
  String get navAiLawyer;

  /// No description provided for @navLawyers.
  ///
  /// In ru, this message translates to:
  /// **'Юристы'**
  String get navLawyers;

  /// No description provided for @navProfile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get navProfile;

  /// No description provided for @authAppName.
  ///
  /// In ru, this message translates to:
  /// **'LegalHelp KZ'**
  String get authAppName;

  /// No description provided for @authSubtitleSignIn.
  ///
  /// In ru, this message translates to:
  /// **'С возвращением'**
  String get authSubtitleSignIn;

  /// No description provided for @authSubtitleSignUp.
  ///
  /// In ru, this message translates to:
  /// **'Создать аккаунт'**
  String get authSubtitleSignUp;

  /// No description provided for @authEmailLabel.
  ///
  /// In ru, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authEmailError.
  ///
  /// In ru, this message translates to:
  /// **'Введите корректный email'**
  String get authEmailError;

  /// No description provided for @authPasswordLabel.
  ///
  /// In ru, this message translates to:
  /// **'Пароль'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordError.
  ///
  /// In ru, this message translates to:
  /// **'Минимум 6 символов'**
  String get authPasswordError;

  /// No description provided for @authEmptyFieldsError.
  ///
  /// In ru, this message translates to:
  /// **'Пожалуйста, заполните все поля'**
  String get authEmptyFieldsError;

  /// No description provided for @authSignIn.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get authSignIn;

  /// No description provided for @authSignUp.
  ///
  /// In ru, this message translates to:
  /// **'Создать аккаунт'**
  String get authSignUp;

  /// No description provided for @authSocialDivider.
  ///
  /// In ru, this message translates to:
  /// **'Или войдите через'**
  String get authSocialDivider;

  /// No description provided for @authNoAccount.
  ///
  /// In ru, this message translates to:
  /// **'Нет аккаунта? '**
  String get authNoAccount;

  /// No description provided for @authHasAccount.
  ///
  /// In ru, this message translates to:
  /// **'Уже есть аккаунт? '**
  String get authHasAccount;

  /// No description provided for @authSwitchToSignUp.
  ///
  /// In ru, this message translates to:
  /// **'Регистрация'**
  String get authSwitchToSignUp;

  /// No description provided for @authSwitchToSignIn.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get authSwitchToSignIn;

  /// No description provided for @dashboardMorning.
  ///
  /// In ru, this message translates to:
  /// **'Доброе утро'**
  String get dashboardMorning;

  /// No description provided for @dashboardDay.
  ///
  /// In ru, this message translates to:
  /// **'Добрый день'**
  String get dashboardDay;

  /// No description provided for @dashboardEvening.
  ///
  /// In ru, this message translates to:
  /// **'Добрый вечер'**
  String get dashboardEvening;

  /// No description provided for @dashboardNight.
  ///
  /// In ru, this message translates to:
  /// **'Доброй ночи'**
  String get dashboardNight;

  /// No description provided for @dashboardAiHelp.
  ///
  /// In ru, this message translates to:
  /// **'Чем ИИ может помочь сегодня?'**
  String get dashboardAiHelp;

  /// No description provided for @dashboardQuickActions.
  ///
  /// In ru, this message translates to:
  /// **'Быстрые действия'**
  String get dashboardQuickActions;

  /// No description provided for @dashboardDocs.
  ///
  /// In ru, this message translates to:
  /// **'Документы'**
  String get dashboardDocs;

  /// No description provided for @dashboardViewAll.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get dashboardViewAll;

  /// No description provided for @dashboardCases.
  ///
  /// In ru, this message translates to:
  /// **'Дела'**
  String get dashboardCases;

  /// No description provided for @dashboardError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка загрузки: {error}'**
  String dashboardError(String error);

  /// No description provided for @dashboardRetry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get dashboardRetry;

  /// No description provided for @quickScanner.
  ///
  /// In ru, this message translates to:
  /// **'Скан паспорта'**
  String get quickScanner;

  /// No description provided for @quickScannerSub.
  ///
  /// In ru, this message translates to:
  /// **'OCR Распознавание'**
  String get quickScannerSub;

  /// No description provided for @quickFindLawyer.
  ///
  /// In ru, this message translates to:
  /// **'Найти юриста'**
  String get quickFindLawyer;

  /// No description provided for @quickFindLawyerSub.
  ///
  /// In ru, this message translates to:
  /// **'Маркетплейс'**
  String get quickFindLawyerSub;

  /// No description provided for @quickSos.
  ///
  /// In ru, this message translates to:
  /// **'Экстренно'**
  String get quickSos;

  /// No description provided for @quickSosSub.
  ///
  /// In ru, this message translates to:
  /// **'Вызов адвоката'**
  String get quickSosSub;

  /// No description provided for @aiSearchTitle.
  ///
  /// In ru, this message translates to:
  /// **'Задать правовой вопрос ИИ...'**
  String get aiSearchTitle;

  /// No description provided for @aiSearchSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Бесплатно • Ответ за 2 секунды'**
  String get aiSearchSubtitle;

  /// No description provided for @scannerTitle.
  ///
  /// In ru, this message translates to:
  /// **'Умный Сканер'**
  String get scannerTitle;

  /// No description provided for @scannerEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Готов к сканированию'**
  String get scannerEmptyTitle;

  /// No description provided for @scannerEmptyDesc.
  ///
  /// In ru, this message translates to:
  /// **'Наведите камеру на документ или паспорт (УДЛ RK), чтобы ИИ распознал текст и данные автоматически.'**
  String get scannerEmptyDesc;

  /// No description provided for @scannerButton.
  ///
  /// In ru, this message translates to:
  /// **'СКАНИРОВАТЬ'**
  String get scannerButton;

  /// No description provided for @scannerProcessing.
  ///
  /// In ru, this message translates to:
  /// **'ИИ анализирует документ...'**
  String get scannerProcessing;

  /// No description provided for @scannerAuthRequired.
  ///
  /// In ru, this message translates to:
  /// **'Войдите, чтобы сохранить документ'**
  String get scannerAuthRequired;

  /// No description provided for @scannerDocTitle.
  ///
  /// In ru, this message translates to:
  /// **'Отсканированный документ'**
  String get scannerDocTitle;

  /// No description provided for @scannerSaved.
  ///
  /// In ru, this message translates to:
  /// **'Документ успешно сохранен'**
  String get scannerSaved;

  /// No description provided for @scannerSaveError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка сохранения: {error}'**
  String scannerSaveError(String error);

  /// No description provided for @scannerNoText.
  ///
  /// In ru, this message translates to:
  /// **'Текст не найден. Попробуйте еще раз.'**
  String get scannerNoText;

  /// No description provided for @scannerCopy.
  ///
  /// In ru, this message translates to:
  /// **'Копировать'**
  String get scannerCopy;

  /// No description provided for @scannerCopied.
  ///
  /// In ru, this message translates to:
  /// **'Текст скопирован в буфер обмена'**
  String get scannerCopied;

  /// No description provided for @scannerSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get scannerSave;

  /// No description provided for @scannerReset.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить и сканировать заново'**
  String get scannerReset;

  /// No description provided for @chatTitle.
  ///
  /// In ru, this message translates to:
  /// **'ИИ-Консультант'**
  String get chatTitle;

  /// No description provided for @chatTyping.
  ///
  /// In ru, this message translates to:
  /// **'ИИ печатает...'**
  String get chatTyping;

  /// No description provided for @chatEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Начните диалог'**
  String get chatEmptyTitle;

  /// No description provided for @chatEmptySubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Напишите ваш правовой вопрос.\nИИ проанализирует законы РК и даст точный ответ.'**
  String get chatEmptySubtitle;

  /// No description provided for @chatInputHint.
  ///
  /// In ru, this message translates to:
  /// **'Опишите вашу проблему...'**
  String get chatInputHint;

  /// No description provided for @paywallTitle.
  ///
  /// In ru, this message translates to:
  /// **'Премиум доступ'**
  String get paywallTitle;

  /// No description provided for @paywallSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Получите неограниченные консультации ИИ'**
  String get paywallSubtitle;

  /// No description provided for @paywallBenefit1.
  ///
  /// In ru, this message translates to:
  /// **'Безлимитные сообщения'**
  String get paywallBenefit1;

  /// No description provided for @paywallBenefit2.
  ///
  /// In ru, this message translates to:
  /// **'Приоритетный ответ'**
  String get paywallBenefit2;

  /// No description provided for @paywallBenefit3.
  ///
  /// In ru, this message translates to:
  /// **'Анализ судебной практики'**
  String get paywallBenefit3;

  /// No description provided for @paywallCta.
  ///
  /// In ru, this message translates to:
  /// **'Оформить подписку'**
  String get paywallCta;

  /// No description provided for @paywallDismiss.
  ///
  /// In ru, this message translates to:
  /// **'Позже'**
  String get paywallDismiss;

  /// No description provided for @marketplaceTitle.
  ///
  /// In ru, this message translates to:
  /// **'Найти юриста'**
  String get marketplaceTitle;

  /// No description provided for @marketplaceError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка загрузки: {error}'**
  String marketplaceError(String error);

  /// No description provided for @marketplaceEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Нет доступных юристов'**
  String get marketplaceEmpty;

  /// No description provided for @marketplaceReviews.
  ///
  /// In ru, this message translates to:
  /// **'{count} отзывов'**
  String marketplaceReviews(int count);

  /// No description provided for @marketplaceRate.
  ///
  /// In ru, this message translates to:
  /// **'{rate} ₸/час'**
  String marketplaceRate(int rate);

  /// No description provided for @marketplaceContact.
  ///
  /// In ru, this message translates to:
  /// **'СВЯЗАТЬСЯ'**
  String get marketplaceContact;

  /// No description provided for @profileTitle.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get profileTitle;

  /// No description provided for @profileGuestInitial.
  ///
  /// In ru, this message translates to:
  /// **'Г'**
  String get profileGuestInitial;

  /// No description provided for @profileGuest.
  ///
  /// In ru, this message translates to:
  /// **'Гость'**
  String get profileGuest;

  /// No description provided for @profileUser.
  ///
  /// In ru, this message translates to:
  /// **'Пользователь'**
  String get profileUser;

  /// No description provided for @profileGuestEmail.
  ///
  /// In ru, this message translates to:
  /// **'Войдите для сохранения данных'**
  String get profileGuestEmail;

  /// No description provided for @profileBasicPlan.
  ///
  /// In ru, this message translates to:
  /// **'Базовый тариф'**
  String get profileBasicPlan;

  /// No description provided for @profileFreeQueries.
  ///
  /// In ru, this message translates to:
  /// **'Осталось бесплатных запросов: 3'**
  String get profileFreeQueries;

  /// No description provided for @profileUpgrade.
  ///
  /// In ru, this message translates to:
  /// **'Получить Pro'**
  String get profileUpgrade;

  /// No description provided for @profileMyDocuments.
  ///
  /// In ru, this message translates to:
  /// **'Мои документы'**
  String get profileMyDocuments;

  /// No description provided for @profileHistory.
  ///
  /// In ru, this message translates to:
  /// **'История услуг'**
  String get profileHistory;

  /// No description provided for @profileSubscription.
  ///
  /// In ru, this message translates to:
  /// **'Управление подпиской'**
  String get profileSubscription;

  /// No description provided for @profileSupport.
  ///
  /// In ru, this message translates to:
  /// **'Служба поддержки'**
  String get profileSupport;

  /// No description provided for @profileLogin.
  ///
  /// In ru, this message translates to:
  /// **'Войти в аккаунт'**
  String get profileLogin;

  /// No description provided for @profileLogout.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get profileLogout;

  /// No description provided for @settingsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settingsTitle;

  /// No description provided for @settingsSectionMain.
  ///
  /// In ru, this message translates to:
  /// **'ОСНОВНЫЕ'**
  String get settingsSectionMain;

  /// No description provided for @settingsPushTitle.
  ///
  /// In ru, this message translates to:
  /// **'Push-уведомления'**
  String get settingsPushTitle;

  /// No description provided for @settingsPushSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Получать ответы юристов и ИИ'**
  String get settingsPushSubtitle;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In ru, this message translates to:
  /// **'Язык интерфейса'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsLanguageKazakh.
  ///
  /// In ru, this message translates to:
  /// **'Қазақша'**
  String get settingsLanguageKazakh;

  /// No description provided for @settingsLanguageRussian.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get settingsLanguageRussian;

  /// No description provided for @settingsChooseLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Выберите язык'**
  String get settingsChooseLanguage;

  /// No description provided for @settingsSectionDesign.
  ///
  /// In ru, this message translates to:
  /// **'ОФОРМЛЕНИЕ'**
  String get settingsSectionDesign;

  /// No description provided for @settingsDarkThemeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Темная тема (Gold Premium)'**
  String get settingsDarkThemeTitle;

  /// No description provided for @settingsDarkThemeSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Оптимизировано для OLED экранов'**
  String get settingsDarkThemeSubtitle;

  /// No description provided for @settingsSectionInfo.
  ///
  /// In ru, this message translates to:
  /// **'ИНФОРМАЦИЯ'**
  String get settingsSectionInfo;

  /// No description provided for @settingsPrivacy.
  ///
  /// In ru, this message translates to:
  /// **'Политика конфиденциальности'**
  String get settingsPrivacy;

  /// No description provided for @settingsTerms.
  ///
  /// In ru, this message translates to:
  /// **'Пользовательское соглашение'**
  String get settingsTerms;

  /// No description provided for @docsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Мои документы'**
  String get docsTitle;

  /// No description provided for @docsFab.
  ///
  /// In ru, this message translates to:
  /// **'Новый скан'**
  String get docsFab;

  /// No description provided for @docsFabSnackbar.
  ///
  /// In ru, this message translates to:
  /// **'Открываем сканер...'**
  String get docsFabSnackbar;

  /// No description provided for @docsError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка: {error}'**
  String docsError(String error);

  /// No description provided for @docsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'У вас пока нет сохраненных документов'**
  String get docsEmpty;

  /// No description provided for @docsUntitled.
  ///
  /// In ru, this message translates to:
  /// **'Без названия'**
  String get docsUntitled;

  /// No description provided for @docsJustNow.
  ///
  /// In ru, this message translates to:
  /// **'Только что'**
  String get docsJustNow;

  /// No description provided for @docsAdded.
  ///
  /// In ru, this message translates to:
  /// **'Добавлен {date}'**
  String docsAdded(String date);

  /// No description provided for @historyTitle.
  ///
  /// In ru, this message translates to:
  /// **'История услуг'**
  String get historyTitle;

  /// No description provided for @historyError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка: {error}'**
  String historyError(String error);

  /// No description provided for @historyEmpty.
  ///
  /// In ru, this message translates to:
  /// **'История консультаций пуста'**
  String get historyEmpty;

  /// No description provided for @historyAiConsult.
  ///
  /// In ru, this message translates to:
  /// **'Консультация с ИИ'**
  String get historyAiConsult;

  /// No description provided for @historyLawyerConsult.
  ///
  /// In ru, this message translates to:
  /// **'Консультация юриста'**
  String get historyLawyerConsult;

  /// No description provided for @historySoon.
  ///
  /// In ru, this message translates to:
  /// **'Скоро'**
  String get historySoon;

  /// No description provided for @historyPending.
  ///
  /// In ru, this message translates to:
  /// **'В обработке'**
  String get historyPending;

  /// No description provided for @historyCompleted.
  ///
  /// In ru, this message translates to:
  /// **'Завершено'**
  String get historyCompleted;

  /// No description provided for @subTitle.
  ///
  /// In ru, this message translates to:
  /// **'Подписка'**
  String get subTitle;

  /// No description provided for @subChoosePlan.
  ///
  /// In ru, this message translates to:
  /// **'Выберите свой тариф'**
  String get subChoosePlan;

  /// No description provided for @subDescription.
  ///
  /// In ru, this message translates to:
  /// **'Бесплатно пробуйте ИИ или откройте все возможности с Premium'**
  String get subDescription;

  /// No description provided for @subPerMonth.
  ///
  /// In ru, this message translates to:
  /// **'/ мес'**
  String get subPerMonth;

  /// No description provided for @subFreeDesc.
  ///
  /// In ru, this message translates to:
  /// **'До 3 запросов к ИИ в день, базовые функции.'**
  String get subFreeDesc;

  /// No description provided for @subProDesc.
  ///
  /// In ru, this message translates to:
  /// **'Безлимитный ИИ-Консультант, приоритетные ответы и полная конфиденциальность.'**
  String get subProDesc;

  /// No description provided for @subBusinessDesc.
  ///
  /// In ru, this message translates to:
  /// **'Интеграция по API, шаблоны договоров и командный доступ.'**
  String get subBusinessDesc;

  /// No description provided for @subPaymentInDev.
  ///
  /// In ru, this message translates to:
  /// **'Упс... Платежный шлюз (Kaspi) в разработке'**
  String get subPaymentInDev;

  /// No description provided for @subB2bInDev.
  ///
  /// In ru, this message translates to:
  /// **'Свяжитесь с нами для B2B решений'**
  String get subB2bInDev;

  /// No description provided for @subRecommended.
  ///
  /// In ru, this message translates to:
  /// **'🔥 РЕКОМЕНДУЕМ'**
  String get subRecommended;

  /// No description provided for @subCurrentPlan.
  ///
  /// In ru, this message translates to:
  /// **'ТЕКУЩИЙ'**
  String get subCurrentPlan;

  /// No description provided for @subUpgrade.
  ///
  /// In ru, this message translates to:
  /// **'ПЕРЕЙТИ'**
  String get subUpgrade;

  /// No description provided for @supportTitle.
  ///
  /// In ru, this message translates to:
  /// **'Поддержка'**
  String get supportTitle;

  /// No description provided for @supportHeader.
  ///
  /// In ru, this message translates to:
  /// **'Возникла проблема?'**
  String get supportHeader;

  /// No description provided for @supportContactOp.
  ///
  /// In ru, this message translates to:
  /// **'Написать оператору'**
  String get supportContactOp;

  /// No description provided for @supportTelegramSnack.
  ///
  /// In ru, this message translates to:
  /// **'Открываем Telegram-чата поддержки...'**
  String get supportTelegramSnack;

  /// No description provided for @supportFaqHeader.
  ///
  /// In ru, this message translates to:
  /// **'ЧАСТЫЕ ВОПРОСЫ (FAQ)'**
  String get supportFaqHeader;

  /// No description provided for @supportFaq1Q.
  ///
  /// In ru, this message translates to:
  /// **'Как работает ИИ-консультант?'**
  String get supportFaq1Q;

  /// No description provided for @supportFaq1A.
  ///
  /// In ru, this message translates to:
  /// **'Наш ИИ обучен на законодательной базе РК и судебной практике. Он анализирует ваш вопрос и выдает ответ со ссылками на законы. До 3 запросов в день бесплатно.'**
  String get supportFaq1A;

  /// No description provided for @supportFaq2Q.
  ///
  /// In ru, this message translates to:
  /// **'Могу ли я нанять реального юриста?'**
  String get supportFaq2Q;

  /// No description provided for @supportFaq2A.
  ///
  /// In ru, this message translates to:
  /// **'Да, если ответ ИИ вам недостаточен, вы можете перейти в раздел \"Юристы\" и выбрать специалиста по нужной отрасли права.'**
  String get supportFaq2A;

  /// No description provided for @supportFaq3Q.
  ///
  /// In ru, this message translates to:
  /// **'Как отменить подписку?'**
  String get supportFaq3Q;

  /// No description provided for @supportFaq3A.
  ///
  /// In ru, this message translates to:
  /// **'Подписку можно отменить в разделе \"Управление подпиской\" в вашем профиле.'**
  String get supportFaq3A;

  /// No description provided for @supportFaq4Q.
  ///
  /// In ru, this message translates to:
  /// **'Мои данные защищены?'**
  String get supportFaq4Q;

  /// No description provided for @supportFaq4A.
  ///
  /// In ru, this message translates to:
  /// **'Мы используем шифрование AES-256 и храним данные на защищенных серверах.'**
  String get supportFaq4A;

  /// No description provided for @sosTitle.
  ///
  /// In ru, this message translates to:
  /// **'SOS Экстренная помощь'**
  String get sosTitle;

  /// No description provided for @sosDialerError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось открыть звонилку'**
  String get sosDialerError;

  /// No description provided for @sosCallError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка вызова: {error}'**
  String sosCallError(String error);

  /// No description provided for @sosButton.
  ///
  /// In ru, this message translates to:
  /// **'ПОЗВОНИТЬ\nАДВОКАТУ'**
  String get sosButton;

  /// No description provided for @sosOfflineHeader.
  ///
  /// In ru, this message translates to:
  /// **'ОФФЛАЙН ПАМЯТКА ПРИ ЗАДЕРЖАНИИ'**
  String get sosOfflineHeader;

  /// No description provided for @sosRule1Title.
  ///
  /// In ru, this message translates to:
  /// **'Вы имеете право на звонок'**
  String get sosRule1Title;

  /// No description provided for @sosRule1Content.
  ///
  /// In ru, this message translates to:
  /// **'Согласно статье 131 УПК РК, вы имеете право на один телефонный звонок адвокату или родственникам немедленно после задержания.'**
  String get sosRule1Content;

  /// No description provided for @sosRule2Title.
  ///
  /// In ru, this message translates to:
  /// **'Право хранить молчание'**
  String get sosRule2Title;

  /// No description provided for @sosRule2Content.
  ///
  /// In ru, this message translates to:
  /// **'В соответствии со статьей 77 Конституции РК, вы вправе не давать показания против себя. Требуйте присутствия адвоката.'**
  String get sosRule2Content;

  /// No description provided for @sosRule3Title.
  ///
  /// In ru, this message translates to:
  /// **'Внимательно читайте протокол'**
  String get sosRule3Title;

  /// No description provided for @sosRule3Content.
  ///
  /// In ru, this message translates to:
  /// **'Никогда не подписывайте пустые листы или документы, если не согласны с их содержанием. Если не согласны — пишите «Не согласен» письменно.'**
  String get sosRule3Content;

  /// No description provided for @dashboardTitle.
  ///
  /// In ru, this message translates to:
  /// **'Главная'**
  String get dashboardTitle;

  /// No description provided for @dashboardOfflineBanner.
  ///
  /// In ru, this message translates to:
  /// **'Офлайн режим. Доступны только сохраненные документы и SOS.'**
  String get dashboardOfflineBanner;

  /// No description provided for @dashboardSectionUrgent.
  ///
  /// In ru, this message translates to:
  /// **'Срочно'**
  String get dashboardSectionUrgent;

  /// No description provided for @dashboardSectionAdvice.
  ///
  /// In ru, this message translates to:
  /// **'Советы'**
  String get dashboardSectionAdvice;

  /// No description provided for @dashboardSectionActivity.
  ///
  /// In ru, this message translates to:
  /// **'Активность'**
  String get dashboardSectionActivity;

  /// No description provided for @dashboardGreetingNight.
  ///
  /// In ru, this message translates to:
  /// **'Доброй ночи'**
  String get dashboardGreetingNight;

  /// No description provided for @dashboardGreetingMorning.
  ///
  /// In ru, this message translates to:
  /// **'Доброе утро'**
  String get dashboardGreetingMorning;

  /// No description provided for @dashboardGreetingAfternoon.
  ///
  /// In ru, this message translates to:
  /// **'Добрый день'**
  String get dashboardGreetingAfternoon;

  /// No description provided for @dashboardGreetingEvening.
  ///
  /// In ru, this message translates to:
  /// **'Добрый вечер'**
  String get dashboardGreetingEvening;

  /// No description provided for @dashboardUser.
  ///
  /// In ru, this message translates to:
  /// **'Пользователь'**
  String get dashboardUser;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Рады видеть вас, {name}'**
  String dashboardSubtitle(String name);

  /// No description provided for @dashboardFreePlan.
  ///
  /// In ru, this message translates to:
  /// **'Базовый план'**
  String get dashboardFreePlan;

  /// No description provided for @dashboardAvailable.
  ///
  /// In ru, this message translates to:
  /// **'Доступно: {available} из {maxQueries}'**
  String dashboardAvailable(int available, int maxQueries);

  /// No description provided for @adviceTitle1.
  ///
  /// In ru, this message translates to:
  /// **'Как открыть ТОО'**
  String get adviceTitle1;

  /// No description provided for @adviceSubtitle1.
  ///
  /// In ru, this message translates to:
  /// **'Пошаговая инструкция'**
  String get adviceSubtitle1;

  /// No description provided for @adviceTitle2.
  ///
  /// In ru, this message translates to:
  /// **'Налоги 2026'**
  String get adviceTitle2;

  /// No description provided for @adviceSubtitle2.
  ///
  /// In ru, this message translates to:
  /// **'Что изменилось?'**
  String get adviceSubtitle2;

  /// No description provided for @adviceTitle3.
  ///
  /// In ru, this message translates to:
  /// **'Трудовой договор'**
  String get adviceTitle3;

  /// No description provided for @adviceSubtitle3.
  ///
  /// In ru, this message translates to:
  /// **'Шаблоны и правила'**
  String get adviceSubtitle3;

  /// No description provided for @activityConsultation.
  ///
  /// In ru, this message translates to:
  /// **'Консультация с ИИ'**
  String get activityConsultation;

  /// No description provided for @activityContractAnalysis.
  ///
  /// In ru, this message translates to:
  /// **'Анализ договора'**
  String get activityContractAnalysis;

  /// No description provided for @activityToday.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get activityToday;

  /// No description provided for @activityYesterday.
  ///
  /// In ru, this message translates to:
  /// **'Вчера'**
  String get activityYesterday;

  /// No description provided for @dashboardErrorTitle.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка загрузки данных'**
  String get dashboardErrorTitle;

  /// No description provided for @subFreeFeat1.
  ///
  /// In ru, this message translates to:
  /// **'До 10 запросов к ИИ'**
  String get subFreeFeat1;

  /// No description provided for @subFreeFeat2.
  ///
  /// In ru, this message translates to:
  /// **'Базовый поиск юристов'**
  String get subFreeFeat2;

  /// No description provided for @subFreeFeat3.
  ///
  /// In ru, this message translates to:
  /// **'Сканер документов'**
  String get subFreeFeat3;

  /// No description provided for @subProFeat1.
  ///
  /// In ru, this message translates to:
  /// **'Безлимитный ИИ-Консультант'**
  String get subProFeat1;

  /// No description provided for @subProFeat2.
  ///
  /// In ru, this message translates to:
  /// **'Анализ договоров и документов'**
  String get subProFeat2;

  /// No description provided for @subProFeat3.
  ///
  /// In ru, this message translates to:
  /// **'Приоритетные ответы за 2 секунды'**
  String get subProFeat3;

  /// No description provided for @subProFeat4.
  ///
  /// In ru, this message translates to:
  /// **'Полная конфиденциальность'**
  String get subProFeat4;

  /// No description provided for @subBizFeat1.
  ///
  /// In ru, this message translates to:
  /// **'Всё из Pro'**
  String get subBizFeat1;

  /// No description provided for @subBizFeat2.
  ///
  /// In ru, this message translates to:
  /// **'API интеграция'**
  String get subBizFeat2;

  /// No description provided for @subBizFeat3.
  ///
  /// In ru, this message translates to:
  /// **'Шаблоны договоров'**
  String get subBizFeat3;

  /// No description provided for @subBizFeat4.
  ///
  /// In ru, this message translates to:
  /// **'Командный доступ до 10 юристов'**
  String get subBizFeat4;

  /// No description provided for @paywallLimitReached.
  ///
  /// In ru, this message translates to:
  /// **'Лимит бесплатных запросов исчерпан'**
  String get paywallLimitReached;

  /// No description provided for @paywallUpgradeHint.
  ///
  /// In ru, this message translates to:
  /// **'Перейдите на PRO для безлимитного доступа к ИИ'**
  String get paywallUpgradeHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['kk', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'kk':
      return AppLocalizationsKk();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
