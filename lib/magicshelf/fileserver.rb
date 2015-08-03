require 'sinatra/base'
require 'sinatra/config_file'
require 'sinatra/reloader'
require 'tilt/erb'

module MagicShelf
  class FileServer < Sinatra::Application
    register Sinatra::ConfigFile
    configure :development do
      register Sinatra::Reloader
    end

    set :root, File.join(File.dirname(__FILE__), '../..') #set :views, File.join(File.dirname(__FILE__), '../..', 'views')
    set :bind, '0.0.0.0'
    config_file 'server_config.yml'

    get '/' do
      settings.page_title
    end

    get '/files/*' do |path|
      sort_type = params['sort_by'] || "title"
      files = Dir.glob(File.join(settings.library_directory, '*'))
      case sort_type
      when 'title'
        files = files.sort
      when 'title_reverse'
        files = files.sort.reverse
      when 'date'
        files = files.sort_by{ |f| File.mtime(f) }
      when 'date_reverse'
        files = files.sort_by{ |f| File.mtime(f) }.reverse
      else
      end
      files_withmtime = files.map do |f|
        [f, File.mtime(f).strftime("%Y/%m/%d %H:%M:%S")]
      end
      erb :index, :locals => {:page_title => settings.page_title, :files_withmtime => files_withmtime}

    end

    run! if app_file == $0
  end
end

