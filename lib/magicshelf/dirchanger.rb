require 'magicshelf/baseconverter'

module MagicShelf
  class DirChangerError < Error; end

  class DirChanger < BaseConverter
    attr_accessor :workdir

    def enter(piped_params,&block)
      raise MagicShelf::DirChangerError.new("workdir is not set") if @workdir == nil
      ret = nil
      Dir.chdir(@workdir) {|dir|
        MagicShelf.logger.debug("DirChanger: chdir to #{dir}")
        ret = super
      }
      ret
    end
  end
end

