RSpec.describe OpenLibrary::WorkCoverService, type: :service do
  it_behaves_like OpenLibrary::BaseCoverService do
    let(:coverables) do
      {
        "/works/OL10000000W" => {
          title: "An Evil Cradling",
          covers: [ 1 ]
        },
        "/works/OL10000001W" => {
          title: "The Mirror Crack'd from Side to Side",
          covers: [ 2 ]
        },
        "/works/OL10000002W" => {
          title: "Pale Kings and Princes",
          covers: [ 3 ]
        },
        "/works/OL10000003W" => {
          title: "The Golden Apples of the Sun",
          covers: [ 4 ]
        },
        "/works/OL10000004W" => {
          title: "Where Angels Fear to Tread",
          covers: [ 5 ]
        },
        "/works/OL10000005W" => {
          title: "The House of Mirth",
          covers: [ 6 ]
        },
        "/works/OL10000006W" => {
          title: "The Millstone",
          covers: [ 7 ]
        },
        "/works/OL10000007W" => {
          title: "Rosemary Sutcliff",
          covers: [ 8 ]
        },
        "/works/OL10000008W" => {
          title: "The Needle's Eye",
          covers: [ 9 ]
        },
        "/works/OL10000009W" => {
          title: "Lilies of the Field",
          covers: [ 10, 11 ]
        }
      }
    end
  end
end
