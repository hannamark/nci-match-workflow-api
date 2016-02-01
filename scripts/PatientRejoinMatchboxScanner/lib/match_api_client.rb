require 'rest-client'

require "#{File.dirname(__FILE__)}/config_helper"

class MatchAPIClient

  def initialize(api_config)
    @scheme = ConfigHelper.get_prop(api_config, 'match_api', 'scheme', 'http')
    @hosts = ConfigHelper.get_prop(api_config, 'match_api', 'hosts', ['127.0.0.1:8080'])
    @context = ConfigHelper.get_prop(api_config, 'match_api', 'context', '/match')
  end

  def simulate_patient_assignment(patient_sequence_number, analysis_id)
    if (patient_sequence_number.nil? || !patient_sequence_number.kind_of?(String) || patient_sequence_number.empty?) || (analysis_id.nil? || !analysis_id.kind_of?(String) || analysis_id.empty?)
      raise ArgumentError, 'Patient sequence number and analysis id cannot be nil or empty.'
    end
    url = build_match_context_url + "/common/rs/simulateAssignmentByPatient?patientId=#{patient_sequence_number}&analysisId=#{analysis_id}&tieBreakerOptions=0"
    JSON.parse(RestClient.get url, {:accept => :json})
  end

  def build_match_context_url
    return "#{@scheme}://#{@hosts[0]}#{@context}"
  end

  private :build_match_context_url

end