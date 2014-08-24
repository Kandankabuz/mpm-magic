#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'creature'
require_relative 'fight'
require_relative 'player'
require_relative 'world'
require_relative 'battle'
require_relative 'turn'
require_relative 'phase'
require_relative 'deck'

set :bind, '0.0.0.0'

set :views, Proc.new { File.join(root, "views") }

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

@@world = World.setup

get "/" do
  @world = @@world
  erb :home
end

get "/next" do
  @@world.turn.next!
  redirect "/"
end


get "/reset" do
  @@world = World.setup
  redirect "/"
end

get "/end" do
  @@world.turn.end!
  redirect "/"
end


get "/draw" do
  @@world.p1.draw!
  redirect "/"
end


get "/toggle/:card_id" do
  card  = Card.find(params[:card_id])
  card.toggle!
  redirect "/"
end

get "/play/:card_id" do
  card  = Card.find(params[:card_id])
  @@world.p1.play! card
  redirect "/"
end
