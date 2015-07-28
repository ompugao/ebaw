require 'magicshelf/baseconverter'
require 'magicshelf/exception'
require 'gepub'
require 'shellwords'

module MagicShelf
  class FileMoverError < Error; end

  class FileMover < BaseConverter
    attr_accessor :inputfile, :outputfile

    def enter(params, &block)
      MagicShelf.logger.debug('enter FileMover')
      raise MagicShelf::FileMoverError.new("inputfile is not set") if @inputfile == nil
      raise MagicShelf::FileMoverError.new("outputfile is not set") if @outputfile == nil

      super
    end

    def process(piped_params)
      FileUtils.mv(@inputfile, @outputfile)
      super
    end
  end
end

