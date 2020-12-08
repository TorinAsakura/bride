$ ->

    $("#edit").on "change", "#idea_section_idea_category_id", (event) ->
        url = '/admin/ideas/' + $("#idea_category_id").val() + '?idea_category_id=' + $(this).val()
        $.get url, (data) ->
            $('#ideas_block').html data