require 'ebaw/exception'
require 'ebaw/baseconverter'
require 'tmpdir'

module Ebaw
  class TempDirOpenerError < Error; end

  class TempDirOpener < BaseConverter
    def enter(params,&block)
      Dir.mktmpdir("ebaw_tempdir") {|dir|
        params[:workdir] = dir
        super
      }
    end
  end
end
