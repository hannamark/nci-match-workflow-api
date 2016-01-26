require 'mongoid'

require "#{File.dirname(__FILE__)}/../util/drug_combo_helper"
require "#{File.dirname(__FILE__)}/../dto/pending_variant_report"

class Patient
  include Mongoid::Document
  store_in collection: 'patient'

  field :patientSequenceNumber, type: String
  field :currentPatientStatus, type: String
  field :currentStepNumber, type: String
  field :patientRejoinTriggers, type: Array
  field :patientTriggers, type: Array
  field :priorDrugs, type: Array

  def add_prior_drugs(priorDrugs)
    if !priorDrugs.nil? && priorDrugs.size > 0
      updated_prior_drugs = []
      priorDrugs.each do |drugCombo|
        updated_prior_drugs.push(drugCombo) if !DrugComboHelper.exist_in_drug_combo_list(self['priorDrugs'], drugCombo)
      end
      self['priorDrugs'] = self['priorDrugs'] + updated_prior_drugs
    end
    self
  end

  def add_patient_trigger(status)
    self['currentPatientStatus'] = status
    self['patientTriggers'] += [{
            studyId: 'EAY131',
            patientSequenceNumber: self['patientSequenceNumber'],
            stepNumber: self['currentStepNumber'],
            patientStatus: status,
            message: 'Notified by ECOG that the patient has rejoined the study.',
            dateCreated: DateTime.now,
            auditDate: DateTime.now
        }]
    self
  end

  # def set_rejoin_date
  #   rejoin_trigger = self['patientRejoinTriggers'][self['patientRejoinTriggers'].size - 1]
  #   rejoin_trigger['dateRejoined'] = DateTime.now
  #   self['patientRejoinTriggers'].pop
  #   self['patientRejoinTriggers'] += [{
  #       'treatmentArmId': rejoin_trigger['treatmentArmId'],
  #       'treatmentArmVersion': rejoin_trigger['treatmentArmVersion'],
  #       'assignmentReason': rejoin_trigger['assignmentReason'],
  #       'dateScanned': rejoin_trigger['dateScanned'],
  #       'dateSentToECOG': rejoin_trigger['dateSentToECOG'],
  #       'dateRejoined': rejoin_trigger['dateRejoined']
  #   }]
  #   self
  # end

  def self.get_patients_with_pending_variant_report
    formatted_patients = []
    begin
      patients = Patient.where('biopsies.nextGenerationSequences.status' => 'PENDING')
      patients.each do | patient |
        formatted = PendingVariantReport.new.create(patient)
        formatted_patients << formatted
      end
    rescue => e
      WorkflowLogger.logger.error "Patient | Error occurred while getting patients with pending variant report: #{e.message}"
      raise e
    end

    formatted_patients.to_json
    formatted_patients
  end

  # def self.get_patients_with_pending_patient_assignment
  #   formatted_patients = []
  #   begin
  #     patients = Patient.where('currentPatientStatus'.in => ['PENDING_CONFIRMATION', 'POTENTIAL_RULES_ISSUE'])
  #
  #     message = 'done'
  #
  #   rescue => e
  #     puts e.message
  #   end
  #
  #   formatted_patients
  # end

end
