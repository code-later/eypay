# encoding: utf-8

module Eypay
  class Fingerprint
    attr_reader :fingerprint
    attr_reader :order

    MANDATORY_FINGERPRINT_PARAMS = %w{
      customerId
      secret
      amount
      currency
      language
      orderDescription
      successURL
      cancelURL
      failureURL
      serviceURL
    }

    def self.verify_from_request(params)
      Rails.application.config.eypay.logins.any? do |login|
        verify params, params["responseFingerprintOrder"], params["responseFingerprint"], login[:secret]
      end
    end

    def self.verify(params, order, given_fingerprint, secret)
      secret_used = false

      fingerprint_items = order.split(",").map do |item|
        if item == "secret"
          secret_used = true
          secret
        else
          params[item]
        end
      end

      secret_used && build_fingerprint(fingerprint_items) == given_fingerprint
    end


    def initialize(params, order_name="RequestFingerprintOrder", mandatory_fingerprint_params = MANDATORY_FINGERPRINT_PARAMS)
      params.stringify_keys!
      params = default_options.merge(params)

      unless all_mandatory_fields_present?(params, mandatory_fingerprint_params)
        raise ArgumentError.new("Missing mandatory fingerprint parameters! #{mandatory_fingerprint_params.join(", ")} are required.")
      end

      if order_name.present?
        @order = build_order params.keys.map(&:to_s) << order_name
        @fingerprint_seed = params.values << @order
      else
        @order = build_order(mandatory_fingerprint_params)
        @fingerprint_seed = build_seed(params, mandatory_fingerprint_params)
      end

      @fingerprint = self.class.build_fingerprint @fingerprint_seed
    end

    private

      def self.build_fingerprint(fingerprint_items)
        Digest::MD5.hexdigest(fingerprint_items.join(""))
      end


      def build_order(mandatory_fingerprint_params)
        mandatory_fingerprint_params.join(",")
      end

      def build_seed(params, mandatory_fingerprint_params)
        mandatory_fingerprint_params.collect { |key| params[key] }
      end

      def default_options
        {
          "currency"   => Rails.application.config.eypay.currency,
          "language"   => Rails.application.config.eypay.language
        }
      end

      def all_mandatory_fields_present?(params, mandatory_fingerprint_params)
        mandatory_fingerprint_params.all? { |field| params.include? field }
      end

  end
end
