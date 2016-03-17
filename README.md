nci-match-workflow-api
=======================

[![Build Status](https://travis-ci.org/CBIIT/nci-match-workflow-api.svg?branch=master)](https://travis-ci.org/CBIIT/nci-match-workflow-api)
[![Code Climate](https://codeclimate.com/github/CBIIT/nci-match-workflow-api/badges/gpa.svg)](https://codeclimate.com/github/CBIIT/nci-match-workflow-api)
[![Test Coverage](https://codeclimate.com/github/CBIIT/nci-match-workflow-api/badges/coverage.svg)](https://codeclimate.com/github/CBIIT/nci-match-workflow-api/coverage)

This repository contains the Matchbox workflow rest services.

Start with 'bundle exec rackup'

Change request example usage
* Upload file:
  * curl -v -F "data=@/Users/pumphreyjj/git/nci-match-workflow-api/test.txt" http://localhost:9292/changerequest/123
* File list per patient:
  * curl https://localhost:9292/changerequest/123
* Download file:
  * curl https://localhost:9292/changerequest/123/test.txt