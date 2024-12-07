module HasExternalIdentifier
  extend ActiveSupport::Concern

  included do
    validates :external_identifier, uniqueness: true, allow_nil: true
  end
end
