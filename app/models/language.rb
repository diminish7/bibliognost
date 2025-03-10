class Language < ApplicationRecord
  include HasExternalIdentifier

  validates :name, presence: true, uniqueness: true
end
