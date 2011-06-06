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
      verify params, params["responseFingerprintOrder"], params["responseFingerprint"]
    end

    def self.verify(params, order, given_fingerprint)
      secret_used = false

      fingerprint_items = order.split(",").map do |item|
        if item == "secret"
          secret_used = true
          Rails.application.config.qpay.secret
        else
          params[item]
        end
      end

      secret_used && build_fingerprint(fingerprint_items) == given_fingerprint
    end


    def initialize(params, order_name="RequestFingerprintOrder")
      params.stringify_keys!
      params = default_options.merge(params)

      unless all_mandatory_fields_present?(params)
        raise ArgumentError.new("Missing mandatory fingerprint parameters! #{MANDATORY_FINGERPRINT_PARAMS.join(", ")} are required.")
      end

      @order = build_order params.keys.map(&:to_s) << order_name
      @fingerprint_seed = params.values << @order
      @fingerprint = self.class.build_fingerprint @fingerprint_seed
    end

    private

      def self.build_fingerprint(fingerprint_items)
        Digest::MD5.hexdigest(fingerprint_items.join(""))
      end


      def build_order(order_items)
        order_items.join(",")
      end

      def default_options
        {
          "customerId" => Rails.application.config.eypay.customer_id,
          "secret"     => Rails.application.config.eypay.secret,

          "currency"   => Rails.application.config.eypay.currency,
          "language"   => Rails.application.config.eypay.language,

          "imageURL"   => Rails.application.config.eypay.bbw_logo,
          "serviceURL" => Rails.application.config.eypay.service_url,
          "successURL" => Rails.application.config.eypay.success_url,
          "cancelURL"  => Rails.application.config.eypay.cancel_url,
          "failureURL" => Rails.application.config.eypay.failure_url
        }
      end

      def all_mandatory_fields_present?(params)
        MANDATORY_FINGERPRINT_PARAMS.all? { |field| params.include? field }
      end

  end
end
