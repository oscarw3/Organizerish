class Api::ResourcesController < ApiController
	respond_to :json
	def index
		@resources = Resource.all
		respond_with @resources
	end
end
