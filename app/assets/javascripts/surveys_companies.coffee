$ ->
  $('#search_company').on 'keyup', ->
    console.log($('#search_company').val)
    # $.ajax
    #   async:     true
    #   type:      "GET"
    #   url:       '/surveys_company.json'
    #   dataType:  "json"
    #   data: {keyword: input}
    #   success:   (data, status, xhr)   -> alert status
    #   error:     (xhr,  status, error) -> alert status
    #   complete:  (xhr, status)         -> alert status