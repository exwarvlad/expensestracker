class Currency < ApplicationRecord
  belongs_to :filter, polymorphic: true, optional: true

  enum name: [ :usd, :eur, :rur, :grn, :btc ]

  validates :name, inclusion: { in: names.keys }
end
