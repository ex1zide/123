// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get navHome => 'Главная';

  @override
  String get navAiLawyer => 'ИИ-Юрист';

  @override
  String get navLawyers => 'Юристы';

  @override
  String get navProfile => 'Профиль';

  @override
  String get authAppName => 'LegalHelp KZ';

  @override
  String get authSubtitleSignIn => 'С возвращением';

  @override
  String get authSubtitleSignUp => 'Создать аккаунт';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailError => 'Введите корректный email';

  @override
  String get authPasswordLabel => 'Пароль';

  @override
  String get authPasswordError => 'Минимум 6 символов';

  @override
  String get authEmptyFieldsError => 'Пожалуйста, заполните все поля';

  @override
  String get authSignIn => 'Войти';

  @override
  String get authSignUp => 'Создать аккаунт';

  @override
  String get authSocialDivider => 'Или войдите через';

  @override
  String get authNoAccount => 'Нет аккаунта? ';

  @override
  String get authHasAccount => 'Уже есть аккаунт? ';

  @override
  String get authSwitchToSignUp => 'Регистрация';

  @override
  String get authSwitchToSignIn => 'Войти';

  @override
  String get dashboardMorning => 'Доброе утро';

  @override
  String get dashboardDay => 'Добрый день';

  @override
  String get dashboardEvening => 'Добрый вечер';

  @override
  String get dashboardNight => 'Доброй ночи';

  @override
  String get dashboardAiHelp => 'Чем ИИ может помочь сегодня?';

  @override
  String get dashboardQuickActions => 'Быстрые действия';

  @override
  String get dashboardDocs => 'Документы';

  @override
  String get dashboardViewAll => 'Все';

  @override
  String get dashboardCases => 'Дела';

  @override
  String dashboardError(String error) {
    return 'Ошибка загрузки: $error';
  }

  @override
  String get dashboardRetry => 'Повторить';

  @override
  String get quickScanner => 'Скан паспорта';

  @override
  String get quickScannerSub => 'OCR Распознавание';

  @override
  String get quickFindLawyer => 'Найти юриста';

  @override
  String get quickFindLawyerSub => 'Маркетплейс';

  @override
  String get quickSos => 'Экстренно';

  @override
  String get quickSosSub => 'Вызов адвоката';

  @override
  String get aiSearchTitle => 'Задать правовой вопрос ИИ...';

  @override
  String get aiSearchSubtitle => 'Бесплатно • Ответ за 2 секунды';

  @override
  String get scannerTitle => 'Умный Сканер';

  @override
  String get scannerEmptyTitle => 'Готов к сканированию';

  @override
  String get scannerEmptyDesc =>
      'Наведите камеру на документ или паспорт (УДЛ RK), чтобы ИИ распознал текст и данные автоматически.';

  @override
  String get scannerButton => 'СКАНИРОВАТЬ';

  @override
  String get scannerProcessing => 'ИИ анализирует документ...';

  @override
  String get scannerAuthRequired => 'Войдите, чтобы сохранить документ';

  @override
  String get scannerDocTitle => 'Отсканированный документ';

  @override
  String get scannerSaved => 'Документ успешно сохранен';

  @override
  String scannerSaveError(String error) {
    return 'Ошибка сохранения: $error';
  }

  @override
  String get scannerNoText => 'Текст не найден. Попробуйте еще раз.';

  @override
  String get scannerCopy => 'Копировать';

  @override
  String get scannerCopied => 'Текст скопирован в буфер обмена';

  @override
  String get scannerSave => 'Сохранить';

  @override
  String get scannerReset => 'Сбросить и сканировать заново';

  @override
  String get chatTitle => 'ИИ-Консультант';

  @override
  String get chatTyping => 'ИИ печатает...';

  @override
  String get chatEmptyTitle => 'Начните диалог';

  @override
  String get chatEmptySubtitle =>
      'Напишите ваш правовой вопрос.\nИИ проанализирует законы РК и даст точный ответ.';

  @override
  String get chatInputHint => 'Опишите вашу проблему...';

  @override
  String get paywallTitle => 'Премиум доступ';

  @override
  String get paywallSubtitle => 'Получите неограниченные консультации ИИ';

  @override
  String get paywallBenefit1 => 'Безлимитные сообщения';

  @override
  String get paywallBenefit2 => 'Приоритетный ответ';

  @override
  String get paywallBenefit3 => 'Анализ судебной практики';

  @override
  String get paywallCta => 'Оформить подписку';

  @override
  String get paywallDismiss => 'Позже';

  @override
  String get marketplaceTitle => 'Найти юриста';

  @override
  String marketplaceError(String error) {
    return 'Ошибка загрузки: $error';
  }

  @override
  String get marketplaceEmpty => 'Нет доступных юристов';

  @override
  String marketplaceReviews(int count) {
    return '$count отзывов';
  }

  @override
  String marketplaceRate(int rate) {
    return '$rate ₸/час';
  }

  @override
  String get marketplaceContact => 'СВЯЗАТЬСЯ';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileGuestInitial => 'Г';

  @override
  String get profileGuest => 'Гость';

  @override
  String get profileUser => 'Пользователь';

  @override
  String get profileGuestEmail => 'Войдите для сохранения данных';

  @override
  String get profileBasicPlan => 'Базовый тариф';

  @override
  String get profileFreeQueries => 'Осталось бесплатных запросов: 3';

  @override
  String get profileUpgrade => 'Получить Pro';

  @override
  String get profileMyDocuments => 'Мои документы';

  @override
  String get profileHistory => 'История услуг';

  @override
  String get profileSubscription => 'Управление подпиской';

  @override
  String get profileSupport => 'Служба поддержки';

  @override
  String get profileLogin => 'Войти в аккаунт';

  @override
  String get profileLogout => 'Выйти';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsSectionMain => 'ОСНОВНЫЕ';

  @override
  String get settingsPushTitle => 'Push-уведомления';

  @override
  String get settingsPushSubtitle => 'Получать ответы юристов и ИИ';

  @override
  String get settingsLanguageTitle => 'Язык интерфейса';

  @override
  String get settingsLanguageKazakh => 'Қазақша';

  @override
  String get settingsLanguageRussian => 'Русский';

  @override
  String get settingsChooseLanguage => 'Выберите язык';

  @override
  String get settingsSectionDesign => 'ОФОРМЛЕНИЕ';

  @override
  String get settingsDarkThemeTitle => 'Темная тема (Gold Premium)';

  @override
  String get settingsDarkThemeSubtitle => 'Оптимизировано для OLED экранов';

  @override
  String get settingsSectionInfo => 'ИНФОРМАЦИЯ';

  @override
  String get settingsPrivacy => 'Политика конфиденциальности';

  @override
  String get settingsTerms => 'Пользовательское соглашение';

  @override
  String get docsTitle => 'Мои документы';

  @override
  String get docsFab => 'Новый скан';

  @override
  String get docsFabSnackbar => 'Открываем сканер...';

  @override
  String docsError(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get docsEmpty => 'У вас пока нет сохраненных документов';

  @override
  String get docsUntitled => 'Без названия';

  @override
  String get docsJustNow => 'Только что';

  @override
  String docsAdded(String date) {
    return 'Добавлен $date';
  }

  @override
  String get historyTitle => 'История услуг';

  @override
  String historyError(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get historyEmpty => 'История консультаций пуста';

  @override
  String get historyAiConsult => 'Консультация с ИИ';

  @override
  String get historyLawyerConsult => 'Консультация юриста';

  @override
  String get historySoon => 'Скоро';

  @override
  String get historyPending => 'В обработке';

  @override
  String get historyCompleted => 'Завершено';

  @override
  String get subTitle => 'Подписка';

  @override
  String get subChoosePlan => 'Выберите свой тариф';

  @override
  String get subDescription =>
      'Бесплатно пробуйте ИИ или откройте все возможности с Premium';

  @override
  String get subPerMonth => '/ мес';

  @override
  String get subFreeDesc => 'До 3 запросов к ИИ в день, базовые функции.';

  @override
  String get subProDesc =>
      'Безлимитный ИИ-Консультант, приоритетные ответы и полная конфиденциальность.';

  @override
  String get subBusinessDesc =>
      'Интеграция по API, шаблоны договоров и командный доступ.';

  @override
  String get subPaymentInDev => 'Упс... Платежный шлюз (Kaspi) в разработке';

  @override
  String get subB2bInDev => 'Свяжитесь с нами для B2B решений';

  @override
  String get subRecommended => '🔥 РЕКОМЕНДУЕМ';

  @override
  String get subCurrentPlan => 'ТЕКУЩИЙ';

  @override
  String get subUpgrade => 'ПЕРЕЙТИ';

  @override
  String get supportTitle => 'Поддержка';

  @override
  String get supportHeader => 'Возникла проблема?';

  @override
  String get supportContactOp => 'Написать оператору';

  @override
  String get supportTelegramSnack => 'Открываем Telegram-чата поддержки...';

  @override
  String get supportFaqHeader => 'ЧАСТЫЕ ВОПРОСЫ (FAQ)';

  @override
  String get supportFaq1Q => 'Как работает ИИ-консультант?';

  @override
  String get supportFaq1A =>
      'Наш ИИ обучен на законодательной базе РК и судебной практике. Он анализирует ваш вопрос и выдает ответ со ссылками на законы. До 3 запросов в день бесплатно.';

  @override
  String get supportFaq2Q => 'Могу ли я нанять реального юриста?';

  @override
  String get supportFaq2A =>
      'Да, если ответ ИИ вам недостаточен, вы можете перейти в раздел \"Юристы\" и выбрать специалиста по нужной отрасли права.';

  @override
  String get supportFaq3Q => 'Как отменить подписку?';

  @override
  String get supportFaq3A =>
      'Подписку можно отменить в разделе \"Управление подпиской\" в вашем профиле.';

  @override
  String get supportFaq4Q => 'Мои данные защищены?';

  @override
  String get supportFaq4A =>
      'Мы используем шифрование AES-256 и храним данные на защищенных серверах.';

  @override
  String get sosTitle => 'SOS Экстренная помощь';

  @override
  String get sosDialerError => 'Не удалось открыть звонилку';

  @override
  String sosCallError(String error) {
    return 'Ошибка вызова: $error';
  }

  @override
  String get sosButton => 'ПОЗВОНИТЬ\nАДВОКАТУ';

  @override
  String get sosOfflineHeader => 'ОФФЛАЙН ПАМЯТКА ПРИ ЗАДЕРЖАНИИ';

  @override
  String get sosRule1Title => 'Вы имеете право на звонок';

  @override
  String get sosRule1Content =>
      'Согласно статье 131 УПК РК, вы имеете право на один телефонный звонок адвокату или родственникам немедленно после задержания.';

  @override
  String get sosRule2Title => 'Право хранить молчание';

  @override
  String get sosRule2Content =>
      'В соответствии со статьей 77 Конституции РК, вы вправе не давать показания против себя. Требуйте присутствия адвоката.';

  @override
  String get sosRule3Title => 'Внимательно читайте протокол';

  @override
  String get sosRule3Content =>
      'Никогда не подписывайте пустые листы или документы, если не согласны с их содержанием. Если не согласны — пишите «Не согласен» письменно.';

  @override
  String get dashboardTitle => 'Главная';

  @override
  String get dashboardOfflineBanner =>
      'Офлайн режим. Доступны только сохраненные документы и SOS.';

  @override
  String get dashboardSectionUrgent => 'Срочно';

  @override
  String get dashboardSectionAdvice => 'Советы';

  @override
  String get dashboardSectionActivity => 'Активность';

  @override
  String get dashboardGreetingNight => 'Доброй ночи';

  @override
  String get dashboardGreetingMorning => 'Доброе утро';

  @override
  String get dashboardGreetingAfternoon => 'Добрый день';

  @override
  String get dashboardGreetingEvening => 'Добрый вечер';

  @override
  String get dashboardUser => 'Пользователь';

  @override
  String dashboardSubtitle(String name) {
    return 'Рады видеть вас, $name';
  }

  @override
  String get dashboardFreePlan => 'Базовый план';

  @override
  String dashboardAvailable(int available, int maxQueries) {
    return 'Доступно: $available из $maxQueries';
  }

  @override
  String get adviceTitle1 => 'Как открыть ТОО';

  @override
  String get adviceSubtitle1 => 'Пошаговая инструкция';

  @override
  String get adviceTitle2 => 'Налоги 2026';

  @override
  String get adviceSubtitle2 => 'Что изменилось?';

  @override
  String get adviceTitle3 => 'Трудовой договор';

  @override
  String get adviceSubtitle3 => 'Шаблоны и правила';

  @override
  String get activityConsultation => 'Консультация с ИИ';

  @override
  String get activityContractAnalysis => 'Анализ договора';

  @override
  String get activityToday => 'Сегодня';

  @override
  String get activityYesterday => 'Вчера';

  @override
  String get dashboardErrorTitle => 'Ошибка загрузки данных';

  @override
  String get subFreeFeat1 => 'До 10 запросов к ИИ';

  @override
  String get subFreeFeat2 => 'Базовый поиск юристов';

  @override
  String get subFreeFeat3 => 'Сканер документов';

  @override
  String get subProFeat1 => 'Безлимитный ИИ-Консультант';

  @override
  String get subProFeat2 => 'Анализ договоров и документов';

  @override
  String get subProFeat3 => 'Приоритетные ответы за 2 секунды';

  @override
  String get subProFeat4 => 'Полная конфиденциальность';

  @override
  String get subBizFeat1 => 'Всё из Pro';

  @override
  String get subBizFeat2 => 'API интеграция';

  @override
  String get subBizFeat3 => 'Шаблоны договоров';

  @override
  String get subBizFeat4 => 'Командный доступ до 10 юристов';

  @override
  String get paywallLimitReached => 'Лимит бесплатных запросов исчерпан';

  @override
  String get paywallUpgradeHint =>
      'Перейдите на PRO для безлимитного доступа к ИИ';
}
