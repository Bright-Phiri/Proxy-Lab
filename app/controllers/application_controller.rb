# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_request!

  private

  def authenticate_request!
    access_token = request.headers['Proxy-Authorization']&.split(' ')&.last
    if access_token.blank?
      render json: { error: 'Access Token Missing' }, status: :unauthorized
    else
      unless valid_access_token?(access_token)
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end
  end

  def valid_access_token?(access_token)
    access_token == ENV['ACCESS_TOKEN']
  end
end
