class SurveysController < ApplicationController

  def index
  end

  def new
    @survey = Survey.new
    @survey.questions.build
  end

  def create
  end
end
