require 'magicshelf/exception'

module MagicShelf
  class DirChangerError < Error; end

  class DirChanger
    attr_accessor :workdir

    def enter()
      raise MagicShelf::DirChangerError.new("workdir is not set") if @workdir == nil
      Dir.chdir(@workdir) {|dir|
        MagicShelf.logger.debug("DirChanger: chdir to #{dir}")
        yield
      }
    end

    def process()
    end

  end
end

