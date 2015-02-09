require File.expand_path('svn_info')
require File.expand_path('tomcat_info')
require File.expand_path('tomcat_deployer')
require "digest"
require "fileutils"

class SvnHook

  attr_accessor :repository , :revision

  SVN_USER = "efraim.gentil" 
  SVN_PASS = "-------"

  def initialize( repository , revision)
    @repository = repository
    @revision = revision
    @deployer = TomcatDeployer.new
    
  end

  def process
    puts "Starting"
    temp_folder = "/tmp/#{Digest::MD5.new.hexdigest( @repository )}"
    checkout_to temp_folder
    deploy_file = mvn_package( temp_folder )
    deploy( deploy_file , temp_folder ) if deploy_file
  end

  private 

    def checkout_to( temp_folder )
      begin
        remove_target_dir( temp_folder ) if File.exist?(temp_folder)
        puts "Checkout"
        c = IO.popen("svn checkout #{@repository} -r #{@revision} #{temp_folder} --username=#{SVN_USER} --password=#{SVN_PASS}")
        c.each_line{ |line|  print ( line )  }
      ensure
        c.close if c
      end
    end

    def remove_target_dir( target_dir )
      FileUtils.rm_rf( target_dir )
    end

    def mvn_package( temp_folder )
      begin 
        c = IO.popen("mvn -f #{temp_folder} clean package")
        errors = []
        c.each_line do |line|  
          puts line
          errors.push line if line.match /\[ERROR\]/ 
        end

        if errors.empty? then
          files = Dir.glob("#{temp_folder}/target/*.war");
          if (!files.empty?) then
            puts "War found #{files[0]}"
            return File.expand_path( files[0] )
          else
            errors.push "Não foi possivel encontrar o arquivo .war na pasta target"
          end
        end
        send_error errors
        return nil
      ensure
        c.close if c
      end
    end

    def deploy( deploy_file , temp_folder )
      puts "Starting to deploy #{deploy_file}"
      @deployer.deploy( deploy_file , get_tomcat_info( temp_folder ) )
    end

    def get_tomcat_info( temp_folder )
      #TODO
      tomcat = TomcatInfo.new
      tomcat.user = "tomcat"
      tomcat.pass = "tomcat"
      tomcat.root_url  = "http://localhost:8080/"
      return tomcat
    end

    def send_error(errors)
      puts "Não foi possivel finalizar o processo"
    end

end


