ready = ->
  $("[data-masked=date]").mask('99.99.9999')
$(document).ready ready
$(document).on 'page:load', ready