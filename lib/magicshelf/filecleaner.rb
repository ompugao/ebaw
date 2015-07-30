require 'magicshelf/exception'

module MagicShelf
  class FileCleanerError < Error; end

  class FileCleaner
    attr_accessor :file

    def enter()
      #raise MagicShelf::FileCleanerError.new("workdir is not set") if @workdir == nil
      yield
    end

    def process()
      FileUtils.remove_file(@file)
    end
  end
end

