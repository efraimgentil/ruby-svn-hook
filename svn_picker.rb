require File.expand_path('svn_info')
require File.expand_path('tomcat_info')
require File.expand_path('deployer')
require "fileutils"

class SvnPicker

  attr_accessor :svn_info_list , :deployer , :teste

  def initialize
    @svn_info_list = SvnInfo.all
    @deployer = Deployer.new
  end

  def finish_deploymend( project_name )
    threads[project_name] = nil
  end

  def process
    svn_info = @svn_info_list[0] #TODO fazer a interasando quando mutiplos projetos
    last_revision = getInfo( svn_info ).strip
    puts "## Last Revision: #{last_revision}"
    if( should_redeploy( svn_info , last_revision ) ) then
      remove_target_dir( svn_info.project_name  ) if File.exist?( File.expand_path( svn_info.project_name ) )
      checkout svn_info
      svn_info = create_mvn_build svn_info
      undeploy svn_info
      deploy svn_info
      svn_info.current_revision = last_revision
      svn_info.save
    else
      puts "## Current deploy at the same revision"
    end

  end

  #private
    def getInfo svn_info
      begin 
        command = IO.popen("svn info #{svn_info.url} --username=#{svn_info.user} --password=#{svn_info.pass}")
        command.each_line{ |line|
          if line.match(/Revision:.\d{1,}/) then
            match = line.match /\d{1,}/
            version = line[ match.begin(0) , match.end(0)]
            return version
          end
        }
      ensure
        command.close if command
      end
    end

    def remove_target_dir( target_dir )
      FileUtils.rm_rf( File.expand_path( target_dir ) )
    end

    def checkout (svn_info)
      begin
        c = IO.popen("svn checkout #{svn_info.url} #{svn_info.project_name} --username=#{svn_info.user} --password=#{svn_info.pass}")
        c.each_line{ |line|  print ( line )  }
      ensure
        c.close if c
      end
    end

    def create_mvn_build(svn_info)
      begin 
        c = IO.popen("mvn -f #{svn_info.project_name} clean package")

        c.each_line do |line|  
          print ( line ) if line.match /\[ERROR\]/ 
          c.close if @teste
        end
        svn_info.deploy_file= File.expand_path("#{svn_info.project_name}/target/#{svn_info.project_name}.war")
        return svn_info
      ensure
        c.close if c
      end
    end

    def should_redeploy ( svn_info , last_revision )
      return !svn_info.current_revision.eql?( last_revision )
    end

    def deploy(svn_info)
      @deployer.deploy( svn_info )
    end

    def undeploy(svn_info)
      @deployer.undeploy( svn_info )
    end

end

