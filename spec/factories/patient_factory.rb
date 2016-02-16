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

end