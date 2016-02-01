require 'logger'

require "#{File.dirname(__FILE__)}/lib/simulate_assignment_analyzer"
require "#{File.dirname(__FILE__)}/lib/command_line_helper"
require "#{File.dirname(__FILE__)}/lib/config_loader"
require "#{File.dirname(__FILE__)}/lib/ecog_api_client"
require "#{File.dirname(__FILE__)}/lib/eligible_patient_selector"
require "#{File.dirname(__FILE__)}/lib/match_api_client"
require "#{File.dirname(__FILE__)}/lib/patient_dao"

clh = CommandLineHelper.new
cl = ConfigLoader.new(clh.options[:configPath], clh.options[:environment])

dirname = File.dirname(cl.config['log_filepath'])
FileUtils.mkdir_p dirname unless File.exist?(dirname)

logger = Logger.new(cl.config['log_filepath'], 3, 100 * 1024 * 1024)
Mongo::Logger.logger = logger

logger.level = cl.config['log_level']
Mongo::Logger.logger.level = logger.level

logger.info('========== Starting Patient Rejoin Matchbox Scanner ==========')
logger.info('SCANNER | Log file written to log/patient_rejoin_matchbox_scanner.log.')

begin
  logger.info("SCANNER | Command line options received #{clh.options}")
  logger.debug("SCANNER | Database configuration #{cl.redacted_config['database']}")
  logger.debug("SCANNER | Match API configuration #{cl.redacted_config['match_api']}")
  logger.debug("SCANNER | ECOG API configuration #{cl.redacted_config['ecog_api']}")

  dao = PatientDao.new(cl.config)
  off_trial_patients = dao.get_patient_by_status('OFF_TRIAL_NO_TA_AVAILABLE')

  logger.info("SCANNER | Patients who are off trial without a treatment arm assignment #{off_trial_patients['off_trial_patients']}.")

  match_api = MatchAPIClient.new(cl.config)

  eligible_patients = { :patient_sequence_numbers => [], :patient_docs => [] }
  off_trial_patients['off_trial_patients'].each_with_index do |off_trial_patient, index|
    begin
      logger.info("SCANNER | Simulating assignment for patient #{off_trial_patient} ...")
      assignment_results = match_api.simulate_patient_assignment(off_trial_patient[:patient_sequence_number], off_trial_patient[:analysis_id])
      logger.debug("SCANNER | Simulating assignment for patient #{off_trial_patient} completed with results #{assignment_results[:results]}")

      is_eligible, patient_doc = SimulateAssignmentAnalyzer.new(off_trial_patients['off_trial_patients_docs'][index], assignment_results).analyze
      if is_eligible
        logger.info("SCANNER | Simulation found patient #{patient_doc} is eligible to rejoin trial.")
        eligible_patients[:patient_sequence_numbers].push(patient_doc[:patientSequenceNumber])
        eligible_patients[:patient_docs].push(patient_doc)
      else
        logger.info("SCANNER | Simulation did not find an eligible arm for patient #{patient_doc[:patientSequenceNumber]}.")
      end

      if clh.options[:print].nil?
        if dao.update(patient_doc).n == 1
          logger.info("SCANNER | Saved simulation analysis for patient #{patient_doc[:patientSequenceNumber]}.")
        else
          logger.info("SCANNER | Failed to save simulation analysis for patient #{patient_doc[:patientSequenceNumber]}.")
        end
      end
    rescue => error
      logger.error("SCANNER | Failed to simulate assignment for patient #{off_trial_patient}. Message: '#{error}'")
      logger.error 'SCANNER | Printing backtrace:'
      error.backtrace.each do |line|
        logger.error "SCANNER |   #{line}"
      end
    end
  end

  if clh.options[:print].nil?
    if eligible_patients[:patient_sequence_numbers].size > 0
      logger.info("SCANNER | Sending ECOG patient(s) #{eligible_patients[:patient_sequence_numbers]} eligible to rejoin Matchbox ...")
      ecog_api = EcogAPIClient.new(cl.config)
      ecog_api.send_patient_eligible_for_rejoin(eligible_patients[:patient_sequence_numbers])
      logger.info("SCANNER | Sending ECOG patient(s) #{eligible_patients[:patient_sequence_numbers]} eligible to rejoin Matchbox complete.")

      eligible_patients[:patient_docs].each do |patient_doc|
        logger.info("SCANNER | Adding/Updating patient #{patient_doc[:patientSequenceNumber]} rejoin trigger #{patient_doc[:patientRejoinTriggers][patient_doc[:patientRejoinTriggers].size - 1]} ...")
        patient_doc[:patientRejoinTriggers][patient_doc[:patientRejoinTriggers].size - 1][:dateSentToECOG] = DateTime.now
        if dao.update(patient_doc).n == 1
          logger.info("SCANNER | Saved date rejoin message sent to ECOG for patient #{patient_doc[:patientSequenceNumber]}.")
        else
          logger.info("SCANNER | Failed to save date rejoin message sent to ECOG for patient  #{patient_doc[:patientSequenceNumber]}.")
        end
      end
    end
  else
    logger.info('SCANNER | Print mode was detected so logging all patient(s) eligible for rejoin ...')
    if eligible_patients[:patient_sequence_numbers].size > 0
      eligible_patients[:patient_docs].each do |patient_doc|
        logger.info("SCANNER | Patient #{patient_doc['patientSequenceNumber']} is eligible to rejoin Matchbox.")
      end
    else
      logger.info('SCANNER | No patients were found to be eligible to rejoin Matchbox.')
    end
  end
rescue => error
  logger.error("SCANNER | Failed to complete scan because an exception was thrown. Message: '#{error}'")
  logger.error 'SCANNER | Printing backtrace:'
  error.backtrace.each do |line|
    logger.error "SCANNER |   #{line}"
  end
end

logger.info('========== Patient Rejoin Matchbox Scanner Complete ==========')