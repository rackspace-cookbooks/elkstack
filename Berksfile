source "https://api.berkshelf.com"

metadata

cookbook 'java'

# until https://github.com/elastic/cookbook-elasticsearch/pull/230
cookbook 'elasticsearch', '~> 0.3', git:'git@github.com:racker/cookbook-elasticsearch.git'

# until cookbook 2.0.4 is updated
cookbook 'kibana_lwrp', git:'https://github.com/lusis/chef-kibana'

group :integration do
  cookbook 'wrapper', path: 'test/fixtures/cookbooks/wrapper'
  cookbook 'apt'
  cookbook 'yum'
end
