
require "socket"
require File.expand_path("svn_hook")
#require File.expand_path("svn_picker")

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
        m = request_uri.scan /([\w]+=[\w\\\/:\.\-\_]+)/
        params = {}
        m.each{ |p|  
          param = p[0].split("=")
          params[param[0]] = param[1]
        }

        puts params
        if( params["host"] ) then
          if( threads[params["host"]] ) then
            threads[params["host"]].exit
          end
          threads[params["host"]] = Thread.new{
            puts "Processando Host: #{params['host']}"
            hook = SvnHook.new params["host"], params["revision"]
            puts " OK "
            hook.process
          }
        end
       
        client.puts "TESTE "
        client.close
      end
    }
  end


end