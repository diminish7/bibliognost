RSpec.describe OpenLibrary::EditionCoverService, type: :service do
  it_behaves_like OpenLibrary::BaseCoverService do
    let(:coverables) do
      {
        "/books/OL10000000M" => {
          title: "An Instant In The Wind",
          covers: [ 1 ]
        },
        "/books/OL10000001M" => {
          title: "Bury My Heart at Wounded Knee",
          covers: [ 2 ]
        },
        "/books/OL10000002M" => {
          title: "A Catskill Eagle",
          covers: [ 3 ]
        },
        "/books/OL10000003M" => {
          title: "Bury My Heart at Wounded Knee (book 2)",
          covers: [ 4 ]
        },
        "/books/OL10000004M" => {
          title: "Françoise Sagan",
          covers: [ 5 ]
        },
        "/books/OL10000005M" => {
          title: "Ah, Wilderness!",
          covers: [ 6 ]
        },
        "/books/OL10000006M" => {
          title: "That Good Night",
          covers: [ 7 ]
        },
        "/books/OL10000007M" => {
          title: "A Swiftly Tilting Planet",
          covers: [ 8 ]
        },
        "/books/OL10000008M" => {
          title: "Let Us Now Praise Famous Men",
          covers: [ 9 ]
        },
        "/books/OL10000009M" => {
          title: "Mother Night",
          covers: [ 10, 11 ]
        }
      }
    end
  end
end
