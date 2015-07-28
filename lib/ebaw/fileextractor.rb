require 'ebaw/baseconverter'
require 'filemagic'
require 'zip'
require 'open3'

module Ebaw
  class FileExtractorError < Error; end

  class FileExtractor < BaseConverter
    attr_accessor :inputfile, :destdir

    def enter(params,&block)
      raise Ebaw::FileExtractorError.new("inputfile is not set") if @inputfile == nil
      mimetype = FileMagic.new(FileMagic::MAGIC_MIME_TYPE).file(@inputfile)
      raise Ebaw::FileExtractorError.new("unsupported filetype: #{mimetype}") if not %w{application/x-rar application/zip}.include?(mimetype)
      params[:mimetype] = mimetype
      
      super
    end

    def process(params)
      case params[:mimetype]
      when "application/zip"
        Zip::File.open(@inputfile) do |zip_file|
          zip_file.each do |entry|
            Ebaw.logger.info("Extracting #{entry.name} ...")
            entry.extract(File.join(@destdir,entry.name))
          end
        end
      when "application/x-rar"
        out, err, status = Open3.capture3("which unrar")
        if status.exitstatus != 0
          raise Ebaw::FileExtractorError.new("cannot execute unrar, is it on your PATH?")
        end
        
        out, err, status = Open3.capture3("unrar x #{@inputfile} #{@destdir}")
      else
        raise Ebaw::FileExtractorError.new("no way to extract file for the file with filetype: #{params[:mimetype]}")
      end

      params.delete :mimetype
      super
    end

  end
end
