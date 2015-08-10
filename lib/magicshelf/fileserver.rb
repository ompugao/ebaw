require 'sinatra/base'
require 'sinatra/config_file'
require 'sinatra/reloader'
require 'tilt/erb'
require 'redis'
require 'magicshelf/mobitask'

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
      redirect to("/files/", false), 303
    end

    get '/files/*' do |path|
      sort_type = params['sort_by'] || "title"
      files = []
      Dir.chdir(settings.library_directory) {
        files = Dir.glob(File.join('.',path, '*'))
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
          fname = (f.start_with?('./') ? f[2..-1] : f)
          [fname, File.mtime(f).strftime("%Y/%m/%d %H:%M:%S")]
        end
        upperpath = nil
        upperpath = path.split('/')[0...-1].join('/') if path != ""
        erb :index, :locals => {:page_title => settings.page_title, :files_withmtime => files_withmtime, :path => path, :upperpath => upperpath, :sort_type => sort_type}
      }
    end

    get '/get_file/*' do |path|
      pass unless path # pass to a subsequent route
      send_file(File.join(settings.library_directory, path))
    end

    get '/get_file*' do
      'you come to this page without specifying the path to file. go back to the previous page!'
    end

    get '/generate_mobi/*' do |path|
      #path = params['splat'].first
      pass unless path # pass to a subsequent route

      erb :generate_mobi, :locals => {:page_title => settings.page_title, :library_directory => settings.library_directory, :path => path}
    end

    post '/generate_mobi/*' do |path|
      title      = params['title']
      author     = params['author']
      booktype   = params['booktype']
      outputfile = params['outputfile']
      outputfile = title + ".mobi" if outputfile.empty?

      taskparams = {}
      #taskparams.update(params)
      taskparams['title']      = params['title']
      taskparams['author']     = params['author']
      taskparams['booktype']   = params['booktype']
      taskparams['inputfile']  = File.join(settings.library_directory,path)
      taskparams['outputfile'] = File.join(settings.library_directory,File.dirname(path),outputfile)

      Resque.enqueue(MobiTask, taskparams)
      
      str = <<-EOF
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <title></title>
      </head>
      <body>
      Now generating mobi file. wait for a while. <br><a href="%s">Back to Top</a>
      </body>
      </html>
      EOF
      str % [url("/", false)]
    end

    get '/generate_mobi*' do |f|
      'you come to this page without specifying the path to file. go back to the previous page!'
    end

    run! if app_file == $0
  end
end

