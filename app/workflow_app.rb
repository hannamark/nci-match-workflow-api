APP_ROOT = File.expand_path('..', __FILE__)
$LOAD_PATH.unshift APP_ROOT
# require 'lib/core_ext/string'
require 'controller/application_controller'

configure do
  set :protection, :except => [:json_csrf]
end

Dir.glob("#{APP_ROOT}/{dao,dto,error,model,queue,controller,util,validator,initializers}/*.rb").each { |file|
  require file
}

module Application
  class WorkflowApi < Sinatra::Application
    use Routes::MatchController
    use Routes::CLIAMessagingController
    use Routes::ECOGMessagingController
    use Routes::ChangeRequestController
    use Routes::MDAMessagingController

    not_found do
      status 400
      body 'Service not found'
    end
  end
end

