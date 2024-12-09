# Bibliognost

A social site for book reviews, lists, favorites.

# Importing Data

Pull the expected data dumps from [Open Library](https://openlibrary.org/developers/dumps).

Get the dumps for authors, works, and editions.

Run the import services in the following order (Until I've added the parent service to run them all):

1. Import authors with `OpenLibrary::AuthorService.new(path/to/author/dump).call`
2. Import works with `OpenLibrary::WorkService.new(path/to/work/dump).call`
3. Import subjects with `OpenLibrary::SubjectService.new(path/to/work/dump).call`
4. Import works/subjects relationships with `OpenLibrary::WorkSubjectService.new(path/to/work/dump).call`
5. Import works/authors relationships with `OpenLibrary::WorkAuthorService.new(path/to/work/dump).call`
6. (TODO) Import editions relationships with `OpenLibrary::EditionService.new(path/to/edition/dump).call``
