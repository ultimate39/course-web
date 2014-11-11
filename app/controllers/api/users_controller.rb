module API
class UsersController < ApplicationController
  before_action :set_user,  only: [:show]
  before_action :authenticate,  only: [:edit, :update, :destroy]
  # GET /users
  # GET /users.json 
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
    if @user
      format.json { render :show, status: :ok, location: api_user_path(@user) }
      format.html { render :show, status: :ok, location: api_user_path(@user) }
    else
      format.html { render json: @user.errors, status: 404 }
      format.json { render json: @user.errors, status: 404 }
    end
   end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
      if @user.save
        render json: @user, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity 
      end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { render :show, status: :ok, location: api_user_path(@user) }
        format.json { render :show, status: :ok, location: api_user_path(@user) }
      else
        format.html { render json: @user.errors, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { head :no_content }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :password)
    end

    def authenticate  
      authenticate_basic_auth || render_unauthorized  
    end

    def render_unauthorized  
     self.headers['WWW-Authenticate'] = 'Basic realm="Users"' 
      respond_to do |format|  
       format.json { render json: '{ "error":"bad credentials" }', status: 401 } 
       format.xml { render xml: 'Bad credentials', status: 401 }
       format.html { render html: 'Bad credentials', status: 401} 
      end 
    end

    def authenticate_basic_auth  
      authenticate_with_http_basic do |username, password| 
       @user = User.authenticate(username, password)
       @user && @user.id.to_s == params[:id].to_s
      end
    end  
end
end
