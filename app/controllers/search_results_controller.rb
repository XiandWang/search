class SearchResultsController < ApplicationController

	def index
	  if params[:keywords].present?
	  	@str = params[:keywords]
	  	if (@str.split.length > 3) 
	  		@error = true
	  		@results = []
	  		return
	  	end
	  	@term = Term.find_by(name: @str)
	  	if @term 
	  		begin_time = Time.now
	  		@results = @term.infos
	  		sleep 2
	  		end_time = Time.now
	  		@time = end_time - begin_time
	  	else
	  		@term = Term.create!(name: @str)
	  		bing = Bing.new('I+aTIM5n1XdH7kntfBv3fXbxxOAKbhYgAe6vG2bAjcs', 50, 'WebOnly')
	  		begin_time = Time.now
			@results = get_results(bing, @str)
			end_time = Time.now
			@time = end_time - begin_time			
			i = @results.size
			@results.each do |r|
				@term.infos.create!(title: r[:Title], url: r[:Url], desc: r[:Description],  weight: i)
				i -= 1
			end
			@results = @term.infos
		end
		sleep 2
	  else 
	  	@term = "Nothing"
	  	@results = []
	  	sleep 2
	  end

	end


	def get_results(bing, str) 
		num = 100 + Random.rand(200)
		res = bing.search(str).take(2)
		offset = 200
		while num > 0 && res.size > 0
			res += bing.search(str, offset)
			num = num - res.size
			offset = offset + 60
		end

		res
	end

	def create
		redirect_to search_results_url(keywords: params[:keywords])
	end
end
