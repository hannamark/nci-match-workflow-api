NCI-MATCHBox Workflow API
=========================
[![Build Status](https://travis-ci.org/CBIIT/nci-match-workflow-api.svg?branch=master)](https://travis-ci.org/CBIIT/nci-match-workflow-api)
[![Code Climate](https://codeclimate.com/github/CBIIT/nci-match-workflow-api/badges/gpa.svg)](https://codeclimate.com/github/CBIIT/nci-match-workflow-api)
[![Test Coverage](https://codeclimate.com/github/CBIIT/nci-match-workflow-api/badges/coverage.svg)](https://codeclimate.com/github/CBIIT/nci-match-workflow-api/coverage)

This repository contains the codebase for the following functionalities.
* Storing change request documents.
* Handling trial rejoin request.

To start the Workflow API service, run 'bundle exec rackup'.

Change request example usage
* Upload file:
  * curl -v -F "data=@/Users/smithj/git/nci-match-workflow-api/test.txt" http://localhost:9292/changerequest/123
* File list per patient:
  * curl https://localhost:9292/changerequest/123
* Download file:
  * curl https://localhost:9292/changerequest/123/test.txt

The rejoin scanner script example usage:
* Print out the usage statement for the scanner script.
  * ruby patient_rejoin_matchbox_scanner.rb --help
* Run the scanner script in print mode.
  * ruby patient_rejoin_matchbox_scanner.rb -c ../config/scanner.yml -e development|prodtest|production --print
* Run the scanner script.
  * ruby patient_rejoin_matchbox_scanner.rb -c ../config/scanner.yml -e development|prodtest|production


