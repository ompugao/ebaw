require 'magicshelf/baseconverter'

module MagicShelf
  class FileCleanerError < Error; end

  class FileCleaner < BaseConverter
    attr_accessor :file

    def enter(piped_params,&block)
      #raise MagicShelf::FileCleanerError.new("workdir is not set") if @workdir == nil
      super
    end

    def process(piped_params)
      FileUtils.remove_file(@file)
      super
    end
  end
end

