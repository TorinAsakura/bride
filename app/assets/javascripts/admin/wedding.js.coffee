$(document).ready ->
  $(".table-sortable").dataTable
    aaSorting: []     # disable default sort (remove this line to enable it)
    bPaginate: false  # Remove pagination
    bFilter: false    # Remove filter
    bInfo: false      # Remove useless info
    # Columns with .unsortable class are not sortable
    aoColumnDefs : [
      'bSortable': false,
      'aTargets': ['unsortable']
    ]
  bind_wedding_color = ->
    $(".wedding_color input[type=checkbox]").change ->
      if $(this).is(':checked') && $(".wedding_color input[type=checkbox]:checked").size()>4
        $(this).attr('checked', false)
  window.bind_wedding_color = bind_wedding_color
  bind_wedding_color()
