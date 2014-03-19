$ ->
  $("[data-filtered-by]").each (i, element) ->
    filteredBy = $(element).data("filtered-by")
    promptOption = "<option value>#{prompt}</option>" if prompt = $(element).data("filtered-by-prompt")

    $(filteredBy).change (event) ->
      # save unfiltered content
      $(element).data("unfiltered", $(element).html()) unless $(element).data("unfiltered")

      # restore unfiltered content
      $(element).html($(element).data("unfiltered"))

      # find selected label in filtering element
      label = $(event.target).find(":selected").text()

      # find corresponding group in filtered element
      optgroup = $(element).find("optgroup[label='#{label}']")

      if optgroup.length > 0
        # corresponding group has been found
        $(element).removeAttr("disabled").html(promptOption + optgroup.html())
      else
        # no groups found - disable element
        $(element).attr("disabled", "disabled")

    # trigger change event to apply filter at startup
    $(filteredBy).change()
