require "#{File.dirname(__FILE__)}/../dto/pending_variant_report"
require "#{File.dirname(__FILE__)}/../dto/pending_patient_assignment"

class PatientDao
  def self.get_patients_with_pending_variant_report
    formatted_patients = []
    begin
      patients = Patient.where('biopsies.nextGenerationSequences.status' => 'PENDING')
      patients.each do | patient |
        formatted = PendingVariantReport.new.create(patient)
        formatted_patients << formatted
      end
    rescue => e
      WorkflowLogger.logger.error "Patient | Error occurred while getting patients with pending variant report: #{e.message}"
      raise e
    end

    formatted_patients.to_json
    formatted_patients
  end

  def self.get_patients_with_pending_patient_assignment
    formatted_patients = []
    begin
      patients = Patient.or([{"currentPatientStatus" => "PENDING_CONFIRMATION"}, {"currentPatientStatus" => "POTENTIAL_RULES_ISSUE"}])

      patients.each do | patient |
        formatted_patient = PendingPatientAssignment.new.create(patient)
        formatted_patients << formatted_patient
      end
    rescue => e
      puts e.message
    end

    formatted_patients
  end
end