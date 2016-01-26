
class PendingVariantReport
  attr_accessor :patientSequenceNumber,
                :biopsySequenceNumber,
                :currentPatientStatus,
                :specimenReceivedDate,
                :molecularSequenceNumber,
                :jobName,
                :ngsStatus,
                :ngsDateReceived,
                :daysPending,
                :location

  def create(db_patient)
    @patientSequenceNumber = db_patient[:patientSequenceNumber]
    @currentPatientStatus = db_patient[:currentPatientStatus]

    biopsy, ngs = get_biopsy_with_pending_variant_report(db_patient[:biopsies])

    @biopsySequenceNumber = biopsy[:biopsySequenceNumber] if (!biopsy.nil?)
    @specimenReceivedDate = find_specimen_received_date(biopsy) if (!biopsy.nil?)

    @molecularSequenceNumber = ngs[:ionReporterResults][:molecularSequenceNumber] if (!ngs.nil?)
    @ngsStatus = ngs[:status] if (!ngs.nil?)
    @jobName = ngs[:ionReporterResults][:jobName] if (!ngs.nil?)
    @ngsDateReceived = ngs[:dateReceived] if (!ngs.nil?)

    @daysPending = (Time.parse(DateTime.now.to_s).to_i - Time.parse(@ngsDateReceived.to_s).to_i.to_i) / 60 / 60 / 24
    @location = get_nucleic_acids_shipping_location(biopsy, @molecularSequenceNumber) if (!biopsy.nil?)

    self
  end

  def get_nucleic_acids_shipping_location(biopsy, molecularSequenceNumber)
    location = ''
    mdaMessages = biopsy[:mdAndersonMessages]
    mdaMessages.each do | message |
      if (message[:message] == 'NUCLEIC_ACID_SENDOUT' && message[:molecularSequenceNumber] == molecularSequenceNumber)
        location = message[:destination]
        break
      end

    end
    location
  end

  def find_specimen_received_date(biopsy)
    received_date = nil
    mdaMessages = biopsy[:mdAndersonMessages]
    mdaMessages.each do | message |
      received_date = message[:reportedDate] if (message[:message] == 'SPECIMEN_RECEIVED')
    end

    received_date
  end

  def get_biopsy_with_pending_variant_report(biopsies)
    biopsy_found = nil
    ngs_found = nil
    biopsies.each do | biopsy |
      ngs = biopsy[:nextGenerationSequences]
      next if (ngs.length == 0)

      biopsy_found = biopsy if (ngs[-1][:status] == 'PENDING')
      ngs_found = ngs[-1] if !biopsy_found.nil?
      break if !biopsy_found.nil?
    end
    [biopsy_found, ngs_found]
  end

  # def get_newest_registration_or_progression_rebiopsy_patient_trigger(patient_triggers)
  #   newest = nil
  #
  #   patient_triggers.each do | trigger |
  #     newest = trigger if ((trigger[:patientStatus] == 'REGISTRATION') || (trigger[:patientStatus] == 'PROGRESSION_REBIOPSY'))
  #   end
  #
  #   newest
  # end
end