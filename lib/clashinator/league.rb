module Clashinator
  # This class represents the league model
  class League < Base
    def initialize(attrs)
      super(attrs)
    end

    def self.list_leagues(options = {})
      new_options = prepare_query_options(options)
      response = get('/v1/leagues', new_options)

      return as_leagues(response.parsed_response['items']) if response.ok?
      raise response['message'] unless response.ok?
    end

    def self.league_info(league_id)
      response = get("/v1/leagues/#{league_id}", http_default_options)

      return new(response.parsed_response) if response.ok?
      raise response['message'] unless response.ok?
    end

    def self.league_seasons(league_id, options = {})
      new_options = prepare_query_options(options)
      response = get("/v1/leagues/#{league_id}/seasons", new_options)

      return as_seasons(response.parsed_response['items']) if response.ok?
      raise response['reason'] unless response.ok?
    end

    def self.league_season_rankings(league_id, season_id, options = {})
      # only available for legend_league
      new_options = prepare_query_options(options)
      response = get(
        "/v1/leagues/#{league_id}/seasons/#{season_id}",
        new_options
      )

      if response.ok?
        return as_player_rankings(response.parsed_response['items'])
      end
      raise response['reason'] unless response.ok?
    end
  end
end