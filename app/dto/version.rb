class Version
  include Singleton
  attr_reader :version

  def initialize
    @version = 'v.1.4.2'
  end
end
