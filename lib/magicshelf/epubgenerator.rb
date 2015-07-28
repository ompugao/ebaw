require 'magicshelf/exception'
require 'magicshelf/baseconverter'
require 'gepub'
require 'shellwords'

module MagicShelf
  class EpubGeneratorError < Error; end

  # create a epub file with the file under the current directory
  class EpubGenerator < BaseConverter
    attr_accessor :book_type, :title, :outputfile, :language, :identifier_url, :creator, :creator_en

    def enter(piped_params,&block)
      MagicShelf.logger.debug('enter EpubGenerator')
      # check parameters
      raise MagicShelf::EpubGeneratorError.new("@title is not set") if @title == nil
      raise MagicShelf::EpubGeneratorError.new("@outputfile is not set") if @outputfile == nil
      # default parameters
      @book_type      ||= 'comic'
      @language       ||= 'ja'
      @identifier_url ||= 'http:/example.jp/bookid_in_url'

      super
    end

    def process(entered_params)
      epubname = @outputfile

      book = GEPUB::Book.new
      book.unique_identifier @identifier_url
      book.identifier @identifier_url
      book.language = @language


      book.add_title(@title, nil, GEPUB::TITLE_TYPE::MAIN) { |title|
        title.lang = @language
        title.file_as = Shellwords.escape(@title)
        title.display_seq = 1
      }
      if @creator
        book.add_creator(@creator) { |creator|
          creator.display_seq = 1
          creator.add_alternates('en' => @creator_en) if @creator_en
        }
      end

      if @book_type == "comic"
        book.page_progression_direction = 'rtl'
        metadata = book.instance_eval{@package}.instance_eval{@metadata}
        metacomic = metadata.add_metadata('meta', '')
        metacomic['name'] = 'book-type'
        metacomic['content'] = 'comic'
        metafixedlayout = metadata.add_metadata('meta', '')
        metafixedlayout['name'] = 'fixed-layout'
        metafixedlayout['content'] = 'true'
      end
      
      # within ordered block, add_item will be added to spine.
      book.ordered {
        # to add nav file:
        #navpath = 'nav.xhtml'
        #book.add_item(navpath).add_content(File.open(navpath)).add_property('nav')
        Dir.glob('**/*.{jpg,png}').each_with_index do |filepath,index|
          item = book.add_item(filepath)
          item.add_content(File.open(filepath)).toc_text(index.to_s)
          item.cover_image if index == 0
        end
      }

      book.generate_epub(epubname)

      super
    end

  end
end
