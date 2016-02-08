class Maraude < ActiveRecord::Base
  default_scope -> { order(date: :desc) }
  validates :date, 	presence: true,
  					        uniqueness: { scope: :type_maraude }
  validates :type_maraude, presence: true

  	def self.search(search)
      if search
        if Rails.env.production?
          where("to_char(maraudes.date, 'DD/MM/YY') ILIKE ? OR maraudes.type_maraude ILIKE? OR maraudes.villes ILIKE?", "%#{search}%", "%#{search}%", "%#{search}%") 
        else
          where("date LIKE ? OR type_maraude LIKE? OR villes LIKE?", "%#{search}%", "%#{search}%", "%#{search}%")
        end
      else
        scoped
      end
    end
end
