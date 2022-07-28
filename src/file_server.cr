require "http"
require "option_parser"

# Handle Ctrl+C and kill signal.
# Needed for hosting this process in a docker
# as the entry point command
Signal::INT.trap { puts "Caught Ctrl+C..." ; exit }
Signal::INT.trap { puts "Caught kill..."   ; exit }

# Defaul values
path = "./www"
port = 80

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

address = server.bind_tcp "0.0.0.0", port
puts "Listening on http://#{address} and serving files in path #{path}"
server.listen

