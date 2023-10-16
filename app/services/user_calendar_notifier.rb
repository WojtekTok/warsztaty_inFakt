require 'google/apis/calendar_v3'
require 'google/api_client/client_secrets'

class UserCalendarNotifier
  CALENDAR_ID = 'primary'.freeze

  def initialize(user, book)
    @user = user
    @book = book
  end

  def google_calendar_client
    client = Google::Apis::CalendarV3::CalendarService.new
    begin
      client.authorization = secrets.to_authorization
      client.authorization.grant_type = 'refresh_token'
    rescue StandardError => e
      Rails.logger.debug e.message
    end

    client
  end

  def secrets
    Google::APIClient::ClientSecrets.new({
                                           'web' => {
                                             'access_token' => user.token,
                                             'refresh_token' => user.refresh_token,
                                             'client_id' => A9n.google_client_id,
                                             'client_secret' => A9n.google_client_secret
                                           }
                                         })
  end

  private

  attr_reader :book, :user
end
