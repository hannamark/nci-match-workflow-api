require 'rest-client'
require 'active_support/core_ext/object/blank'

require "#{File.dirname(__FILE__)}/config_helper"
require "#{File.dirname(__FILE__)}/match_properties_message_dao"

class EcogAPIClient

  def initialize(api_config, username, password)
    @scheme = ConfigHelper.get_prop(api_config, 'ecog_api', 'scheme', 'http')
    @hosts = ConfigHelper.get_prop(api_config, 'ecog_api', 'hosts', ['127.0.0.1:3000'])
    @context = ConfigHelper.get_prop(api_config, 'ecog_api', 'context', '/MatchInformaticsLayer')
    @username = !username.blank? ? username : ConfigHelper.get_prop(api_config, 'ecog_api', 'username', nil)
    @password = !password.blank? ? password : ConfigHelper.get_prop(api_config, 'ecog_api', 'password', nil)
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