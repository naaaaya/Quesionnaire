module SurveysHelper

  def question_description_form(question)
    question_description = content_tag(:div, class:"question_description") do
      concat text_field(:question, :id, value: question.id, name: 'questions[][id]', type:'hidden')
      concat text_field(:question, :description, value: question.description, name:'questions[][description]')
      concat select(:question, :question_type, Question.question_types.keys.to_a, {selected: question.question_type},
        class: 'form-control', data: {"question-number" =>question.id}, id:"question#{question.id}_question_type",
          name:'questions[][question_type]', onchange:'appendAnswerForm(this)')
    end
  end

  def answers_preview_forms(question)
    content_tag(:div, class: "question_field", id: "question#{question.id}" ) do
      case question.question_type_before_type_cast
      when Question.question_types[:text_field]
        text_field(:answer, :description, placeholder: '自由記述（短文回答）')
      when Question.question_types[:textarea]
        text_area(:answer, :description, placeholder: '自由記述（長文回答）')
      when Question.question_types[:checkbox], Question.question_types[:radio_button]
        concat choise_list(question)
        concat content_tag(:input,'', {type:'button',class: 'append_checkbox', data: {"question-number" => question.id}, value:'選択肢追加', onclick:"appendCheckbox(this)"})
      end
    end
  end

  def choise_list(question)
    content_tag(:ul, class: "checkbox_choises",id: "question#{question.id}-choises") do
      choise_number = 1
      question.questions_choises.each do |choise|
        choises = content_tag(:li, class: "question#{question.id}-choise", id: "choise#{choise_number}") do
          concat text_field(:questions_choise, :id, value: choise.id, name:'questions[][choises[][id]]', type: 'hidden')
          concat text_field(:questions_choise, :description, value: choise.description, name:'questions[][choises[][description]]')
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
      answer = content_tag(:ul, class: 'text_answers') do
        question.text_answers.each do |answer|
          if answer.surveys_user.answered_flag
            concat content_tag(:li, answer.description)
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
      description = content_tag(:h4, question.description )
      case question.question_type_before_type_cast
      when Question.question_types[:text_field], Question.question_types[:textarea]
        answer = content_tag(:ul, class: "text_answers") do
          question.text_answers.each do |answer|
            if answer.surveys_user.user.company.id == current_user.company.id && answer.surveys_user.answered_flag
              concat content_tag(:li, answer.description)
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