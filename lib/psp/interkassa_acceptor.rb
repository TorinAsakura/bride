require "digest/md5"

module InterkassaAcceptor
  class << self
    def config
      @config ||= YAML.load_file(File.join(Rails.root, "config", "psp", "interkassa.yml"))[Rails.env]
    end
  end

  class InvalidTransaction < Exception
  end

  module ControllerExtension
    def self.included(base)
      base.helper_method :interkassa
    end

    def interkassa
      @interkassa_acceptor ||= Acceptor.new(self)
    end

    class Acceptor
      def initialize(controller)
        @controller = controller
      end

      def prerequest?
        false
      end

      def success?
        params[:inv_st].eql?('success') && params[:co_id].eql?(InterkassaAcceptor.config["shop_id"])
      end

      def valid_payment?(secret = InterkassaAcceptor.config["secret"])
        raise ArgumentError.new("Interkassa secret key is not provided") if secret.blank?

        params_sign = params.delete(:sign)
        sign(params, secret).eql? params_sign
      end

      def sign(hash, secret = InterkassaAcceptor.config["secret"])
        Base64.encode64(Digest::MD5.digest(hash.keys.sort.map{|key| hash[key]}.push(secret).join(":"))).gsub(/\n/, '')
      end

      def params
        unless @params
          @params = HashWithIndifferentAccess.new
          @controller.params.each{ |key, value| @params[key.gsub(/^ik_/, "")] = value if key.starts_with?('ik_') }
        end
        @params
      end
    end
  end

  module ViewExtension
    def interkassa_payment_form(*args, &block)
      options = args.extract_options!
      amount  = args.pop
      shop  = args.first || InterkassaAcceptor.config["shop_id"]

      raise ArgumentError.new("Interkassa wallet is not provided") if shop.blank?

      params = {'ik_co_id' => shop, 'ik_am' => amount} # Sym dont work
      options.map {|key, value| params["ik_#{key.to_s}"] = value}

      params['ik_sign'] = interkassa.sign(params)

      result = form_tag("https://sci.interkassa.com/", method: :post )

      params.map{|key, value| result << hidden_field_tag(key, value)}

      result << capture(&block) if block_given?

      result.html_safe
    end
  end
end
