module OpenLibrary
  # Service for importing works (books, novels, novellas, short stories, poems) from Open Library
  class WorkSubjectService < BaseService
    private

    # Override from OpenLibrary::BaseService
    def valid?(attrs)
      attrs[:work_external_identifier].present? && attrs[:subjects].present?
    end

    # Override from OpenLibrary::BaseService
    # This needs to use SQL instead of Rails's upsert to avoid re-querying works
    def upsert!
      Rails.logger.info "Upserting #{upsert_attrs.length} #{model_name} records."
      sql = build_sql(upsert_attrs)
      ActiveRecord::Base.connection.execute(sql)
    end

    def build_sql(upsert_attrs)
      insert_lines = upsert_attrs.flat_map do |attrs|
        work_external_identifier, subjects = attrs.values_at(:work_external_identifier, :subjects)
        quoted_work_external_identifier = quote(work_external_identifier)

        subjects.map do |subject_name|
          <<~SQL.squish
            (
              (SELECT id FROM works WHERE external_identifier = #{quoted_work_external_identifier}),
              #{subject_id_for(subject_name)},
              NOW(),
              NOW()
            )
          SQL
        end
      end

      <<~SQL.squish
        INSERT INTO work_subjects
        (work_id, subject_id, created_at, updated_at)
        VALUES
        #{insert_lines.join(', ')}
        ON CONFLICT DO NOTHING
      SQL
    end

    def subject_id_for(name)
      subject_ids_by_name[name] ||= Subject.create!(name:).id
    end

    def subject_ids_by_name
      @subject_ids_by_name ||= Subject.pluck(:name, :id).to_h
    end
  end
end
