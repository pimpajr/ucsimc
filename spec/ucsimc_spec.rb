require 'spec_helper'
require_relative '../lib/ucsimc'
describe Ucsimc do

  it 'has IMC.connect and processes properly' do
   expect {
     Ucsimc::IMC.connect :host=>"127.0.0.1", :user=>"admin", :pass=>"pass", :verify_ssl=>"false"
   }.to raise_error
  end
  
  it 'has a version number' do
    expect(Ucsimc::VERSION).not_to be nil
  end

end
