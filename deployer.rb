require "rest_client"

class Deployer

  #Usuário deve conter a permissão 'manager-script' do tomcat
  tomcat = {  
      :user => "tomcat",
      :pass => "tomcat",
      :url  => "http://localhost:8080/manager/text/"
      :deploy => "deploy?path=/"
      :undeploy => "undeploy?path=/"
      :stop => "stop?path=/"
      :dir  => "/home/efraimgentil/Servidores/apache-tomcat-7.0.57-teste-jotm/conf"
  }

  def deploy( svn_info )
    request = RestClient::Resource.new(tomcat[:url] + tomcat[:deploy] + svn_info[:project_name] , tomcat[:user] , tomcat[:pass]) 
    request.put File.new( File.expand_path( svn_info[:deploy_file] ) )
  end

  def undeploy( svn_info )
    request = RestClient::Resource.new(tomcat[:url] + tomcat[:undeploy] + svn_info[:project_name] , tomcat[:user] , tomcat[:pass]) 
    request.get
  end

end