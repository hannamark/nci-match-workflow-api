require 'logger'

class SecurityConfigLoader

  def initialize(environment)

    @environment = environment

    if @environment == 'dev'

    end

    if @environment == 'prod-test'

    end

    else
      return
  end


  def load_config

  end

end
