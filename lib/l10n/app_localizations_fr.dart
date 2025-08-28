// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Finqly';

  @override
  String get emotionPrompt => 'Comment vous sentez-vous aujourd\'hui à propos de vos finances ?';

  @override
  String get startButton => 'Commencer maintenant';

  @override
  String get diagnosisTitle => 'Diagnostic';

  @override
  String get diagnosisQuestion => 'Comment vous sentez-vous par rapport au marché en ce moment ?';

  @override
  String get diagnosisButton => 'Run Diagnosis';

  @override
  String get optionOptimistic => 'Optimiste';

  @override
  String get optionNeutral => 'Neutre';

  @override
  String get optionWorried => 'Inquiet';

  @override
  String get optionConfused => 'Confus';

  @override
  String get optionExcited => 'Excité';

  @override
  String get optionCautious => 'Prudent';

  @override
  String get badgeOptimistic => 'Vous êtes optimiste concernant le marché !';

  @override
  String get badgeNeutral => 'Vous vous sentez neutre aujourd\'hui.';

  @override
  String get badgeWorried => 'Vous êtes inquiet pour vos investissements.';

  @override
  String get badgeConfused => 'Vous vous sentez incertain ou confus.';

  @override
  String get badgeExcited => 'Vous êtes plein d\'énergie et prêt !';

  @override
  String get badgeCautious => 'Vous abordez le marché avec prudence.';

  @override
  String get investmentTipsTitle => 'Conseils d\'investissement';

  @override
  String get investmentTips1 => 'Diversifiez vos investissements pour réduire les risques.';

  @override
  String get investmentTips2 => 'Ne laissez pas les émotions à court terme influencer vos décisions à long terme.';

  @override
  String get investmentTips3 => 'Comprenez votre tolérance au risque avant d\'investir.';

  @override
  String get investmentTips4 => 'Restez informé, mais évitez de vendre dans la panique.';

  @override
  String get investmentTips5 => 'Investir est un voyage à long terme — pas un sprint.';

  @override
  String get tapToFlip => 'Tap to flip';

  @override
  String get investmentTipsExplanation1 => 'Diversification is the golden rule!';

  @override
  String get investmentTipsExplanation2 => 'Stay focused on the long term, not short-term feelings.';

  @override
  String get investmentTipsExplanation3 => 'Knowing your risk tolerance reduces mistakes.';

  @override
  String get investmentTipsExplanation4 => 'Stay informed. Avoid panic selling!';

  @override
  String get investmentTipsExplanation5 => 'Consistency builds your financial future.';

  @override
  String get forecastTitle => 'Prévisions d\'investissement';

  @override
  String forecastMessage(Object percent) {
    return 'Selon votre état d\'esprit et votre historique, vous devriez croître de $percent% ce mois-ci.';
  }

  @override
  String get premiumPrompt => 'Vous êtes sur le point de débloquer des informations encore meilleures.';

  @override
  String get premiumCTA => 'Obtenir les prévisions Premium';

  @override
  String get language => 'Langue';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get languageSpanish => 'Espagnol';

  @override
  String get languageFrench => 'Français';

  @override
  String get languagePortuguese => 'Portugais';

  @override
  String get languageGerman => 'Allemand';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get lightMode => 'Mode clair';

  @override
  String get darkModeOn => 'Dark mode is ON';

  @override
  String get darkModeOff => 'Dark mode is OFF';

  @override
  String get premiumUnlockTitle => 'Débloquez des informations Premium';

  @override
  String get premiumUnlockMessage => 'Accédez à des prévisions avancées, des tendances émotionnelles et des conseils d\'experts.';

  @override
  String get premiumUnlockButton => 'Débloquer maintenant';

  @override
  String get premiumDisclaimer => 'Vous pouvez annuler à tout moment. Aucun frais caché.';

  @override
  String get upgradeToPremium => 'Passez à Finqly Plus';

  @override
  String get unlockInsights => '💡 Débloquez des connaissances plus approfondies';

  @override
  String get premiumFeature1 => 'Prévisions avancées basées sur les émotions.';

  @override
  String get premiumFeature2 => 'Suivez l’évolution de vos émotions dans le temps.';

  @override
  String get premiumFeature3 => 'Recevez des conseils d\'experts en investissement.';

  @override
  String get premiumUnlockSuccess => 'Premium débloqué avec succès !';

  @override
  String get premiumUnlockError => 'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get emotionHistoryTitle => 'Historique des émotions';

  @override
  String get emotionHistoryEmpty => 'Aucun historique trouvé.';

  @override
  String get educationTitle => 'Éducation financière';

  @override
  String get other => 'Autres';

  @override
  String get trendForecastTitle => 'Graphique de tendance émotionnelle';

  @override
  String get premiumFeatureExplain => 'Débloquez cette fonctionnalité Premium pour accéder à du contenu exclusif.';

  @override
  String get noTrendData => 'Aucune donnée de tendance disponible.';

  @override
  String get trendForecastDescription => 'Votre tendance émotionnelle récente est visualisée ci-dessous.';

  @override
  String get privacyTitle => 'Privacy Policy';

  @override
  String get termsTitle => 'Terms of Service';

  @override
  String get disclaimerTitle => 'Disclaimer';

  @override
  String get faqTitle => 'FAQ';

  @override
  String get restorePurchasesTitle => 'Restaurer les achats';

  @override
  String get restorePurchasesDone => 'Achats restaurés';

  @override
  String get trendScoreLegend => 'Score Legend: 6=Excited, 5=Optimistic, 3=Neutral, 2=Confused, 1=Worried, 0=Cautious';

  @override
  String get premiumTrendUpsell => 'Unlock trend charts, performance tracking, and personalized insights with Finqly Plus!';

  @override
  String dayLabel(Object n) {
    return 'Day $n';
  }
}
