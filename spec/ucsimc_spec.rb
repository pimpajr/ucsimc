require 'spec_helper'
require_relative '../lib/ucsimc'
require_relative '../lib/ucsimc/aaa'

describe Ucsimc do

  it 'has IMC.connect and processes properly' do
   expect {
     Ucsimc::IMC.connect :host=>"127.0.0.1", :user=>"admin", :pass=>"pass", :verify_ssl=>"false"
   }.to raise_error
  end
  
  it 'has a version number' do
    expect(Ucsimc::VERSION).not_to be nil
  end
  
  it 'has class aaa and method aaalogin builds xml payloads correctly' do
    aaa = Ucsimc::Aaa.new
    expect(aaa.aaalogin "user", "pass").to eq("<aaaLogin inName=\"user\" inPassword=\"pass\"/>")
  end
  
  it 'has class ConfigResolveClass and method request that builds xml correctly' do
    crc = Ucsimc::ConfigResolveClass.new "fake-cookie"
    expect(crc.request "fabricVlan").to eq("<configResolveClass cookie=\"fake-cookie\" classId=\"fabricVlan\" inHierarchical=\"false\">\n  <inFilter/>\n</configResolveClass>")
  end

end
