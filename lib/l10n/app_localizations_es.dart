// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Finqly';

  @override
  String get emotionPrompt => '¿Cómo te sientes hoy con tus finanzas?';

  @override
  String get startButton => 'Iniciar ahora';

  @override
  String get diagnosisTitle => 'Diagnóstico';

  @override
  String get diagnosisQuestion => '¿Cómo te sientes respecto al mercado en este momento?';

  @override
  String get diagnosisButton => 'Ejecutar diagnóstico';

  @override
  String get optionOptimistic => 'Optimista';

  @override
  String get optionNeutral => 'Neutral';

  @override
  String get optionWorried => 'Preocupado';

  @override
  String get optionConfused => 'Confundido';

  @override
  String get optionExcited => 'Emocionado';

  @override
  String get optionCautious => 'Cauteloso';

  @override
  String get badgeOptimistic => '¡Tienes una perspectiva optimista del mercado!';

  @override
  String get badgeNeutral => 'Hoy te sientes neutral.';

  @override
  String get badgeWorried => 'Estás preocupado por tus inversiones.';

  @override
  String get badgeConfused => 'Te sientes inseguro o confundido.';

  @override
  String get badgeExcited => '¡Estás lleno de energía y listo!';

  @override
  String get badgeCautious => 'Estás abordando el mercado con precaución.';

  @override
  String get investmentTipsTitle => 'Consejos de inversión';

  @override
  String get investmentTips1 => 'Diversifica tus inversiones para reducir riesgos.';

  @override
  String get investmentTips2 => 'No dejes que las emociones a corto plazo afecten tus decisiones a largo plazo.';

  @override
  String get investmentTips3 => 'Comprende tu tolerancia al riesgo antes de invertir.';

  @override
  String get investmentTips4 => 'Mantente informado, pero evita vender por pánico.';

  @override
  String get investmentTips5 => 'Invertir es un viaje a largo plazo, no una carrera corta.';

  @override
  String get tapToFlip => 'Toca para voltear';

  @override
  String get investmentTipsExplanation1 => '¡La diversificación es la regla de oro de los inversores exitosos!';

  @override
  String get investmentTipsExplanation2 => 'No te dejes llevar por las emociones a corto plazo, piensa a largo plazo.';

  @override
  String get investmentTipsExplanation3 => 'Conocer tu tolerancia al riesgo te ayudará a evitar errores.';

  @override
  String get investmentTipsExplanation4 => 'Estar informado es importante. ¡Pero evita vender en pánico!';

  @override
  String get investmentTipsExplanation5 => 'Invertir a largo plazo es lo que construye el futuro.';

  @override
  String get forecastTitle => 'Tu pronóstico de inversión';

  @override
  String forecastMessage(Object percent) {
    return 'Según tu mentalidad e historial, se espera un crecimiento del $percent% este mes.';
  }

  @override
  String get premiumPrompt => 'Estás a punto de desbloquear ideas aún mejores.';

  @override
  String get premiumCTA => 'Obtener pronóstico Premium';

  @override
  String get language => 'Idioma';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Francés';

  @override
  String get languagePortuguese => 'Portugués';

  @override
  String get languageGerman => 'Alemán';

  @override
  String get settingsTitle => 'Configuraciones';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get lightMode => 'Modo claro';

  @override
  String get darkModeOn => 'El modo oscuro está ACTIVADO';

  @override
  String get darkModeOff => 'El modo oscuro está DESACTIVADO';

  @override
  String get premiumUnlockTitle => 'Desbloquear información Premium';

  @override
  String get premiumUnlockMessage => 'Accede a pronósticos avanzados, tendencias emocionales y consejos de expertos.';

  @override
  String get premiumUnlockButton => 'Desbloquear ahora';

  @override
  String get premiumDisclaimer => 'Puedes cancelar en cualquier momento. Sin cargos ocultos.';

  @override
  String get upgradeToPremium => 'Mejorar a Finqly Plus';

  @override
  String get unlockInsights => '💡 Desbloquea conocimientos más profundos';

  @override
  String get premiumFeature1 => 'Pronósticos avanzados con datos emocionales.';

  @override
  String get premiumFeature2 => 'Sigue las tendencias emocionales a lo largo del tiempo.';

  @override
  String get premiumFeature3 => 'Obtén consejos de inversión de expertos.';

  @override
  String get premiumUnlockSuccess => '¡Premium desbloqueado con éxito!';

  @override
  String get premiumUnlockError => 'Algo salió mal. Por favor, inténtalo de nuevo.';

  @override
  String get emotionHistoryTitle => 'Historial emocional';

  @override
  String get emotionHistoryEmpty => 'No se encontró historial.';

  @override
  String get educationTitle => 'Educación financiera';

  @override
  String get other => 'Otros';

  @override
  String get trendForecastTitle => 'Gráfico de tendencia emocional';

  @override
  String get premiumFeatureExplain => 'Premium desbloquea todas las funciones de tendencias, gráficos y consejos pro.';

  @override
  String get noTrendData => 'No hay datos de tendencia disponibles.';

  @override
  String get trendForecastDescription => 'Tu tendencia emocional reciente se visualiza a continuación.';

  @override
  String get privacyTitle => 'Política de privacidad';

  @override
  String get termsTitle => 'Términos de servicio';

  @override
  String get disclaimerTitle => 'Descargo de responsabilidad';

  @override
  String get faqTitle => 'Preguntas frecuentes';

  @override
  String get restorePurchasesTitle => 'Restaurar compras';

  @override
  String get restorePurchasesDone => 'Compras restauradas';

  @override
  String get trendScoreLegend => 'Leyenda de puntuación: 6=Emocionado, 5=Optimista, 3=Neutral, 2=Confundido, 1=Preocupado, 0=Cauteloso';

  @override
  String get premiumTrendUpsell => '¡Desbloquea gráficos de tendencia, seguimiento de rendimiento e insights personalizados con Finqly Plus!';

  @override
  String dayLabel(Object n) {
    return 'Día $n';
  }

  @override
  String get manageSubscriptionTitle => 'Gestionar suscripción (Play Store)';

  @override
  String get openSubscriptionPageFailed => 'No se pudo abrir la página de suscripción.';

  @override
  String get unlockOptionsTitle => 'Opciones de desbloqueo';

  @override
  String get oneTimeDiagnosisTitle => 'Diagnóstico único';

  @override
  String get oneTimeDiagnosisSubtitle => '\$2.99 • No se requiere suscripción';

  @override
  String get goPremiumTitle => 'Hazte Premium';

  @override
  String get goPremiumSubtitle => 'Suscripción mensual o anual disponible';

  @override
  String get purchaseErrorPrefix => 'Error de compra:';

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
}
