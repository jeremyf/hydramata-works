json.set! :work do
  json.set! :work_type, show.work_type
  json.properties do
    show.fieldsets.each do |fieldset|
      # Why the locals?
      # Without the local json declared the jbuilder rendering engine
      # will call :target! and dump the attributes to JSON form.
      # This means nested calls will result in multiple dump commands on the
      # rendered value.
      fieldset.render(template: self, locals: {json: json})
    end
  end
end