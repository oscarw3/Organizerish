require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Duke < OmniAuth::Strategies::OAuth2
      option :name, 'duke'
      option :client_options, {
        site:          'https://oauth.oit.duke.edu/',
        authorize_url: 'https://oauth.oit.duke.edu/oauth/authorize.php'
      }

      uid {
        raw_info['id']
      }

      info do
        {
          email: raw_info['email'],
        }
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get('/me').parsed
      end
    end
  end
end