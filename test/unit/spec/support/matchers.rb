# elkstack/libraries/matchers.rb

if defined?(ChefSpec)
  # ChefSpec::Runner.define_runner_method(:heat_nginx_vhost)

  # Logstash matchers
  def create_logstash_service(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:logstash_service, :create, resource)
  end

  def enable_logstash_service(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:logstash_service, :enable, resource)
  end

  def start_logstash_service(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:logstash_service, :start, resource)
  end

  def create_logstash_instance(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:logstash_instance, :create, resource)
  end

  def enable_logstash_instance(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:logstash_instance, :enable, resource)
  end

  def start_logstash_instance(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:logstash_instance, :start, resource)
  end

  def create_logstash_pattern(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:logstash_pattern, :create, resource)
  end

  def create_logstash_config(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:logstash_config, :create, resource)
  end

  def add_htpasswd(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:htpasswd, :add, resource)
  end

  # Kibana matchers
  def create_kibana_web(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:kibana_web, :create, resource)
  end

  def create_kibana_install(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:kibana_install, :create, resource)
  end

  def create_openssl_x509(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:openssl_x509, :create, resource)
  end

  def append_if_no_line(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:append_if_no_line, :edit, resource)
  end

  def put_http_request(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:http_request, :put, resource)
  end

  def create_cron_d(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:cron_d, :create, resource)
  end

end
