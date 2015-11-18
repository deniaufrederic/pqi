class User < ActiveRecord::Base
	validates :nom, 		presence: true,
							length: {maximum: 25}
	validates :prenom, 		presence: true,
							length: {maximum: 25}
	validates :identifiant, presence: true,
							length: {maximum: 25, minimum: 4},
							uniqueness: {case_sensitive: false}
	has_secure_password
	validates :password,	presence: true,
							length: {minimum: 6}
end
