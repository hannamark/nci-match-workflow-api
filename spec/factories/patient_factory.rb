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

  factory :patientNull, class: Patient do
    patientSequenceNumber nil
    currentPatientStatus nil
    currentStepNumber nil
    patientRejoinTriggers nil
    patientTriggers nil
    priorDrugs nil
  end

end