require 'magicshelf/exception'

module MagicShelf
  class FileNameValidatorError < Error; end

  class FileNameValidator
    attr_accessor :workdir
    def initialize()
      @erase_original = true
    end

    def enter()
      yield
    end

    def process()
      @workdir ||= Dir.pwd
      Dir.glob(File.join(@workdir,'**/*')).select{|f|File.file?(f)}.each do |f|
        dirname = File.dirname(f)
        basename = File.basename(f,'.*')
        extname = File.extname(f)
        newbasename = basename.gsub(/#/, '_').gsub(/\+/, '_')
        if not (basename == newbasename)
          newfilename = File.join(dirname, newbasename + extname)
          FileUtils.mv(f, newfilename)
          MagicShelf.logger.info("move #{f} to #{newfilename}.")
        end
      end
    end
  end
end
