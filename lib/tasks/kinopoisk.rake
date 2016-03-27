#http://stackoverflow.com/questions/29649213/ruby-mechanize-how-to-parse-the-site-response-before-mechanize-parses-it
class MyParser
  def self.parse(thing, url = nil, encoding = nil, options = Nokogiri::XML::ParseOptions::DEFAULT_HTML, &block)
    thing = thing.gsub(/\x00/, "")
    Nokogiri::HTML::Document.parse(thing, url, encoding, options, &block)
  end
end

def create_person(agent, link)
  person_page = agent.click link
  name = person_page.search("#headerPeople [itemprop='name']")[0].text
  origin_name = person_page.search("#headerPeople span[itemprop='alternativeHeadline']")[0].try(:text)
  birthday_node = person_page.search(".birth")[0]
  begin
    birthday = Date.parse(birthday_node.attr('birthdate'))
  rescue
    birthday = nil
  end

  puts "IMPORT PERSON #{name}"

  img = person_page.search("#photoBlock img")[0]
  avatar_url = img.attr('src') if img
  p=Person.where(name: name, origin_name: origin_name, birthday: birthday).first_or_initialize
  p.avatar = open(avatar_url) if avatar_url.present?
  p.save!
  p
end

def create_film(agent, link)
  film_page = agent.click link
  name = film_page.search("#headerFilm .moviename-big")[0].text
  origin_name = film_page.search("#headerFilm span[itemprop='alternativeHeadline']")[0].try(:text)
  slogan = film_page.search("td.type:contains('слоган')")[0].next.text
  slogan = nil if slogan =~ /\A\-/
  length = film_page.search('#runtime')
  length = length.text.match(/(\d+)\s* мин/)[1].to_i if length

  year = film_page.search("#infoTable td.type:contains('год')")[0].next.next.search('a')[0].try(:text)
  year = year =~ /\A\-/ ? nil : year.to_i

  description = film_page.search(".brand_words[itemprop='description']")[0].try(:text)

  puts "IMPORT FILM #{name}"


  country_name = film_page.search(".movieFlags .flag")[0]
  country_name = country_name.attr('title') if country_name
  country = Country.where(name: country_name).first_or_create

  genre_name = film_page.search("span[itemprop='genre'] a")[0]
  genre_name = genre_name.text.mb_chars.capitalize.to_s
  genre = Genre.where(name: genre_name).first_or_create

  img = film_page.search("#photoBlock a img")[0]
  cover_url = img.attr('src') if img

  film = Film.where(name: name, origin_name: origin_name, year: year).first_or_initialize
  film.attributes = {country: country, genre: genre, description: description, length: length, slogan: slogan}
  film.cover = open(cover_url)


  director_link = film_page.at("[itemprop='director'] a")

  director = director_link ? create_person(agent, director_link) : nil

  film.director = director

  film_page.search("#actorList ul:first li a").each do |person_link|
    if person_link.attr('href') =~ /\/name\//
      p = create_person(agent, person_link)
      film.people << p unless film.people.include?(p)
    end
  end
  film.save!
end

namespace :kinopoisk do
  task :import => :environment do
    agent = Mechanize.new
    agent.html_parser = MyParser
    host = "http://www.kinopoisk.ru"
    agent.get "#{host}/box/" do |box_page|
      box_page.search("a.continue[href^='/film/'],a.all[href^='/film/']").each do |film_link|
        create_film(agent, film_link)
      end
    end
  end
end
