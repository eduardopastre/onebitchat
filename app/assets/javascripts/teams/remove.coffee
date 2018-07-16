$(document).on 'turbolinks:load', ->
  $(".remove_team").on 'click', (e) =>
    $('#remove_team_modal').modal('open')
    $('.remove_team_form').attr('action', 'teams/' + e.target.id)
    return false

  $('.remove_team_form').on 'submit', (e) ->
    $.ajax e.target.action,
      type: 'DELETE'
      contentType:'application/json',
      dataType: 'json',
      data: {}
      success: (data, text, jqXHR) ->
        $(location).attr('href','/');
      error: (jqXHR, textStatus, errorThrown) ->
        $('#remove_team_modal').modal('close')
        Materialize.toast('Problem to delete Team &nbsp;<b>:(</b>', 4000, 'red')
    return false

  $('.leave_team').on 'click', (e) =>
    $('#leave_team_modal').modal('open')
    $('.leave_team_form').attr('action', 'team_users/' + e.target.id)
    return false

  $('.leave_team_form').on 'submit', (e) ->
    $.ajax e.target.action,
      type: 'DELETE'
      #contentType:'application/json',
      dataType: 'json',
      data: {team_id: $(".team_id").val()}
      success: (data, text, jqXHR) ->
        $(location).attr('href','/');
      error: (jqXHR, textStatus, errorThrown) ->
        Materialize.toast('Problem to leave the Team &nbsp;<b>:(</b>', 4000, 'red')
    
    $('#remove_user_modal').modal('close')
    return false
