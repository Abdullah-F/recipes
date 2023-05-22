class RecipesController < ApplicationController
  def index
    # the ContentfulClient supports pagination for recipes,
    # but here I'm not doing the pagination as we only have 4 recipes in the contentful db for this environment
    # so I'm skipping pagination here in this action for simplicity
    @recipes = ContentfulClient.get_recipes
  end

  def show
    @recipe = ContentfulClient.get_recipe(params[:id])
  end
end
