json.array!(@short_visits) do |short_visit|
  json.extract! short_visit, :visitor_ip, :visitor_city, :visitor_state, :visitor_country_iso2, :visitor_country
end