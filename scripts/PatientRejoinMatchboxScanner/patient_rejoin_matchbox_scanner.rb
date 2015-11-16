require 'logger'

require "#{File.dirname(__FILE__)}/lib/command_line_helper"
require "#{File.dirname(__FILE__)}/lib/config_loader"
require "#{File.dirname(__FILE__)}/lib/patient_dao"
require "#{File.dirname(__FILE__)}/lib/match_api_client"
require "#{File.dirname(__FILE__)}/lib/eligible_patient_selector"
require "#{File.dirname(__FILE__)}/lib/ecog_api_client"

begin
  LOG_LEVEL = ENV['LOG_LEVEL'].nil? ? Logger::INFO : Logger.const_get(ENV['LOG_LEVEL'])
rescue
  LOG_LEVEL = Logger::INFO
end

logger = Logger.new('log/patient_rejoin_matchbox_scanner.log', 3, 100 * 1024 * 1024)
Mongo::Logger.logger = logger

logger.level = LOG_LEVEL
Mongo::Logger.logger.level = logger.level

logger.info('========== Starting Patient Rejoin Matchbox Scanner ==========')
logger.info('SCANNER | Log file written to log/patient_rejoin_matchbox_scanner.log.')

begin
  clh = CommandLineHelper.new

  logger.info("SCANNER | Command line options received #{clh.options}")

  cl = ConfigLoader.new(clh.options[:configPath], clh.options[:environment])
  logger.debug("SCANNER | Database configuration #{cl.config['database']}")
  logger.debug("SCANNER | Match API configuration #{cl.config['match_api']}")
  logger.debug("SCANNER | ECOG API configuration #{cl.config['ecog_api']}")

  dao = PatientDao.new(cl.config)
  off_trial_patients = dao.get_patient_by_status('OFF_TRIAL_NO_TA_AVAILABLE')

  logger.info("SCANNER | Patients who are off trial without a treatment arm assignment #{off_trial_patients['off_trial_patients']}.")

  match_api = MatchAPIClient.new(cl.config)

  eligible_patients = { 'patient_sequence_numbers' => [], 'patient_docs' => [] }
  off_trial_patients['off_trial_patients'].each_with_index do |off_trial_patient, index|
    begin
      logger.info("SCANNER | Simulating assignment for patient #{off_trial_patient} ...")
      assignment_results = match_api.simulate_patient_assignment(off_trial_patient[:patient_sequence_number], off_trial_patient[:analysis_id])
      logger.debug("SCANNER | Simulating assignment for patient #{off_trial_patient} completed with results #{assignment_results['results']}")
      selected_arm = EligiblePatientSelector.get_selected_arm(assignment_results)
      if !selected_arm.nil?
        logger.info("SCANNER | Simulation found a match between #{off_trial_patient} and #{selected_arm}")
        eligible_patients['patient_sequence_numbers'].push(off_trial_patient[:patient_sequence_number])

        patient_doc = off_trial_patients['off_trial_patients_docs'][index]
        if patient_doc['patientRejoinTriggers'].nil?
          patient_doc['patientRejoinTriggers'] = []
        end
        trigger = {
            'treatmentArmId' => selected_arm['treatmentArmId'],
            'treatmentArmVersion' => selected_arm['treatmentArmVersion'],
            'assignmentReason' => selected_arm['reason'],
            'dateScanned' => DateTime.now
        }
        patient_doc['patientRejoinTriggers'].push(trigger)

        eligible_patients['patient_docs'].push(off_trial_patients['off_trial_patients_docs'][index])
      else
        logger.info("SCANNER | Simulation did not find a matching arm for patient #{off_trial_patient}.");
      end
    rescue => error
      logger.error("SCANNER | Failed to simulate assignment for patient #{off_trial_patient}. Message: '#{error}'")
      logger.error 'SCANNER | Printing backtrace:'
      error.backtrace.each do |line|
        logger.error "SCANNER |   #{line}"
      end
    end
  end

  if eligible_patients['patient_sequence_numbers'].size > 0
    logger.info("SCANNER | Sending ECOG patient(s) #{eligible_patients['patient_sequence_numbers']} eligible to rejoin Matchbox ...")
    ecog_api = EcogAPIClient.new(cl.config)
    ecog_api.send_patient_eligible_for_rejoin(eligible_patients['patient_sequence_numbers'])
    logger.info("SCANNER | Sending ECOG patient(s) #{eligible_patients['patient_sequence_numbers']} eligible to rejoin Matchbox complete.")

    eligible_patients['patient_docs'].each do |patient_doc|
      logger.info("SCANNER | Adding patient #{patient_doc['patientSequenceNumber']} rejoin trigger #{patient_doc['patientRejoinTriggers'][patient_doc['patientRejoinTriggers'].size - 1]} ...")
      patient_doc['patientRejoinTriggers'][patient_doc['patientRejoinTriggers'].size - 1]['dateSentToECOG'] = DateTime.now
      result = dao.update(patient_doc)
      if result.n == 1
        logger.info("SCANNER | Adding patient rejoin trigger for patient #{patient_doc['patientSequenceNumber']} complete.")
      else
        logger.info("SCANNER | Failed to add patient rejoin trigger for patient #{patient_doc['patientSequenceNumber']} complete.")
      end
    end
  else
    logger.info('SCANNER | No patients were found to be eligible to rejoin Matchbox.')
  end
rescue => error
  logger.error("SCANNER | Failed to complete scan because an exception was thrown. Message: '#{error}'")
  logger.error 'SCANNER | Printing backtrace:'
  error.backtrace.each do |line|
    logger.error "SCANNER |   #{line}"
  end
end

logger.info('========== Patient Rejoin Matchbox Scanner Complete ==========')