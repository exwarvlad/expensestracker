class Currency < ApplicationRecord
  belongs_to :expense, polymorphic: true, optional: true
  belongs_to :filter, polymorphic: true, optional: true

  enum name: [ :dollar, :euro, :rub, :grn, :bitcoin ]
end
