class DataElementLocator

  def self.get_specimen_received_message(biopsy)
    if !biopsy.nil?
      biopsy['mdAndersonMessages'].each do |mda_message|
        return mda_message if mda_message['message'] == 'SPECIMEN_RECEIVED'
      end
    end
  end

  def self.get_confirmed_variant_report_analysis_id(next_generation_sequence)
    return next_generation_sequence['ionReporterResults']['jobName'] if !next_generation_sequence.nil? && next_generation_sequence['status'] == 'CONFIRMED' && next_generation_sequence['ionReporterResults']['jobName']
  end

  def self.get_last_element(list)
    return list[list.size() - 1] if !list.nil? && list.size() > 0
  end

end