require "http"

path = "./public"
server = HTTP::Server.new([
  HTTP::LogHandler.new,
  HTTP::ErrorHandler.new,
  HTTP::StaticFileHandler.new(path),
])

address = server.bind_tcp 8081
puts "Listening on http://#{address} and serving files in path #{path}"
server.listen

