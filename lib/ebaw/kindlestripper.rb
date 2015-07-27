require 'ebaw/exception'
require 'ebaw/baseconverter'
require 'ebaw/kindlestrip'

module Ebaw
  class KindleStripperError < Error; end

  class KindleStripper < BaseConverter
    attr_accessor :inputfile, :outputfile

    def enter(piped_params,&block)
      Ebaw.logger.debug('enter KindleStripper')

      # check parameters
      raise Ebaw::EpubGeneratorError.new("inputfile is not set") if @inputfile == nil
      raise Ebaw::EpubGeneratorError.new("outputfile is not set") if @outputfile == nil

      super
    end

    def process(entered_params)
      stripped_file = SectionStripper.strip(@inputfile, @outputfile)

      super
    end

  end
end
