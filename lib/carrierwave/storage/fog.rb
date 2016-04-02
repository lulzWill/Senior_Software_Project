CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'                        # required
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     'AKIAIBGGY32ISHRDIASQ',                        # required
    aws_secret_access_key: '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',                        # required
    region:                'us-west-2'                  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'backpacktraveler'                          # required
  config.fog_public     = false                                        # optional, defaults to true
  config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } # optional, defaults to {}
end