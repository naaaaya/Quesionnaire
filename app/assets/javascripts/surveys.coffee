$ ->

  question_field = $('.question_field')
  type = 'text_field'
  choise_index = 1
  appendQuestionType = (type) ->
    if type == 'text_field'
      question_field.append("<input type = 'text' placeholder = '自由記述（短文回答）'>")
    else if type == 'textarea'
      question_field.append("<textarea name = 'answer' rows='4' cols='40' placeholder = '自由記述（長文回答）'>")
    else if type == 'checkbox'
      choise_index = 1
      question_field.append("<ul class= 'checkbox_choises'><li id='choise#{choise_index}'><input type= 'text' value= '選択肢#{choise_index}'><input type= 'button' id='delete_checkbox' value= '削除' data-index= #{choise_index}></li></ul><input type= 'button' id='append_checkbox' value= '選択肢追加'>")
    else
      choise_index = 1
      question_field.append("<ul class= 'radio_choises'><li id='choise#{choise_index}'><input type= 'text' value= '選択肢#{choise_index}'><input type= 'button' id='delete_choise' value= '削除' data-index= #{choise_index}></li></ul><input type= 'button' id='append_radio' value= '選択肢追加'>")

  $('#question_question_type').on 'change', ->
    question_type = $(@).val()
    question_field.empty()
    $('.choise_number').remove()
    appendQuestionType(question_type)

  question_field.on 'click', '#append_checkbox', ->
    choise_index = choise_index + 1
    $('.checkbox_choises').append("<li id='choise#{choise_index}'><input type= 'text' value= '選択肢#{choise_index}'><input type= 'button' id=
                                  'delete_checkbox' value= '削除' data-index= #{choise_index}></li>")

  question_field.on 'click', '#append_radio', ->
    choise_index = choise_index + 1
    $('.radio_choises').append("<li id='choise#{choise_index}'><input type= 'text' value= '選択肢#{choise_index}'><input type= 'button' id=
                                  'delete_choise' value= '削除' data-index= #{choise_index}></li>")

  question_field.on 'click', '#delete_choise', ->
    delete_id = $(@).data('index')
    $("#choise"+delete_id).remove()



