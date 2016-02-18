require "#{File.dirname(__FILE__)}/../../../app/model/patient"

RSpec.describe Patient do

  context '#add_prior_drugs' do

    it 'should add prior_drugs to a patient' do
      patient = create(:patientEmpty)
      priorRejoinDrugs = [{'drugs' => [{'drugId' => "", 'name' => "Afatinib"}]}]
      expect(patient).to be(patient.add_prior_drugs(priorRejoinDrugs))
    end

    it 'should not add another drug if it already exists' do
      patient = create(:patientWithData)
      expect(patient).to be(patient.add_prior_drugs([{'drugs' => [{'drugId' => "", 'name' => "Afatinib"}]}]))
    end

    it 'should return empty since patient is empty' do
      patient = create(:patientEmpty)
      expect(patient).to be(patient.add_prior_drugs(patient[:priorDrugs]))
    end
  end


  context '#add_patient_trigger' do
    it 'should add patient_trigger to patient data'
  end

 context '#set_rejoin_date' do
    it 'should set join_date for a patient' do
      patient = create(:patientWithData)
      patient.set_rejoin_date
      expect(patient[:patientRejoinTriggers][0][:dateRejoined]).to be_truthy
      expect(patient).to be(patient.set_rejoin_date)
    end
 end
end
