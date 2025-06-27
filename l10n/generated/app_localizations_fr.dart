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
  String get emotionPrompt =>
      'Comment vous sentez-vous aujourd\'hui à propos de vos finances ?';

  @override
  String get startButton => 'Commencer maintenant';

  @override
  String get diagnosisTitle => 'Diagnostic';

  @override
  String get diagnosisQuestion =>
      'Comment vous sentez-vous par rapport au marché en ce moment ?';

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
  String get investmentTips1 =>
      'Diversifiez vos investissements pour réduire les risques.';

  @override
  String get investmentTips2 =>
      'Ne laissez pas les émotions à court terme influencer vos décisions à long terme.';

  @override
  String get investmentTips3 =>
      'Comprenez votre tolérance au risque avant d\'investir.';

  @override
  String get investmentTips4 =>
      'Restez informé, mais évitez de vendre dans la panique.';

  @override
  String get investmentTips5 =>
      'Investir est un voyage à long terme — pas un sprint.';

  @override
  String get forecastTitle => 'Prévisions d\'investissement';

  @override
  String forecastMessage(Object percent) {
    return 'Selon votre état d\'esprit et votre historique, vous devriez croître de $percent ce mois-ci.';
  }

  @override
  String get premiumPrompt =>
      'Vous êtes sur le point de débloquer des informations encore meilleures.';

  @override
  String get premiumCTA => 'Obtenir les prévisions Premium';

  @override
  String get language => 'Langue';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get lightMode => 'Mode clair';

  @override
  String get premiumUnlockTitle => 'Débloquez des informations Premium';

  @override
  String get premiumUnlockMessage =>
      'Accédez à des prévisions avancées, des tendances émotionnelles et des conseils d\'experts.';

  @override
  String get premiumUnlockButton => 'Débloquer maintenant';

  @override
  String get premiumDisclaimer =>
      'Vous pouvez annuler à tout moment. Aucun frais caché.';

  @override
  String get upgradeToPremium => 'Passez à Finqly Plus';

  @override
  String get unlockInsights =>
      '💡 Débloquez des connaissances plus approfondies';

  @override
  String get premiumFeature1 => 'Prévisions avancées basées sur les émotions.';

  @override
  String get premiumFeature2 =>
      'Suivez l’évolution de vos émotions dans le temps.';

  @override
  String get premiumFeature3 =>
      'Recevez des conseils d\'experts en investissement.';

  @override
  String get premiumUnlockSuccess => 'Premium débloqué avec succès !';

  @override
  String get premiumUnlockError =>
      'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get emotionHistoryTitle => 'Emotion History';

  @override
  String get emotionHistoryEmpty => 'No history found.';

  @override
  String get educationTitle => 'Financial Education';

  @override
  String get other => 'Autres';
}
