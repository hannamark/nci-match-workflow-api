module Routes
  class MatchController < ApplicationController

      get '/version' do
        content_type :json
        version = Version.instance
        WorkflowLogger.logger.info "WORKFLOW API | Returning version '#{version.to_json}' to remote host."
        version.to_json
      end

      get '/patients' do
        content_type :json
        begin
          Patient.all.to_json
        rescue
          status 500
        end
      end

      get '/patient/:patientSequenceNumber' do
        content_type :json
        patientSequenceNumber = params['patientSequenceNumber']
        begin
          docs = Patient.where(patientSequenceNumber: patientSequenceNumber)
          raise NotFoundError, "Patient #{patientSequenceNumber} does not exist." if docs.size == 0
          docs[0].to_json
        rescue NotFoundError
          status 404
        rescue
          status 500
        end
      end

      get '/dashboardStatistics' do
        content_type :json
        DashboardStatistics.new.to_json
      end

      get '/patientRejoinTrialPendingReview' do
        content_type :json
        docs = Patient.where('patientRejoinTriggers.0' => { :$exists => true }).only(:patientSequenceNumber, :patientRejoinTriggers)
        docs.to_json
      end

      get '/newsFeed/:age' do
        content_type :json
        days = params['age']
        WorkflowLogger.logger.info "WORKFLOW API | getting news feed for the past #{days} days..."
        begin
          news = Logging.get_latest_logs(days)
          news.to_json
        rescue NotFoundError
          status 404
        rescue
          status 500
        end

      end

      get '/pendingVariantReports' do
        content_type :json
        begin
          puts "==================== here"
          pending_variant_reports = PatientDao.get_patients_with_pending_variant_report
          pending_variant_reports.to_json
        rescue => e
          WorkflowLogger.logger.error "WORKFLOW API | Got error while getting pending variant reports: #{e.message}"
          status 500
        end
      end

      get '/pendingPatientAssignments' do
        content_type :json
        begin
          puts "==================== here2"
          pending_assignments = PatientDao.get_patients_with_pending_patient_assignment
          pending_assignments.to_json
        rescue => e
          WorkflowLogger.logger.error "WORKFLOW API | Got error while getting pending patient assignments: #{e.message}"
          status 500
        end
      end
    end

  end

