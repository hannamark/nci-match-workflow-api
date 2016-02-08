require "#{File.dirname(__FILE__)}/../../../app/model/patient"

RSpec.describe Patient, '#add_prior_drugs' do
  # Implement unit tests
end

RSpec.describe Patient, '#add_patient_trigger' do
  # Implement unit tests
end

RSpec.describe Patient, '#set_rejoin_date' do
  # Implement unit tests
end

RSpec.describe Patient, '#get_rejoin_message' do
  it 'should return default rejoin message' do
    expectedmessage = 'Notified by ECOG that the patient has rejoined the study.'

    message = Patient.new().get_rejoin_message()
    expect(message).to eq(expectedmessage)
  end

  it 'should return rejoin message with prior drugs' do
    priorRejoinDrugs = ['Drug1', 'Drug2']
    expectedmessage = 'Notified by ECOG that the patient has rejoined the study.'
    # expectedmessage = "Notified by ECOG that the patient has rejoined the study. Previous drugs:  #{priorRejoinDrugs}"

    patient = Patient.new()
    # patient.add_prior_drugs(priorRejoinDrugs)
    message = patient.get_rejoin_message()
    expect(message).to eq(expectedmessage)
  end

end