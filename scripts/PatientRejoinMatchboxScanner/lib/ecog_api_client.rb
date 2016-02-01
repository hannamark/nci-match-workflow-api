require 'rest-client'

require "#{File.dirname(__FILE__)}/config_helper"

class EcogAPIClient

  def initialize(api_config)
    @scheme = ConfigHelper.get_prop(api_config, 'ecog_api', 'scheme', 'http')
    @hosts = ConfigHelper.get_prop(api_config, 'ecog_api', 'hosts', ['127.0.0.1:3000'])
    @context = ConfigHelper.get_prop(api_config, 'ecog_api', 'context', '/MatchInformaticsLayer')
    @username = ConfigHelper.get_prop(api_config, 'ecog_api', 'username', nil)
    @password = ConfigHelper.get_prop(api_config, 'ecog_api', 'password', nil)
  end

  def send_patient_eligible_for_rejoin(patientSequenceNumbers)
    if patientSequenceNumbers.nil? || !patientSequenceNumbers.kind_of?(Array) || patientSequenceNumbers.size == 0
      raise ArgumentError, 'Patient sequence number list cannot be nil or empty.'
    end

    url = build_ecog_context_url + '/services/rs/rerun'
    RestClient::Request.execute(
        :url => url,
        :method => :post,
        :payload => patientSequenceNumbers.to_json,
        :user => @username,
        :password => @password,
        :headers => { 'Accept'=>'application/json', :content_type => 'application/json' },
        :verify_ssl => false)
  end

  def build_ecog_context_url
    return "#{@scheme}://#{@hosts[0]}#{@context}"
  end

  private :build_ecog_context_url

end