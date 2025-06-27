// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Finqly';

  @override
  String get emotionPrompt =>
      'Como você está se sentindo em relação às suas finanças hoje?';

  @override
  String get startButton => 'Começar agora';

  @override
  String get diagnosisTitle => 'Diagnóstico';

  @override
  String get diagnosisQuestion =>
      'Como você se sente sobre o mercado neste momento?';

  @override
  String get diagnosisButton => 'Run Diagnosis';

  @override
  String get optionOptimistic => 'Otimista';

  @override
  String get optionNeutral => 'Neutro';

  @override
  String get optionWorried => 'Preocupado';

  @override
  String get optionConfused => 'Confuso';

  @override
  String get optionExcited => 'Animado';

  @override
  String get optionCautious => 'Cauteloso';

  @override
  String get badgeOptimistic => 'Você está otimista em relação ao mercado!';

  @override
  String get badgeNeutral => 'Você está se sentindo neutro hoje.';

  @override
  String get badgeWorried => 'Você está preocupado com seus investimentos.';

  @override
  String get badgeConfused => 'Você está se sentindo inseguro ou confuso.';

  @override
  String get badgeExcited => 'Você está cheio de energia e pronto!';

  @override
  String get badgeCautious => 'Você está abordando o mercado com cautela.';

  @override
  String get investmentTipsTitle => 'Dicas de investimento';

  @override
  String get investmentTips1 =>
      'Diversifique seus investimentos para reduzir riscos.';

  @override
  String get investmentTips2 =>
      'Não deixe emoções de curto prazo influenciarem decisões de longo prazo.';

  @override
  String get investmentTips3 =>
      'Entenda sua tolerância ao risco antes de investir.';

  @override
  String get investmentTips4 =>
      'Mantenha-se informado, mas evite vender em pânico.';

  @override
  String get investmentTips5 =>
      'Investir é uma jornada de longo prazo — não uma corrida.';

  @override
  String get forecastTitle => 'Previsão de Investimento';

  @override
  String forecastMessage(Object percent) {
    return 'Com base na sua mentalidade e histórico, prevê-se um crescimento de $percent neste mês.';
  }

  @override
  String get premiumPrompt =>
      'Você está prestes a desbloquear insights ainda melhores.';

  @override
  String get premiumCTA => 'Obter Previsão Premium';

  @override
  String get language => 'Idioma';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get darkMode => 'Modo escuro';

  @override
  String get lightMode => 'Modo claro';

  @override
  String get premiumUnlockTitle => 'Desbloqueie Insights Premium';

  @override
  String get premiumUnlockMessage =>
      'Acesse previsões avançadas, tendências emocionais e dicas de especialistas.';

  @override
  String get premiumUnlockButton => 'Desbloquear agora';

  @override
  String get premiumDisclaimer =>
      'Você pode cancelar a qualquer momento. Sem taxas ocultas.';

  @override
  String get upgradeToPremium => 'Atualizar para o Finqly Plus';

  @override
  String get unlockInsights => '💡 Desbloqueie insights mais profundos';

  @override
  String get premiumFeature1 =>
      'Previsões avançadas com base em dados emocionais.';

  @override
  String get premiumFeature2 =>
      'Acompanhe tendências emocionais ao longo do tempo.';

  @override
  String get premiumFeature3 =>
      'Receba dicas de especialistas em investimentos.';

  @override
  String get premiumUnlockSuccess => 'Premium desbloqueado com sucesso!';

  @override
  String get premiumUnlockError => 'Algo deu errado. Tente novamente.';

  @override
  String get emotionHistoryTitle => 'Emotion History';

  @override
  String get emotionHistoryEmpty => 'No history found.';

  @override
  String get educationTitle => 'Financial Education';

  @override
  String get other => 'Outros';
}
