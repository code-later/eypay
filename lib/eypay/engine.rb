module Eypay
  require "eypay"
  require "rails"
  class Engine < Rails::Engine
    config.eypay                    = ActiveSupport::OrderedOptions.new

    config.eypay.qpay_url           = "https://secure.wirecard-cee.com/qpay/init.php"
    config.eypay.qpay_toolkit_url   = "https://secure.wirecard-cee.com/qpay/toolkit.php"

    config.eypay.currency           = "EUR"
    config.eypay.language           = "de"
  end
end
