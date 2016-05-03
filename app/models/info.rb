class Info < ActiveRecord::Base
  belongs_to :term
  default_scope -> { order(weight: :desc) }

end
