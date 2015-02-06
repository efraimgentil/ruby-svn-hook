class SvnPicker

  attr_accessor :svn_info_list
  tomcat = {  
      :user => "tomcat",
      :pass => "tomcat",
      :url  => "http://localhost:8080/manager/text/stop?path=/"
      :dir  => "/home/efraimgentil/Servidores/apache-tomcat-7.0.57-teste-jotm/conf"
  }

  def initialize
    @svn_info_list = []
    info = SvnInfo.new
    info.project_name = 'lol'
    info.user = "efraim.gentil"
    info.pass = "Shint@160"
    info.url  = "https://subversion.assembla.com/svn/viai/trunk"
    svn_info_list.push info
  end

  def getInfo
    command = IO.popen("svn info #{login_info[:url]} --username=#{login_info[:user]} --password=#{login_info[:pass]}")
    command.each_line{ |line|
      if line.match(/Revision:.\d{1,}/) then
        match = line.match /\d{1,}/
        version = line[ match.begin(0) , match.end(0)]
        print version
      end
    }
    command.close
  end

  def checkout (svn_info)
    c = IO.popen("svn checkout #{svn_info.url} #{svn_info.project_name} --username=#{svn_info.user} --password=#{svn_info.pass}")
    c.close
  end

  def create_mvn_build(svn_info)
    c = IO.popen("mvn -f #{svn_info.project_name} clean package")
    c.each_line{ |line|  
      #WAIT FOR c to end
    }
    c.close
    svn_info.deploy_file= File.expand_path("#{svn_info.project_name}/target/#{svn_info.project_name}.war")
  end

  def deploy(svn_info)

  end

  def undeploy(svm_info)

  end

end

class SvnInfo

  attr_accessor :project_name, :user, :pass, :url, :current_version, :deploy_file

  def to_s
    "SvnInfo{ 'project_name':'#{@project_name}' , 'user':'#{@user}', 'pass':'#{@pass}', 'url':'#{@url}', 'current_version':'#{@current_version}' }"
  end

end