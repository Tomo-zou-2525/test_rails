class BoardsController < ApplicationController
# ControllerClassの中にbefor_actionは構文
# その引数に、シンボル型でオブジェクトを定義してあげるとOK！
before_action :set_target_params, only: %i[show edit update destroy]
								     # %記号でシンボルの配列を定義

	def index 
	  # gem kaminari導入前↓
	  # @boards = Board.all

	  # gem kaminari導入後↓
	  # @boards = Board.page(params[:page])

	  # タグ検索機能追加の記述
	  # タグがあればタグからタグIDを取得、掲示板に紐づくタグのIDを取得・タグがなければ、一度board.allで取得
		@boards = params[:tag_id].present? ? Tag.find(params[:tag_id]).boards : Board.all
		@boards = @boards.page(params[:page]).order("created_at DESC")
	end

	def new
	  @board = Board.new(flash[:board])
	end

	def create
	  # board = Board.create(board_params)
	  # # falsh変数という特殊な変数 引数に指定したものに値が参照されるまで保存される 一度使われれば削除される
	  # flash[:notice] = "『  #{board.title}』の掲示板を作成しました"
	  # redirect_to board
	  board = Board.new(board_params)
	  if board.save
	  	flash[:notice] = "『  #{board.title}』の掲示板を作成しました"
	    redirect_to board
	  else
	  	redirect_to :back, flash: {
	  		board: board,
	  		error_messages: board.errors.full_messages
	  	}
	  end
	end

	def show
	  # @board = Board.find(params[:id])

    # アソシエーションによって使用できるメソッド
    # @comment = @board.comments.new
    # ↑上記の記述だと、コメント一覧表示の際に、常に空のコメントが生成されてしまう

    @comment = Comment.new(board_id: @board.id )
    # ↑上記の記述では、Commentモデルのnewで初期化する際、board_idをセットして初期化
	end

	def edit
	  # @board = Board.find(params[:id])
	end

	def update
	  # 変数boardにfindメソッドでIDを取得した値を代入
	  # board = Board.find(params[:id])
	  # updateアクションで保存_引数にはストロングパラメータで
	  # @board.update(board_params)

	  # redirect先はオブジェクトでも構わない
	  # redirect_to @board

	  # ここからバリデーションの書き方
	  if @board.update(board_params)
	  	redirect_to @board
	  else
	  	redirect_to :back, flash: {
	  		board: @board,
	  		error_messages: @board.errors.full_messages
	  	}
	  end
	end

	def destroy
	# 特定のIDに対して何かするので、findで取得するようにする
	  # board = Board.find(params[:id])
	  @board.destroy

	  # resourceベースルーティングでは、controllerでもpathを生成することができるので、以下の書き方が可
	  redirect_to boards_path, flash: { notice: "『  #{@board.title}』の掲示板が削除されました" }
	  						# ↑flashの別の書き方
	end

	private

	def board_params
		# 末尾のtag_idsは、formビルダーのcolectioncheckboxの第一引数に指定したものを許可するための記述
	  params.require(:board).permit(:name, :title, :body, tag_ids: [])
	end

	def set_target_params
	  @board = Board.find(params[:id])
	end
end
