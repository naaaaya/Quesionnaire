$ ->
  preInputedCompanyName = ""
  appendResultList = (company) ->
      html = "<li class='list-group-item'>#{company.name}<input type='button' value='公開' data-company-id=#{company.id} data-company-name=#{company.name} class='add-company-button btn btn-primary btn-sm' onclick=addCompanyButton(this)></input></li>"
      $('.search_result').append(html)

  appendCompaniesList = (id, name) ->
      html = "<li class='list-group-item'>#{name}<input type='button' value='非公開' data-company-id=#{id} class='delete_company_button btn btn-danger btn-sm' onclick=deleteCompanyButton(this)></input></li>"
      $('.added_companies').append(html)

  appendHiddenField = (companyId) ->
    html = "<input type='hidden' name='company_ids[]' value=#{companyId} id='hidden_company#{companyId}'>"
    $('.hidden_company_field').append(html)

  @searchCompany = ->
    InputedCompanyName = $('#search_company').val()
    if preInputedCompanyName != InputedCompanyName
      $.ajax
        type: "GET"
        url: "#{window.location.href}/surveys_companies.json"
        dataType: "json"
        data: {keyword: InputedCompanyName}
        success: (data, status, xhr)   ->
          $('.search_result').empty()
          for company in data
            appendResultList(company)
            preInputedCompanyName = InputedCompanyName
        error: (xhr,  status, error) ->
          alert(status)
          preInputedCompanyName = InputedCompanyName

  @addCompanyButton = (button) ->
    companyId = $(button).data('companyId')
    companyName = $(button).data('companyName')
    appendCompaniesList(companyId,companyName)
    appendHiddenField(companyId)
    $(button).parent().remove()

  @deleteCompanyButton = (button) ->
    companyId = $(button).data('companyId')
    $(button).parent().remove()
    $("#hidden_company#{companyId}").remove()
