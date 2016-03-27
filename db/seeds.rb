# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#Страны
countries = HTTParty.get('http://api.vk.com/method/database.getCountries', query: {v: '5.50', need_all: 1, count: 1000})
countries['response']['items'].each do |attrs|
  Country.create!(name: attrs['title'])
end

#Жанры
%w(Боевик Вестерн Детектив Драма Комедия Мелодрама Мистика Приключения Триллер Ужастик Фантастика Фэнтези).each{|name| Genre.create!(name: name)}

#Создание администратора
login = `whoami`.strip
email = "#{login}@campus.mephi.ru"
password = login * 2
User.create!(name: login, email: email, password: password, password_confirmation: password, role: 1)
