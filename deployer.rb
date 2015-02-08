require "rest_client"
require File.expand_path("tomcat_info")

class Deployer

  #Usuário deve conter a permissão 'manager-script' do tomcat
  
  def initialize
    @tomcat = TomcatInfo.new
    @tomcat.user = "tomcat"
    @tomcat.pass = "tomcat"
    @tomcat.root_url  = "http://localhost:8080/"
  end

  def deploy( svn_info )
    request = RestClient::Resource.new( @tomcat.deploy_url_to_project( svn_info.project_name ) , @tomcat.user , @tomcat.pass ) 
    print svn_info.deploy_file
    request.put File.new( svn_info.deploy_file )
  end

  def undeploy( svn_info )
    print @tomcat.undeploy_url_to_project( svn_info.project_name ) 
    request = RestClient::Resource.new( @tomcat.undeploy_url_to_project( svn_info.project_name ) , @tomcat.user , @tomcat.pass ) 
    request.get
  end

end