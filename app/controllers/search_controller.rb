class SearchController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:slack]
  require 'json'
  require 'httparty'

  def index
  end

  def show
    @found = Scraper.getgif(params[:search][:query])
  end

  def slack
    @found = Scraper.getgif(params[:text])
    @text = params[:text]
    @channel = params[:channel_name]
    @username = params[:user_name]
    @command = params[:command]
    @random_image = @found.sample
    if @found.present?
      @responselink = ' /reactif ' + @text + '    <' + @random_image + '?' + Random.rand(500).to_s + '|' + @random_image + '>'
      @responsechannel = '#' + @channel
      HTTParty.post(ENV['SLACK_WEBHOOK_URL'],
        body: {
                payload: {
                  username: @username,
                  channel: @responsechannel,
                  text: @responselink
                }.to_json
              })
      return render nothing: true
    else
      return render json: 'No gifs found'
    end
  end
end
