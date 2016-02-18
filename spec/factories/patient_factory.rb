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
    patientRejoinTriggers [{ 'eligibleArms' => [{
                                                    'treatmentArmId' => "rejoinTest7",
                                                    'treatmentArmVersion' => "2016-02-01",
                                                    'reason' => "The patient and treatment arm match on variant identifier [COSM901].",
                                                    'reasonCategory' => "SELECTED"
                                                },
                                                {
                                                    'treatmentArmId' => "rejoinTest8",
                                                    'treatmentArmVersion' => "2016-02-01",
                                                    'reason' => "The patient and treatment arm match on variant identifier [COSM1001].",
                                                    'reasonCategory' => "SELECTED"
                                                }],
                             'dateScanned' => Time.now - 10.seconds,
                             'dateSentToECOG' => Time.now - 10.seconds
                           }]
    patientTriggers []
    priorDrugs [{'drugs' => [{
                                'drugId' => "781450",
                                'name' => "VS-6063 (Defactinib)",
                                'drugClass' => "NF2 Loss",
                                'target' => "NF2"
                            }]},
                'drugs' => [{
                               'drugId' => "",
                               'name' => "Afatinib",
                               'drugClass' => "",
                               'target' => ""
                           }]]
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