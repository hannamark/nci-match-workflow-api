require "#{File.dirname(__FILE__)}/../../../scripts/PatientRejoinMatchboxScanner/lib/patient_dao"

class PatientCollection
  def initialize
    @patients = []
    @update_result = 1
  end

  def patients(patients)
    @patients = patients
  end

  def update_one(query, doc)
    @update_result
  end

  def find(query)
    @patients
  end
end

class PatientCreator
  def self.create_eligible_patients(num, current_patient_status)
    patients = []
    for i in 0...num
      patients.push({
          'patientSequenceNumber' => i.to_s,
          'currentPatientStatus' => current_patient_status,
          'currentStepNumber' => '0',
          'biopsies' => [{
              'nextGenerationSequences' => [{
                  'status' => 'CONFIRMED',
                  'ionReporterResults' => {
                      'jobName' => "jobName#{i}"
                  }
              }],
              'mdAndersonMessages' => [{
                      'reportedDate' => Time.now.utc,
                      'message' => 'SPECIMEN_RECEIVED'
              }]
          }]
      })
    end
    patients
  end

  def self.create_noneligible_patients
    patients = []

    # Patient is not on step 0
    patients.push({
        'patientSequenceNumber' => '123',
        'currentPatientStatus' => 'OFF_TRIAL_NO_TA_AVAILABLE',
        'currentStepNumber' => '2',
        'biopsies' => [
            {
                'nextGenerationSequences' => [
                    {
                        'status' => 'CONFIRMED',
                        'ionReporterResults' => { 'jobName' => 'jobName456' }
                    }
                ],
                'mdAndersonMessages' => [
                    {

                        'reportedDate' => Time.now.utc,
                        'message' => 'SPECIMEN_RECEIVED'

                    }
                ]

            }
        ]
    })

    # Patient does not have a biopsy exist
    patients.push({
        'patientSequenceNumber' => '234',
        'currentPatientStatus' => 'OFF_TRIAL_NO_TA_AVAILABLE',
        'currentStepNumber' => '0',
        'biopsies' => []
    })

    # Patient does not have a next generation sequence
    patients.push({
        'patientSequenceNumber' => '345',
        'currentPatientStatus' => 'OFF_TRIAL_NO_TA_AVAILABLE',
        'currentStepNumber' => '0',
        'biopsies' => [
            {
                'nextGenerationSequences' => [],
                'mdAndersonMessages' => [
                    {

                        'reportedDate' => Time.now.utc,
                        'message' => 'SPECIMEN_RECEIVED'

                    }
                ]

            }
        ]
    })

    # Patient variant report is pending confirmation
    patients.push({
        'patientSequenceNumber' => '456',
        'currentPatientStatus' => 'OFF_TRIAL_NO_TA_AVAILABLE',
        'currentStepNumber' => '0',
        'biopsies' => [
            {
                'nextGenerationSequences' => [
                    {
                        'status' => 'PENDING',
                        'ionReporterResults' => { 'jobName' => 'jobName456' }
                    }
                ],
                'mdAndersonMessages' => [
                    {

                        'reportedDate' => Time.now.utc,
                        'message' => 'SPECIMEN_RECEIVED'

                    }
                ]

            }
        ]
    })

    # Patient specimen received date is beyond 6 months
    patients.push({
        'patientSequenceNumber' => '567',
        'currentPatientStatus' => 'OFF_TRIAL_NO_TA_AVAILABLE',
        'currentStepNumber' => '0',
        'biopsies' => [
            {
                'nextGenerationSequences' => [
                    {
                        'status' => 'CONFIRMED',
                        'ionReporterResults' => { 'jobName' => 'jobName456' }
                    }
                ],
                'mdAndersonMessages' => [
                    {
                        'reportedDate' => (DateTime.now << 6).to_time,
                        'message' => 'SPECIMEN_RECEIVED'
                    }
                ]
            }
        ]
    })

    patients
  end
end

RSpec.describe PatientDao, '#get_off_trial_patients' do

  before(:each) do
    @db_config = {
        'database' => {
            'hosts' => ['127.0.0.1:9000'],
            'dbname' => 'matchUnitTest'
        }
    }
  end

  context 'with patient in both the OFF_TRIAL_NO_TA_AVAILABLE and REJOIN_REQUESTED statuses' do
    it 'should return a list of eligible patients to examine' do
      eligible_patients = PatientCreator.create_eligible_patients(2, 'OFF_TRIAL_NO_TA_AVAILABLE') + PatientCreator.create_eligible_patients(1, 'REJOIN_REQUESTED')
      noneligible_patients = PatientCreator.create_noneligible_patients
      patients = eligible_patients + noneligible_patients

      collection = PatientCollection.new
      collection.patients(patients)

      allow(Mongo::Client).to receive(:new).and_return({:patient => collection})

      dao = PatientDao.new(@db_config)
      docs = dao.get_off_trial_patients
      expect(docs['off_trial_patients'].size).to be == 3
      expect(docs['off_trial_patients_docs'].size).to be == 3
    end
  end

  context 'with patient in both the OFF_TRIAL_NO_TA_AVAILABLE and REJOIN_REQUESTED statuses but using default db config' do
    it 'should return a list of eligible patients to examine' do
      eligible_patients = PatientCreator.create_eligible_patients(2, 'OFF_TRIAL_NO_TA_AVAILABLE') + PatientCreator.create_eligible_patients(1, 'REJOIN_REQUESTED')
      noneligible_patients = PatientCreator.create_noneligible_patients
      patients = eligible_patients + noneligible_patients

      collection = PatientCollection.new
      collection.patients(patients)

      allow(Mongo::Client).to receive(:new).and_return({:patient => collection})

      dao = PatientDao.new({})
      docs = dao.get_off_trial_patients
      expect(docs['off_trial_patients'].size).to be == 3
      expect(docs['off_trial_patients_docs'].size).to be == 3
    end
  end

end

RSpec.describe PatientDao, '#update' do

  before(:each) do
    @db_config = {
        'database' => {
            'hosts' => ['127.0.0.1:9000'],
            'dbname' => 'matchUnitTest'
        }
    }
  end

  context 'with a bad input parameter' do
    it 'should raise an ArgumentError' do
      allow(Mongo::Client).to receive(:new).and_return({:patient => PatientCollection.new})

      dao = PatientDao.new(@db_config)
      expect { dao.update(nil) }.to raise_error(ArgumentError)
    end
  end

  context 'with a bad input parameter' do
    it 'should raise an ArgumentError' do
      allow(Mongo::Client).to receive(:new).and_return({:patient => PatientCollection.new})

      dao = PatientDao.new(@db_config)
      result = dao.update({ '_id' => 'abcd1234' })
      expect(result).to be == 1
    end
  end

end