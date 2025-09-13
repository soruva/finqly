// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Finqly';

  @override
  String get emotionPrompt => 'How are you feeling about your finances today?';

  @override
  String get startButton => 'Start Now';

  @override
  String get diagnosisTitle => 'Diagnosis';

  @override
  String get diagnosisQuestion => 'How do you feel about the market right now?';

  @override
  String get diagnosisButton => 'Run Diagnosis';

  @override
  String get optionOptimistic => 'Optimistic';

  @override
  String get optionNeutral => 'Neutral';

  @override
  String get optionWorried => 'Worried';

  @override
  String get optionConfused => 'Confused';

  @override
  String get optionExcited => 'Excited';

  @override
  String get optionCautious => 'Cautious';

  @override
  String get badgeOptimistic => 'You\'re optimistic about the market!';

  @override
  String get badgeNeutral => 'You’re feeling neutral today.';

  @override
  String get badgeWorried => 'You’re worried about your investments.';

  @override
  String get badgeConfused => 'You feel unsure or confused.';

  @override
  String get badgeExcited => 'You’re feeling energized and ready!';

  @override
  String get badgeCautious => 'You’re approaching the market with care.';

  @override
  String get investmentTipsTitle => 'Investment Tips';

  @override
  String get investmentTips1 => 'Diversify your investments to reduce risk.';

  @override
  String get investmentTips2 =>
      'Don’t let short-term emotions drive long-term decisions.';

  @override
  String get investmentTips3 =>
      'Understand your risk tolerance before investing.';

  @override
  String get investmentTips4 => 'Stay informed but avoid panic-selling.';

  @override
  String get investmentTips5 =>
      'Investing is a long-term journey — not a sprint.';

  @override
  String get tapToFlip => 'Tap to flip';

  @override
  String get investmentTipsExplanation1 =>
      'Diversification is the golden rule!';

  @override
  String get investmentTipsExplanation2 =>
      'Stay focused on the long term, not short-term feelings.';

  @override
  String get investmentTipsExplanation3 =>
      'Knowing your risk tolerance reduces mistakes.';

  @override
  String get investmentTipsExplanation4 =>
      'Stay informed. Avoid panic selling!';

  @override
  String get investmentTipsExplanation5 =>
      'Consistency builds your financial future.';

  @override
  String get forecastTitle => 'Your Investment Forecast';

  @override
  String forecastMessage(Object percent) {
    return 'Based on your mindset and history, you\'re expected to grow by $percent this month.';
  }

  @override
  String get premiumPrompt =>
      'You\'re close to unlocking even better insights.';

  @override
  String get premiumCTA => 'Get Premium Forecast';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Français';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkModeOn => 'Dark mode is ON';

  @override
  String get darkModeOff => 'Dark mode is OFF';

  @override
  String get premiumUnlockTitle => 'Unlock Premium Insights';

  @override
  String get premiumUnlockMessage =>
      'Get access to advanced forecasts, emotional trends, and expert tips.';

  @override
  String get premiumUnlockButton => 'Unlock Now';

  @override
  String get premiumDisclaimer => 'You can cancel anytime. No hidden fees.';

  @override
  String get upgradeToPremium => 'Upgrade to Finqly Plus';

  @override
  String get unlockInsights => '💡 Unlock deeper insights';

  @override
  String get premiumFeature1 => 'Advanced forecasts with emotion data.';

  @override
  String get premiumFeature2 => 'Track emotional trends over time.';

  @override
  String get premiumFeature3 => 'Get expert investing tips.';

  @override
  String get premiumUnlockSuccess => 'Premium unlocked successfully!';

  @override
  String get premiumUnlockError => 'Something went wrong. Please try again.';

  @override
  String get emotionHistoryTitle => 'Emotion History';

  @override
  String get emotionHistoryEmpty => 'No history found.';

  @override
  String get educationTitle => 'Financial Education';

  @override
  String get other => 'Other';

  @override
  String get trendForecastTitle => 'Emotion Trend Chart';

  @override
  String get premiumFeatureExplain =>
      'Premium unlocks all trend, chart, and pro tips features.';

  @override
  String get noTrendData => 'No trend data available.';

  @override
  String get trendForecastDescription =>
      'Your recent emotional trend is visualized below.';

  @override
  String get privacyTitle => 'Privacy Policy';

  @override
  String get termsTitle => 'Terms of Service';

  @override
  String get disclaimerTitle => 'Disclaimer';

  @override
  String get faqTitle => 'FAQ';

  @override
  String get restorePurchasesTitle => 'Restore purchases';

  @override
  String get restorePurchasesDone => 'Purchases restored';

  @override
  String get trendScoreLegend =>
      'Score Legend: 6=Excited, 5=Optimistic, 3=Neutral, 2=Confused, 1=Worried, 0=Cautious';

  @override
  String get premiumTrendUpsell =>
      'Unlock trend charts, performance tracking, and personalized insights with Finqly Plus!';

  @override
  String dayLabel(Object n) {
    return 'Day $n';
  }

  @override
  String get manageSubscriptionTitle => 'Manage subscription (Play Store)';

  @override
  String get openSubscriptionPageFailed => 'Could not open subscription page.';

  @override
  String get unlockOptionsTitle => 'Unlock options';

  @override
  String get oneTimeDiagnosisTitle => 'One-time Diagnosis';

  @override
  String get oneTimeDiagnosisSubtitle => '\$2.99 • No subscription required';

  @override
  String get goPremiumTitle => 'Go Premium';

  @override
  String get goPremiumSubtitle => 'Monthly or Yearly subscription available';

  @override
  String get purchaseErrorPrefix => 'Purchase error:';

  @override
  String get reportsTitle => 'Reports & notifications';

  @override
  String get openWeeklyReport => 'Open Weekly Report';

  @override
  String get openWeeklyReportSub => 'See last 7 days trend';

  @override
  String get dailyReminderTitle => 'Daily reminder (9:00)';

  @override
  String get dailyReminderSub => 'Keep your check-in streak';

  @override
  String get weeklyReminderTitle => 'Weekly report reminder (Mon 9:00)';

  @override
  String get weeklyReminderSub => 'Get your weekly summary';

  @override
  String get manageSubscription => 'Manage subscription (Play Store)';

  @override
  String get about => 'About';

  @override
  String get loadingReminders => 'Loading reminders...';

  @override
  String get dailyReminderEnabledMsg => 'Daily reminder enabled';

  @override
  String get dailyReminderDisabledMsg => 'Daily reminder disabled';

  @override
  String get weeklyReminderEnabledMsg => 'Weekly report reminder enabled';

  @override
  String get weeklyReminderDisabledMsg => 'Weekly report reminder disabled';

  @override
  String get restoreErrorPrefix => 'Restore error:';
}
