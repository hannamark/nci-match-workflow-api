module Sinatra
  module WorkflowApi
    module MatchService

      def self.registered(service)

        service.get '/version' do
          content_type :json
          version = Version.instance
          WorkflowLogger.logger.info "WORKFLOW API | Returning version '#{version.to_json}' to remote host."
          version.to_json
        end

        service.get '/patients' do
          content_type :json
          begin
            Patient.all.to_json
          rescue
            status 500
          end
        end

        service.get '/patient/:patientSequenceNumber' do
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

        service.get '/dashboardStatistics' do
          content_type :json
          DashboardStatistics.new.to_json
        end

        service.get '/patientRejoinTrialPendingReview' do
          content_type :json
          docs = Patient.where('patientRejoinTriggers.0' => { :$exists => true }).only(:patientSequenceNumber, :patientRejoinTriggers)
          docs.to_json
        end

        service.get '/newsFeed/:age' do
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

      end

    end
  end
end
