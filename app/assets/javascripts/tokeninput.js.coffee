ready= ->
  $("[data-tokeninput]").each ->
    url=$(this).data 'tokeninput'
    dom_id=$(this).attr 'id'
    placeholder=$(this).attr 'placeholder'
    opts=
      theme: 'bootstrap'
      hintText: 'Введите слово для поиска'
      noResultsText: "Ничего не найдено"
      searchingText: "Поиск"
    opts['tokenLimit']=$(this).data("limit") if $(this).data("limit")
    opts['prePopulate']=$(this).data("pre") if $(this).data("pre")
    $(this).tokenInput url,opts


$(document).ready ready
$(document).on 'page:load', ready
