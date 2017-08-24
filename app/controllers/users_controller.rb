class UsersController < ApplicationController
  before_action :authenticate_user!
  def index
    redirect_to authenticated_user_root_path unless current_user.chief_flag
    @company = current_user.company
  end

  def destroy
    @user = User.find(params[:id])
    begin
      ActiveRecord::Base.transaction do
        @surveys_users = @user.try(:surveys_users)
        if @surveys_users.present?
          @surveys_users.each do |surveys_user|
            surveys_user.text_answers.map{|answer| answer.destroy!} if surveys_user.text_answers
            surveys_user.choise_answers.map{|answer| answer.destroy!} if surveys_user.choise_answers
            surveys_user.destroy!
          end
        end
        @user.destroy!
      end
      redirect_to users_path
    rescue  => e
    end
  end
end
