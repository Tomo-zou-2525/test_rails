class Tag < ApplicationRecord
  has_many :board_tag_relations
  has_many :boards, through: :board_tag_relations
end
