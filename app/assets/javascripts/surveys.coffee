$ ->
  question_field = $('.question_field')
  type = 'text_field'
  choise_index = 1
  question_id = $('select').data('question-id')

  appendQuestionType = (type, question_id) ->
    question_field = $("#question#{question_id}")
    if type == 'text_field'
      question_field.append("<input type = 'text' placeholder = '自由記述（短文回答）'>")
    else if type == 'textarea'
      question_field.append("<textarea name = 'answer' rows='4' cols='40' placeholder = '自由記述（長文回答）'>")
    else if type == 'checkbox'
      choise_index = 1
      question_field.append("<ul class= 'checkbox_choises' id='question#{question_id}-choises'>
                            <li id='choise#{choise_index}' class='question#{question_id}-choise'>
                            <input type= 'text' name= 'choises[][description]' value= '選択肢#{choise_index}'>
                            <input type='hidden' name='choises[][question_id]' value=#{question_id}>
                            <input type= 'button' id='delete_checkbox' value= '削除' data-index=#{choise_index} data-question-id=#{question_id}>
                            </li></ul>
                            <input type= 'button' class='append_checkbox' data-question-id=#{question_id} value= '選択肢追加'>")
    else
      choise_index = 1
      question_field.append("<ul class= 'radio_choises' id='question#{question_id}-choises'>
                            <li id='choise#{choise_index}' class='question#{question_id}-choise'>
                            <input type= 'text' name= 'choises[][description]' value= '選択肢#{choise_index}'>
                            <input type='hidden' name='choises[][question_id]' value=#{question_id}>
                            <input type= 'button' id='delete_choise' value= '削除' data-index=#{choise_index} data-question-id=#{question_id}>
                            </li></ul>
                            <input type= 'button' id='append_radio' data-question-id=#{question_id}  value= '選択肢追加'>")

  $('.questions').on 'change', '.form-control', ->
    question_type = $(@).val()
    question_id = $(@).data('question-id')
    $("#question#{question_id}").empty()
    $('.choise_number').remove()
    appendQuestionType(question_type, question_id)

  $('.questions').on 'click', '.append_checkbox', ->
    choise_index = choise_index + 1
    question_id = $(@).data('question-id')
    $("#question#{question_id}-choises").append("<li id='choise#{choise_index}' class='question#{question_id}-choise'>
                                                <input type= 'text' name= 'choises[][description]' value= '選択肢#{choise_index}'>
                                                <input type='hidden' name='choises[][question_id]' value=#{question_id}>
                                                <input type= 'button' id='delete_choise' value= '削除' data-index= #{choise_index} data-question-id=#{question_id}>
                                                </li>")

  $('.questions').on 'click', '#append_radio', ->
    choise_index = choise_index + 1
    question_id = $(@).data('question-id')
    $("#question#{question_id}-choises").append("<li id='choise#{choise_index}' class='question#{question_id}-choise'>
                                                <input type= 'text' name= 'choises[][description]' value= '選択肢#{choise_index}'>
                                                <input type='hidden' name='choises[][question_id]' value=#{question_id}>
                                                <input type= 'button' id='delete_choise' value= '削除' data-index= #{choise_index} data-question-id=#{question_id}>
                                                </li>")

  $('.questions').on 'click', '#delete_choise', ->
    question_id = $(@).data('question-id')
    choise_id = $(@).data('index')
    $("#choise#{choise_id}").remove(".question#{question_id}-choise")


  $('.add_question').on 'click', ->
    question_id = question_id + 1
    html = "<p>問題</p>
            <input value='無題の質問' type='text' name='questions[][description]' id='question#{question_id}_description'>
            <select class='form-control' name='questions[][question_type]' id='question#{question_id}_question_type' data-question-id=#{question_id}>
            <option value='text_field'>text_field</option>
            <option value='textarea'>textarea</option>
            <option value='checkbox'>checkbox</option>
            <option value='radio_button'>radio_button</option></select>
            <div id='question#{question_id}' class='question_field'>
            <input placeholder='自由記述（短文回答）' type='text'></div>"
    $('.questions').append(html)

