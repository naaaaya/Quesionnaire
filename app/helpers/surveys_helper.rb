module SurveysHelper

  def edit_question_form (question)
    question_description = content_tag(:div, class:"question_description") do
      concat text_field(:question, :id, value: question.id, name: 'questions[][id]', type:'hidden')
      concat text_field(:question, :description, value: question.description, name:'questions[][description]')
      concat select(:question, :question_type, Question.question_types.keys.to_a, {selected: question.question_type},
        class: 'form-control', data: {"question-number" =>question.id}, id:"question#{question.id}_question_type",
          name:'questions[][question_type]', onchange:'appendAnswerForm(this)')
    end
    answer_field = content_tag(:div, class: "question_field", id: "question#{question.id}" ) do
      case question.question_type_before_type_cast
      when Question::TEXT_FIELD
        text_field(:answer, :description, placeholder: '自由記述（短文回答）')
      when Question::TEXTAREA
        text_area(:answer, :description, placeholder: '自由記述（長文回答）')
      when Question::CHECKBOX, Question::RADIO_BUTTON
        concat choise_list(question)
        concat content_tag(:input,'', {type:'button',class: 'append_checkbox', data: {"question-number" => question.id}, value:'選択肢追加', onclick:"appendCheckbox(this)"})
      end
    end
    question_description + answer_field
  end

  def choise_list(question)
    content_tag(:ul, class: "checkbox_choises",id: "question#{question.id}-choises") do
      choiseNumber = 1
      question.questions_choises.each do |choise|
        choises = content_tag(:li, class: "question#{question.id}-choise", id: "choise#{choiseNumber}") do
          concat text_field(:questions_choise, :id, value: choise.id, name:'questions[][choises[][id]]', type: 'hidden')
          concat text_field(:questions_choise, :description, value: choise.description, name:'questions[][choises[][description]]')
        end
        choiseNumber += 1
        concat choises
      end
    end
  end


end