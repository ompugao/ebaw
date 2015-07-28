require 'ebaw/exception'
require 'ebaw/baseconverter'

module Ebaw
  class DirStructureFlattenerError < Error; end

  class DirStructureFlattener < BaseConverter
    attr_accessor :workdir
    def process(entered_params)
      @workdir ||= Dir.pwd
      Dir.glob(File.join(@workdir,'**/*')).select{|f|File.file?(f)}.each do |f|
        FileUtils.mv f, @workdir
      end
      super
    end
  end
end

