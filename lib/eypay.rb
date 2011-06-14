require "eypay/version"

module Eypay
  require 'eypay/engine' if defined?(Rails)
  require 'eypay/fingerprint'
  require 'eypay/toolkit'
end
