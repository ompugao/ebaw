require 'resque'
require 'redis'
require 'magicshelf'
require 'magicshelf/executionpipe'

module MagicShelf
  module MobiTask
    @queue = :default

    # Runs a subprocess and applies handlers for stdout and stderr
    # TODO make this function to a redis task and run it background
    # Params:
    # +inputfile+:: must be fullpath to the input file
    # +title+:: book title
    # +booktype+:: book type: must be one of ["comic", "novelimage", "novel", "ltr"]
    # +outputfile+:: must be fullpath to the output file
    def self.perform(params)
      inputfile = params['inputfile']
      title = params['title']
      author = params['author']
      booktype = params['booktype']
      outputfile = params['outputfile']
      MagicShelf.logger.info("generate_mobi with params: #{params}")

      MagicShelf::ExecutionPipe.new.enter { |params,&block|
        Dir.mktmpdir("magicshelf") do |dir|
          params[:workdir] = dir
          block.call
        end
      }.pipe(MagicShelf::FileExtractor.new,:workdir => [:destdir]) { |this|
        this.inputfile = File.expand_path(inputfile)
      }.enter(:destdir => [:workdir]) {|params, &block|
        Dir.chdir(params[:workdir]) do
          block.call
        end
      }.pipe(MagicShelf::DirRenamer.new, :workdir => [:workdir]) { |this|
      }.pipe(MagicShelf::FileNameValidator.new, :workdir => [:workdir]) { |this|
      }.pipe(MagicShelf::MakeItVertical.new, :workdir => [:workdir]) { |this|
      }.pipe(MagicShelf::EpubGenerator.new, :workdir => [:workdir]) { |this|
        this.title      = title
        this.creator    = author
        this.book_type  = booktype
        this.outputfile = 'test.epub'
      }.pipe(MagicShelf::KindleGenWrapper.new, :outputfile => [:inputfile]) { |this|
        this.outputfile = 'test.mobi'
      }.process(:inputfile => [:file,:inputfile], :outputfile => [:outputfile]) { |params|
        FileUtils.remove(params[:file])
      }.pipe(MagicShelf::KindleStripper.new, :outputfile => [:inputfile]) { |this|
        this.outputfile = File.expand_path('test_strip.mobi')
      }.pipe(MagicShelf::FileCleaner.new, :inputfile => [:file], :outputfile => [:outputfile]) { |this|
      }.pipe(MagicShelf::FileMover.new, :outputfile => [:inputfile]) { |this|
        this.outputfile = File.expand_path(outputfile)
      }.execute

    end
  end
end

