class WorkAuthor < ApplicationRecord
  belongs_to :work
  belongs_to :author

  validates :work_id, uniqueness: { scope: :author_id }

  def self.attributes_from_open_library_json(json)
    title, work_external_identifier, authors = json.values_at("title", "key", "authors")
    author_external_identifiers = authors.filter_map do |author_json|
      author_json.dig("author", "key")
    end

    { title:, work_external_identifier:, author_external_identifiers: }
  end
end
