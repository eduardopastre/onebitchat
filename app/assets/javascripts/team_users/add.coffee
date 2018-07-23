$(document).on 'turbolinks:load', ->
  $(".add_user").on 'click', (e) =>
    $('#add_user_modal').modal('open')
    $('.add_user_form').attr('action', 'teams/invite/' + e.target.id)
    return false
