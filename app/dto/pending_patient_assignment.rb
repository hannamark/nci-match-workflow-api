
class PendingPatientAssignment

  attr_accessor :patientSequenceNumber,
                :biopsySequenceNumber,
                :molecularSequenceNumber,
                :jobName,
                :dateAssigned,
                :patientStatus,
                :patientCurrentStatus,
                :patientStepNumber,
                :patientConcordance,
                :hoursPending

  def create(db_patient)
    @patientSequenceNumber = db_patient[:patientSequenceNumber]
    @patientCurrentStatus = db_patient[:currentPatientStatus]
    # ??
    @patientStatus = @patientCurrentStatus
    @patientStepNumber = db_patient[:currentStepNumber]
    @patientConcordance = db_patient[:concordance]

    biopsy = db_patient[:biopsies][-1]
    @biopsySequenceNumber = biopsy[:biopsySequenceNumber]

    ngs = biopsy[:nextGenerationSequences][-1]
    @molecularSequenceNumber = ngs[:ionReporterResults][:molecularSequenceNumber]
    @jobName = ngs[:ionReporterResults][:jobName]

    patientAssignment = db_patient[:patientAssignments][-1]
    @dateAssigned = patientAssignment[:dateAssigned]
    @hoursPending = (Time.parse(DateTime.now.to_s).to_i - Time.parse(@dateAssigned.to_s).to_i.to_i) / 60 / 60

    self
  end
end