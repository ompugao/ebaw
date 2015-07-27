require 'ebaw/baseconverter'

module Ebaw
  class DirChangerError < Error; end

  class DirChanger < BaseConverter
    attr_accessor :workdir

    def enter(piped_params,&block)
      raise Ebaw::DirChangerError.new("workdir is not set") if @workdir == nil
      ret = nil
      Dir.chdir(@workdir) {|dir|
        Ebaw.logger.debug("DirChanger: chdir to #{dir}")
        ret = super
      }
      ret
    end
  end
end

