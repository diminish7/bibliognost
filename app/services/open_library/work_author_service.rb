module OpenLibrary
  # Service for importing work/author relationships from Open Library
  class WorkAuthorService < BaseService
    private

    # Override from OpenLibrary::BaseService
    def valid?(attrs)
      # NOTE: Check title also - not needed for `work_authors`, but without it, the `works`
      #       record was skipped
      %i[ title work_external_identifier author_external_identifiers ].all? do |attr|
        attrs[attr].present?
      end
    end

    # Override from OpenLibrary::BaseService
    # This needs to use SQL instead of Rails's upsert to avoid re-querying works and authors
    def upsert!
      Rails.logger.info "Upserting #{upsert_attrs.length} #{model_name} records."
      sql = build_sql(upsert_attrs)
      ActiveRecord::Base.connection.execute(sql)
    end

    def build_sql(upsert_attrs)
      insert_lines = upsert_attrs.flat_map do |attrs|
        work_external_identifier, author_external_identifiers = attrs.values_at(
          :work_external_identifier, :author_external_identifiers
        )
        quoted_work_external_identifier = quote(work_external_identifier)

        author_external_identifiers.map do |author_external_identifier|
          quoted_author_external_identifier = quote(author_external_identifier)

          <<~SQL.squish
            (
              (
                SELECT id
                FROM works
                WHERE external_identifier = #{quoted_work_external_identifier}
              ),
              (
                SELECT id
                FROM authors
                WHERE external_identifier = #{quoted_author_external_identifier}
              ),
              NOW(),
              NOW()
            )
          SQL
        end
      end

      <<~SQL.squish
        INSERT INTO work_authors
        (work_id, author_id, created_at, updated_at)
        VALUES
        #{insert_lines.join(', ')}
        ON CONFLICT DO NOTHING
      SQL
    end
  end
end
