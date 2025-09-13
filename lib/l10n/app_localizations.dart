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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
  ];

  /// Main app title
  ///
  /// In en, this message translates to:
  /// **'Finqly'**
  String get appTitle;

  /// Main prompt on home screen
  ///
  /// In en, this message translates to:
  /// **'How are you feeling about your finances today?'**
  String get emotionPrompt;

  /// Button to start diagnosis
  ///
  /// In en, this message translates to:
  /// **'Start Now'**
  String get startButton;

  /// Title for diagnosis page
  ///
  /// In en, this message translates to:
  /// **'Diagnosis'**
  String get diagnosisTitle;

  /// Question about market sentiment
  ///
  /// In en, this message translates to:
  /// **'How do you feel about the market right now?'**
  String get diagnosisQuestion;

  /// Button to run the diagnosis
  ///
  /// In en, this message translates to:
  /// **'Run Diagnosis'**
  String get diagnosisButton;

  /// Emotion option: optimistic
  ///
  /// In en, this message translates to:
  /// **'Optimistic'**
  String get optionOptimistic;

  /// Emotion option: neutral
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get optionNeutral;

  /// Emotion option: worried
  ///
  /// In en, this message translates to:
  /// **'Worried'**
  String get optionWorried;

  /// Emotion option: confused
  ///
  /// In en, this message translates to:
  /// **'Confused'**
  String get optionConfused;

  /// Emotion option: excited
  ///
  /// In en, this message translates to:
  /// **'Excited'**
  String get optionExcited;

  /// Emotion option: cautious
  ///
  /// In en, this message translates to:
  /// **'Cautious'**
  String get optionCautious;

  /// Badge message: optimistic
  ///
  /// In en, this message translates to:
  /// **'You\'re optimistic about the market!'**
  String get badgeOptimistic;

  /// Badge message: neutral
  ///
  /// In en, this message translates to:
  /// **'You’re feeling neutral today.'**
  String get badgeNeutral;

  /// Badge message: worried
  ///
  /// In en, this message translates to:
  /// **'You’re worried about your investments.'**
  String get badgeWorried;

  /// Badge message: confused
  ///
  /// In en, this message translates to:
  /// **'You feel unsure or confused.'**
  String get badgeConfused;

  /// Badge message: excited
  ///
  /// In en, this message translates to:
  /// **'You’re feeling energized and ready!'**
  String get badgeExcited;

  /// Badge message: cautious
  ///
  /// In en, this message translates to:
  /// **'You’re approaching the market with care.'**
  String get badgeCautious;

  /// Title of the investment tips page
  ///
  /// In en, this message translates to:
  /// **'Investment Tips'**
  String get investmentTipsTitle;

  /// Tip 1: diversification
  ///
  /// In en, this message translates to:
  /// **'Diversify your investments to reduce risk.'**
  String get investmentTips1;

  /// Tip 2: avoid short-term emotion
  ///
  /// In en, this message translates to:
  /// **'Don’t let short-term emotions drive long-term decisions.'**
  String get investmentTips2;

  /// Tip 3: risk tolerance
  ///
  /// In en, this message translates to:
  /// **'Understand your risk tolerance before investing.'**
  String get investmentTips3;

  /// Tip 4: avoid panic selling
  ///
  /// In en, this message translates to:
  /// **'Stay informed but avoid panic-selling.'**
  String get investmentTips4;

  /// Tip 5: long-term focus
  ///
  /// In en, this message translates to:
  /// **'Investing is a long-term journey — not a sprint.'**
  String get investmentTips5;

  /// Hint for flipping the card
  ///
  /// In en, this message translates to:
  /// **'Tap to flip'**
  String get tapToFlip;

  /// Explanation for tip 1
  ///
  /// In en, this message translates to:
  /// **'Diversification is the golden rule!'**
  String get investmentTipsExplanation1;

  /// Explanation for tip 2
  ///
  /// In en, this message translates to:
  /// **'Stay focused on the long term, not short-term feelings.'**
  String get investmentTipsExplanation2;

  /// Explanation for tip 3
  ///
  /// In en, this message translates to:
  /// **'Knowing your risk tolerance reduces mistakes.'**
  String get investmentTipsExplanation3;

  /// Explanation for tip 4
  ///
  /// In en, this message translates to:
  /// **'Stay informed. Avoid panic selling!'**
  String get investmentTipsExplanation4;

  /// Explanation for tip 5
  ///
  /// In en, this message translates to:
  /// **'Consistency builds your financial future.'**
  String get investmentTipsExplanation5;

  /// Title for forecast page
  ///
  /// In en, this message translates to:
  /// **'Your Investment Forecast'**
  String get forecastTitle;

  /// Message showing the forecasted investment growth based on emotion and history
  ///
  /// In en, this message translates to:
  /// **'Based on your mindset and history, you\'re expected to grow by {percent} this month.'**
  String forecastMessage(Object percent);

  /// Prompt for premium upgrade
  ///
  /// In en, this message translates to:
  /// **'You\'re close to unlocking even better insights.'**
  String get premiumPrompt;

  /// Button for premium forecast
  ///
  /// In en, this message translates to:
  /// **'Get Premium Forecast'**
  String get premiumCTA;

  /// Label for language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Spanish
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// French
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// Portuguese
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get languagePortuguese;

  /// German
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// Title for settings page
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Option for dark mode
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Option for light mode
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// Label shown when dark mode switch is ON
  ///
  /// In en, this message translates to:
  /// **'Dark mode is ON'**
  String get darkModeOn;

  /// Label shown when dark mode switch is OFF
  ///
  /// In en, this message translates to:
  /// **'Dark mode is OFF'**
  String get darkModeOff;

  /// Title for premium unlock screen
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium Insights'**
  String get premiumUnlockTitle;

  /// Marketing message for premium features
  ///
  /// In en, this message translates to:
  /// **'Get access to advanced forecasts, emotional trends, and expert tips.'**
  String get premiumUnlockMessage;

  /// Button to unlock premium
  ///
  /// In en, this message translates to:
  /// **'Unlock Now'**
  String get premiumUnlockButton;

  /// Disclaimer for premium subscription
  ///
  /// In en, this message translates to:
  /// **'You can cancel anytime. No hidden fees.'**
  String get premiumDisclaimer;

  /// Button text for premium upgrade
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Finqly Plus'**
  String get upgradeToPremium;

  /// Button to unlock deeper premium insights
  ///
  /// In en, this message translates to:
  /// **'💡 Unlock deeper insights'**
  String get unlockInsights;

  /// Premium feature 1
  ///
  /// In en, this message translates to:
  /// **'Advanced forecasts with emotion data.'**
  String get premiumFeature1;

  /// Premium feature 2
  ///
  /// In en, this message translates to:
  /// **'Track emotional trends over time.'**
  String get premiumFeature2;

  /// Premium feature 3
  ///
  /// In en, this message translates to:
  /// **'Get expert investing tips.'**
  String get premiumFeature3;

  /// Success message for unlocking premium
  ///
  /// In en, this message translates to:
  /// **'Premium unlocked successfully!'**
  String get premiumUnlockSuccess;

  /// Error message for premium unlock
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get premiumUnlockError;

  /// Title for emotion history page
  ///
  /// In en, this message translates to:
  /// **'Emotion History'**
  String get emotionHistoryTitle;

  /// Message shown when there is no emotion history
  ///
  /// In en, this message translates to:
  /// **'No history found.'**
  String get emotionHistoryEmpty;

  /// Title for financial education section
  ///
  /// In en, this message translates to:
  /// **'Financial Education'**
  String get educationTitle;

  /// Other category
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

  /// Message shown when no trend data is available
  ///
  /// In en, this message translates to:
  /// **'No trend data available.'**
  String get noTrendData;

  /// Description text below the trend chart
  ///
  /// In en, this message translates to:
  /// **'Your recent emotional trend is visualized below.'**
  String get trendForecastDescription;

  /// Title for Privacy policy page
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyTitle;

  /// Title for Terms of Service page
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsTitle;

  /// Title for Disclaimer page
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get disclaimerTitle;

  /// Title for FAQ page
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faqTitle;

  /// Settings: list item to restore previously purchased items
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get restorePurchasesTitle;

  /// SnackBar message shown after restore completes
  ///
  /// In en, this message translates to:
  /// **'Purchases restored'**
  String get restorePurchasesDone;

  /// Legend for the trend chart scores
  ///
  /// In en, this message translates to:
  /// **'Score Legend: 6=Excited, 5=Optimistic, 3=Neutral, 2=Confused, 1=Worried, 0=Cautious'**
  String get trendScoreLegend;

  /// Upsell text shown on the trend page when user is not premium
  ///
  /// In en, this message translates to:
  /// **'Unlock trend charts, performance tracking, and personalized insights with Finqly Plus!'**
  String get premiumTrendUpsell;

  /// Axis label for day N in trend chart
  ///
  /// In en, this message translates to:
  /// **'Day {n}'**
  String dayLabel(Object n);

  /// Settings: open Play subscription management
  ///
  /// In en, this message translates to:
  /// **'Manage subscription (Play Store)'**
  String get manageSubscriptionTitle;

  /// Snackbar when Play subscription page can't open
  ///
  /// In en, this message translates to:
  /// **'Could not open subscription page.'**
  String get openSubscriptionPageFailed;

  /// Paywall sheet title
  ///
  /// In en, this message translates to:
  /// **'Unlock options'**
  String get unlockOptionsTitle;

  /// Paywall: one-time purchase option title
  ///
  /// In en, this message translates to:
  /// **'One-time Diagnosis'**
  String get oneTimeDiagnosisTitle;

  /// Paywall: one-time purchase subtitle
  ///
  /// In en, this message translates to:
  /// **'\$2.99 • No subscription required'**
  String get oneTimeDiagnosisSubtitle;

  /// Paywall: premium option title
  ///
  /// In en, this message translates to:
  /// **'Go Premium'**
  String get goPremiumTitle;

  /// Paywall: premium option subtitle
  ///
  /// In en, this message translates to:
  /// **'Monthly or Yearly subscription available'**
  String get goPremiumSubtitle;

  /// Snackbar prefix for purchase errors
  ///
  /// In en, this message translates to:
  /// **'Purchase error:'**
  String get purchaseErrorPrefix;

  /// Section title for reports and notifications
  ///
  /// In en, this message translates to:
  /// **'Reports & notifications'**
  String get reportsTitle;

  /// Settings: button to open weekly report page
  ///
  /// In en, this message translates to:
  /// **'Open Weekly Report'**
  String get openWeeklyReport;

  /// Subtitle for opening weekly report
  ///
  /// In en, this message translates to:
  /// **'See last 7 days trend'**
  String get openWeeklyReportSub;

  /// Toggle title for daily reminder
  ///
  /// In en, this message translates to:
  /// **'Daily reminder (9:00)'**
  String get dailyReminderTitle;

  /// Subtitle for daily reminder
  ///
  /// In en, this message translates to:
  /// **'Keep your check-in streak'**
  String get dailyReminderSub;

  /// Toggle title for weekly reminder
  ///
  /// In en, this message translates to:
  /// **'Weekly report reminder (Mon 9:00)'**
  String get weeklyReminderTitle;

  /// Subtitle for weekly reminder
  ///
  /// In en, this message translates to:
  /// **'Get your weekly summary'**
  String get weeklyReminderSub;

  /// Label for subscription management in settings
  ///
  /// In en, this message translates to:
  /// **'Manage subscription (Play Store)'**
  String get manageSubscription;

  /// Settings: about item
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;
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
      <String>['de', 'en', 'es', 'fr', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
