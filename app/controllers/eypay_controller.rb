class EypayController < ApplicationController
  before_filter :validate_fingerprint, :only => [:success, :confirm]

  def confirm
    case params["paymentState"]
      when "SUCCESS"
        success
      when "CANCEL"
        cancel
      when "FAILURE"
        failure
    end

    render :nothing
  end

  def success
    Rails.logger.debug "===> Payment succeeded!"
    render :nothing
  end

  def failure
    Rails.logger.debug "===> Payment failed!"
    render :nothing
  end

  def cancel
    Rails.logger.debug "===> Payment canceled!"
    render :nothing
  end

  private

    def validate_fingerprint
      if Eypay::Fingerprint.verify_from_request(params)
        Rails.logger.debug "===> VALIDATED_PAYMENT: #{params}"
      else
        Rails.logger.debug "===> Payment verification failed!"
      end
    end

end
