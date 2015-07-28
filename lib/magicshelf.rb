require 'rubygems'
require "magicshelf/version"

require "magicshelf/dirchanger"
require "magicshelf/epubgenerator"
require "magicshelf/filecleaner"
require "magicshelf/filemover"
require "magicshelf/dirstructureflattener"
require "magicshelf/kindlegenwrapper"
require "magicshelf/kindlestripper"
require "magicshelf/tempdiropener"
require "magicshelf/fileextractor"

require 'logger'

module MagicShelf
  (class << self; self end).module_eval do
    attr_accessor :logger
  end
end

MagicShelf.logger = Logger.new(STDOUT)

