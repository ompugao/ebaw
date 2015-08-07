require 'magicshelf/exception'
require 'rmagick'

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
          img = Magick::Image.read(f).first
        rescue Magick::ImageMagickError, RuntimeError => ex
          MagicShelf.logger.info("#{f} is not an image file. skipped.")
        end
        if img.columns > img.rows
          img.rotate!(90)
          newfile = File.join(File.dirname(f), File.basename(f,'.*') + '_rotate' + File.extname(f))
          img.write(newfile)
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


