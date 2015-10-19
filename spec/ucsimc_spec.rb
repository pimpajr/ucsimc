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
  
  it 'has class aaa and method aaalogin builds xml payloads correctly' do
    aaa = Ucsimc::Aaa.new
    expect(aaa.aaalogin "user", "pass").to eq("<aaaLogin inName=\"user\" inPassword=\"pass\"/>")
  end
  
  it 'has class ConfigResolveClass and method request that builds xml correctly' do
    cookie = "fake-cookie"
    opts = {:in_class => "fabricVlan"}
    crc = Ucsimc::ConfigResolveClass.new
    expect(crc.request cookie, opts).to eq("<configResolveClass cookie=\"fake-cookie\" classId=\"fabricVlan\" inHierarchical=\"false\">\n  <inFilter/>\n</configResolveClass>")
  end
  
  it 'has class ConfigConfMo and method request that builds xml correctly' do
    
    ccm = Ucsimc::ConfigConfMo.new
    cookie = "fake-cookie"
    dn = "domaingroup-root/fabric/lan/net-not-found"
    mo_class = "fabricVlan"
    class_opts = {"defaultNet"=>"no",
                  "dn"=>"domaingroup-root/fabric/lan/net-not-found",
                  "id"=>"404",
                  "mcastPolicyName"=>"default",
                  "name"=>"not-found"}
    opts = {:dn => dn, :mo_class => mo_class, :class_opts => class_opts}
                  
    expect(ccm.request cookie, opts).to eq("<configConfMo cookie=\"fake-cookie\" dn=\"domaingroup-root/fabric/lan/net-not-found\" inHierarchical=\"false\">\n  <inConfig>\n    <fabricVlan defaultNet=\"no\" dn=\"domaingroup-root/fabric/lan/net-not-found\" id=\"404\" mcastPolicyName=\"default\" name=\"not-found\" switchId=\"dual\"/>\n  </inConfig>\n</configConfMo>")
  end

end
