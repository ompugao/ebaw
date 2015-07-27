require 'ebaw/baseconverter'
require 'ebaw/exception'
require 'gepub'
require 'shellwords'

module Ebaw
  class FileMoverError < Error; end

  class FileMover < BaseConverter
    attr_accessor :inputfile, :outputfile

    def enter(params, &block)
      Ebaw.logger.debug('enter FileMover')
      raise Ebaw::FileMoverError.new("inputfile is not set") if @inputfile == nil
      raise Ebaw::FileMoverError.new("outputfile is not set") if @outputfile == nil

      super
    end

    def process(piped_params)
      FileUtils.mv(@inputfile, @outputfile)
      super
    end
  end
end

