require 'magicshelf/exception'
require 'open3'

module MagicShelf
  class KindleGenWrapperError < Error; end

  class KindleGenWrapper
    attr_accessor :inputfile, :outputfile, :compression, :verbose

    def initialize
      @compression = "-c2"
      @verbose = true
    end

    def enter()
      MagicShelf.logger.debug('enter KindleGenWrapper')

      # check parameters
      raise MagicShelf::KindleGenWrapperError.new("inputfile is not set") if @inputfile == nil
      raise MagicShelf::KindleGenWrapperError.new("outputfile is not set") if @outputfile == nil
      out, err, status = Open3.capture3("which kindlegen")
      if status.exitstatus != 0
        raise MagicShelf::KindleGenWrapperError.new("cannot execute kindlegen, is it on your PATH?")
      end

      yield
    end

    def process()
      out, err, status = Open3.capture3("kindlegen #{@inputfile} #{@compression} #{"-verbose" if @verbose} -o #{@outputfile}")
      if status.exitstatus != 0
        raise MagicShelf::KindleGenWrapperError.new("kindlegen exited with #{status.exitstatus}: \n" + out + "\n" + err)
      end
    end

  end
end

