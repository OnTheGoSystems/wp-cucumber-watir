# Various hacks to work around Selenium's limitations
module BrowserInteractionHacks
  def force_check_hacky_checkbox(checkbox_element)
    until checkbox_element.checked?
      checkbox_element.focus
      checkbox_element.click
      checkbox_element.check
    end
  end

  def click_focused_and_viewed(element)
    element.scroll_into_view
    element.focus
    element.click
  end
end
