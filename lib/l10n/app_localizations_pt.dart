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
  String get emotionPrompt => 'Como você está se sentindo em relação às suas finanças hoje?';

  @override
  String get startButton => 'Começar agora';

  @override
  String get diagnosisTitle => 'Diagnóstico';

  @override
  String get diagnosisQuestion => 'Como você se sente sobre o mercado neste momento?';

  @override
  String get diagnosisButton => 'Executar diagnóstico';

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
  String get investmentTips1 => 'Diversifique seus investimentos para reduzir riscos.';

  @override
  String get investmentTips2 => 'Não deixe emoções de curto prazo influenciarem decisões de longo prazo.';

  @override
  String get investmentTips3 => 'Entenda sua tolerância ao risco antes de investir.';

  @override
  String get investmentTips4 => 'Mantenha-se informado, mas evite vender em pânico.';

  @override
  String get investmentTips5 => 'Investir é uma jornada de longo prazo — não uma corrida.';

  @override
  String get tapToFlip => 'Toque para virar';

  @override
  String get investmentTipsExplanation1 => 'A diversificação é a regra de ouro dos investidores bem-sucedidos!';

  @override
  String get investmentTipsExplanation2 => 'Não se deixe levar por sentimentos de curto prazo — pense a longo prazo.';

  @override
  String get investmentTipsExplanation3 => 'Conhecer sua tolerância ao risco ajuda a evitar erros.';

  @override
  String get investmentTipsExplanation4 => 'Estar informado é importante. Evite vendas em pânico!';

  @override
  String get investmentTipsExplanation5 => 'Consistência constrói o seu futuro financeiro.';

  @override
  String get forecastTitle => 'Previsão de Investimento';

  @override
  String forecastMessage(Object percent) {
    return 'Com base na sua mentalidade e histórico, prevê-se um crescimento de $percent% neste mês.';
  }

  @override
  String get premiumPrompt => 'Você está prestes a desbloquear insights ainda melhores.';

  @override
  String get premiumCTA => 'Obter Previsão Premium';

  @override
  String get language => 'Idioma';

  @override
  String get languageEnglish => 'Inglês';

  @override
  String get languageSpanish => 'Espanhol';

  @override
  String get languageFrench => 'Francês';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageGerman => 'Alemão';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get darkMode => 'Modo escuro';

  @override
  String get lightMode => 'Modo claro';

  @override
  String get darkModeOn => 'Modo escuro ATIVADO';

  @override
  String get darkModeOff => 'Modo escuro DESATIVADO';

  @override
  String get premiumUnlockTitle => 'Desbloquear Insights Premium';

  @override
  String get premiumUnlockMessage => 'Acesse previsões avançadas, tendências emocionais e dicas de especialistas.';

  @override
  String get premiumUnlockButton => 'Desbloquear agora';

  @override
  String get premiumDisclaimer => 'Você pode cancelar a qualquer momento. Sem taxas ocultas.';

  @override
  String get upgradeToPremium => 'Atualizar para o Finqly Plus';

  @override
  String get unlockInsights => '💡 Desbloqueie insights mais profundos';

  @override
  String get premiumFeature1 => 'Previsões avançadas com base em dados emocionais.';

  @override
  String get premiumFeature2 => 'Acompanhe tendências emocionais ao longo do tempo.';

  @override
  String get premiumFeature3 => 'Receba dicas de especialistas em investimentos.';

  @override
  String get premiumUnlockSuccess => 'Premium desbloqueado com sucesso!';

  @override
  String get premiumUnlockError => 'Algo deu errado. Tente novamente.';

  @override
  String get emotionHistoryTitle => 'Histórico emocional';

  @override
  String get emotionHistoryEmpty => 'Nenhum histórico encontrado.';

  @override
  String get educationTitle => 'Educação financeira';

  @override
  String get other => 'Outros';

  @override
  String get trendForecastTitle => 'Gráfico de tendência emocional';

  @override
  String get premiumFeatureExplain => 'O Premium desbloqueia todos os gráficos de tendências e dicas exclusivas.';

  @override
  String get noTrendData => 'Nenhum dado de tendência disponível.';

  @override
  String get trendForecastDescription => 'Sua tendência emocional recente está visualizada abaixo.';

  @override
  String get privacyTitle => 'Política de Privacidade';

  @override
  String get termsTitle => 'Termos de Serviço';

  @override
  String get disclaimerTitle => 'Aviso Legal';

  @override
  String get faqTitle => 'FAQ';

  @override
  String get restorePurchasesTitle => 'Restaurar compras';

  @override
  String get restorePurchasesDone => 'Compras restauradas';

  @override
  String get trendScoreLegend => 'Legenda: 6=Animado, 5=Otimista, 3=Neutro, 2=Confuso, 1=Preocupado, 0=Cauteloso';

  @override
  String get premiumTrendUpsell => 'Desbloqueie gráficos de tendências, acompanhamento de desempenho e insights personalizados com o Finqly Plus!';

  @override
  String dayLabel(Object n) {
    return 'Dia $n';
  }

  @override
  String get manageSubscriptionTitle => 'Gerenciar assinatura (Play Store)';

  @override
  String get openSubscriptionPageFailed => 'Não foi possível abrir a página de assinatura.';

  @override
  String get unlockOptionsTitle => 'Opções de desbloqueio';

  @override
  String get oneTimeDiagnosisTitle => 'Diagnóstico único';

  @override
  String get oneTimeDiagnosisSubtitle => 'US\$ 2,99 • Sem necessidade de assinatura';

  @override
  String get goPremiumTitle => 'Ir para Premium';

  @override
  String get goPremiumSubtitle => 'Assinatura mensal ou anual disponível';

  @override
  String get purchaseErrorPrefix => 'Erro de compra:';
}
