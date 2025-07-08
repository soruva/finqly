import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Finqly'**
  String get appTitle;

  /// No description provided for @emotionPrompt.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling about your finances today?'**
  String get emotionPrompt;

  /// No description provided for @startButton.
  ///
  /// In en, this message translates to:
  /// **'Start Now'**
  String get startButton;

  /// No description provided for @diagnosisTitle.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis'**
  String get diagnosisTitle;

  /// No description provided for @diagnosisQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do you feel about the market right now?'**
  String get diagnosisQuestion;

  /// No description provided for @diagnosisButton.
  ///
  /// In en, this message translates to:
  /// **'Run Diagnosis'**
  String get diagnosisButton;

  /// No description provided for @optionOptimistic.
  ///
  /// In en, this message translates to:
  /// **'Optimistic'**
  String get optionOptimistic;

  /// No description provided for @optionNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get optionNeutral;

  /// No description provided for @optionWorried.
  ///
  /// In en, this message translates to:
  /// **'Worried'**
  String get optionWorried;

  /// No description provided for @optionConfused.
  ///
  /// In en, this message translates to:
  /// **'Confused'**
  String get optionConfused;

  /// No description provided for @optionExcited.
  ///
  /// In en, this message translates to:
  /// **'Excited'**
  String get optionExcited;

  /// No description provided for @optionCautious.
  ///
  /// In en, this message translates to:
  /// **'Cautious'**
  String get optionCautious;

  /// No description provided for @badgeOptimistic.
  ///
  /// In en, this message translates to:
  /// **'You\'re optimistic about the market!'**
  String get badgeOptimistic;

  /// No description provided for @badgeNeutral.
  ///
  /// In en, this message translates to:
  /// **'You’re feeling neutral today.'**
  String get badgeNeutral;

  /// No description provided for @badgeWorried.
  ///
  /// In en, this message translates to:
  /// **'You’re worried about your investments.'**
  String get badgeWorried;

  /// No description provided for @badgeConfused.
  ///
  /// In en, this message translates to:
  /// **'You feel unsure or confused.'**
  String get badgeConfused;

  /// No description provided for @badgeExcited.
  ///
  /// In en, this message translates to:
  /// **'You’re feeling energized and ready!'**
  String get badgeExcited;

  /// No description provided for @badgeCautious.
  ///
  /// In en, this message translates to:
  /// **'You’re approaching the market with care.'**
  String get badgeCautious;

  /// No description provided for @investmentTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Investment Tips'**
  String get investmentTipsTitle;

  /// No description provided for @investmentTips1.
  ///
  /// In en, this message translates to:
  /// **'Diversify your investments to reduce risk.'**
  String get investmentTips1;

  /// No description provided for @investmentTips2.
  ///
  /// In en, this message translates to:
  /// **'Don’t let short-term emotions drive long-term decisions.'**
  String get investmentTips2;

  /// No description provided for @investmentTips3.
  ///
  /// In en, this message translates to:
  /// **'Understand your risk tolerance before investing.'**
  String get investmentTips3;

  /// No description provided for @investmentTips4.
  ///
  /// In en, this message translates to:
  /// **'Stay informed but avoid panic-selling.'**
  String get investmentTips4;

  /// No description provided for @investmentTips5.
  ///
  /// In en, this message translates to:
  /// **'Investing is a long-term journey — not a sprint.'**
  String get investmentTips5;

  /// No description provided for @forecastTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Investment Forecast'**
  String get forecastTitle;

  /// Message showing the forecasted investment growth based on emotion and history
  ///
  /// In en, this message translates to:
  /// **'Based on your mindset and history, you\'re expected to grow by {percent} this month.'**
  String forecastMessage(Object percent);

  /// No description provided for @premiumPrompt.
  ///
  /// In en, this message translates to:
  /// **'You\'re close to unlocking even better insights.'**
  String get premiumPrompt;

  /// No description provided for @premiumCTA.
  ///
  /// In en, this message translates to:
  /// **'Get Premium Forecast'**
  String get premiumCTA;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languagePortuguese.
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get languagePortuguese;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @premiumUnlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium Insights'**
  String get premiumUnlockTitle;

  /// No description provided for @premiumUnlockMessage.
  ///
  /// In en, this message translates to:
  /// **'Get access to advanced forecasts, emotional trends, and expert tips.'**
  String get premiumUnlockMessage;

  /// No description provided for @premiumUnlockButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock Now'**
  String get premiumUnlockButton;

  /// No description provided for @premiumDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'You can cancel anytime. No hidden fees.'**
  String get premiumDisclaimer;

  /// No description provided for @upgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Finqly Plus'**
  String get upgradeToPremium;

  /// No description provided for @unlockInsights.
  ///
  /// In en, this message translates to:
  /// **'💡 Unlock deeper insights'**
  String get unlockInsights;

  /// No description provided for @premiumFeature1.
  ///
  /// In en, this message translates to:
  /// **'Advanced forecasts with emotion data.'**
  String get premiumFeature1;

  /// No description provided for @premiumFeature2.
  ///
  /// In en, this message translates to:
  /// **'Track emotional trends over time.'**
  String get premiumFeature2;

  /// No description provided for @premiumFeature3.
  ///
  /// In en, this message translates to:
  /// **'Get expert investing tips.'**
  String get premiumFeature3;

  /// No description provided for @premiumUnlockSuccess.
  ///
  /// In en, this message translates to:
  /// **'Premium unlocked successfully!'**
  String get premiumUnlockSuccess;

  /// No description provided for @premiumUnlockError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get premiumUnlockError;

  /// No description provided for @emotionHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Emotion History'**
  String get emotionHistoryTitle;

  /// No description provided for @emotionHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No history found.'**
  String get emotionHistoryEmpty;

  /// No description provided for @educationTitle.
  ///
  /// In en, this message translates to:
  /// **'Financial Education'**
  String get educationTitle;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// Title for the emotional trend chart
  ///
  /// In en, this message translates to:
  /// **'Emotion Trend Chart'**
  String get trendForecastTitle;

  /// Short explanation of Premium benefits
  ///
  /// In en, this message translates to:
  /// **'Premium unlocks all trend, chart, and pro tips features.'**
  String get premiumFeatureExplain;

  /// No description provided for @noTrendData.
  ///
  /// In en, this message translates to:
  /// **'No trend data available.'**
  String get noTrendData;

  /// No description provided for @trendForecastDescription.
  ///
  /// In en, this message translates to:
  /// **'Your recent emotional trend is visualized below.'**
  String get trendForecastDescription;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'fr', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
