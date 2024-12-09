module OpenLibrary
  # Service for importing work/subject relationships from Open Library
  class WorkSubjectService < BaseService
    private

    # Override from OpenLibrary::BaseService
    def valid?(attrs)
      %i[ work_external_identifier subjects ].all? { |attr| attrs[attr].present? }
    end

    # Override from OpenLibrary::BaseService
    # Convert work external identifier and subject names into collection of work and subject IDs
    # Note that some may not exist because the work or subject was invalid for some reason, so
    # this filters out invalid ones as well.
    def transform_upsert_attrs
      batch_work_ids = query_batch_work_ids
      batch_subject_ids = query_batch_subject_ids

      upsert_attrs.flat_map do |attrs|
        work_external_identifier, subjects = attrs.values_at(:work_external_identifier, :subjects)
        work_id = batch_work_ids[work_external_identifier]
        next if work_id.nil?

        subject_ids = subjects.filter_map { |subject_name| batch_subject_ids[subject_name] }
        next if subject_ids.blank?

        subject_ids.map { |subject_id| { work_id:, subject_id: } }
      end.compact
    end

    # Override from OpenLibrary::BaseService
    def upsert_unique_by_field
      %i[ work_id subject_id ]
    end

    def query_batch_work_ids
      external_identifiers = upsert_attrs.map { |attrs| attrs[:work_external_identifier] }
      Work.where(external_identifier: external_identifiers).pluck(:external_identifier, :id).to_h
    end

    def query_batch_subject_ids
      names = upsert_attrs.flat_map { |attrs| attrs[:subjects] }.uniq
      Subject.where(name: names).pluck(:name, :id).to_h
    end
  end
end
