require 'hydramata/works/predicates/storage'
require 'hydramata/works/work_types/storage'

Hydramata::Works::Predicates::Storage.create!(identity: 'depositor')
Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/created', name_for_application_usage: 'dc_created', value_parser_name: 'DateParser')
Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/language', name_for_application_usage: 'dc_language', value_parser_name: 'InterrogationParser' )
Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/publisher', name_for_application_usage: 'dc_publisher', value_parser_name: 'InterrogationParser')
Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/title', name_for_application_usage: 'dc_title', value_parser_name: 'InterrogationParser')
Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/dateSubmitted', name_for_application_usage: 'dc_dateSubmitted', value_parser_name: 'DateParser')
Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/modified', name_for_application_usage: 'dc_modified', value_parser_name: 'DateParser')
Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/rights', name_for_application_usage: 'dc_rights', value_parser_name: 'InterrogationParser')
Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/creator', name_for_application_usage: 'dc_creator', value_parser_name: 'InterrogationParser')
Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/description', name_for_application_usage: 'dc_description', value_parser_name: 'InterrogationParser')

Hydramata::Works::WorkTypes::Storage.create(identity: 'book')
Hydramata::Works::WorkTypes::Storage.create(identity: 'article')