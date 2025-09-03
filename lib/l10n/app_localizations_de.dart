// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Finqly';

  @override
  String get emotionPrompt => 'Wie fühlen Sie sich heute in Bezug auf Ihre Finanzen?';

  @override
  String get startButton => 'Jetzt starten';

  @override
  String get diagnosisTitle => 'Diagnose';

  @override
  String get diagnosisQuestion => 'Wie fühlen Sie sich momentan in Bezug auf den Markt?';

  @override
  String get diagnosisButton => 'Diagnose ausführen';

  @override
  String get optionOptimistic => 'Optimistisch';

  @override
  String get optionNeutral => 'Neutral';

  @override
  String get optionWorried => 'Besorgt';

  @override
  String get optionConfused => 'Verwirrt';

  @override
  String get optionExcited => 'Aufgeregt';

  @override
  String get optionCautious => 'Vorsichtig';

  @override
  String get badgeOptimistic => 'Sie sind optimistisch in Bezug auf den Markt!';

  @override
  String get badgeNeutral => 'Sie fühlen sich heute neutral.';

  @override
  String get badgeWorried => 'Sie machen sich Sorgen um Ihre Investitionen.';

  @override
  String get badgeConfused => 'Sie fühlen sich unsicher oder verwirrt.';

  @override
  String get badgeExcited => 'Sie sind voller Energie und bereit!';

  @override
  String get badgeCautious => 'Sie gehen den Markt mit Vorsicht an.';

  @override
  String get investmentTipsTitle => 'Anlagetipps';

  @override
  String get investmentTips1 => 'Diversifizieren Sie Ihre Investitionen, um Risiken zu minimieren.';

  @override
  String get investmentTips2 => 'Lassen Sie sich bei langfristigen Entscheidungen nicht von kurzfristigen Emotionen leiten.';

  @override
  String get investmentTips3 => 'Verstehen Sie Ihre Risikobereitschaft, bevor Sie investieren.';

  @override
  String get investmentTips4 => 'Bleiben Sie informiert, aber vermeiden Sie Panikverkäufe.';

  @override
  String get investmentTips5 => 'Investieren ist eine langfristige Reise – kein Sprint.';

  @override
  String get tapToFlip => 'Zum Umdrehen tippen';

  @override
  String get investmentTipsExplanation1 => 'Diversifikation ist das oberste Gebot erfolgreicher Anleger!';

  @override
  String get investmentTipsExplanation2 => 'Lassen Sie sich nicht von kurzfristigen Gefühlen leiten – denken Sie langfristig.';

  @override
  String get investmentTipsExplanation3 => 'Wer seine Risikobereitschaft kennt, macht weniger Fehler.';

  @override
  String get investmentTipsExplanation4 => 'Information ist wichtig – vermeiden Sie dennoch Panikverkäufe!';

  @override
  String get investmentTipsExplanation5 => 'Durchhaltevermögen zahlt sich für Ihre Zukunft aus.';

  @override
  String get forecastTitle => 'Ihre Investitionsprognose';

  @override
  String forecastMessage(Object percent) {
    return 'Basierend auf Ihrer Einstellung und Ihrem Verlauf wird in diesem Monat ein Wachstum von $percent% erwartet.';
  }

  @override
  String get premiumPrompt => 'Sie sind kurz davor, noch tiefere Einblicke freizuschalten.';

  @override
  String get premiumCTA => 'Premium-Prognose erhalten';

  @override
  String get language => 'Sprache';

  @override
  String get languageEnglish => 'Englisch';

  @override
  String get languageSpanish => 'Spanisch';

  @override
  String get languageFrench => 'Französisch';

  @override
  String get languagePortuguese => 'Portugiesisch';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get darkMode => 'Dunkler Modus';

  @override
  String get lightMode => 'Heller Modus';

  @override
  String get darkModeOn => 'Dunkler Modus ist AKTIV';

  @override
  String get darkModeOff => 'Dunkler Modus ist INAKTIV';

  @override
  String get premiumUnlockTitle => 'Premium-Einblicke freischalten';

  @override
  String get premiumUnlockMessage => 'Erhalten Sie Zugang zu erweiterten Prognosen, Emotionstrends und Experten-Tipps.';

  @override
  String get premiumUnlockButton => 'Jetzt freischalten';

  @override
  String get premiumDisclaimer => 'Jederzeit kündbar. Keine versteckten Kosten.';

  @override
  String get upgradeToPremium => 'Upgrade auf Finqly Plus';

  @override
  String get unlockInsights => '💡 Tiefere Einblicke freischalten';

  @override
  String get premiumFeature1 => 'Erweiterte Prognosen mit Emotionsdaten.';

  @override
  String get premiumFeature2 => 'Emotionstrends im Zeitverlauf verfolgen.';

  @override
  String get premiumFeature3 => 'Experten-Tipps zur Geldanlage erhalten.';

  @override
  String get premiumUnlockSuccess => 'Premium erfolgreich freigeschaltet!';

  @override
  String get premiumUnlockError => 'Ein Fehler ist aufgetreten. Bitte versuchen Sie es erneut.';

  @override
  String get emotionHistoryTitle => 'Emotionsverlauf';

  @override
  String get emotionHistoryEmpty => 'Keine Einträge gefunden.';

  @override
  String get educationTitle => 'Finanzbildung';

  @override
  String get other => 'Sonstiges';

  @override
  String get trendForecastTitle => 'Emotionstrend-Diagramm';

  @override
  String get premiumFeatureExplain => 'Premium schaltet alle Trend-, Diagramm- und Pro-Tipps-Funktionen frei.';

  @override
  String get noTrendData => 'Keine Trenddaten verfügbar.';

  @override
  String get trendForecastDescription => 'Ihr jüngster Emotionstrend wird unten visualisiert.';

  @override
  String get privacyTitle => 'Datenschutzerklärung';

  @override
  String get termsTitle => 'Nutzungsbedingungen';

  @override
  String get disclaimerTitle => 'Haftungsausschluss';

  @override
  String get faqTitle => 'FAQ';

  @override
  String get restorePurchasesTitle => 'Käufe wiederherstellen';

  @override
  String get restorePurchasesDone => 'Käufe wiederhergestellt';

  @override
  String get trendScoreLegend => 'Legende: 6=Aufgeregt, 5=Optimistisch, 3=Neutral, 2=Verwirrt, 1=Besorgt, 0=Vorsichtig';

  @override
  String get premiumTrendUpsell => 'Schalten Sie Trenddiagramme, Performance-Tracking und personalisierte Einblicke mit Finqly Plus frei!';

  @override
  String dayLabel(Object n) {
    return 'Tag $n';
  }

  @override
  String get manageSubscriptionTitle => 'Abo verwalten (Play Store)';

  @override
  String get openSubscriptionPageFailed => 'Abo-Seite konnte nicht geöffnet werden.';

  @override
  String get unlockOptionsTitle => 'Freischalt-Optionen';

  @override
  String get oneTimeDiagnosisTitle => 'Einmalige Diagnose';

  @override
  String get oneTimeDiagnosisSubtitle => '\$2.99 • Keine Abonnements erforderlich';

  @override
  String get goPremiumTitle => 'Premium werden';

  @override
  String get goPremiumSubtitle => 'Monatliches oder jährliches Abo verfügbar';

  @override
  String get purchaseErrorPrefix => 'Kauf-Fehler:';
}
