#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
  @db = SQLite3::Database.new 'barbershop.db'
  @db.execute 'CREATE TABLE IF NOT EXISTS USERS
              (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT,
                phone TEXT,
                datestamp TEXT,
                barber TEXT,
                color TEXT
              )'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"
end

get '/about' do
  @error = 'Something wrong'
  erb :about
end

get '/visit' do
  erb :visit
end

get '/contacts' do
  @myFile = File.open './public/contacts.txt', 'r'
  erb :contacts
end

post '/visit' do

  @username = params[:username]
  @phone    = params[:phone]
  @dateTime = params[:date_time]
  @email    = params[:email]
  @barber   = params[:barber]

  hh = {
      :username   => 'Please, enter your name',
      :phone      => 'Please, enter your phone',
      :date_time  => 'Please, enter date and time',
      :email      => 'Please, enter your email'
  }

  @error = hh.select {|key,_| params[key] == ''}.values.join(', ')

  if @error != ''
    return erb :visit
  end

  #hh.each do |key,value|
   # if params[key] == ''
    #  @error = value
     # return erb :visit
    #end
  #end

  myFile = File.open './public/contacts.txt', 'a'
  myFile.write "User: <i>#{params[:username]}</i>, Phone: <i>#{params[:phone]}</i>, Email: <i>#{params[:email]}</i>, Date: <i>#{params[:date_time]}</i>, The hairdresser: <i>#{params[:barber]}</i> , color: <i>#{params[:color]}</i>\n"
  myFile.close

  erb '<h4>You are registered! We will call you later!</h4>'
end

post '/contacts' do
  erb params[:mail]
end


