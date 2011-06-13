module EypayHelper
  def hidden_fields_for_qpay(params, specific_params = {})
    # collect required informations for the qpay request
    qpay_options = {
      "customerId"          => Rails.application.config.eypay.customer_id,
      "successURL"          => Rails.application.config.eypay.success_url,
      "failureURL"          => Rails.application.config.eypay.failure_url,
      "cancelURL"           => Rails.application.config.eypay.cancel_url,
      "serviceURL"          => Rails.application.config.eypay.service_url,
      "imageURL"            => Rails.application.config.eypay.logo_url,
      "amount"              => params[:amount],
      "currency"            => Rails.application.config.eypay.currency,
      "language"            => Rails.application.config.eypay.language,
      "orderDescription"    => params[:description],
      "displayText"         => params[:text],
      "paymenttype"         => params[:payment_type]
    }.merge(specific_params)

    if Rails.application.config.eypay.confirm_url
      qpay_options["confirmURL"] = Rails.application.config.eypay.confirm_url
    end

    # generate request fingerprint
    fingerprint = Eypay::Fingerprint.new qpay_options
    qpay_options["RequestFingerprintOrder"] = fingerprint.order
    qpay_options["requestfingerprint"]      = fingerprint.fingerprint

    # generate hidden fields for request to qpay
    qpay_options.each do |field_name, value|
      concat hidden_field_tag field_name, value
    end
  end
end
