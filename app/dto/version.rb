class Version
  include Singleton
  attr_reader :version

  def initialize
    @version = 'v.1.3.0'
  end
end
