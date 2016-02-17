require 'factory_girl'

FactoryGirl.define do

  factory :patientEmpty, class: Patient do
    patientSequenceNumber ""
    currentPatientStatus ""
    currentStepNumber ""
    patientRejoinTriggers []
    patientTriggers []
    priorDrugs []
  end

  factory :patientWithData, class: Patient do
    patientSequenceNumber "211re"
    currentPatientStatus "REJOIN"
    currentStepNumber "2"
    patientRejoinTriggers []
    patientTriggers []
    priorDrugs [:drugs => [{:drugId => "", :name => "Afatinib"}]]
  end

  factory :patientNull, class: Patient do
    patientSequenceNumber nil
    currentPatientStatus nil
    currentStepNumber nil
    patientRejoinTriggers nil
    patientTriggers nil
    priorDrugs nil
  end

end