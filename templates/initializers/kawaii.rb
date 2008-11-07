
# Require all our too cute handlers
Dir.glob(File.join(RAILS_ROOT, 'lib/too_cute/*.rb')).each {|f| require f }

KAWAII_OPTIONS = YAML.load_file("#{RAILS_ROOT}/config/kawaii.yml")


# If snippets are enabled
if KAWAII_OPTIONS['snippets_enabled']

  if KAWAII_OPTIONS['snippet_storage'] == 'local'
    # We're using local snippets so there's nothing to connect to...
  else  
    unless KAWAII_OPTIONS['access_key_id'] and KAWAII_OPTIONS['secret_access_key'] and KAWAII_OPTIONS['bucket_name']
      raise "If you want to enable snippets, you must add access_key_id, secret_access_key and bucket_name to kawaii.yml!"
    end
  
    require 'aws/s3'

    AWS::S3::Base.establish_connection!(
        :access_key_id     => KAWAII_OPTIONS['access_key_id'],
        :secret_access_key => KAWAII_OPTIONS['secret_access_key']
    )
  end  
  
end
