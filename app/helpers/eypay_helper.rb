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

    extend_qpay_options_with_fingerprint(qpay_options)
    generate_hidden_fields_for_request_to_qpay(qpay_options)
  end

  def hidden_fields_for_qpay_toolkit(params, specific_params = {})
    # collect required informations for the qpay request
    qpay_options = {
      "customerId"          => Rails.application.config.eypay.customer_id,
      "toolkitPassword"     => Rails.application.config.eypay.toolkit_password,
      "language"            => Rails.application.config.eypay.language
    }.merge(specific_params)

    toolkit = Eypay::Toolkit.new(params)
    qpay_options.merge(toolkit.params)

    extend_qpay_options_with_fingerprint(qpay_options, toolkit.fingerprint_order)
    generate_hidden_fields_for_request_to_qpay(qpay_options)
  end

  private

    def extend_qpay_options_with_fingerprint(qpay_options, fingerprint_order)
      if fingerprint_order.present?
        fingerprint = Eypay::Fingerprint.new qpay_options, nil, fingerprint_order
      else
        fingerprint = Eypay::Fingerprint.new qpay_options
      end

      qpay_options["RequestFingerprintOrder"] = fingerprint.order
      qpay_options["requestfingerprint"]      = fingerprint.fingerprint
    end

    def generate_hidden_fields_for_request_to_qpay(qpay_options)
      qpay_options.each do |field_name, value|
        concat hidden_field_tag field_name, value
      end
    end
end
