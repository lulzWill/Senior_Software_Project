CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'                        # required
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     'AKIAIX3WWZM57ARACQIA',                        # required
    aws_secret_access_key: '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',                        # required
    region:                'us-east-1'                  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'backpacktraveler'                          # required
  config.fog_public     = false                                        # optional, defaults to true
  config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } # optional, defaults to {}
end