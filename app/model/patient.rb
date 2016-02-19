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

  @message = ""
  @rejoinMessage = ""

  def add_prior_drugs(priorDrugs)
    if !priorDrugs.blank?
      @message =""
      drugCombocounter = 0
      updated_prior_drugs = []

      priorDrugs.each do |drugCombo|
        updated_prior_drugs.push(drugCombo) if !DrugComboHelper.exist_in_drug_combo_list(self['priorDrugs'], drugCombo)
        if drugCombocounter > 0
          @message <<", "
        end
        @message << "["

        drugcounter = 0
        drugCombo['drugs'].each do |drug|
          if drugcounter > 0
            @message <<", "
          end
          @message << drug['drugId'] + " " + drug['name']
          drugcounter += 1
        end
        @message << "]"
        drugCombocounter += 1
      end
      @rejoinMessage = "Prior to rejoin drugs: #{@message}"
      self['priorDrugs'] = self['priorDrugs'] + updated_prior_drugs
    else
      @rejoinMessage = 'No drugs prior to rejoin.'
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
                                   message: @rejoinMessage,
                                   dateCreated: DateTime.now,
                                   auditDate: DateTime.now
                               }]
    self
  end

  def set_rejoin_date
    rejoin_trigger = self['patientRejoinTriggers'][self['patientRejoinTriggers'].size - 1]
    rejoin_trigger['dateRejoined'] = DateTime.now
    self['patientRejoinTriggers'].pop
    self['patientRejoinTriggers'] += [{
                                         'eligibleArms': rejoin_trigger['eligibleArms'],
                                         'dateScanned': rejoin_trigger['dateScanned'],
                                         'dateSentToECOG': rejoin_trigger['dateSentToECOG'],
                                         'dateRejoined': rejoin_trigger['dateRejoined']
                                     }]
    self
  end

end