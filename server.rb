# server.rb
require 'sinatra'
require 'sinatra/activerecord'

Dir["#{__dir__}/models/*.rb"].each { |file| require_relative file }
Dir["#{__dir__}/routes/*.rb"].each { |file| require_relative file }

set :root, __dir__
set :database, "sqlite3:fshopdb.sqlite3"

enable :sessions

