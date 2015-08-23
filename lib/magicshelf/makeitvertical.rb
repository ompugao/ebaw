require 'magicshelf/exception'
require 'mini_magick'

module MagicShelf
  class MakeItVerticalError < Error; end

  class MakeItVertical
    attr_accessor :workdir, :erase_original
    def initialize()
      @erase_original = true
    end

    def enter()
      yield
    end

    def process()
      @workdir ||= Dir.pwd
      Dir.glob(File.join(@workdir,'**/*')).select{|f|File.file?(f)}.each do |f|
        begin
          img = MiniMagick::Image.open(f)
        rescue MiniMagick::Invalid, MiniMagick::Error, RuntimeError => ex
          MagicShelf.logger.info("#{f} is not an image file. skipped.")
        end
        next if img.nil?
        if img.width > img.height
          newfile = File.join(File.dirname(f), File.basename(f,'.*') + '-rotate' + File.extname(f))
          img.combine_options do |b|
            b.rotate(90)
          end.write(newfile)
          MagicShelf.logger.info("#{f} is rotated and saved to #{newfile}.")
          if @erase_original
            FileUtils.remove(f) 
            MagicShelf.logger.info("#{f} is erased.")
          end
        end
      end
    end
  end
end


