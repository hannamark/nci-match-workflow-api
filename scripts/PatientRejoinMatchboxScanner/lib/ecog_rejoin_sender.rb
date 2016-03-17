require "#{File.dirname(__FILE__)}/ecog_api_client"

class EcogRejoinSender

  @ecog_username_key = 'ecog.post.patient.rerun.username'
  @ecog_password_key = 'ecog.post.patient.rerun.password'

  def initialize(logger, config)
    @logger = logger
    @config = config
  end

  def send(eligible_patients)
    @logger.info("SCANNER | Sending ECOG patient(s) #{eligible_patients[:patient_sequence_numbers]} eligible to rejoin Matchbox ...")
    matchPropertyDao = MatchPropertiesMessageDao.new(@config)
    EcogAPIClient.new(@config, matchPropertyDao.get_value(@ecog_username_key), matchPropertyDao.get_value(@ecog_password_key))
        .send_patient_eligible_for_rejoin(eligible_patients[:patient_sequence_numbers])
    @logger.info("SCANNER | Sending ECOG patient(s) #{eligible_patients[:patient_sequence_numbers]} eligible to rejoin Matchbox complete.")
    save(eligible_patients)
  end

  def save(eligible_patients)
    dao = PatientDao.new(@config)
    eligible_patients[:patient_docs].each do |patient_doc|
      @logger.info("SCANNER | Adding/Updating patient #{patient_doc[:patientSequenceNumber]} rejoin trigger #{patient_doc[:patientRejoinTriggers][patient_doc[:patientRejoinTriggers].size - 1]} ...")
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
        @logger.info("SCANNER | Saved date rejoin message sent to ECOG for patient #{patient_doc[:patientSequenceNumber]}.")
      else
        @logger.info("SCANNER | Failed to save date rejoin message sent to ECOG for patient  #{patient_doc[:patientSequenceNumber]}.")
      end
    end
  end

  private :save

end