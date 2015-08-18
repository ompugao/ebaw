require 'magicshelf/exception'
require 'rmagick'

module MagicShelf
  class ShrinkItError < Error; end

  class ShrinkIt
    attr_accessor :workdir, :erase_original, :resolution
    def initialize()
      @erase_original = true
      @resolution = [1072, 1448] #[width, height], default is based on kindle paperwhite 2015
    end

    def enter()
      yield
    end

    def process()
      @workdir ||= Dir.pwd
      Dir.glob(File.join(@workdir,'**/*')).select{|f|File.file?(f)}.each do |f|
        begin
          img = Magick::Image.read(f).first
        rescue Magick::ImageMagickError, RuntimeError => ex
          MagicShelf.logger.info("#{f} is not an image file. skipped.")
        end
        next if img.nil?

        newfile = File.join(File.dirname(f), File.basename(f,'.*') + '-shrink' + File.extname(f))
        img.resize_to_fit(@resolution[0], @resolution[1]).write(newfile)
        MagicShelf.logger.info("#{f} is shrinked and saved to #{newfile}.")
        if @erase_original
          FileUtils.remove(f) 
          MagicShelf.logger.info("#{f} is erased.")
        end
      end
    end
  end
end


