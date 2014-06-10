show.each do |property|
  # Why the locals?
  # Without the local json declared the jbuilder rendering engine
  # will call :target! and dump the attributes to JSON form.
  # This means nested calls will result in multiple dump commands on the
  # rendered value.
  json.set! property.render(template: self, locals: {json: json})
end
