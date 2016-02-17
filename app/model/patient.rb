require 'mongoid'

require "#{File.dirname(__FILE__)}/../util/drug_combo_helper"


class Patient
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  store_in collection: 'patient'

  field :patientSequenceNumber, type: String
  field :currentPatientStatus, type: String
  field :currentStepNumber, type: String
  field :patientRejoinTriggers, type: Array
  field :patientTriggers, type: Array
  field :priorDrugs, type: Array

  @message = " "

  def add_prior_drugs(priorRejoinDrugs)
    if !priorRejoinDrugs.blank?
      updated_prior_drugs = []
      priorRejoinDrugs.each do |drugCombo|
        updated_prior_drugs.push(drugCombo) if !DrugComboHelper.exist_in_drug_combo_list(self[:priorDrugs], drugCombo)
        # @message += drugCombo[:drugs] + ", "
      end
      self[:priorDrugs] = self[:priorDrugs] + updated_prior_drugs
    end
    self
  end

  def add_patient_trigger(status)
    # message = get_rejoin_message
    message = "Prior to rejoin drugs: #{@message}"
    self[:currentPatientStatus] = status
    self[:patientTriggers] += [{
            studyId: 'EAY131',
            patientSequenceNumber: self[:patientSequenceNumber],
            stepNumber: self[:currentStepNumber],
            patientStatus: status,
            message: message,
            dateCreated: DateTime.now,
            auditDate: DateTime.now
        }]
    self
  end

  def set_rejoin_date
    rejoin_trigger = self[:patientRejoinTriggers][self[:patientRejoinTriggers].size - 1]
    rejoin_trigger[:dateRejoined] = DateTime.now
    self[:patientRejoinTriggers].pop
    self[:patientRejoinTriggers] += [{
        'eligibleArms': rejoin_trigger[:eligibleArms],
        'dateScanned': rejoin_trigger[:dateScanned],
        'dateSentToECOG': rejoin_trigger[:dateSentToECOG],
        'dateRejoined': rejoin_trigger[:dateRejoined]
    }]
    self
  end

  # private
  # def get_rejoin_message()
  #   @message ||= 'No drugs prior to rejoin.'
  #   # counter = 0
  #
  #   # if !self[:priorRejoinDrugs].blank?
  #   #   drugList ||= ""
  #   #   self[:priorRejoinDrugs].each do | drugs |
  #   #     drugs[:drugs].each do | details |
  #   #       if counter > 0
  #   #         drugList << ", "
  #   #       end
  #   #       drugList << details[:drugId] + " " + details[:name]
  #   #       ++counter
  #   #     end
  #   #   end
  #   #   message = "Prior to rejoin drugs: #{drugList}"
  #   # end
  #   message
  # end
end
