module ApplicationHelper
  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def agreements_options
    [
      'I accept the MASAS Information eXchange (MASAS-X) Pilot Participation Agreement.',
      'I am not a member of the media.',
      'I certify that I am a bona fide member of the Canadian Emergency Management community and have a valid reason to join the MASAS-X community.'
    ]
  end

  def yesno_options
    [
      ['Yes', true],
      ['No', false]
    ]
  end

  def on_dom_ready(javascript)
    content_for(:head) do
      javascript_tag("$(function() {#{javascript}})")
    end
  end
end
