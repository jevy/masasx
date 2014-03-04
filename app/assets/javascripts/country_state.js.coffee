$ ->
  $('select#organization_country').on "change", (event) ->
    select_wrapper = $('#state_wrapper')

    $('select', select_wrapper).attr('disabled', true)

    country = $(this).val()

    url = "/welcome/subregion_options?parent_region=#{country}"
    select_wrapper.load(url)
