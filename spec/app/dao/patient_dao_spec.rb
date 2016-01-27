require 'rspec'

require "#{File.dirname(__FILE__)}/../../../app/model/patient"
require "#{File.dirname(__FILE__)}/../../../app/dao/patient_dao"
require "#{File.dirname(__FILE__)}/../../factories/patient_factory"
require "#{File.dirname(__FILE__)}/../../../app/util/workflow_logger"
require "#{File.dirname(__FILE__)}/../../../app/util/workflow_api_config"

describe 'PatientDao behaviour' do

  it 'should return patient with pending variant report' do

    patients = PatientFactory.one_has_confirmed_ngs_and_one_pending
    pending_patients = []
    pending_patients << patients[1]

    allow(Patient).to receive(:where).and_return(pending_patients)
    ps = PatientDao.get_patients_with_pending_variant_report
    expect(ps).not_to be_nil
    expect(ps.length).to eq(1)
  end

  it 'should return patient with pending assignment' do

    patients = PatientFactory.one_has_confirmed_ngs_and_one_pending
    patient = patients[1]
    patient.currentPatientStatus = 'PENDING_CONFIRMATION'
    pending_patients = []
    pending_patients << patient

    allow(Patient).to receive(:or).and_return(pending_patients)
    ps = PatientDao.get_patients_with_pending_patient_assignment
    expect(ps).not_to be_nil
    expect(ps.length).to eq(1)
  end
end