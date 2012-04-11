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

end
