require "#{File.dirname(__FILE__)}/../../../scripts/PatientRejoinMatchboxScanner/lib/eligible_patient_selector"

RSpec.describe EligiblePatientSelector, '.get_eligible_arms' do
  context 'with a nil value' do
    it 'should return a nil value' do
      expect(EligiblePatientSelector.get_eligible_arms(nil)).to eq([])
    end
  end

  context 'without the results key in the associative array' do
    it 'should return a nil value' do
      expect(EligiblePatientSelector.get_eligible_arms({ 'result' => [] })).to eq([])
    end
  end

  context 'with no arm selected for the patient' do
    it 'should return a nil value' do
      expect(EligiblePatientSelector.get_eligible_arms({ 'results' => [ { 'reasonCategory' => 'NO_VARIANT_MATCH' }, { 'reasonCategory' => 'ARM_NOT_OPEN' } ] })).to eq([])
    end
  end

  context 'with an arm selected for the patient' do
    it 'should return the arm selected' do
      assignment_results = { 'results' => [ { 'treatmentArmId' => 'Arm1',  'reasonCategory' => 'SELECTED' }, { 'treatmentArmId' => 'Arm2', 'reasonCategory' => 'SELECTED' }, { 'treatmentArmId' => 'Arm3', 'reasonCategory' => 'ARM_NOT_OPEN' } ] }
      eligible_arms = EligiblePatientSelector.get_eligible_arms(assignment_results)
      expect(eligible_arms.size).to eq(2)
      expect(eligible_arms[0]['treatmentArmId']).to eq('Arm1')
      expect(eligible_arms[1]['treatmentArmId']).to eq('Arm2')
    end
  end
end

RSpec.describe EligiblePatientSelector, '.is_eligible_arms_list_equal' do
  context 'with the eligible arms and other eligible arms nil' do
    it 'should return true' do
      expect(EligiblePatientSelector.is_eligible_arms_list_equal(nil, nil)).to eq(true)
    end
  end

  context 'with one nil parameter and the other not' do
    it 'should return false' do
      expect(EligiblePatientSelector.is_eligible_arms_list_equal(nil, [])).to eq(false)
      expect(EligiblePatientSelector.is_eligible_arms_list_equal([], nil)).to eq(false)
    end
  end

  context 'with the eligible arms and other eligible arms size different' do
    it 'should return false' do
      expect(EligiblePatientSelector.is_eligible_arms_list_equal([{}], [{}, {}])).to eq(false)
    end
  end

  context 'with the eligible arms and other eligible arms not matching' do
    it 'should return false' do
      expect(EligiblePatientSelector.is_eligible_arms_list_equal([{'treatmentArmId' => 'ArmA', 'treatmentArmVersion' => 'v1'}, {'treatmentArmId' => 'ArmB', 'treatmentArmVersion' => 'v1'}], [{'treatmentArmId' => 'ArmA', 'treatmentArmVersion' => 'v1'}, {'treatmentArmId' => 'ArmC', 'treatmentArmVersion' => 'v1'}])).to eq(false)
      expect(EligiblePatientSelector.is_eligible_arms_list_equal([{'treatmentArmId' => 'ArmA', 'treatmentArmVersion' => 'v1'}, {'treatmentArmId' => 'ArmB', 'treatmentArmVersion' => 'v1'}], [{'treatmentArmId' => 'ArmA', 'treatmentArmVersion' => 'v1'}, {'treatmentArmId' => 'ArmB', 'treatmentArmVersion' => 'v2'}])).to eq(false)
    end
  end

  context 'with the eligible arms and other eligible arms matching' do
    it 'should return true' do
      expect(EligiblePatientSelector.is_eligible_arms_list_equal([{'treatmentArmId' => 'ArmA', 'treatmentArmVersion' => 'v1'}, {'treatmentArmId' => 'ArmB', 'treatmentArmVersion' => 'v1'}], [{'treatmentArmId' => 'ArmA', 'treatmentArmVersion' => 'v1'}, {'treatmentArmId' => 'ArmB', 'treatmentArmVersion' => 'v1'}])).to eq(true)
    end
  end
end