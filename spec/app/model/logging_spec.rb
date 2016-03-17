require 'rspec'
require "#{File.dirname(__FILE__)}/../../../app/model/logging"

describe 'Logging behaviour' do
  before do
    # Mongoid.load!(File.dirname(__FILE__) + '/../../../config/mongoid-test.yml', :test)

    @logs = []
    log = Logging.new({
                          site: "matchAdmin",
                          logger: "gov.match.workflow.assignment.ConfirmPatientAssignmentProcessor",
                          timeStamp: "2016-01-20T21:42:08.908Z",
                          level: "INFO",
                          marker: "VERIFY",
                          message: "Processed {\"name\":\"matchAdmin\"} ACCEPTED assignment message for patient(PSN:204re)."})
    @logs << log


    log = Logging.new({
                          site: "ECOG",
                          logger: "gov.match.workflow.assignment.ConfirmPatientAssignmentProcessor",
                          timeStamp: "2016-01-19T21:42:08.908Z",
                          level: "INFO",
                          marker: "VERIFY",
                          message: "Processed {\"name\":\"matchAdmin\"} ACCEPTED assignment message for patient(PSN:204re)."})
    @logs << log

    log = Logging.new({
                          site: "MDA",
                          logger: "gov.match.workflow.assignment.ConfirmPatientAssignmentProcessor",
                          timeStamp: "2016-01-18T21:42:08.908Z",
                          level: "INFO",
                          marker: "VERIFY",
                          message: "Processed {\"name\":\"matchAdmin\"} ACCEPTED assignment message for patient(PSN:204re)."})
    @logs << log

  end

  it 'should retrieve news feed and calculate log age' do

    @logs[0]['timeStamp'] = Date.today

    fake_logs = []
    fake_logs << @logs[0]

    allow(Logging).to receive(:where).and_return(fake_logs)
    news_feed = Logging.get_latest_logs(1)
    expect(news_feed).not_to be_nil
    expect(news_feed.length).to eq(1)
    expect(news_feed[0].age).to eq(0)
  end
end