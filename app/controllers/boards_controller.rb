class BoardsController < ApplicationController
	def index
	  @boards = Board.all
	end

	def new
	  @board = Board.new
	end

	def create
	  Board.create(board_params)
	end

	def show
	  @board = Board.find(params[:id])
	end

	def edit
	  @board = Board.find(params[:id])
	end

	def update
	  # 変数boardにfindメソッドでIDを取得した値を代入
	  board = Board.find(params[:id])
	  # updateアクションで保存_引数にはストロングパラメータで
	  board.update(board_params)

	  redirect_to board
	end

	private

	def board_params
	  params.require(:board).permit(:name, :title, :body)
	end 
end
