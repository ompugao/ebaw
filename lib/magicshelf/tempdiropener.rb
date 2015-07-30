require 'magicshelf/exception'
require 'tmpdir'

module MagicShelf
  class TempDirOpenerError < Error; end

  class TempDirOpener
    def enter
      Dir.mktmpdir("magicshelf_tempdir") {|dir|
        @workdir = dir
        yield
      }
    end
    
    def process
    end
  end
end
