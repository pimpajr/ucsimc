require 'ucsimc/aaa'
require 'rest-client'

module Ucsimc
  class Connection < Aaa
    attr_accessor :user, :host, :aaa
    attr_reader :connection, :cookie
        
    def initialize opts
      @user = opts[:user]
      @pass = opts[:pass]
      @host = opts[:host]
        
      build_connect
      login
    end
    
    def login
      aaalogin
      @resp = @connection.post @req
      aaalogin_response
    end
    
    def refresh
      aaarefresh
      @resp = @connection.post @req
      aaarefresh_response
    end
    
    def logout
      aaalogout
      @resp = @connection.post @req
      aaalogout_response
    end
    
    def build_connect
      @connection = RestClient::Resource.new "https://#{@host}/xmlIM", :verify_ssl => @insecure
    end
  end
end
