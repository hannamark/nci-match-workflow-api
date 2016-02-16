require "#{File.dirname(__FILE__)}/../../../app/model/patient"

RSpec.describe Patient do

  context '#add_prior_drugs' do
    it 'should add prior_drugs to a patient'
    it 'should return empty since patient is empty' do
      patient = create(:patientEmpty)
      patient.add_prior_drugs(patient[:priorDrugs])
    end
  end


  context '#add_patient_trigger' do
    it 'should add patient_trigger to patient data'
  end

 context '#set_rejoin_date' do
    it 'should set join_date for a patient'
 end
end
