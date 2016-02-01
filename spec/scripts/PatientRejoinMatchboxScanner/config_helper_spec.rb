require "#{File.dirname(__FILE__)}/../../../scripts/PatientRejoinMatchboxScanner/lib/config_helper"

RSpec.describe ConfigHelper, '.get_prop' do
  context 'with a nil config object' do
    it 'should return the default value' do
      expect(ConfigHelper.get_prop(nil, 'api_config', 'hostname', '127.0.0.1')).to eq('127.0.0.1')
    end
  end

  context 'with a resource key that does not exist' do
    it 'should return the default value' do
      expect(ConfigHelper.get_prop({}, 'api_config', 'hostname', '127.0.0.1')).to eq('127.0.0.1')
    end
  end

  context 'with a prop key that does not exist' do
    it 'should return the default value' do
      expect(ConfigHelper.get_prop({ 'api_config' => {} }, 'api_config', 'hostname', '127.0.0.1')).to eq('127.0.0.1')
    end
  end

  context 'with a prop key that exist' do
    it 'should return the prop value' do
      expect(ConfigHelper.get_prop({ 'api_config' => { 'hostname' => '192.168.1.1' } }, 'api_config', 'hostname', '127.0.0.1')).to eq('192.168.1.1')
    end
  end
end