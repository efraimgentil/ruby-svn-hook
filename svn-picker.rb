class SvnPicker

  attr_accessor svn_info_list

  def initialize
    svn_info_list = []
    info = SvnInfo.new
    info.project_name = 'lol'
    info.user = "efraim.gentil"
    info.pass = "Shint@160"
    info.url  = "https://subversion.assembla.com/svn/viai/"
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
  end

end

class SvnInfo

  attr_accessor :project_name, :user, :pass, :url, :current_version

  def to_s
    "SvnInfo{ 'project_name':'#{@project_name}' , 'user':'#{@user}', 'pass':'#{@pass}', 'url':'#{@url}', 'current_version':'#{@current_version}' }"
  end

end