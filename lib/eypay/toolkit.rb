# encoding: utf-8

module Eypay
  class Toolkit
    attr_reader :options
    attr_reader :fingerprint_order

    def initialize(qpay_options, params)
      @options = qpay_options
      determine_toolkit_options_by_command(params)
    end

    private

      def determine_toolkit_options_by_command(params)
        case params[:command]
          when "RecurPayment"
            determine_toolkit_options_for_recur_payment(params)
        end
      end

      def determine_toolkit_options_for_recur_payment(params)
        @options.merge!({
          "command"             => params[:command],
          "sourceOrderNumber"   => params[:source_order_number],
          "amount"              => params[:amount],
          "currency"            => Rails.application.config.eypay.currency,
          "orderDescription"    => params[:description]
        })

        @fingerprint_order = %w{
          customerId
          toolkitPassword
          secret
          command
          language
          sourceOrderNumber
          orderDescription
          amount
          currency
        }
      end
  end
end
