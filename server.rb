
require "socket"
require File.expand_path("svn_picker")

class Server

  attr_accessor :server

  def initialize
    @server = TCPServer.open( 9090 )
  end

  def start
    threads = {}
    loop{
      Thread.start( @server.accept ) do |client|
        
        request_line = client.gets
        puts request_line

        request_uri  = request_line.split(" ")[1]
        m = request_uri.scan /([\w]+=[\w\\\/:]+)/
        params = {}
        m.each{ |p|  
          param = p[0].split("=")
          params[param[0]] = param[1]
        }

        if( params["host"] ) then
          if( threads[params["host"]] ) then
            threads[params["host"]].exit
          end
          threads[params["host"]] = Thread.new{
            c = IO.popen("mvn -f agenda-siconect clean package")
            c.each_line do |l|
              puts l
            end
          }
        end
       
        client.puts "TESTE "
        client.close
      end
    }
  end


end