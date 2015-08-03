require 'magicshelf/exception'

module MagicShelf
  class DirStructureFlattenerError < Error; end

  class DirStructureFlattener
    attr_accessor :workdir
    def enter()
      yield
    end

    def process()
      @workdir ||= Dir.pwd
      Dir.glob(File.join(@workdir,'**/*')).select{|f|File.file?(f)}.each do |f|
        begin
          FileUtils.mv f, @workdir
        rescue => e
          MagicShelf.logger.warn(e.message)
        end

      end
    end
  end
end

