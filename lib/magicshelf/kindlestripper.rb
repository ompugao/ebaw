require 'magicshelf/exception'
require 'magicshelf/baseconverter'
require 'magicshelf/kindlestrip'

module MagicShelf
  class KindleStripperError < Error; end

  class KindleStripper < BaseConverter
    attr_accessor :inputfile, :outputfile

    def enter(piped_params,&block)
      MagicShelf.logger.debug('enter KindleStripper')

      # check parameters
      raise MagicShelf::EpubGeneratorError.new("inputfile is not set") if @inputfile == nil
      raise MagicShelf::EpubGeneratorError.new("outputfile is not set") if @outputfile == nil

      super
    end

    def process(entered_params)
      stripped_file = SectionStripper.strip(@inputfile, @outputfile)

      super
    end

  end
end
