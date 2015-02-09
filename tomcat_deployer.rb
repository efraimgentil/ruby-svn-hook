require "rest_client"
require File.expand_path("tomcat_info")

class TomcatDeployer

  #Usuário deve conter a permissão 'manager-script' do tomcat
 
  def deploy( deployment_file  , tomcat )
    context = get_context( deployment_file )
    undeploy( context , tomcat )
    request = RestClient::Resource.new( tomcat.deploy_url_to_project( context ) ,
       tomcat.user , tomcat.pass ) 
    request.put File.new( deployment_file )
    puts "Deploy #{context} efetuado com sucesso!"
  end

  def undeploy( context , tomcat )
    request = RestClient::Resource.new( tomcat.undeploy_url_to_project( context ), tomcat.user , tomcat.pass ) 
    request.get
  end

  def get_context(deployment_file )
    return  deployment_file.split("/").last.split(".war").first
  end

end