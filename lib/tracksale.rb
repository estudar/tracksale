require 'httparty'
require 'tracksale/configuration'
require 'tracksale/client'
require 'tracksale/campaign'

module Tracksale
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

