article = Hydramata::Work::WorkTypes::Storage.create!(identity: 'article', name_for_application_usage: 'article')
predicate_set = Hydramata::Work::PredicateSets::Storage.create!(identity: 'required', work_type: article, presentation_sequence: 1, name_for_application_usage: 'required')

def within_predicate_set_create_predicate_by_term(predicate_set, term)
  name = "dc_#{term.gsub('#', '_')}"
  predicate = Hydramata::Work::Predicates::Storage.new(identity: "http://purl.org/dc/terms/#{term}", name_for_application_usage: name)
  predicate.save!
  counter = predicate_set.predicate_presentation_sequences.count + 1
  predicate_set.predicate_presentation_sequences.create!(presentation_sequence: counter, predicate: predicate)
end

[
  'title',
  'alternative',
  'creator#author',
  'contributor#author',
  'identifier#issn',
  'identifier#doi',
  'abstract',
  'subject',
  'source',
  'publisher',
  'created',
  'format#mimeType',
  'bibliographicCitation',
  'contributor#repository',
  'relation#ispartof',
  'temporal',
  'spatial',
  'language',
  'format#extent',
  'contributor#institution',
  'rights#permissions',
].each do |term|
  within_predicate_set_create_predicate_by_term(predicate_set, term)
end