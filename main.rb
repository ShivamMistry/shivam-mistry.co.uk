require 'sinatra'
require 'redcarpet'
require 'slim'

configure do
  #enable :sessions
  set :environment, :production
end

helpers do
  def pages
    Hash[Dir['pages/*.md'].map {
        |page| [page.sub('pages/', '').sub('.md', ''), lambda { File.read(page) }] }]
  end

  def url page
    '/pages/' + page
  end
end

get('/styles/main.css') do
  send_file('public/main.css')
end

get('/public/:name') do
  send_file('public/' + params[:name])
end

get '/pages' do
  @pages = pages
  slim :index
end

get('/pages/:name') do
  begin
    @pages = pages
    @name = params[:name]
    @page = pages[@name].call
    slim :show
  rescue
    halt 404, 'Page not found'
  end
end

get '/' do
  redirect to 'pages/about'
end
