require 'magicshelf/exception'

module MagicShelf
  class DirRenamerError < Error; end

  class DirRenamer
    attr_accessor :workdir
    def enter()
      yield
    end

    def process()
      @workdir ||= Dir.pwd
      rename_dir_recursively(@workdir)
    end

    def rename_dir_recursively(path)
        Dir.chdir(path) {
          Dir['./*'].select{|f|File.directory?(f)}.each.with_index { |f,index|
            if File.directory?(f)
              rename_dir_recursively(f)
              FileUtils.mv(f, index.to_s)
            end
          }
        }
    end
  end
end


