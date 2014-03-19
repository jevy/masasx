module ApplicationHelper

  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def yesno_options
    [
      ['Yes', true],
      ['No', false]
    ]
  end

  def show_address model
    secondary_fields_values = [:city, :state, :country, :postal_code].map{ |field| model.send(field) }.compact
    output = model.address_line_1
    output << "<br/>#{model.address_line_2}" if model.address_line_2
    output << "<br/>#{secondary_fields_values.join(', ') }" unless secondary_fields_values.empty?
    content_tag :span, output.html_safe
  end

  def country_collection
    Carmen::Country.all.select { |country| %w[US CA].include?(country.code) }
  end

  def subregion_collection
    country_collection.map { |country| [country, country.subregions] }
  end
end
