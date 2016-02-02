require "#{File.dirname(__FILE__)}/../../../scripts/PatientRejoinMatchboxScanner/lib/simulate_assignment_analyzer"

RSpec.describe SimulateAssignmentAnalyzer, '#analyze' do

  context 'simulated assignment have no eligible arms and patient rejoin trigger is empty' do
    it 'should return false and the updated patient object contains a new rejoin trigger' do
      off_trial_patient = {
        :patientRejoinTriggers => []
      }

      assignment_results = {
        'results' => [
          {
            'treatmentArmId' => 'ArmA',
            'treatmentArmVersion' => 'v1',
            'reasonCategory' => 'NOT_SELECTED'
          }
        ]
      }

      analyzer = SimulateAssignmentAnalyzer.new(off_trial_patient, assignment_results)
      is_eligible, updated_off_trial_patient = analyzer.analyze
      expect(is_eligible).to eq(false)
      expect(updated_off_trial_patient[:patientRejoinTriggers].size).to eq(1)
    end
  end

  context 'simulated assignment have no eligible arms and the latest patient rejoin trigger is not empty' do
    it 'should return false and the latest rejoin trigger scanned date should be updated' do
      off_trial_patient = {
          :patientRejoinTriggers => [{
            :eligibleArms => [],
            :dateScanned => DateTime.now
          }]
      }

      assignment_results = {
          'results' => [
              {
                  'treatmentArmId' => 'ArmA',
                  'treatmentArmVersion' => 'v1',
                  'reasonCategory' => 'NOT_SELECTED'
              }
          ]
      }

      analyzer = SimulateAssignmentAnalyzer.new(off_trial_patient, assignment_results)
      is_eligible, updated_off_trial_patient = analyzer.analyze
      expect(is_eligible).to eq(false)
      expect(updated_off_trial_patient[:patientRejoinTriggers].size).to eq(1)
    end
  end

  context 'simulated assignment have no eligible arms and the latest patient rejoin trigger contains a eligible arm' do
    it 'should return false and the updated patient object contains a new rejoin trigger' do
      off_trial_patient = {
          :patientRejoinTriggers => [{
            :eligibleArms => [{
              :treatmentArmId => 'ArmB',
              :treatmentArmVersion => 'v1'
            }],
            :dateScanned => DateTime.now
          }]
      }

      assignment_results = {
          'results' => [
              {
                  'treatmentArmId' => 'ArmA',
                  'treatmentArmVersion' => 'v1',
                  'reasonCategory' => 'NOT_SELECTED'
              }
          ]
      }

      analyzer = SimulateAssignmentAnalyzer.new(off_trial_patient, assignment_results)
      is_eligible, updated_off_trial_patient = analyzer.analyze
      expect(is_eligible).to eq(false)
      expect(updated_off_trial_patient[:patientRejoinTriggers].size).to eq(2)
    end
  end

end