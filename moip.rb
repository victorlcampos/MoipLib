# encoding: utf-8

require "nokogiri"

module MoIP  
  mattr_accessor :uri
  @@uri = "https://desenvolvedor.moip.com.br/sandbox"
  mattr_accessor :token
  mattr_accessor :key
  
  def self.setup
    yield self
  end
  
  CodigoErro = 0..999
  CodigoEstado = %w{AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO}
  CodigoMoeda = "BRL"
  CodigoPais = "BRA"
  Destino = %w{Nenhum MesmoCobranca AInformar PreEstabelecido}
  FormaEntregaCorreios = %w{EncomendaNormal Sedex Sedex10 SedexACobrar SedexHoje}
  FormaPagamento = %w{CarteiraMoIP CartaoCredito CartaoDebito DebitoBancario FinanciamentoBancario BoletoBancario}
  FormaRestricao = %w{Contador Valor}
  InstituicaoPagamento = %w{MoIP Visa AmericanExpress Mastercard Diners BancoDoBrasil Bradesco Itau BancoReal Unibanco Aura Hipercard Paggo Banrisul}
  PapelIndividuo = %w{Integrador Recebedor Comissionado Pagado}
  OpcaoDisponivel = %w{Sim Não PagadorEscolhe}
  Parcelador = %w{Nenhum Administradora MoIP Recebedor}
  StatusLembrete = %w{Enviado Realizado EmAndamento Aguardando Falha}
  StatusPagamento = %w{Autorizado Iniciado BoletoImpresso Concluido Cancelado EmAnalise Estornado}
  TipoDias = %w{Corridos Uteis}
  TipoDuracao = %w{Minutos Horas Dias Semanas Meses Ano}
  TipoFrete = %w{Proprio Correio}
  TipoIdentidade = %w{CPF CNPJ}
  TipoInstrucao = %w{Unico Recorrente PrePago PosPago Remessa}
  TipoLembrete = %w{Email SMS}
  TipoPeriodicidade = %w{Anual Mensal Semanal Diaria}
  TipoRecebimento = %w{AVista Parcelado}
  TipoRestricao = %w{Autorizacao Pagamento}
  TipoStatus = %w{Sucesso Falha}
  
  def self.get_status(status)
    StatusPagamento[status - 1]
  end
end