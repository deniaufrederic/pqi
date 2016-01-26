class Maraude < ActiveRecord::Base
  default_scope -> { order(date: :desc) }
  validates :date, 	presence: true,
  					uniqueness: { scope: :type_maraude }
end
