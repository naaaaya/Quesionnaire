$ ->

  type = 'text_field'
  choise_number = 1
  question_number = 1


  appendQuestionType = (type, question_number) ->
    question_field = $("#question#{question_number}")
    switch type
      when  'text_field'
        question_field.append("<input type = 'text' placeholder = '自由記述（短文回答）'>")
      when 'textarea'
        question_field.append("<textarea name = 'answer' rows='4' cols='40' placeholder = '自由記述（長文回答）'>")
      when 'checkbox'
        choise_number = 1
        question_field.append("<ul class= 'checkbox_choises' id='question#{question_number}-choises'>
                              <li id='choise#{choise_number}' class='question#{question_number}-choise'>
                              <input type= 'text' name= 'questions[][choises[][description]]' value= '選択肢#{choise_number}'>
                              <input type= 'button' id='delete_choise' value= '削除' data-number=#{choise_number} data-question-number=#{question_number} onclick=deleteChoise(this)>
                              </li></ul>
                              <input type= 'button' class='append_checkbox' data-question-number=#{question_number} value= '選択肢追加' onclick=appendCheckbox(this)>")
      when 'radio_button'
        choise_number = 1
        question_field.append("<ul class= 'radio_choises' id='question#{question_number}-choises'>
                              <li id='choise#{choise_number}' class='question#{question_number}-choise'>
                              <input type= 'text' name= 'questions[][choises[][description]]' value= '選択肢#{choise_number}'>
                              <input type= 'button' id='delete_choise' value= '削除' data-number=#{choise_number} data-question-number=#{question_number} onclick=deleteChoise(this)>
                              </li></ul>
                              <input type= 'button' id='append_radio' data-question-number=#{question_number}  value= '選択肢追加' onclick='appendRadioButton(this)'>")

  @appendAnswerForm = (select_field) ->
    console.log(select_field)
    question_type = $(select_field).val()
    question_number = $(select_field).data('questionNumber')
    $("#question#{question_number}").empty()
    $('.choise_number').remove()
    appendQuestionType(question_type, question_number)

  @appendCheckbox = (button) ->
    choise_number = choise_number + 1
    question_number = $(button).data('questionNumber')
    $("#question#{question_number}-choises").append("<li id='choise#{choise_number}' class='question#{question_number}-choise'>
                                                <input type= 'text' name= 'questions[][choises[][description]]' value= '選択肢#{choise_number}'>
                                                <input type= 'button' id='delete_choise' value= '削除' data-number= #{choise_number} data-question-number=#{question_number} onclick=deleteChoise(this)>
                                                </li>")
  @appendRadioButton = (button) ->
    choise_number = choise_number + 1
    question_number = $(button).data('questionNumber')
    $("#question#{question_number}-choises").append("<li id='choise#{choise_number}' class='question#{question_number}-choise'>
                                                <input type= 'text' name= 'questions[][choises[][description]]' value= '選択肢#{choise_number}'>
                                                <input type= 'button' id='delete_choise' value= '削除' data-number= #{choise_number} data-question-number=#{question_number} onclick=deleteChoise(this)>
                                                </li>")
  @deleteChoise = (button) ->
    question_number = $(button).data('questionNumber')
    choise_id = $(button).data('number')
    $("#choise#{choise_id}").remove(".question#{question_number}-choise")

  @addQuestion = ->
    question_number = question_number + 1
    html = "<p>問題</p>
            <input value='無題の質問' type='text' name='questions[][description]' id='question#{question_number}_description'>
            <select class='form-control' name='questions[][question_type]' id='question#{question_number}_question_type' data-question-number=#{question_number} onchange='appendAnswerForm(this)'>
            <option value='text_field'>text_field</option>
            <option value='textarea'>textarea</option>
            <option value='checkbox'>checkbox</option>
            <option value='radio_button'>radio_button</option></select>
            <div id='question#{question_number}' class='question_field'>
            <input placeholder='自由記述（短文回答）' type='text'></div>"
    $('.questions').append(html)


