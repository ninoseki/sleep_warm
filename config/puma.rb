preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 9292
environment ENV['RACK_ENV'] || 'development'
