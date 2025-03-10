class Edition < ApplicationRecord
  include HasExternalIdentifier

  belongs_to :work
  belongs_to :language, optional: true
  belongs_to :publisher, optional: true

  has_many :edition_authors, dependent: :destroy
  has_many :authors, through: :edition_authors

  validates :title, presence: true

  def self.attributes_from_open_library_json(json)
    title, name, subtitle, edition, contributors, external_identifier, isbn_10, isbn_13,
    published_at, format, pages, word_count, description, work, authors, publishers =
      json.values_at(
        "title", "name", "subtitle", "edition_name", "contributions", "key", "isbn_10", "isbn_13",
        "publish_date", "physical_format", "number_of_pages", "word_count", "description", "works",
        "authors", "publishers"
      )

    description = description&.fetch("value", nil) if description.is_a?(Hash)
    work = Array.wrap(work).first
    work_external_identifier = work["key"] if work.is_a?(Hash)

    {
      title: title.presence || name,
      contributors: Array.wrap(contributors.presence),
      published_at: safe_parse_date(published_at),
      isbn_10: Array.wrap(isbn_10).first,
      isbn_13: Array.wrap(isbn_13).first,
      publisher_name: Array.wrap(publishers).first,
      work_external_identifier:,
      description:,
      subtitle:,
      edition:,
      external_identifier:,
      format:,
      pages:,
      word_count:
    }
  end

  private

  def self.safe_parse_date(date)
    return if date.blank?

    Date.parse(date)
  rescue Date::Error
    nil
  end
end
