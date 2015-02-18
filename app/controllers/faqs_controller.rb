class FaqsController < ApplicationController
	load_resource param_method: :faq_params 
	def index

	end

	def create
		if @faq.save
			redirect_to :index
		else
			render :new
		end
	end

	def new

	end

	def show

	end

	def edit

	end

	def update
		if @faq.save
			redirect_to :index
		else
			render :edit
		end
	end



	private

	def faq_params
		params.require(:faq).permit(:title,:body, :video)
	end

end
