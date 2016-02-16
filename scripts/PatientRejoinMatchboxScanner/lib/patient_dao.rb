require 'mongo'

require "#{File.dirname(__FILE__)}/config_helper"
require "#{File.dirname(__FILE__)}/data_element_locator"

class PatientDao

  def initialize(db_config)
    @hosts = ConfigHelper.get_prop(db_config, 'database', 'hosts', ['127.0.0.1:27017'])
    @dbname = ConfigHelper.get_prop(db_config, 'database', 'dbname', 'match')
    @username = ConfigHelper.get_prop(db_config, 'database', 'username', nil)
    @password = ConfigHelper.get_prop(db_config, 'database', 'password', nil)

    @client = Mongo::Client.new(@hosts, :database => @dbname, :user => @username, :password => @password)
  end

  ###
  # Patients are eligible for rejoin is there current status is OFF_TRIAL_NO_TA_AVAILABLE or REJOIN_REQUESTED, current step
  # is 0, and the specimen received date is within 6 months lof the current time the rejoin scan.
  ###
  def get_off_trial_patients
    results = { 'off_trial_patients' => [], 'off_trial_patients_docs' => [] }
    documents = @client[:patient].find(:currentPatientStatus => { '$in' => %w('OFF_TRIAL_NO_TA_AVAILABLE', 'REJOIN_REQUESTED') })
    documents.each do |document|
      next if document['currentStepNumber'] != '0'
      patient_sequence_number = document['patientSequenceNumber']
      biopsy = DataElementLocator.get_last_element(document['biopsies'])
      next if biopsy.nil?

      specimen_received_message = DataElementLocator.get_specimen_received_message(biopsy)
      next if specimen_received_message.nil?
      cut_off_date = DateTime.now << 6
      next if specimen_received_message['reportedDate'].utc < cut_off_date.to_time.utc

      next_generation_sequence = DataElementLocator.get_last_element(biopsy['nextGenerationSequences'])
      next if next_generation_sequence.nil?
      analysis_id = DataElementLocator.get_confirmed_variant_report_analysis_id(next_generation_sequence)
      if !patient_sequence_number.nil? && !analysis_id.nil?
        results['off_trial_patients'].push({ :patient_sequence_number => patient_sequence_number, :analysis_id => analysis_id })
        results['off_trial_patients_docs'].push(document)
      end
    end
    results
  end

  def add_patient_trigger(patient_doc, patient_trigger)
    raise ArgumentError, 'Patient document cannot be nil.' if patient_doc.nil?
    raise ArgumentError, 'Patient trigger cannot be nil.' if patient_trigger.nil?
    patient_doc['patientTriggers'].push(patient_trigger)
    update(patient_doc)
  end

  def update(patient_doc)
    raise ArgumentError, 'Patient document cannot be nil.' if patient_doc.nil?
    @client[:patient].update_one({'_id' => patient_doc['_id']}, patient_doc)
  end

end