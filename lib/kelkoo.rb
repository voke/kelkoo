require 'logger'

require 'kelkoo/version'
require 'kelkoo/configuration'
require 'kelkoo/request'
require 'kelkoo/resource'
require 'kelkoo/product'
require 'kelkoo/product_response'
require 'kelkoo/image'
require 'kelkoo/refinement'
require 'kelkoo/store'

module Kelkoo

  def self.configure
    yield config
  end

  def self.config
    @config ||= Kelkoo::Configuration.new
  end

  def self.logger
    @logger ||= Logger.new($stdout).tap do |x|
      x.progname = 'Kelkoo'
    end
  end

end
