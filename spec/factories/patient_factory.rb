
class PatientFactory
  def self.one_has_confirmed_ngs_and_one_pending
    patients = []
    patients << Patient.new({
                                patientSequenceNumber: "202re",
                                gender: "UNKNOWN",
                                ethnicity: "UNKNOWN",
                                races: [],
                                patientRejoinTriggers: [],
                                biopsies: [
                                    {
                                        dateCreated: Time.now,
                                        biopsySequenceNumber: "N-15-00005",
                                        ptenIhcResult: "POSITIVE",
                                        nextGenerationSequences: [
                                            {
                                                ngsRunNumber: "1",
                                                dateReceived: Time.now,
                                                status: "CONFIRMED",
                                                ionReporterResults: {
                                                    jobName: "somejob1",
                                                    molecularSequenceNumber: "202_N-15-00005",
                                                    dnaBamFilePath: "/tmp/patient-202re/biopsy-N-15-00005/ngs-somejob1/IonXpress_087_rawlib.bam",
                                                    rnaBamFilePath: "/tmp/patient-202re/biopsy-N-15-00005/ngs-somejob1/IonXpress_088_rawlib.bam",
                                                    vcfFilePath: "/tmp/patient-202re/biopsy-N-15-00005/ngs-somejob1/gene-fusion.vcf"
                                                }
                                            }
                                        ],
                                        failure: false,
                                        associatedPatientStatus: "REGISTRATION"
                                    },
                                    {
                                        dateCreated: Time.now,
                                        biopsySequenceNumber: "N-15-00005",
                                        ptenIhcResult: "POSITIVE",
                                        nextGenerationSequences: [
                                            {
                                                ngsRunNumber: "1",
                                                dateReceived: Time.now,
                                                status: "CONFIRMED",
                                                ionReporterResults: {
                                                    jobName: "somejob1",
                                                    molecularSequenceNumber: "202_N-15-00005",
                                                    dnaBamFilePath: "/tmp/patient-202re/biopsy-N-15-00005/ngs-somejob1/IonXpress_087_rawlib.bam",
                                                    rnaBamFilePath: "/tmp/patient-202re/biopsy-N-15-00005/ngs-somejob1/IonXpress_088_rawlib.bam",
                                                    vcfFilePath: "/tmp/patient-202re/biopsy-N-15-00005/ngs-somejob1/gene-fusion.vcf"
                                                }
                                            }
                                        ],
                                        failure: false,
                                        associatedPatientStatus: "REGISTRATION"
                                    }
                                ],
                                currentStepNumber: "0",
                                currentPatientStatus: ["PENDING_CONFIRMATION"].sample,
                                patientAssignments: [],
                                diseases: [],
                                concordance: ["U", "Y", "N", "W"].sample,
                                priorDrugs: [],
                                exclusionCriterias: [],
                                registrationDate: Time.now
                            })

    patients << Patient.new({
                                patientSequenceNumber: "202re",
                                gender: "UNKNOWN",
                                ethnicity: "UNKNOWN",
                                races: [],
                                patientRejoinTriggers: [],
                                biopsies: [
                                    {
                                        dateCreated: Time.now,
                                        biopsySequenceNumber: "N-15-00005",
                                        ptenIhcResult: "POSITIVE",
                                        nextGenerationSequences: [
                                            {
                                                ngsRunNumber: "1",
                                                dateReceived: Time.now,
                                                status: "REJECTED",
                                                ionReporterResults: {
                                                    jobName: "somejob1",
                                                    molecularSequenceNumber: "202_N-15-00005",
                                                    dnaBamFilePath: "/tmp/patient-202re/biopsy-N-15-00005/ngs-somejob1/IonXpress_087_rawlib.bam",
                                                    rnaBamFilePath: "/tmp/patient-202re/biopsy-N-15-00005/ngs-somejob1/IonXpress_088_rawlib.bam",
                                                    vcfFilePath: "/tmp/patient-202re/biopsy-N-15-00005/ngs-somejob1/gene-fusion.vcf"
                                                }
                                            }
                                        ],
                                        failure: false,
                                        associatedPatientStatus: "REGISTRATION"
                                    },
                                    {
                                        dateCreated: Time.now,
                                        biopsySequenceNumber: "N-15-00005",
                                        ptenIhcResult: "POSITIVE",
                                        nextGenerationSequences: [
                                            {
                                                ngsRunNumber: "1",
                                                dateReceived: Time.now,
                                                status: "PENDING",
                                                ionReporterResults: {
                                                    jobName: "somejob1",
                                                    molecularSequenceNumber: "202_N-15-00005",
                                                    dnaBamFilePath: "/tmp/patient-202re/biopsy-N-15-00005/ngs-somejob1/IonXpress_087_rawlib.bam",
                                                    rnaBamFilePath: "/tmp/patient-202re/biopsy-N-15-00005/ngs-somejob1/IonXpress_088_rawlib.bam",
                                                    vcfFilePath: "/tmp/patient-202re/biopsy-N-15-00005/ngs-somejob1/gene-fusion.vcf"
                                                }
                                            }
                                        ],
                                        failure: false,
                                        associatedPatientStatus: "REGISTRATION",
                                        mdAndersonMessages: [{
                                            patientSequenceNumber: "203re",
                                            biopsySequenceNumber: "N-15-00005",
                                            reportedDate: "2016-01-20T20:20:27.000Z",
                                            status: "CONFIRMED",
                                            comment: "This is a biopsy comment.",
                                            message: "SPECIMEN_RECEIVED"
                                            }, {
                                            patientSequenceNumber: "203re",
                                            biopsySequenceNumber: "N-15-00005",
                                            reportedDate: "2016-01-20T20:20:30.199Z",
                                            status: "Y",
                                            message: "PATHOLOGY_CONFIRMATION"
                                            },
                                              {
                                            molecularSequenceNumber: "203_N-15-00005",
                                            destinationSite: "Boston",
                                            trackingNumber: "987654321",
                                            dnaConcentration: ".55",
                                            patientSequenceNumber: "203re",
                                            biopsySequenceNumber: "N-15-00005",
                                            reportedDate: "2016-01-20T20:20:31.649Z",
                                            message: "NUCLEIC_ACID_SENDOUT",
                                       }],
                                    }
                                ],
                                currentStepNumber: "0",
                                currentPatientStatus: ["REGISTRATION", "PROGRESSION_REBIOPSY"].sample,
                                patientAssignments: [{
                                                         dateAssigned: "2016-01-20T20:20:13.867Z",
                                                        biopsySequenceNumber: "N-15-00005",
                                                        patientAssignmentStatusMessage: "MESSAGE",
                                                        stepNumber: "0",
                                                        patientAssignmentMessages: [
                                                        {
                                                          patientSequenceNumber: "201re",
                                                            treatmentArmId: "CukeTest-173",
                                                            status: "ON_TREATMENT_ARM",
                                                                message: "MESSAGE",
                                                            stepNumber: "1"
                                                        }
                                                        ],
                                                        dateConfirmed: "2016-01-20T20:41:42.081Z"
                                                        }],
                                diseases: [],
                                concordance: ["U", "Y", "N", "W"].sample,
                                priorDrugs: [],
                                exclusionCriterias: [],
                                registrationDate: Time.now
                            })

    patients << Patient.new({
                                patientSequenceNumber: "202re",
                                gender: "UNKNOWN",
                                ethnicity: "UNKNOWN",
                                races: [],
                                patientRejoinTriggers: [],
                                biopsies: [
                                    {
                                        dateCreated: Time.now,
                                        biopsySequenceNumber: "N-15-00005",
                                        ptenIhcResult: "POSITIVE",
                                        nextGenerationSequences: [],
                                        failure: false,
                                        associatedPatientStatus: "REGISTRATION"
                                    },
                                    {
                                        dateCreated: Time.now,
                                        biopsySequenceNumber: "N-15-00005",
                                        ptenIhcResult: "POSITIVE",
                                        nextGenerationSequences: [],
                                        failure: false,
                                        associatedPatientStatus: "REGISTRATION"
                                    }
                                ],
                                currentStepNumber: "0",
                                currentPatientStatus: ["REGISTRATION", "PROGRESSION_REBIOPSY"].sample,
                                patientAssignments: [],
                                diseases: [],
                                concordance: ["U", "Y", "N", "W"].sample,
                                priorDrugs: [],
                                exclusionCriterias: [],
                                registrationDate: Time.now
                            })
  end
end