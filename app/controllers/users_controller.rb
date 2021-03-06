require 'bcrypt'
class UsersController < ApplicationController
	layout 'user_dashboard'
	before_action :authenticate_user!, :except => [:user_demo_login , :trigger_login, :check_if_user_exist, :login_sign_up]

	# this is used to initial user's object to that it will be available to all
	# method without recalling it again
	before_filter :set_up_user, :except => [:user_demo_login, :trigger_login, :check_if_user_exist, :login_sign_up]

    def set_up_user
        @user = current_user
        @notification = Notification.where(user_id: @user.id, read: 0)
    end

    def  createt
        raise request.env["rack.auth"]
    end


   def update_notification
	     @notification = Notification.find(params[:notification_id])
	    if !@notification.update_attributes(update_notification_params)
	       render plain: "failure"
	    else
	      render plain: "success"
	    end
   end


  def build_profile
    @unique_to_p = false
    @profile_page = true
    render  :layout => 'wizard'
  end


  def become_interviewer
    @user.update_attributes(status:1)
    if @user.companies.length == 0
      redirect_to new_company_path
    else
      self.dashboard_function()
    end
  end

  def become_applicant
    @user.update_attributes(status:0)
    redirect_to user_timeline_path(current_user)
  end


  def profile
     @unique_to_p = false
     @profile_page = true
     @user = current_user
     render  :layout => 'wizard'
  end


  def update_profile
     @user.update_attributes(user_params)
     if !session[:return_to].nil? 
       redirect_to session[:return_to]
     else
       redirect_to user_timeline_path
     end   
  end


  def user_demo_login
    render :layout => 'signin'
  end


  def trigger_login
      if User.exists?(email: "demo_user@dropque.com")
        sign_out current_user
        demo_user = User.find_by(email:"demo_user@dropque.com")
        sign_in(:user, demo_user)
        redirect_to user_profile_path(demo_user)
      else
         demo_user = User.new(name: "Demo Name", email: "demo_user@dropque.com", password: 'dropqueapp', password_confirmation: 'dropqueapp')
         demo_user.save()
         sign_in(:user, demo_user)
         if  demo_user.status == 1
            self.dashboard_function()
         elsif demo_user.status == 0
            redirect_to user_timeline_path(demo_user)
         elsif  demo_user.status == nil
            redirect_to user_profile_path(demo_user)
         end 
      end
  end

  def application_timeline
    @profile_page = true
    @logo_off = false
  end


  def account
    @profile_page = true
    @logo_off = false
    if params[:update].present?
        @user.update_attributes(user_params)
        flash.now[:success] = "Account Updated Successfully"     
    end
  end



  def interviews
    @profile_page = true
    @logo_off = false
    render "applicant_interview_listing"
  end
  

  def check_if_user_exist
      user_email = params[:email]
      result = User.find_by(email:user_email)
      if result
          # render json: {status: "success", email: result.email, name: result.name}
          render plain: result.name
      else
          render plain: "error"
          # render json: {status: "error"}
      end
  end

  def login_sign_up
      if User.exists?(email: params[:email])
      user_applicant = User.find_by(email:params[:email])
       bcrypt_object = BCrypt::Password.new(user_applicant.encrypted_password) 
       password_hash = ::BCrypt::Engine.hash_secret(params[:password], bcrypt_object.salt)
            if password_hash == user_applicant.encrypted_password
                sign_in(:user, user_applicant)
                render plain: "success"
            else
                render plain: "error"
            end
      else
         user_applicant = User.new(name: params[:name], email: params[:email], password: params[:password], password_confirmation: params[:password])
         user_applicant.save()
         sign_in(:user, user_applicant)
         render plain: "success"
      end
      puts "sign in successfully"
  end


  # def account
  # 	if params[:update].present?
	 #  	bcrypt_object = BCrypt::Password.new(@user.encrypted_password) 
	 #    password_hash = ::BCrypt::Engine.hash_secret(params[:current_password], bcrypt_object.salt)
  #       if password_hash == @user.encrypted_password
  #         if !params[:password].blank? 
  #           if (params[:password] == params[:confirm_password])
  #             @user.update_attributes(email: params[:email], name: params[:name], password: params[:password])
  #             flash.now[:success] = "Account Updated Successfully"
  #           else 
  #             flash.now[:danger] = "Password Didn't match"
  #           end
  #         else 
  #           @user.update_attributes(email: params[:email], name: params[:name])
  #            flash.now[:success] = "Account Updated Successfully"
  #         end
  #       else
  #         flash.now[:danger] = "Current password not correct"
  #       end 
  #    end
  # end

  def check_password
  	 bcrypt_object = BCrypt::Password.new(@user.encrypted_password) 
     password_hash = ::BCrypt::Engine.hash_secret(params[:current_password], bcrypt_object.salt)
	    if password_hash == @user.encrypted_password
	    	render plain: "correct"
	    else
	    	render plain: "wrong"
	    end
  end

  def update_account_profile
     @user.update_attributes(user_profile_params)
     flash.now[:success] = "Profile Updated Successfully"     
     redirect_to user_account_path
  end

  def update_account_skill
      @user.update_attributes(skill: params[:skill])
     flash.now[:success] = "Skills Updated Successfully"     
      redirect_to user_account_path
  end

  def update_education
      if @user.educations.nil?
         @user.educations= []
      end
      if params[:status] == "new"
          @user.educations << params[:data]
      elsif params[:status] == "update"
          @user.educations[params[:pos].to_i] = params[:data]
      end
      if @user.save
          render plain: "successful"
      else
          render plain: "error"
      end
  end

  def delete_education
      @user.educations.delete_at(params[:pos].to_i)    
      if  @user.save
        render plain: "successful"
      else
        render plain: "error"
      end
  end

  def retrieve_education
      render :json => {:message => "success", :data=> @user.educations[params[:pos].to_i]}, status: 200
  end

  # parameters used to update the notification
  def update_notification_params
    params.permit(:read)
  end

  # parameters to update user's details
  def user_params
    params.permit(:name, :a_dp, :a_qualification, :a_experience, :a_dob, :a_gender, :address, :address, :city, :country, :a_cv, :logo, :status, :skill, :school, :grade, :field_of_study, :about_me)
  end

  def user_profile_params
    params.permit(:a_dp, :name, :email, :address, :city, :state,  :country , :about_me, :telephone, social: [:twitter, :linkedin, :github])
  end

end
