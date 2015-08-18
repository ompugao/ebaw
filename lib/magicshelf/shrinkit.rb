require 'magicshelf/exception'
require 'mini_magick'

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
          img = MiniMagick::Image.open(f)
        rescue MiniMagick::Error, RuntimeError => ex
          MagicShelf.logger.info("#{f} is not an image file. skipped.")
        end
        next if img.nil?
        #NOTE img.type => "JPEG"
        if img.type == "JPEG"
          option = "jpeg:size=#{@resolution[0]}x#{@resolution[1]}"
          MagicShelf.logger.debug("#{f} is jpeg, add define option '#{option}'")
          img.define(option)
        end
        newfile = File.join(File.dirname(f), File.basename(f,'.*') + '-shrink' + File.extname(f))
        img.resize("#{@resolution[0]}x#{@resolution[1]}").write(newfile)
        MagicShelf.logger.info("#{f} is shrinked and saved to #{newfile}.")
        if @erase_original
          FileUtils.remove(f) 
          MagicShelf.logger.info("#{f} is erased.")
        end
      end
    end
  end
end


