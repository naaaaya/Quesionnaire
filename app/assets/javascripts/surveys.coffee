$ ->
  type = 'text_field'
  choiseNumber = 1
  questionNumber = 1

  renderTextField = ->
    "<input type = 'text' placeholder = '自由記述（短文回答）' class='form-control'>"

  renderTextArea = ->
    "<textarea name = 'answer' rows='4' cols='40' placeholder = '自由記述（長文回答）' class='form-control'>"

  renderCheckBox = (choiseNumber, QuestionNumber) ->
    "<ul class='checkbox-choises' id='question#{questionNumber}-choises'>
    <li id='choise#{choiseNumber}' class='choise-description question#{questionNumber}-choise'>
    <input type='text' name='questions[][choises[][description]]' value='選択肢#{choiseNumber}', class='form-control col-md-4'>
    <input type='button' id='delete_choise' value='削除' data-number=#{choiseNumber} data-question-number=#{questionNumber},
    class='delete_choise btn btn-danger'></li></ul>
    <input type='button' class='append_checkbox btn btn-default' data-question-number=#{questionNumber} value='選択肢追加'>"


  renderRadioButton = (choiseNumber, QuestionNumber) ->
    "<ul class='radio-choises' id='question#{questionNumber}-choises'>
    <li id='choise#{choiseNumber}' class='choise-description question#{questionNumber}-choise'>
    <input type='text' name='questions[][choises[][description]]' value='選択肢#{choiseNumber}', class='form-control col-md-4'>
    <input type='button' id='delete_choise' value='削除' data-number=#{choiseNumber} data-question-number=#{questionNumber},
    class='delete_choise btn btn-danger'></li></ul>
    <input type='button' class='append_checkbox btn btn-default' data-question-number=#{questionNumber} value='選択肢追加'>"

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

  $('.questions-wrapper').on 'change', '.form-control', ->
    questionType = $(this).val()
    questionNumber = $(this).data('questionNumber')
    $("#question#{questionNumber}").empty()
    $('.choiseNumber').remove()
    appendQuestionType(questionType, questionNumber)

  $('.questions-wrapper').on 'click', '.append_checkbox', ->
    choiseNumber = choiseNumber + 1
    questionNumber = $(this).data('questionNumber')
    $("#question#{questionNumber}-choises").append("<li id='choise#{choiseNumber}' class='choise-description question#{questionNumber}-choise'>
                                                <input type='text' name='questions[][choises[][description]]' value='選択肢#{choiseNumber}',
                                                class='form-control col-md-4'>
                                                <input type='button' id='delete_choise' class='delete_choise btn btn-danger' value='削除' data-number=#{choiseNumber} data-question-number=#{questionNumber}>
                                                </li>")

  $('.questions-wrapper').on 'click', '#append_radio', ->
    choiseNumber = choiseNumber + 1
    questionNumber = $(this).data('questionNumber')
    $("#question#{questionNumber}-choises").append("<li id='choise#{choiseNumber}' class='choise-description question#{questionNumber}-choise'>
                                                <input type= 'text' name= 'questions[][choises[][description]]' value= '選択肢#{choiseNumber}' class='form-control col-md-4'>
                                                <input type= 'button' id='delete_choise' class='delete_choise btn btn-danger' value= '削除'
                                                  data-number=#{choiseNumber} data-question-number=#{questionNumber}>
                                                </li>")

  $('.questions-wrapper').on 'click', '.delete_choise', ->
    questionNumber = $(this).data('questionNumber')
    deleteChoiseNumber = $(this).data('number')
    $("#choise#{deleteChoiseNumber}").remove(".question#{questionNumber}-choise")

  $('.questions-wrapper').on 'click', '.delete-question', ->
    questionNumber = $(this).data('questionNumber')
    $("#question#{questionNumber}-wrapper").remove()

  $('.add_question').on 'click', ->
    questionNumber = questionNumber + 1
    html = "<div class='question-wrapper' id='question#{questionNumber}-wrapper'>
            <input type= 'button' id='delete-question' class='delete-question btn btn-danger float-right' value= '削除'
            data-question-number=#{questionNumber}>
            <div class='form-group'>
              <div class='col-md-6'>
                <input value='無題の質問' type='text' name='questions[][description]' id='question#{questionNumber}_description' class='form-control'>
              </div>
              <div class='col-md-4'>
                <div class='ui-select'>
                  <select class='form-control' name='questions[][question_type]' id='question#{questionNumber}_question_type' data-question-number=#{questionNumber}>
                  <option value='text_field'>text_field</option>
                  <option value='textarea'>textarea</option>
                  <option value='checkbox'>checkbox</option>
                  <option value='radio_button'>radio_button</option></select>
                </div>
              </div>
            </div>
            <div class='form-group'>
              <div class='col-md-8'>
                <div id='question#{questionNumber}' class='questionField'>
                <input placeholder='自由記述（短文回答）' type='text' class='form-control'></div>
                </div>
            </div></div>"
    $('.questions-wrapper').append(html)
