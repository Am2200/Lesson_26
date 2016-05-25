#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
  db = SQLite3::Database.new 'barbershop.db'
  db.execute 'CREATE TABLE IF NOT EXISTS Users
              (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT,
                phone TEXT,
                datestamp TEXT,
                barber TEXT,
                color TEXT
              )'
   if !db.execute 'CREATE TABLE IF NOT EXISTS Barbers
              (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT
              )'
      mas = ['Walter White', 'Jessie Pinkman', 'Gus Fring', 'Mike Ehrmantraut']
      mas.length.times do |i|
        db.execute 'INSERT INTO Barbers (name) VALUES (?)', [mas[i]]
      end

     end
end

before do
  db = get_db
  @barbers = db.execute 'select * from Barbers'
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

get '/showusers' do
  db = get_db
  @row = db.execute 'SELECT * FROM Users ORDER BY id desc'
  erb :showusers
end

post '/visit' do

  @username = params[:username]
  @phone    = params[:phone]
  @dateTime = params[:date_time]
  @email    = params[:email]
  @barber   = params[:barber]
  @color    = params[:color]

  hh = {
      :username   => 'Please, enter your name',
      :phone      => 'Please, enter your phone',
      :date_time  => 'Please, enter date and time',
      :email      => 'Please, enter your email'
  }

  @error = hh.select {|key,_| params[key] == ''}.values.join(', ')
  p @barber
  if @error != ''
    return erb :visit
  end

  db = get_db
  db.execute 'INSERT INTO Users (username, phone, datestamp, barber, color) VALUES (?,?,?,?,?)', [@username, @phone, @dateTime, @barber, @color]


  erb '<h4>You are registered! We will call you later!</h4>'
end

post '/contacts' do
  erb params[:mail]
end


def get_db
  return SQLite3::Database.new 'barbershop.db'
end