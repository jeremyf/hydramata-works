require 'hydramata/works/predicates/storage'

Hydramata::Works::Predicates::Storage.create!(identity: 'depositor')
Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/created', value_parser_name: 'DateParser')
Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/language', value_parser_name: 'InterrogationParser' )
Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/publisher', value_parser_name: 'InterrogationParser')
Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/title', value_parser_name: 'InterrogationParser')
Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/dateSubmitted', value_parser_name: 'DateParser')
Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/modified', value_parser_name: 'DateParser')
Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/rights', value_parser_name: 'InterrogationParser')
Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/creator', value_parser_name: 'InterrogationParser')
Hydramata::Works::Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/description', value_parser_name: 'InterrogationParser')
