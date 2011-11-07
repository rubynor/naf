
if Rails.env.test? || Rails.env.development?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = true
  end
else
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',       # required
      :aws_access_key_id      => 'AKIAJFEHYG7AMC6UBMQQ',       # required
      :aws_secret_access_key  => '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',       # required
      :region                 => 'eu-west-1'  # optional, defaults to 'us-east-1'
    }
    config.fog_directory  = "naf-#{Rails.env}"                     # required
    #config.fog_host       = 'https://assets.example.com'            # optional, defaults to nil
    config.fog_public     = true
  end
end


