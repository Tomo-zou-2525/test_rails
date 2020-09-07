class CommentsController < ApplicationController
  def create
    # comment.newの中にboard_idが入っているので、関連付けはOK
    comment = Comment.new(comment_params)
    if comment.save
      flash[:notice] = "コメントを投稿しました"
      # コメントに紐づく掲示板の詳細画面に戻す
      # このcomment.boardの記述が適用されるのは、belongs_toがあるから
      redirect_to comment.board
      # comment.boardでboard_idの対応するboardオブジェクトを引っ張ってくれる
    else
     flash[:comment] = comment
		 flash[:error_messages] = comment.errors.full_messages
		 redirect_back fallback_location: comment.board
			# redirect_to :back, flash: {
			# 	comment: comment,
			# 	error_messages: comment.errors.full_messages
			# }
		end
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:name, :comment, :board_id)
  end
end
