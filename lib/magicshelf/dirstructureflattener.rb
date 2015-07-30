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
        FileUtils.mv f, @workdir
      end
    end
  end
end

