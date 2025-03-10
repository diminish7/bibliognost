# frozen_string_literal: true

class EditionAuthor < ApplicationRecord
  belongs_to :edition
  belongs_to :author

  validates :edition_id, uniqueness: { scope: :author_id }

  def self.attributes_from_open_library_json(json)
    edition_external_identifier, authors = json.values_at("key", "authors")
    authors ||= [] # Not all editions have authors and this key is then omitted from the source data
    author_external_identifiers = authors.filter_map do |author_json|
      author_json["key"]
    end

    { edition_external_identifier:, author_external_identifiers: }
  end
end
