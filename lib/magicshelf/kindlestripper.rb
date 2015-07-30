require 'magicshelf/exception'
require 'magicshelf/kindlestrip'

module MagicShelf
  class KindleStripperError < Error; end

  class KindleStripper
    attr_accessor :inputfile, :outputfile

    def enter()
      MagicShelf.logger.debug('enter KindleStripper')

      # check parameters
      raise MagicShelf::EpubGeneratorError.new("inputfile is not set") if @inputfile == nil
      raise MagicShelf::EpubGeneratorError.new("outputfile is not set") if @outputfile == nil

      yield
    end

    def process()
      stripped_file = SectionStripper.strip(@inputfile, @outputfile)
    end

  end
end
