json.extract! event, :id, :name, :level, :starts_at, :created_at, :updated_at
json.url event_url(event, format: :json)
