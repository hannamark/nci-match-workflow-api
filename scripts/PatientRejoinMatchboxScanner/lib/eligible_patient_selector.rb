class EligiblePatientSelector
  def self.get_eligible_arms(assignment_results)
    eligible_arms = []
    if !assignment_results.nil? && assignment_results.has_key?('results')
      assignment_results['results'].each do |arm_result|
        eligible_arms.push(arm_result) if arm_result['reasonCategory'] == 'SELECTED'
      end
    end
    return eligible_arms
  end

  def self.is_eligible_arms_list_equal(eligible_arms, other_eligible_arms)
    return true if eligible_arms.nil? && other_eligible_arms.nil?
    return false if (eligible_arms.nil? && !other_eligible_arms.nil?) || (!eligible_arms.nil? && other_eligible_arms.nil?)
    return false if eligible_arms.size != other_eligible_arms.size
    eligible_arms.each do |arm|
      found = false
      other_eligible_arms.each do |other_arm|
        if arm['treatmentArmId'] == other_arm['treatmentArmId'] && arm['treatmentArmVersion'] == other_arm['treatmentArmVersion']
          found = true
          break
        end
      end
      return false if !found
    end
    return true
  end
end