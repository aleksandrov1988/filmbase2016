class Person < ActiveRecord::Base
  has_attached_file :avatar, styles: {medium: "250x250>", thumb: "100x100>"}


  validates :name, presence: true
  validate :check_birthday
  validates_attachment :avatar, content_type: {content_type: /\Aimage\/.*\z/}

  has_and_belongs_to_many :films, -> { ordering.base }
  has_many :produced_films, -> { ordering.base }, class_name: 'Film', foreign_key: :director_id

  scope :ordering, -> { (order(:name)) }
  scope :full, -> { includes(films: :genre, produced_films: :genre) }



  def self.edit_by?(u)
    u.try(:admin?)
  end

  def can_destroy?
    produced_films.blank? && films.blank?
  end

  def age(d = nil)
    d ||= Date.today
    return unless birthday
    res = d.year - birthday.year
    res -= 1 if Date.new(d.year, birthday.month, birthday.day) > d
    res
  end

  def human_age(d = nil)
    "#{age(d)} #{RuPropisju.choose_plural(age(d), 'год', 'года', 'лет')}"
  end

  def self.search(query)
    ordering.where("upper(name) like upper(:q) or upper(origin_name) like upper(:q)", q: "%#{query}%")
  end


  private
  def check_birthday
    errors.add(:birthday, :invalid) if birthday && birthday > Date.today
    true
  end
end
