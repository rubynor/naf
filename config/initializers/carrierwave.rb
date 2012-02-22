# -*- encoding : utf-8 -*-

if Rails.env.test? || Rails.env.development?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = true
  end
else
  CarrierWave.configure do |config|
    aws_key, aws_secret, aws_region, aws_bucket = ENV['AWS_ACCESS_KEY'], ENV['AWS_SECRET_ACCESS_KEY'], ENV['AWS_REGION'], ENV['AWS_BUCKET']
    puts "Error: AWS keys not configured for env #{Rails.env}" unless aws_key && !Rails.env.production?
    config.fog_credentials = {
      :provider               => 'AWS',       # required
      :aws_access_key_id      => aws_key,       # required
      :aws_secret_access_key  => aws_secret,       # required
      :region                 => aws_region  # optional, defaults to 'us-east-1'
    }
    config.fog_directory  = aws_bucket                   # required
    #config.fog_host       = 'https://assets.example.com'            # optional, defaults to nil
    config.fog_public     = true
  end
end


