require './lib/magicshelf/fileserver'
require 'resque/server'

run Rack::URLMap.new \
  "/"       => MagicShelf::FileServer,
  "/resque" => Resque::Server.new
