# encoding: utf-8

module Eypay
  class Toolkit
    attr_reader :params

    def initialize(params)
      @params = { "command" => params[:command] }
      determine_params_by_command(params)
    end

    private

      def determine_params_by_command(params)
        case params[:command]
          when "RecurPayment"
            determine_params_for_recur_payment(params)
        end
      end

      def determine_params_for_recur_payment(params)
        @params.merge!({
          "sourceOrderNumber"   => params[:source_order_number],
          "amount"              => params[:amount],
          "currency"            => Rails.application.config.eypay.currency,
          "orderDescription"    => params[:description]
        })
      end
  end
end
