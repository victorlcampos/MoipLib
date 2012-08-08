# encoding: utf-8

require "nokogiri"

module MoIP
  class ApiMoip
    class << self
      def body(attributes = {})
        builder = Nokogiri::XML::Builder.new(:encoding => "UTF-8") do |xml|
          xml.EnviarInstrucao do
            xml.InstrucaoUnica do
              # INICIO DADOS OBRIGATÓRIOS
              xml.Razao { xml.text attributes[:razao] }

              xml.Valores do
                attributes[:valores].each do |valor|
                  xml.Valor(:moeda => "BRL") { xml.text valor }
                end
              end
              # FIM DADOS OBRIGATÓRIOS

              # INICIO INFOMRAÇÕES ADICIONAIS
              if attributes[:formas_pagamento]
                xml.FormasPagamento do
                  attributes[:formas_pagamento].each do |forma_pagamento|
                    xml.FormaPagamento { xml.text forma_pagamento}
                  end
                end
              end

              xml.URLRetorno { xml.text attributes[:url_retorno] }
              xml.URLNotificacao { xml.text attributes[:url_notificacao] }

              # FIM INFOMRAÇÕES ADICIONAIS

              # INICIO DADOS RECOMENDADOS
              xml.IdProprio { xml.text (attributes[:id_proprio] ? attributes[:id_proprio] : self.generate_uid) }
              xml.DataVencimento { xml.text attributes[:data_vencimento] } if attributes[:data_vencimento]        
              # FIM DADOS RECOMENDADOS

              # INICIO DADOS CLIENTE
              if attributes[:pagador]          
                xml.Pagador do
                  xml.Nome { xml.text attributes[:pagador][:nome] }
                  xml.LoginMoIP { xml.text attributes[:pagador][:login_moip] }
                  xml.Email { xml.text attributes[:pagador][:email] }
                  xml.TelefoneCelular { xml.text attributes[:pagador][:tel_cel] }
                  xml.Apelido { xml.text attributes[:pagador][:apelido] }
                  xml.Identidade(:Tipo => "CPF") { xml.text attributes[:pagador][:identidade] }
                  xml.EnderecoCobranca do
                    xml.Logradouro { xml.text attributes[:pagador][:logradouro] }
                    xml.Numero { xml.text attributes[:pagador][:numero] }
                    xml.Complemento { xml.text attributes[:pagador][:complemento] }
                    xml.Bairro { xml.text attributes[:pagador][:bairro] }
                    xml.Cidade { xml.text attributes[:pagador][:cidade] }
                    xml.Estado { xml.text attributes[:pagador][:estado] }
                    xml.Pais { xml.text attributes[:pagador][:pais] }
                    xml.CEP { xml.text attributes[:pagador][:cep] }
                    xml.TelefoneFixo { xml.text attributes[:pagador][:tel_fixo] }
                  end
                end
              end
              # FIM DADOS CLIENTE

              # INICIO DADOS RECEBEDOR
              if attributes[:recebedor]
                xml.Recebedor do
                  xml.LoginMoIP { xml.text attributes[:recebedor][:login_moip] }
                  xml.Email { xml.text attributes[:pagador][:email] }
                  xml.Apelido { xml.text attributes[:pagador][:apelido] }
                end
              end
              # FIM DADOS RECEBEDOR          
            end
          end
        end
        builder.to_xml
      end

      def checkout(attributes = {})
        body = self.body(attributes)
        puts "************ XML ************"
        puts body
        full_data = peform_action!(:post, 'EnviarInstrucao/Unica', body)
        get_response!(full_data["EnviarInstrucaoUnicaResponse"]["Resposta"])
      end

      def moip_page(token)
        "#{MoIP.uri}/Instrucao.do?token=#{token}"
      end

      protected
        def generate_uid
          SecureRandom.hex(5)
        end

      private
        def peform_action!(action_name, url, body)
          uri = URI.parse("#{MoIP.uri}/ws/alpha/#{url}")        
          req = "Net::HTTP::#{action_name.capitalize}".to_class.new(uri.path)

          req.body = body
          req.basic_auth MoIP.token, MoIP.key

          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          Hash.from_xml(http.request(req).body)
        end

        def get_response!(data)
          err = data["Erro"].is_a?(Array) ? data["Erro"].join(", ") : data["Erro"]
          data
        end
    end
  end
end