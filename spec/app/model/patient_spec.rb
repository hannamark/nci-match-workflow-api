require "#{File.dirname(__FILE__)}/../../../app/model/patient"

RSpec.describe Patient do

  context '#add_prior_drugs' do

    it 'should add prior_drugs to a patient' do
      patient = build_stubbed(:patientEmpty)
      priorRejoinDrugs = [{'drugs' => [{'drugId' => "", 'name' => "Afatinib"}]}]
      expect(patient).to be(patient.add_prior_drugs(priorRejoinDrugs))
    end

    it 'should not add another drug if it already exists' do
      patient = build_stubbed(:patientWithData)
      expect(patient).to be(patient.add_prior_drugs([{'drugs' => [{'drugId' => "", 'name' => "Afatinib"}]}]))
    end

    it 'should return empty since patient is empty' do
      patient = build_stubbed(:patientEmpty)
      expect(patient).to be(patient.add_prior_drugs(patient[:priorDrugs]))
    end
  end


  context '#add_patient_trigger' do
    it 'should add patient_trigger to patient data' do
      patient = build_stubbed(:patientWithData)
      patient.add_patient_trigger('REJOIN')
      expect(patient[:patientTriggers][-1][:patientStatus]).to eq("REJOIN")
    end

  end

  context '#set_rejoin_date' do
    it 'should set join_date for a patient' do
      patient = build_stubbed(:patientWithData)
      patient.set_rejoin_date
      expect(patient[:patientRejoinTriggers][0][:dateRejoined]).to be_truthy
      expect(patient).to be(patient.set_rejoin_date)
    end
  end
end

context '#rejoin messages' do
  it 'rejoin drug should show in rejoin message' do
    patient = build_stubbed(:patientWithData)
    priorRejoinDrugs = [{'drugs' => [{'drugId' => "12345", 'name' => "FakeDrug"}]}]
    patient.add_prior_drugs(priorRejoinDrugs)
    patient.add_patient_trigger('REJOIN')
    expect(patient[:patientTriggers][-1][:message]).to eq('Prior to rejoin drugs: [12345 FakeDrug]')
  end

  it 'rejoin drug combos should show in rejoin message as combos' do
    patient = build_stubbed(:patientWithData)
    priorRejoinDrugs = [{"drugs"=>[{"drugId"=>"763093", "name"=>"Trametinib"}, {"drugId"=>"763760", "name"=>"Dabrafenib"}]}, {"drugs"=>[{"drugId"=>"2000", "name"=>"Asprin"}]}]
    patient.add_prior_drugs(priorRejoinDrugs)
    patient.add_patient_trigger('REJOIN')
    expect(patient[:patientTriggers][-1][:message]).to eq('Prior to rejoin drugs: [763093 Trametinib, 763760 Dabrafenib], [2000 Asprin]')
  end

  it 'no rejoin drug should show no drug message' do
    patient = build_stubbed(:patientWithData)
    priorRejoinDrugs = nil
    patient.add_prior_drugs(priorRejoinDrugs)
    patient.add_patient_trigger('REJOIN')
    expect(patient[:patientTriggers][-1][:message]).to eq('No drugs prior to rejoin.')
  end

end