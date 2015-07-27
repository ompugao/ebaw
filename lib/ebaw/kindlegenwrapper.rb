require 'ebaw/exception'
require 'ebaw/baseconverter'
require 'open3'

module Ebaw
  class KindleGenWrapperError < Error; end

  class KindleGenWrapper < BaseConverter
    attr_accessor :inputfile, :outputfile

    def enter(piped_params,&block)
      Ebaw.logger.debug('enter KindleGenWrapper')

      # check parameters
      raise Ebaw::KindleGenWrapperError.new("inputfile is not set") if @inputfile == nil
      raise Ebaw::KindleGenWrapperError.new("outputfile is not set") if @outputfile == nil
      out, err, status = Open3.capture3("which kindlegen")
      if status.exitstatus != 0
        raise Ebaw::KindleGenWrapperError.new("cannot execute kindlegen, is it on your PATH?")
      end

      super
    end

    def process(entered_params)
      out, err, status = Open3.capture3("kindlegen #{@inputfile} -o #{@outputfile}")
      if status.exitstatus != 0
        raise Ebaw::KindleGenWrapperError.new("kindlegen did not exit with 0: \n" + out + "\n" + err)
      end

      super
    end

  end
end

