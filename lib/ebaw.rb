require 'rubygems'
require "ebaw/version"

require "ebaw/dirchanger"
require "ebaw/epubgenerator"
require "ebaw/filecleaner"
require "ebaw/filemover"
require "ebaw/kindlegenwrapper"
require "ebaw/kindlestripper"
require "ebaw/tempdiropener"
require "ebaw/zipextractor"

require 'logger'

module Ebaw
  (class << self; self end).module_eval do
    attr_accessor :logger
  end
end

Ebaw.logger = Logger.new(STDOUT)

