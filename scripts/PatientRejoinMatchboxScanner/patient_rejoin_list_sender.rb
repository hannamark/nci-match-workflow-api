require 'logger'

require "#{File.dirname(__FILE__)}/lib/command_line_helper"
require "#{File.dirname(__FILE__)}/lib/config_loader"
require "#{File.dirname(__FILE__)}/lib/ecog_rejoin_sender"
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

logger.info('========== Starting Patient Rejoin List Sender ==========')
logger.info('SCANNER | Log file written to log/patient_rejoin_matchbox_scanner.log.')

begin
  logger.info("SCANNER | Command line options received #{clh.options}")
  logger.debug("SCANNER | Database configuration #{cl.redacted_config['database']}")
  logger.debug("SCANNER | Match API configuration #{cl.redacted_config['match_api']}")
  logger.debug("SCANNER | ECOG API configuration #{cl.redacted_config['ecog_api']}")

  # TODO: Get patient sequence numbers from input
  patient_sequence_numbers = []
  if patient_sequence_numbers.size > 0
    EcogRejoinSender.new(logger, cl.config).send(eligible_patients, false)
  end
  patient_sequence_numbers.each do |patient_sequence_number|
    logger.info "Querying database for #{patient_sequence_number} ..."
    patient_doc = dao.get(patient_sequence_number)
    logger.info patient_doc
    patient_doc[:patientRejoinTriggers][patient_doc[:patientRejoinTriggers].size - 1][:dateSentToECOG] = DateTime.now
    rejoin_requested_trigger = {
        'studyId' => 'EAY131',
        'patientSequenceNumber' => patient_doc[:patientSequenceNumber],
        'stepNumber' => patient_doc[:currentStepNumber],
        'patientStatus' => 'REJOIN_REQUESTED',
        'message' => '',
        'dateCreated' => DateTime.now,
        'dateAudited' => DateTime.now
    }
    patient_doc[:currentPatientStatus] = 'REJOIN_REQUESTED'
    if dao.add_patient_trigger(patient_doc, rejoin_requested_trigger).n == 1
      logger.info("SCANNER | Saved date rejoin message sent to ECOG for patient #{patient_doc[:patientSequenceNumber]}.")
    else
      logger.info("SCANNER | Failed to save date rejoin message sent to ECOG for patient  #{patient_doc[:patientSequenceNumber]}.")
    end
  end
rescue => error
  logger.error("SCANNER | Failed to complete scan because an exception was thrown. Message: '#{error}'")
  logger.error 'SCANNER | Printing backtrace:'
  error.backtrace.each do |line|
    logger.error "SCANNER |   #{line}"
  end
end

logger.info('========== Patient Rejoin List Sender Complete ==========')