# frozen_string_literal: true

# Users Controller
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
 
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
      format.html
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    respond_to do |format|
      format.html
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user       = User.new(user_params)
    @user.admin = false
    @user.skip_password_validation = true
    @user.skip_confirmation!
    
    respond_to do |format|
      if @user.save
        UserMailer.delay.welcome_reset_password_instructions(@user)
        format.html { redirect_to @user, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
      else
        format.html { render :edit }

      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    
    @user.destroy!
    redirect_to users_path, notice: 'User was successfully destroyed.'
    
  rescue ActiveRecord::RecordNotDestroyed => e
    redirect_to users_path, alert: e.message
  end
  

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:email, :name)
  end
end

