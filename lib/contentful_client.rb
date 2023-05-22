require 'contentful'

class ContentfulClient
  PAGE_LIMIT = 10
  RECIPES_CONTENT_TYPE = 'recipe'.freeze

  class << self
    def connection
      @client ||= Contentful::Client.new(
        space: 'kk2bw5ojx476', # not using environment variables here for simplicity
        access_token: '7ac531648a1b5e1dab6c18b0979f822a5aad0fe5f1109829b8a197eb2be4b84c', # not using environment variables here for simplicity
        environment: 'master', # not using environment variables here for simplicity,
        entry_mapping: {
          'recipe' => ContentfulRecipe
        }
      )
    end

    def get_recipes(page = 0, query = {})
      skip = page * PAGE_LIMIT
      query.merge!(
        content_type: RECIPES_CONTENT_TYPE,
        limit: PAGE_LIMIT,
        skip: skip
      )
      handle_error(__method__) do
        connection.entries(query)
      end
    end

    def get_recipe(recipe_id)
      handle_error(__method__) do
        get_recipes(0, 'sys.id' => recipe_id).first
      end
    end

    private

    def handle_error(method_name)
      yield
    # need more rescues here for other statuses error like Contentful::NotFound
    # Contentful::RateLimitExceeded ... etc
    rescue Contentful::BadRequest, Contentful::ServerError => e
      Rails.logger.error "Error occurred in #{method_name}: #{e.message}"
      raise e
    end
  end
end
