require 'magicshelf/exception'
require 'gepub'
require 'shellwords'

module MagicShelf
  class FileMoverError < Error; end

  class FileMover
    attr_accessor :inputfile, :outputfile

    def enter()
      MagicShelf.logger.debug('enter FileMover')
      raise MagicShelf::FileMoverError.new("inputfile is not set") if @inputfile == nil
      raise MagicShelf::FileMoverError.new("outputfile is not set") if @outputfile == nil

      yield
    end

    def process()
      FileUtils.mv(@inputfile, @outputfile)
    end
  end
end

