require 'hydramata/works/predicates/storage'
require 'hydramata/works/predicate_sets/storage'
require 'hydramata/works/work_types/storage'

predicate_depositor = Hydramata::Works::Predicates::Storage.create!(identity: 'depositor')
predicate_created = Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/created', name_for_application_usage: 'dc_created', value_parser_name: 'DateParser')
predicate_language = Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/language', name_for_application_usage: 'dc_language', value_parser_name: 'InterrogationParser' )
predicate_publicher = Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/publisher', name_for_application_usage: 'dc_publisher', value_parser_name: 'InterrogationParser')
predicate_title = Hydramata::Works::Predicates::Storage.create!(
  identity: 'http://purl.org/dc/terms/title',
  name_for_application_usage: 'dc_title',
  value_parser_name: 'InterrogationParser',
  validations: '{ "presence_of_each": true }'
)
predicate_attachment = Hydramata::Works::Predicates::Storage.create!(
  identity: 'opaque:attachment',
  name_for_application_usage: 'attachment'
)
predicate_dateSubmitted = Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/dateSubmitted', name_for_application_usage: 'dc_dateSubmitted', value_parser_name: 'DateParser')
predicate_modified = Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/modified', name_for_application_usage: 'dc_modified', value_parser_name: 'DateParser')
predicate_rights = Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/rights', name_for_application_usage: 'dc_rights', value_parser_name: 'InterrogationParser')
predicate_creator = Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/creator', name_for_application_usage: 'dc_creator', value_parser_name: 'InterrogationParser')
predicate_description = Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/description', name_for_application_usage: 'dc_description', value_parser_name: 'InterrogationParser')

['book', 'article'].each do |identifier|
  work_type = Hydramata::Works::WorkTypes::Storage.create(identity: identifier, name_for_application_usage: identifier)
  predicate_set = Hydramata::Works::PredicateSets::Storage.create!(identity: 'required', work_type: work_type, presentation_sequence: 1, name_for_application_usage: 'required')
  predicate_set.predicate_presentation_sequences.create!(presentation_sequence: 1, predicate: predicate_title)
  predicate_set.predicate_presentation_sequences.create!(presentation_sequence: 2, predicate: predicate_description)

  optional_predicate_set = Hydramata::Works::PredicateSets::Storage.create!(identity: 'optional', work_type: work_type, presentation_sequence: 2, name_for_application_usage: 'optional')
  optional_predicate_set.predicate_presentation_sequences.create!(presentation_sequence: 1, predicate: predicate_attachment)
end
