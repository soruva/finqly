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
  String get diagnosisButton => 'Lancer le diagnostic';

  @override
  String get optionOptimistic => 'Optimiste';

  @override
  String get optionNeutral => 'Neutre';

  @override
  String get optionWorried => 'Inquiet';

  @override
  String get optionConfused => 'Perplexe';

  @override
  String get optionExcited => 'Enthousiaste';

  @override
  String get optionCautious => 'Prudent';

  @override
  String get badgeOptimistic => 'Vous êtes optimiste concernant le marché !';

  @override
  String get badgeNeutral => 'Vous vous sentez neutre aujourd\'hui.';

  @override
  String get badgeWorried => 'Vous êtes inquiet pour vos investissements.';

  @override
  String get badgeConfused => 'Vous vous sentez incertain ou perplexe.';

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
      'Investir est un parcours de longue durée — pas un sprint.';

  @override
  String get tapToFlip => 'Touchez pour retourner';

  @override
  String get investmentTipsExplanation1 =>
      'La diversification est la règle d’or des investisseurs !';

  @override
  String get investmentTipsExplanation2 =>
      'Ne vous laissez pas guider par le court terme — pensez long terme.';

  @override
  String get investmentTipsExplanation3 =>
      'Connaître votre tolérance au risque réduit les erreurs.';

  @override
  String get investmentTipsExplanation4 =>
      'S’informer est important. Évitez les ventes paniques !';

  @override
  String get investmentTipsExplanation5 =>
      'La constance construit votre avenir financier.';

  @override
  String get forecastTitle => 'Vos prévisions d\'investissement';

  @override
  String forecastMessage(Object percent) {
    return 'Selon votre état d’esprit et votre historique, une croissance de $percent% est attendue ce mois-ci.';
  }

  @override
  String get premiumPrompt =>
      'Vous êtes sur le point de débloquer des informations encore meilleures.';

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
  String get darkModeOn => 'Le mode sombre est ACTIVÉ';

  @override
  String get darkModeOff => 'Le mode sombre est DÉSACTIVÉ';

  @override
  String get premiumUnlockTitle => 'Débloquer les insights Premium';

  @override
  String get premiumUnlockMessage =>
      'Accédez à des prévisions avancées, des tendances émotionnelles et des conseils d’experts.';

  @override
  String get premiumUnlockButton => 'Débloquer maintenant';

  @override
  String get premiumDisclaimer =>
      'Vous pouvez annuler à tout moment. Aucun frais caché.';

  @override
  String get upgradeToPremium => 'Passer à Finqly Plus';

  @override
  String get unlockInsights => '💡 Débloquez des insights plus profonds';

  @override
  String get premiumFeature1 =>
      'Prévisions avancées basées sur des données émotionnelles.';

  @override
  String get premiumFeature2 =>
      'Suivez l’évolution de vos émotions dans le temps.';

  @override
  String get premiumFeature3 =>
      'Recevez des conseils d’experts en investissement.';

  @override
  String get premiumUnlockSuccess => 'Premium débloqué avec succès !';

  @override
  String get premiumUnlockError =>
      'Une erreur s’est produite. Veuillez réessayer.';

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
  String get premiumFeatureExplain =>
      'Premium débloque toutes les fonctions de tendances, graphiques et conseils pro.';

  @override
  String get noTrendData => 'Aucune donnée de tendance disponible.';

  @override
  String get trendForecastDescription =>
      'Votre tendance émotionnelle récente est visualisée ci-dessous.';

  @override
  String get privacyTitle => 'Politique de confidentialité';

  @override
  String get termsTitle => 'Conditions d’utilisation';

  @override
  String get disclaimerTitle => 'Avertissement';

  @override
  String get faqTitle => 'FAQ';

  @override
  String get restorePurchasesTitle => 'Restaurer les achats';

  @override
  String get restorePurchasesDone => 'Achats restaurés';

  @override
  String get trendScoreLegend =>
      'Légende : 6=Enthousiaste, 5=Optimiste, 3=Neutre, 2=Perplexe, 1=Inquiet, 0=Prudent';

  @override
  String get premiumTrendUpsell =>
      'Débloquez les graphiques de tendance, le suivi des performances et des insights personnalisés avec Finqly Plus !';

  @override
  String dayLabel(Object n) {
    return 'Jour $n';
  }

  @override
  String get manageSubscriptionTitle => 'Gérer l’abonnement (Play Store)';

  @override
  String get openSubscriptionPageFailed =>
      'Impossible d’ouvrir la page d’abonnement.';

  @override
  String get unlockOptionsTitle => 'Options de déblocage';

  @override
  String get oneTimeDiagnosisTitle => 'Diagnostic unique';

  @override
  String get oneTimeDiagnosisSubtitle => '2,99 \$ • Aucun abonnement requis';

  @override
  String get goPremiumTitle => 'Passer Premium';

  @override
  String get goPremiumSubtitle => 'Abonnement mensuel ou annuel disponible';

  @override
  String get purchaseErrorPrefix => 'Erreur d’achat :';

  @override
  String get reportsTitle => 'Rapports et notifications';

  @override
  String get openWeeklyReport => 'Ouvrir le rapport hebdomadaire';

  @override
  String get openWeeklyReportSub => 'Voir la tendance des 7 derniers jours';

  @override
  String get dailyReminderTitle => 'Rappel quotidien (9h00)';

  @override
  String get dailyReminderSub => 'Gardez votre série de check-ins';

  @override
  String get weeklyReminderTitle =>
      'Rappel du rapport hebdomadaire (lun. 9h00)';

  @override
  String get weeklyReminderSub => 'Recevez votre résumé hebdomadaire';

  @override
  String get manageSubscription => 'Gérer l’abonnement (Play Store)';

  @override
  String get about => 'À propos';
}
