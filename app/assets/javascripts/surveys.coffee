$ ->

  type = 'text_field'
  choiseNumber = 1
  questionNumber = 1

  renderTextField = ->
    "<input type = 'text' placeholder = '自由記述（短文回答）'>"

  renderTextArea = ->
    "<textarea name = 'answer' rows='4' cols='40' placeholder = '自由記述（長文回答）'>"

  renderCheckBox = (choiseNumber, QuestionNumber) ->
    "<ul class= 'checkbox_choises' id='question#{questionNumber}-choises'>
    <li id='choise#{choiseNumber}' class='question#{questionNumber}-choise'>
    <input type= 'text' name= 'questions[][choises[][description]]' value= '選択肢#{choiseNumber}'>
    <input type= 'button' id='delete_choise' value= '削除' data-number=#{choiseNumber} data-question-number=#{questionNumber}>
    </li></ul>
    <input type= 'button' class='append_checkbox' data-question-number=#{questionNumber} value= '選択肢追加'>"

  renderRadioButton = (choiseNumber, QuestionNumber) ->
    "<ul class= 'radio_choises' id='question#{questionNumber}-choises'>
    <li id='choise#{choiseNumber}' class='question#{questionNumber}-choise'>
    <input type= 'text' name= 'questions[][choises[][description]]' value= '選択肢#{choiseNumber}'>
    <input type= 'button' id='delete_choise' value= '削除' data-number=#{choiseNumber} data-question-number=#{questionNumber}>
    </li></ul>
    <input type= 'button' id='append_radio' data-question-number=#{questionNumber}  value= '選択肢追加'>"

  appendQuestionType = (type, questionNumber) ->
    questionField = $("#question#{questionNumber}")

    switch type
      when  'text_field'
        questionField.append(renderTextField())
      when 'textarea'
        questionField.append(renderTextArea())
      when 'checkbox'
        choiseNumber = 1
        questionField.append(renderCheckBox(choiseNumber, questionNumber))
      when 'radio_button'
        choiseNumber = 1
        questionField.append(renderRadioButton(choiseNumber, questionNumber))

  $('.questions').on 'change', '.form-control', ->
    questionType = $(this).val()
    questionNumber = $(this).data('questionNumber')
    $("#question#{questionNumber}").empty()
    $('.choiseNumber').remove()
    appendQuestionType(questionType, questionNumber)

  $('.questions').on 'click', '.append_checkbox', ->
    choiseNumber = choiseNumber + 1
    questionNumber = $(this).data('questionNumber')
    $("#question#{questionNumber}-choises").append("<li id='choise#{choiseNumber}' class='question#{questionNumber}-choise'>
                                                <input type= 'text' name= 'questions[][choises[][description]]' value= '選択肢#{choiseNumber}'>
                                                <input type= 'button' id='delete_choise' value= '削除' data-number= #{choiseNumber} data-question-number=#{questionNumber}>
                                                </li>")
  $('.questions').on 'click', '#append_radio', ->
    choiseNumber = choiseNumber + 1
    questionNumber = $(this).data('questionNumber')
    $("#question#{questionNumber}-choises").append("<li id='choise#{choiseNumber}' class='question#{questionNumber}-choise'>
                                                <input type= 'text' name= 'questions[][choises[][description]]' value= '選択肢#{choiseNumber}'>
                                                <input type= 'button' id='delete_choise' value= '削除' data-number= #{choiseNumber} data-question-number=#{questionNumber}>
                                                </li>")
  $('.questions').on 'click', '#delete_choise', ->
    questionNumber = $(this).data('questionNumber')
    deleteChoiseNumber = $(this).data('number')
    $("#choise#{deleteChoiseNumber}").remove(".question#{questionNumber}-choise")

  $('.add_question').on 'click', ->
    questionNumber = questionNumber + 1
    html = "<p>問題</p>
            <input value='無題の質問' type='text' name='questions[][description]' id='question#{questionNumber}_description'>
            <select class='form-control' name='questions[][question_type]' id='question#{questionNumber}_question_type' data-question-number=#{questionNumber} onchange='appendAnswerForm(this)'>
            <option value='text_field'>text_field</option>
            <option value='textarea'>textarea</option>
            <option value='checkbox'>checkbox</option>
            <option value='radio_button'>radio_button</option></select>
            <div id='question#{questionNumber}' class='questionField'>
            <input placeholder='自由記述（短文回答）' type='text'></div>"
    $('.questions').append(html)


