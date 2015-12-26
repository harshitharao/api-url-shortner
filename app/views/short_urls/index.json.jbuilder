json.array!(@short_urls) do |short_url|
  json.extract! short_url, :id, :original_url, :shorty, :visits_count
  json.url short_url_url(short_url, format: :json)
end
