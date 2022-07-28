require "http"
require "option_parser"

path = "./public"
port = 8081

OptionParser.parse do |parser|
  parser.banner = "A Simple Static File Server"
  
  parser.on "-f PATH", "--files=PATH", "Files path (default: #{path})" do |files_path|
    path = files_path
  end
  
  parser.on "-p PORT", "--port=PORT", "Port to listen (defaul: #{port})" do |server_port|
    port = server_port.to_i
  end
  
  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end
end

server = HTTP::Server.new([
  HTTP::LogHandler.new,
  HTTP::ErrorHandler.new,
  HTTP::StaticFileHandler.new(path),
])

address = server.bind_tcp port
puts "Listening on http://#{address} and serving files in path #{path}"
server.listen

