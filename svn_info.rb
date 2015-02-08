require File.expand_path('tomcat_info')
require File.expand_path('active_file')

class SvnInfo
  include ActiveFile

  attr_accessor :project_name, :user, :pass, :url, :current_revision, :deploy_file, :tomcat_info

  def initialize
    @id = self.class.next_id
  end

  def to_s
    "SvnInfo{ 'project_name':'#{@project_name}' , 'user':'#{@user}', 'pass':'#{@pass}', 'url':'#{@url}', 'current_version':'#{@current_version}' }"
  end

end