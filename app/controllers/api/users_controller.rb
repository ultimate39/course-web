module API
class UsersController < ApplicationController
  before_action :set_user,  only: [:show, :edit, :update, :destroy]
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
      format.json { render :show, status: :created, location: api_user_path(@user) }
    else
      format.html { render html: @user.errors, status: 404 }
      format.json { render json: @user.errors, status: :unprocessable_entity }
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

    respond_to do |format|
      if @user.save
        format.html { redirect_to api_user_path(@user), notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to api_user_path(@user), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to api_users_url, notice: 'User was successfully destroyed.' }
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
       format.json { render json: 'Bad credentials', status: 401 } 
       format.xml { render xml: 'Bad credentials', status: 401 }
       format.html { render html: 'Bad credentials', status: 401} 
      end 
    end

    def authenticate_basic_auth  
      authenticate_with_http_basic do |username, password| 
       User.authenticate(username, password)
      end
    end  
end
end
