json.set! :properties do
  show.each do |property|
    json.set! property.name do
      json.set! :values do
        json.array! property.values
      end
    end
  end
end
