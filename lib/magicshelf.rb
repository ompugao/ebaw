require 'rubygems'
require "magicshelf/version"

require "magicshelf/dirchanger"
require "magicshelf/dirrenamer"
require "magicshelf/dirstructureflattener"
require "magicshelf/epubgenerator"
require "magicshelf/executionpipe"
require "magicshelf/filecleaner"
require "magicshelf/fileextractor"
require "magicshelf/filemover"
require "magicshelf/filenamevalidator"
require "magicshelf/fileserver"
require "magicshelf/kindlegenwrapper"
require "magicshelf/kindlestripper"
require "magicshelf/makeitvertical"
require "magicshelf/shrinkit"
require "magicshelf/tempdiropener"


Dir.glob('monkeypatches/*') do |f|
  require f
end

require 'logger'

module MagicShelf
  (class << self; self end).module_eval do
    attr_accessor :logger
  end
end

MagicShelf.logger = Logger.new(STDOUT)

