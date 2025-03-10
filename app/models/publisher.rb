class Publisher < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  # This comes from the editions data
  def self.attributes_from_open_library_json(json)
    # This comes as an array, but in practice, they are all an array of 1
    publisher = json["publishers"]&.first
    return {} if publisher.blank?

    name = truncated_publisher_name(publisher)
    # If we had to truncate the publisher, put the un-truncated version in the description field
    description = publisher unless name == publisher

    { name:, description: }
  end

  private

  # Some of the publisher names in OpenLibrary data are bad data with huge blocks of descriptive
  # text for the name. This helper truncates bad data to the max size of the DB column (255)
  def self.truncated_publisher_name(publisher)
    # NOTE: Check byte length to account for unicode characters
    return publisher if publisher.bytes.length <= 255

    truncated = publisher[0...255]
    while truncated.bytes.length > 255
      truncated = truncated[0...-1]
    end

    truncated
  end
end
