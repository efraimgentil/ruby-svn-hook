class TomcatInfo

  attr_accessor :user , :pass , :root_url, :interface, :deploy, :undeploy , :stop, :dir

  def initialize
    @interface = "manager/text/"
    @deploy = "deploy?path=/"
    @undeploy = "undeploy?path=/"
    @stop = "stop?path=/"
  end


  def deploy_url_to_project ( project_name )
    get_url( deploy ) + project_name
  end

  def undeploy_url_to_project ( project_name )
    get_url( undeploy ) + project_name
  end

  private
    def get_url ( to_action )
      @root_url + @interface + to_action
    end

end