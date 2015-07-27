require 'ebaw/baseconverter'

module Ebaw
  class ZipExtractor < BaseConverter
    attr_accessor :extraction_dir
    def enter(params,&block)
      
      super
    end

    def process(params)
      params[:inputfile]
      super
    end

  end
end
