require 'magicshelf/exception'
require 'magicshelf/baseconverter'
require 'open3'

module MagicShelf
  class KindleGenWrapperError < Error; end

  class KindleGenWrapper < BaseConverter
    attr_accessor :inputfile, :outputfile

    def enter(piped_params,&block)
      MagicShelf.logger.debug('enter KindleGenWrapper')

      # check parameters
      raise MagicShelf::KindleGenWrapperError.new("inputfile is not set") if @inputfile == nil
      raise MagicShelf::KindleGenWrapperError.new("outputfile is not set") if @outputfile == nil
      out, err, status = Open3.capture3("which kindlegen")
      if status.exitstatus != 0
        raise MagicShelf::KindleGenWrapperError.new("cannot execute kindlegen, is it on your PATH?")
      end

      super
    end

    def process(entered_params)
      out, err, status = Open3.capture3("kindlegen #{@inputfile} -o #{@outputfile}")
      if status.exitstatus != 0
        raise MagicShelf::KindleGenWrapperError.new("kindlegen exited with #{status.exitstatus}: \n" + out + "\n" + err)
      end

      super
    end

  end
end

