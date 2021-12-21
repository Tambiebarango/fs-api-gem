require_relative 'lib/fullscriptapi.rb'

client = FullscriptApi.new do |c|
  c.client_id = "something"
  c.secret = "something else"
  c.redirect_uri = "https://google.com"
  c.server = "http://localhost:3000"
end

client.use_token("yU_kH3uyTuMgZ0KkIxLyg_ozMy4vLW29QR-OhTAgU_I")

pp client.list_all_products