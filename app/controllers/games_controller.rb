require 'net/http'
require 'uri'
require 'json'
require 'time'

class GamesController < ApplicationController

  def new
    @game = Game.new
    authorize @game
  end

  def create
    @game = Game.new(game_params)
    @game.platforms = game_params[:platforms].split(',').map(&:strip)
    @game.cover_url = game_details.first['cover']['url'].gsub("//", "https://").gsub("t_thumb", "t_cover_big")
    @game.summary = game_details.first['summary']
    authorize @game
    if @game.save
      redirect_to game_path(@game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
    @review = Review.new
  end

  private

  def authorize_game
    authorize(Game)
  end

  def game_details
    client_id = ENV.fetch('CLIENT_ID')
    access_token = ENV.fetch('ACCESS_TOKEN')

    # Set up the HTTP connection
    http = Net::HTTP.new('api.igdb.com', 443)
    http.use_ssl = true

    # Define the headers
    uri = URI.parse('https://api.igdb.com/v4/games')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(URI('https://api.igdb.com/v4/games'), { 'Client-ID' => client_id, 'Authorization' => "Bearer #{access_token}", 'Content-Type' => 'application/json' })

    # Create the request
    escaped_title = game_params[:title].gsub("'", "''") # Escape single quotes
    date = timestamp
    request.body = <<-QUERY
      fields cover.url,  summary, first_release_date;
      where name = "#{escaped_title}" & first_release_date = #{date};
      limit 1;
    QUERY

    # Send the request and parse the response
    response = http.request(request)
    JSON.parse(response.body)
  end

  def timestamp
    Time.zone = 'UTC'
    date = Time.parse(game_params[:release_date])
    Time.zone.local(date.year, date.month, date.day).to_i
  end

  def game_params
    params.require(:game).permit(:title, :platforms, :release_date)
  end
end
