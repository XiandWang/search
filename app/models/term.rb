class Term < ActiveRecord::Base
	has_many :infos, dependent: :destroy
end
