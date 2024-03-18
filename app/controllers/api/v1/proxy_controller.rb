# frozen_string_literal: true

require 'httparty'

class Api::V1::ProxyController < ApplicationController
  def proxy
    endpoint = proxy_params[:endpoint]
    url = "https://restful-booker.herokuapp.com#{endpoint}"
    http_method = proxy_params[:http_method]&.upcase
    request_params = proxy_params[:proxy] || {}
    token = proxy_params[:token] || ''

    begin
      response = case http_method
                 when 'GET'
                   HTTParty.get(url, body: request_params.to_json, headers: request_headers(token))
                 when 'POST'
                   HTTParty.post(url, body: request_params.to_json, headers: request_headers(token))
                 when 'PUT'
                   HTTParty.put(url, body: request_params.to_json, headers: request_headers(token))
                 when 'PATCH'
                   HTTParty.patch(url, body: request_params.to_json, headers: request_headers(token))
                 when 'DELETE'
                   HTTParty.delete(url, body: request_params.to_json, headers: request_headers(token))
                 else
                   raise ArgumentError, 'Invalid request method type'
                 end
      render json: JSON.parse(response.body), status: response.code
    rescue ArgumentError => e
      render json: e.message, status: :bad_request
    rescue HTTParty::Error, StandardError => e
      render json: e.message, status: :internal_server_error
    end
  end

  private

  def proxy_params
    params.permit(:token, :endpoint, :http_method, proxy: {})
  end

  def request_headers(token)
    {
      'Content-Type' => 'application/json',
      'Cookie' => "token=#{token}"
    }
  end
end
