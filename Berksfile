source "https://api.berkshelf.com"

metadata

cookbook 'java'
cookbook 'kibana_lwrp', github: 'lusis/chef-kibana'

group :integration do
  cookbook 'wrapper', path: 'test/fixtures/cookbooks/wrapper'
  cookbook 'apt'
  cookbook 'yum'
end
