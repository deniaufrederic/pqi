class Maraude < ActiveRecord::Base
  default_scope -> { order(date: :desc) }
  validates :date, 	presence: true,
  					uniqueness: { scope: :type_maraude }

  	def self.search(search)
      if search
        if Rails.env.production?
          where("date ILIKE ? OR type_maraude ILIKE? OR villes ILIKE?", "%#{search}%", "%#{search}%", "%#{search}%") 
        else
          where("date LIKE ? OR type_maraude LIKE? OR villes LIKE?", "%#{search}%", "%#{search}%", "%#{search}%")
        end
      else
        scoped
      end
    end
end
