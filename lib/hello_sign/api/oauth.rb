#
# The MIT License (MIT)
#
# Copyright (C) 2014 hellosign.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

module HelloSign
  module Api

    #
    # OAuth allows you to perform actions on behalf of other users after they grant you the authorization to do so.
    # For example, you could send signature requests on behalf of your users.
    # For more information, see our OAuth API documentation (https://app.hellosign.com/api/oauthWalkthrough).
    #
    # IMPORTANT: With some OAuth scopes, you (the app owner) will be charged for all signature requests sent on behalf of other users via your app.
    #
    # @author [hellosign]
    #
    module OAuth

      #
      # Returns the OAuth URL where users can give permission for your application to perform actions on their behalf.
      #
      # @param state [String] used for security and must match throughout the flow for a given user.
      # It can be set to the value of your choice (preferably something random). You should verify it matches the expected value when validating the OAuth callback.
      # @return [type] [description]
      def oauth_url(state)
        "#{self.oauth_end_point}/oauth/authorize?response_type=code&client_id=#{self.client_id}&state=#{state}"
      end

      #
      # Retrieves the OAuth token
      #
      # @option opts [String] state Random value that was used when you created oauth_url for a specific user.
      # @option opts [String] code The code passed to your callback when the user granted access.
      # @option opts [String] client_id The API App Client ID.
      # @option opts [String] client_secret The secret token of your API App.
      #
      # @return [Hash] OAuth data of the user
      #
      # @example
      #   client = HelloSign::Client.new :api_key => '%apikey%', :client_id => 'cc91c61d00f8bb2ece1428035716b', :client_secret => '1d14434088507ffa390e6f5528465'
      #   client.get_oauth_token :state => '900e06e2', :code =>'1b0d28d90c86c141'
      def get_oauth_token(opts)
        opts[:client_id] = self.client_id
        opts[:client_secret] = self.client_secret
        opts[:grant_type] = 'authorization_code'
        post('/oauth/token', { :body => opts, :oauth_request => true })
      end

      #
      # Refreshes the user's OAuth token.
      #
      # @option opts [String] refresh_token The refresh provided when the access token has expired.
      #
      # @return [Hash] Refreshed OAuth info
      #
      # @example
      #   client.refresh_oauth_token :refresh_token => 'hNTI2MTFmM2VmZDQxZTZjOWRmZmFjZmVmMGMyNGFjMzI2MGI5YzgzNmE3'
      def refresh_oauth_token(opts)
        opts[:client_id] = self.client_id
        opts[:client_secret] = self.client_secret
        opts[:grant_type] = 'refresh_token'
        post('/oauth/token', { :body => opts, :oauth_request => true })
      end

      #
      # Create new user and get their OAuth token. The user will receive an email asking them to confirm the access being granted.
      # Your app will not be able to perform actions on behalf of this user until they confirm.
      #
      # @option opts [String] email_address New user email address.
      #
      # @example
      #   client.oauth_create_account :email_address => 'new_user@example.com'
      #
      # @return [Hash] details about new user, including OAuth data
      def oauth_create_account(opts)
        opts[:client_id] = self.client_id
        opts[:client_secret] = self.client_secret

        HelloSign::Resource::Account.new post('/account/create', { :body => opts })
      end
    end
  end
end
