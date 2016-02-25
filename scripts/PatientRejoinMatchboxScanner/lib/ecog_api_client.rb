require 'rest-client'

require "#{File.dirname(__FILE__)}/config_helper"
require "#{File.dirname(__FILE__)}/match_properties_message_dao"

class EcogAPIClient

  def initialize(api_config)
    @scheme = ConfigHelper.get_prop(api_config, 'ecog_api', 'scheme', 'http')
    @hosts = ConfigHelper.get_prop(api_config, 'ecog_api', 'hosts', ['127.0.0.1:3000'])
    @context = ConfigHelper.get_prop(api_config, 'ecog_api', 'context', '/MatchInformaticsLayer')
    match_properties = MatchPropertiesMessageDao.new(api_config)
    @username = match_properties.get_value('ecog.post.patient.rerun.username')
    @password = match_properties.get_value('ecog.post.patient.rerun.password')
    @username = ConfigHelper.get_prop(api_config, 'ecog_api', 'username', nil) if @username.blank?
    @password = ConfigHelper.get_prop(api_config, 'ecog_api', 'password', nil) if @password.blank?
    match_properties.close
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