#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

@@allFilesCheck = 1

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
  myFile.write "User: <i>#{params[:username]}</i>, Phone: <i>#{params[:phone]}</i>, Email: <i id = '#{@@allFilesCheck}'>#{params[:email]}</i>, Date: <i>#{params[:date_time]}</i>, The hairdresser: <i>#{params[:hair]}</i> , color: <i>#{params[:color]}</i>\n"
  myFile.close
  @@allFilesCheck += 1
  erb '<h4>You are registered! We will call you later!</h4>'
end

post '/contacts' do
  erb params[:mail]
end


