class Maraude < ActiveRecord::Base
  validates :date, 	presence: true,
  					uniqueness: true
end
