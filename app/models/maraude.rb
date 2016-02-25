class Maraude < ActiveRecord::Base
  has_and_belongs_to_many :intervenants

  accepts_nested_attributes_for :intervenants, reject_if: lambda { |a| a[:nom].blank? },
                                               allow_destroy: true

  before_save :get_intervenants
  
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

  private
    def get_intervenants
      self.intervenants = self.intervenants.collect do |interv|
        Intervenant.find_or_create_by(nom: interv.nom.split(' ').map(&:capitalize).join(' ').split('-').map(&:capitalize).join('-'))
      end
    end
end
