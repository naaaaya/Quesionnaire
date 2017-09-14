module SurveysHelper

  def answer_field(question, answer_form)
    if question.is_answered?(current_user)
      surveys_user = question.survey.surveys_users.find_by(user_id: current_user.id)
      if question.text_field?
        answer_form = answer_form.fields_for "#{question.id}".to_sym do |text_answer_form|
          text_answer_form.text_field :description, value: question.text_answers.find_by(surveys_user_id: surveys_user.id).description, class: 'form-control'
        end
      elsif question.textarea?
        answer_form = answer_form.fields_for "#{question.id}".to_sym do |text_answer_form|
          text_answer_form.text_area :description, value: question.text_answers.find_by(surveys_user_id: surveys_user.id).description, class: 'form-control'
        end
      elsif question.checkbox?
        answer_form = answer_form.fields_for "#{question.id}".to_sym do |choise_answer_form|
          choise_answer_form.collection_check_boxes :choise_ids, question.questions_choises, :id, :description,checked: question.choise_answers.where(surveys_user_id: surveys_user.id).map {|answer| answer.questions_choise.id },
          include_hidden: false
        end
      else
        answer_form = answer_form.fields_for "#{question.id}".to_sym do |choise_answer_form|
          choise_answer_form.collection_radio_buttons :choise_id, question.questions_choises, :id, :description,checked: question.choise_answers.find_by(surveys_user_id: surveys_user.id).questions_choise.id, include_hidden: false
        end
      end
    else
      if question.text_field?
        answer_form = answer_form.fields_for "#{question.id}".to_sym do |text_answer_form|
          text_answer_form.text_field :description, placeholder: '自由記述（短文回答）', class: 'form-control'
        end
      elsif question.textarea?
        answer_form.fields_for "#{question.id}".to_sym do |text_answer_form|
          text_answer_form.text_area :description, placeholder: '自由記述（長文回答）', class: 'form-control'
        end
      elsif question.checkbox?
        answer_form.fields_for "#{question.id}".to_sym do |choise_answer_form|
          choise_answer_form.collection_check_boxes :choise_ids, question.questions_choises, :id, :description, include_hidden: false
        end
      elsif question.radio_button?
        answer_form.fields_for "#{question.id}".to_sym do |choise_answer_form|
          choise_answer_form.collection_radio_buttons :choise_id, question.questions_choises, :id, :description, include_hidden: false
        end
      end
    end
  end


  def question_description_form(question)
    question_description = content_tag(:div, class: "col-md-6") do
      concat text_field(:question, :id, value: question.id, name: 'questions[][id]', type:'hidden')
      concat text_field(:question, :description, value: question.description, name:'questions[][description]', class: "form-control")
    end
    question_description + question_type_select(question)
  end

  def question_type_select(question)
    content_tag(:div, class: "col-md-4 ui-select") do
      select(:question, :question_type, Question.question_types.keys.to_a, {selected: question.question_type},
        class: 'form-control', data: {"question-number" =>question.id}, id:"question#{question.id}_question_type",
          name:'questions[][question_type]', onchange:'appendAnswerForm(this)')
    end
  end

  def answers_preview_forms(question)
    content_tag(:div, class: "question_field", id: "question#{question.id}" ) do
      if question.text_field?
        text_field(:answer, :description, placeholder: '自由記述（短文回答）', class: "form-control")
      elsif question.textarea?
        text_area(:answer, :description, placeholder: '自由記述（長文回答）', class: "form-control")
      else
        concat choise_list(question)
        concat content_tag(:input,'', {type:'button',class: 'append_checkbox btn btn-default', data: {"question-number" => question.id}, value:'選択肢追加'})
      end
    end
  end

  def choise_list(question)
    content_tag(:ul, class: "checkbox-choises",id: "question#{question.id}-choises") do
      choise_number = 1
      question.questions_choises.each do |choise|
        choises = content_tag(:li, class: "choise-description question#{question.id}-choise", id: "choise#{choise_number}") do
          concat text_field(:questions_choise, :id, value: choise.id, name:'questions[][choises[][id]]', type: 'hidden', class: "form-control")
          concat text_field(:questions_choise, :description, value: choise.description, name:'questions[][choises[][description]]',
            class: "form-control")
          end
          choise_number += 1
          concat choises
        end
      end
    end

    def overall_survey_results(question)
      description = content_tag(:h4, question.description)
      case question.question_type_before_type_cast
      when Question.question_types[:text_field], Question.question_types[:textarea]
        answer = content_tag(:ul, class: 'text_answers list-group col-md-8') do
          question.text_answers.each do |answer|
            if answer.surveys_user.answered_flag
              concat content_tag(:li, answer.description, class: 'list-group-item')
            end
          end
        end
      when Question.question_types[:checkbox]
        answer = bar_chart question.overall_choise_answers_for_chart
      when Question.question_types[:radio_button]
        answer = pie_chart question.overall_choise_answers_for_chart
      end
      description + answer
    end

    def company_survey_results(question)
      description = content_tag(:h4, question.description)
      case question.question_type_before_type_cast
      when Question.question_types[:text_field], Question.question_types[:textarea]
        answer = content_tag(:ul, class: "text_answers list-group col-md-8") do
          question.text_answers.each do |answer|
            if answer.surveys_user.user.company.id == current_user.company.id && answer.surveys_user.answered_flag
              concat content_tag(:li, answer.description, class: 'list-group-item')
            end
          end
        end
      when Question.question_types[:checkbox]
        answer = bar_chart question.company_choise_answers_for_chart(current_user.company)
      when Question.question_types[:radio_button]
        answer = pie_chart question.company_choise_answers_for_chart(current_user.company)
      end
      description + answer
    end

  end