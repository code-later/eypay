module Eypay
  module EypayHelper
    def form_for_qpay(params, specific_params = {})
      # collect required informations for the qpay request
      qpay_options = {
        "customerId"          => Rails.application.config.eypay.customer_id,
        "successURL"          => Rails.application.config.eypay.success_url,
        "failureURL"          => Rails.application.config.eypay.failure_url,
        "cancelURL"           => Rails.application.config.eypay.cancel_url,
        "serviceURL"          => Rails.application.config.eypay.service_url,
        "imageURL"            => Rails.application.config.eypay.bbw_logo_url,
        "amount"              => params[:amount],
        "currency"            => Rails.application.config.eypay.currency,
        "language"            => Rails.application.config.eypay.language,
        "displayText"         => params[:text],
        "orderDescription"    => params[:description]
      }.merge(specific_params)

      if Rails.application.config.eypay.confirm_url
        qpay_options["confirmURL"] = Rails.application.config.eypay.confirm_url
      end

      # generate request fingerprint
      fingerprint = Eypay::Fingerprint.new qpay_options
      qpay_options["RequestFingerprintOrder"] = fingerprint.order
      qpay_options["requestfingerprint"]      = fingerprint.fingerprint

      # generate form with hidden fields for request to qpay
      form_tag Rails.application.config.eypay.qpay_url, "method" => "post", "accept-charset" => "utf-8" do
        qpay_options.each do |field_name, value|
          concat hidden_field_tag field_name, value
        end
      end
    end
  end
end