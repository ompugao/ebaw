#web: bundle exec rackup -p 4567 -o 0.0.0.0
web:thin -R config.ru -a 0.0.0.0 -p 4567 --prefix /magicshelf start 
resque: QUEUE=* bundle exec rake resque:work
#redisserver: redis-server
#resque-web: resque-web --foreground
