class SurveysController < ApplicationController
  before_action :authenticate_user!

  def index
    @surveys = current_user.company.surveys
  end
end
