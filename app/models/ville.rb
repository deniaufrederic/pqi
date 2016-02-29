class Ville < ActiveRecord::Base
  validates :nom, presence: true, uniqueness: {case_sensitive: false}
end