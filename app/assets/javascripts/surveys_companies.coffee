$ ->
  preinput = ""
  appendResultList = (company) ->
      html = "<li>#{company.name}<input type='button' value='公開' data-company-id=#{company.id} data-company-name=#{company.name} class='add_company_button' onclick=addCompanyButton(this)></input></li>"
      $('.search_result').append(html)

  appendCompaniesList = (id, name) ->
      html = "<li>#{name}<input type='button' value='非公開' data-company-id=#{id} class='delete_company_button' onclick=deleteCompanyButton(this)></input></li>"
      $('.added_companies').append(html)

  appendHiddenField = (company_id) ->
    html = "<input type='hidden' name='company_ids[]' value=#{company_id} id='hidden_company#{company_id}'>"
    $('.hidden_company_field').append(html)

  @searchCompany = ->
    input = $('#search_company').val()
    html = window.location.href
    if preinput != input
      $.ajax
        type:      "GET"
        url:       "#{html}/surveys_companies.json"
        dataType:  "json"
        data: {keyword: input}
        success:   (data, status, xhr)   ->
          $('.search_result').empty()
          for company in data
              appendResultList(company)
              preinput = input
        error:     (xhr,  status, error) ->
          alert(status)
          preinput = input

  @addCompanyButton = (button) ->
    company_id = $(button).data('companyId')
    company_name = $(button).data('companyName')
    appendCompaniesList(company_id,company_name)
    appendHiddenField(company_id)
    $(button).parent().remove()

  @deleteCompanyButton = (button) ->
    company_id = $(button).data('companyId')
    $(button).parent().remove()
    $("#hidden_company#{company_id}").remove()
