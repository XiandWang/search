class SearchResultsController < ApplicationController

	def index
	  if params[:keywords].present?
	  	@str = params[:keywords]
	  	if (!@str.ascii_only?) 
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
				@term.infos.create(title: r[:Title], url: r[:Url], desc: r[:Description],  weight: i)
				i -= 1
			end
			@results = @term.infos
		end
		sleep 2
	  else 
	  	@term = "Nothing"
	  	@results = []
	  	@time = 0
	  	sleep 2
	  end

	end


	def get_results(bing, str) 
		num = 50
		res = bing.search(str).take(2)
		if res.size == 0
			return []
		end
		top1 = res[0]
		top2 = res[1]
		offset = 80
		while num > 0 && res.size > 0
			res += bing.search(str, offset).take(20)
			num = num - res.size
			offset = offset + 60
		end

		words = %w(time person year way day thing man world life hand part child eye problem fact)
		words.shuffle!

		res += bing.search(words[0],10).take 10
		res += bing.search(words[1], 10).take 10
		res += bing.search(words[2], 10).take 10	
		res += bing.search(words[3], 10).take 10
		res += bing.search(words[4], 10).take 10
		
		res=res.drop 2
		res.shuffle!
		res.insert(Random.rand(3...10), top1)
		res.insert(Random.rand(10...15), top2)
		if res.size > 0
			return res
		else
			return []
		end
	end

	def create
		redirect_to search_results_url(keywords: params[:keywords])
	end
end
