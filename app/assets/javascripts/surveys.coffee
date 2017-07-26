$ ->

  question_field = $('.question_field')
  type = 'text_field'
  choise_index = 1
  question_num = 1

  appendQuestionType = (type) ->
    if type == 'text_field'
      question_field.append("<input type = 'text' placeholder = '自由記述（短文回答）'>")
    else if type == 'textarea'
      question_field.append("<textarea name = 'answer' rows='4' cols='40' placeholder = '自由記述（長文回答）'>")
    else if type == 'checkbox'
      choise_index = 1
      question_field.append("<ul class= 'checkbox_choises'>
                            <li id='choise#{choise_index}'>
                            <input type= 'text' name= 'choises[][description]' value= '選択肢#{choise_index}'>
                            <input type= 'button' id='delete_checkbox' value= '削除' data-index= #{choise_index}></li></ul>
                            <input type= 'button' id='append_checkbox' value= '選択肢追加'>")
    else
      choise_index = 1
      question_field.append("<ul class= 'radio_choises'>
                            <li id='choise#{choise_index}'>
                            <input type= 'text' name= 'choise[description]' value= '選択肢#{choise_index}'>
                            <input type= 'button' id='delete_choise' value= '削除' data-index= #{choise_index}></li></ul>
                            <input type= 'button' id='append_radio' value= '選択肢追加'>")

  $('.form-control').on 'change', ->
    question_type = $(@).val()
    question_field.empty()
    $('.choise_number').remove()
    appendQuestionType(question_type)

  question_field.on 'click', '#append_checkbox', ->
    choise_index = choise_index + 1
    $('.checkbox_choises').append("<li id='choise#{choise_index}'><input type= 'text' name= 'choises[][description]' value= '選択肢#{choise_index}'>
                                   <input type= 'button' id='delete_choise' value= '削除' data-index= #{choise_index}></li>")

  question_field.on 'click', '#append_radio', ->
    choise_index = choise_index + 1
    $('.radio_choises').append("<li id='choise#{choise_index}'><input type= 'text' name= 'choises[][description]' value= '選択肢#{choise_index}'>
                                <input type= 'button' id='delete_choise' value= '削除' data-index= #{choise_index}></li>")

  question_field.on 'click', '#delete_choise', ->
    delete_id = $(@).data('index')
    $("#choise"+delete_id).remove()


  $('.add_question').on 'click', ->
    question_num = question_num + 1
    html = "<p>問題#{question_num}</p>
            <input value='無題の質問' type='text' name='question#{question_num}[description]' id='question#{question_num}_description'>
            <select class='form-control' name='question#{question_num}[question_type]' id='question#{question_num}_question_type'>
            <option value='text_field'>text_field</option>
            <option value='textarea'>textarea</option>
            <option value='checkbox'>checkbox</option>
            <option value='radiobutton'>radiobutton</option></select>"
    $('.questions').append(html)


  # $('.question_form').on 'change', ->
  #   setTimeout ->
  #     survey_form = $('.new_survey')
  #     formdata = new FormData(survey_form.get(0))
  #     url = survey_form.attr('action')
  #     $.ajax
  #       type: 'POST',
  #       url: url,
  #       dataType: 'json',
  #       data: formdata,
  #       processData: false,
  #       contentType: false
  #       success: (data, textStatus, jqXHR) ->
  #         console.log(data)
  #       error: (jqXHR, textStatus, errorThrown) ->
  #         console.log(errorThrown)
  #   , 1000




