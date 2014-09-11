# 0.3.0

Bumped default Elasticsearch version to 1.3.2. Java 7 is now required, and some tests had to be adjusted.
Fix bug in username not being used in tests because it was wrong in /etc/nginx/htpassword.curl.
Fix bug where port 443 was not open in iptables.

# 0.2.0

Added the ability to disable redirects on kibana

# 0.1.3

Sheppy Reno - Convert process monitors to platformstack

# 0.1.2
=======

Add more options for kibana username and password fields under basic auth over SSL on nginx.

# 0.1.1

Seperate recipes per service, add searching and tests. Major workarounds for logstash cookbook.

# 0.1.0

Initial release of elkstack
