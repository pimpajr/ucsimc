require 'ucsimc/connection'
module Ucsimc
  class IMC < Connection
    attr_accessor :user, :pass, :host, :verify_ssl, :cookie
    
    def self.connect opts
      fail unless opts.is_a? Hash
      opts[:inHierarchical] = "false"
      Ucsimc::Connection.new opts
    end
  end
end