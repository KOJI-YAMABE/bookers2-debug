class BookCommentsController < ApplicationController
	 before_action :authenticate_user!
	def create
		@book = Book.find(params[:book_id])
	    book_comment = current_user.book_comments.new(book_comment_params)
	    book_comment.book_id = params[:book_id]
	    book_comment.save
	    #redirect_to request.referer
	end

	def destroy
		@book = Book.find(params[:book_id])
		comment = BookComment.find(params[:book_comment_id])
		comment.destroy
		#redirect_to request.referer
	end

private
    def book_comment_params
        params.require(:book_comment).permit(:comment, :user_id, :book_id)
    end
end
