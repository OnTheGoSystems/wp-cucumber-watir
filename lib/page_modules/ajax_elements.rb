# Module holding a collection of methods to handle ajax related events
module AjaxElements
  def click_when_present(element)
    element.when_present(30)
    element.click
  end

  def wait_focus_send(element, *keys)
    focus_when_visible element
    element.send_keys keys
  end

  def focus_when_visible(element)
    element.when_visible(30)
    element.focus
  end

  def click_when_visible(element)
    element.when_visible(30)
    element.click
  end

  def click_when_enabled(element)
    wait_for_enabled element
    focus_then_click element
  end

  def wait_for_enabled(element)
    Watir::Wait.until do
      element.present? && element.enabled?
    end
  end

  def focus_then_click(element)
    element.focus
    element.click
  end
end
