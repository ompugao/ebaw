require 'magicshelf/exception'
require 'magicshelf/baseconverter'
require 'tmpdir'

module MagicShelf
  class TempDirOpenerError < Error; end

  class TempDirOpener < BaseConverter
    def enter(params,&block)
      Dir.mktmpdir("magicshelf_tempdir") {|dir|
        @workdir = dir
        super
      }
    end
  end
end
