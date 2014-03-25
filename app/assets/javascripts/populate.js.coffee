$ ->
  $(".populate").click (event) ->
    populateData = $(event.target).data()
    for key, value of populateData
      $(populateData["#{key}Target"]).val(value) if /^populate/.test(key) and not /Target$/.test(key)
