require "#{File.dirname(__FILE__)}/../../../scripts/PatientRejoinMatchboxScanner/lib/eligible_patient_selector"

class SimulateAssignmentAnalyzer

  def initialize(off_trial_patient, assignment_results)
    @off_trial_patient = off_trial_patient
    @assignment_results = assignment_results
  end

  # This method analyzes the simulated assignment result and return back a flag indicating
  # if the patient is eligible to rejoin and the updated patient model.
  def analyze
    eligible_arms = EligiblePatientSelector.get_eligible_arms(@assignment_results)

    if @off_trial_patient['patientRejoinTriggers'].nil?
      @off_trial_patient['patientRejoinTriggers'] = []
    end

    if eligible_arms.nil? || eligible_arms.size == 0
      update_trigger_with_no_eligible_arms
      return false, @off_trial_patient
    end

    not_eligible_assignment_index = -1
    @off_trial_patient['patientTriggers'].each do |trigger|
      if trigger['patientStatus'] == 'PENDING_CONFIRMATION'
        not_eligible_assignment_index += 1
      end
      if trigger['patientStatus'] == 'NOT_ELIGIBLE'
        assignment_report = (@off_trial_patient['patientAssignments'])[not_eligible_assignment_index]
        selected_treatment_arm = assignment_report['treatmentArm']
        matching_arm_index = -1
        eligible_arms.each_with_index do |eligible_arm, index|
          if eligible_arm['treatmentArmId'] == selected_treatment_arm['_id'] && eligible_arm['treatmentArmVersion'] == selected_treatment_arm['version']
            matching_arm_index = index
            break;
          end
        end
        eligible_arms.delete_at(matching_arm_index) unless matching_arm_index == -1
      end
    end

    if eligible_arms.size == 0
      return false, @off_trial_patient
    end

    update_trigger_with_eligible_arms(eligible_arms)
    return true, @off_trial_patient
  end

  def update_trigger_with_no_eligible_arms
    if @off_trial_patient['patientRejoinTriggers'].size == 0
      # Patient contains no rejoin trigger so we add one to
      # capture this event that no arm is eligible for the
      # patient at this time.
      add_new_patient_rejoin_trigger([])
    else
      latest_rejoin_trigger = @off_trial_patient['patientRejoinTriggers'][@off_trial_patient['patientRejoinTriggers'].size - 1]
      if latest_rejoin_trigger['eligibleArms'].size == 0
        # The latest rejoin trigger shows that in a previous run
        # no arm was eligible for the patient and no arm is eligible
        # now so we update the scanned date property.
        latest_rejoin_trigger['dateScanned'] = DateTime.now
      else
        # The latest rejoin trigger shows that in a previous run
        # one or more arms were eligible for the patient and no arm
        # is eligible for the patient now so we add a patient rejoin
        # trigger to capture this event.
        add_new_patient_rejoin_trigger([])
      end
    end
  end

  def update_trigger_with_eligible_arms(eligible_arms)
    if @off_trial_patient['patientRejoinTriggers'].size == 0
      # Patient contains no rejoin trigger so we add one to
      # capture this event that there are eligible arms for the
      # patient at this time.
      add_new_patient_rejoin_trigger(eligible_arms)
    else
      latest_rejoin_trigger = @off_trial_patient['patientRejoinTriggers'][@off_trial_patient['patientRejoinTriggers'].size - 1]
      if !latest_rejoin_trigger['dateRejoined'].nil?
        # The latest rejoin trigger has a dateRejoined property
        # which means that the patient has rejoined the trial before
        # so we create a new trigger to capture this event.
        add_new_patient_rejoin_trigger(eligible_arms)
      elsif latest_rejoin_trigger['eligibleArms'].nil? || latest_rejoin_trigger['eligibleArms'].size == 0
        # The latest rejoin trigger shows that in a previous run
        # no arm was eligible for the patient and now we found arms
        # eligible for the patient so we add a new trigger to
        # capture this event.
        add_new_patient_rejoin_trigger(eligible_arms)
      else
        if !EligiblePatientSelector.is_eligible_arms_list_equal(latest_rejoin_trigger['eligibleArms'], eligible_arms)
          # The latest rejoin trigger shows that in a previous run
          # there were arms eligible for the patient and now we found arms
          # eligible for the patient but the eligible arms have changed so
          # we add a new trigger to capture this event.
          add_new_patient_rejoin_trigger(eligible_arms)
        else
          # The latest rejoin trigger shows that in a previous run
          # there were arms eligible for the patient and now we found arms
          # eligible for the patient. The eligible arms have not changed so
          # we update the scanned date property.
          latest_rejoin_trigger['dateScanned'] = DateTime.now
        end
      end
    end
  end

  def add_new_patient_rejoin_trigger(eligible_arms)
    @off_trial_patient['patientRejoinTriggers'].push({
      'eligibleArms' => eligible_arms,
      'dateScanned' => DateTime.now
    })
  end

  private :update_trigger_with_no_eligible_arms, :update_trigger_with_eligible_arms, :add_new_patient_rejoin_trigger

end