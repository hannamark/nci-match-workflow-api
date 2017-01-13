require "#{File.dirname(__FILE__)}/../../../scripts/PatientRejoinMatchboxScanner/lib/simulate_assignment_analyzer"

RSpec.describe SimulateAssignmentAnalyzer, '#analyze' do

  context 'simulated assignment have no eligible arms and patient rejoin trigger is empty' do
    it 'should return false and the updated patient object contains a new rejoin trigger' do
      off_trial_patient = {
        'patientTriggers' => [],
        'patientRejoinTriggers' => []
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
      expect(updated_off_trial_patient['patientRejoinTriggers'].size).to eq(1)
      expect(updated_off_trial_patient['patientRejoinTriggers'][0]['eligibleArms'].size).to eq(0)
    end
  end

  context 'simulated assignment have no eligible arms and the latest patient rejoin trigger contains no eligible arms' do
    it 'should return false and the latest rejoin trigger scanned date should be updated' do
      off_trial_patient = {
          'patientTriggers' => [],
          'patientRejoinTriggers' => [{
            'eligibleArms' => [],
            'dateScanned' => DateTime.now
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
      expect(updated_off_trial_patient['patientRejoinTriggers'].size).to eq(1)
      expect(updated_off_trial_patient['patientRejoinTriggers'][0]['eligibleArms'].size).to eq(0)
    end
  end

  context 'simulated assignment have no eligible arms and the latest patient rejoin trigger contains a eligible arm' do
    it 'should return false and the updated patient object contains a new rejoin trigger' do
      off_trial_patient = {
          'patientTriggers' => [],
          'patientRejoinTriggers' => [{
            'eligibleArms' => [{
              'treatmentArmId' => 'ArmB',
              'treatmentArmVersion' => 'v1'
            }],
            'dateScanned' => DateTime.now
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
      expect(updated_off_trial_patient['patientRejoinTriggers'].size).to eq(2)
      expect(updated_off_trial_patient['patientRejoinTriggers'][1]['eligibleArms'].size).to eq(0)
    end
  end

  context 'simulated assignment have eligible arms and the latest patient trigger is empty' do
    it 'should return true and the updated patient object contains a new rejoin trigger' do
      off_trial_patient = {
          'patientTriggers' => [],
          'patientRejoinTriggers' => []
      }

      assignment_results = {
          'results' => [
              {
                  'treatmentArmId' => 'ArmA',
                  'treatmentArmVersion' => 'v1',
                  'reasonCategory' => 'SELECTED'
              }
          ]
      }

      analyzer = SimulateAssignmentAnalyzer.new(off_trial_patient, assignment_results)
      is_eligible, updated_off_trial_patient = analyzer.analyze
      expect(is_eligible).to eq(true)
      expect(updated_off_trial_patient['patientRejoinTriggers'].size).to eq(1)
      expect(updated_off_trial_patient['patientRejoinTriggers'][0]['eligibleArms'].size).to eq(1)
    end
  end

  context 'simulated assignment have eligible arms and the latest patient trigger contains no eligible arms' do
    it 'should return true and the updated patient object contains a new rejoin trigger' do
      off_trial_patient = {
          'patientTriggers' => [],
          'patientRejoinTriggers' => [{
            'eligibleArms' => [],
            'dateScanned' => DateTime.now
          }]
      }

      assignment_results = {
          'results' => [
              {
                  'treatmentArmId' => 'ArmA',
                  'treatmentArmVersion' => 'v1',
                  'reasonCategory' => 'SELECTED'
              }
          ]
      }

      analyzer = SimulateAssignmentAnalyzer.new(off_trial_patient, assignment_results)
      is_eligible, updated_off_trial_patient = analyzer.analyze
      expect(is_eligible).to eq(true)
      expect(updated_off_trial_patient['patientRejoinTriggers'].size).to eq(2)
      expect(updated_off_trial_patient['patientRejoinTriggers'][1]['eligibleArms'].size).to eq(1)
    end
  end

  context 'simulated assignment have eligible arms and the latest patient trigger contains a rejoined date' do
    it 'should return true and the updated patient object contains a new rejoin trigger' do
      off_trial_patient = {
          'patientTriggers' => [],
          'patientRejoinTriggers' => [{
            'eligibleArms' => [{
              'treatmentArmId' => 'ArmB',
              'treatmentArmVersion' => 'v1'
            }],
            'dateScanned' => DateTime.now,
            'dateSentToECOG' => DateTime.now,
            'dateRejoined' => DateTime.now
          }]
      }

      assignment_results = {
          'results' => [
              {
                  'treatmentArmId' => 'ArmA',
                  'treatmentArmVersion' => 'v1',
                  'reasonCategory' => 'SELECTED'
              }
          ]
      }

      analyzer = SimulateAssignmentAnalyzer.new(off_trial_patient, assignment_results)
      is_eligible, updated_off_trial_patient = analyzer.analyze
      expect(is_eligible).to eq(true)
      expect(updated_off_trial_patient['patientRejoinTriggers'].size).to eq(2)
      expect(updated_off_trial_patient['patientRejoinTriggers'][1]['eligibleArms'].size).to eq(1)
    end
  end

  context 'simulated assignment found different eligible arms and the latest patient trigger does not have date rejoined' do
    it 'should return true and the updated patient object contains a new rejoin trigger' do
      off_trial_patient = {
          'patientTriggers' => [],
          'patientRejoinTriggers' => [{
            'eligibleArms' => [{
              'treatmentArmId' => 'ArmA',
              'treatmentArmVersion' => 'v1'
            }],
            'dateScanned' => DateTime.now,
            'dateSentToECOG' => DateTime.now
          }]
      }

      assignment_results = {
          'results' => [
              {
                  'treatmentArmId' => 'ArmA',
                  'treatmentArmVersion' => 'v2',
                  'reasonCategory' => 'SELECTED'
              }
          ]
      }

      analyzer = SimulateAssignmentAnalyzer.new(off_trial_patient, assignment_results)
      is_eligible, updated_off_trial_patient = analyzer.analyze
      expect(is_eligible).to eq(true)
      expect(updated_off_trial_patient['patientRejoinTriggers'].size).to eq(2)

      eligible_arms = updated_off_trial_patient['patientRejoinTriggers'][1]['eligibleArms'][0]
      expect(eligible_arms['treatmentArmId']).to eq('ArmA')
      expect(eligible_arms['treatmentArmVersion']).to eq('v2')
    end
  end

  context 'simulated assignment did not find different eligible arms and the latest patient trigger does not have date rejoined' do
    it 'should return true and the latest rejoin trigger scanned date should be updated' do
      off_trial_patient = {
          'patientTriggers' => [],
          'patientRejoinTriggers' => [{
            'eligibleArms' => [{
              'treatmentArmId' => 'ArmA',
              'treatmentArmVersion' => 'v1'
            }],
            'dateScanned' => DateTime.now,
            'dateSentToECOG' => DateTime.now
          }]
      }

      assignment_results = {
          'results' => [
              {
                  'treatmentArmId' => 'ArmA',
                  'treatmentArmVersion' => 'v1',
                  'reasonCategory' => 'SELECTED'
              }
          ]
      }

      analyzer = SimulateAssignmentAnalyzer.new(off_trial_patient, assignment_results)
      is_eligible, updated_off_trial_patient = analyzer.analyze
      expect(is_eligible).to eq(true)
      expect(updated_off_trial_patient['patientRejoinTriggers'].size).to eq(1)
    end
  end

end