# Encoding: utf-8
require 'serverspec'

set :backend, :exec

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin:/bin:/usr/bin'
  end
end
