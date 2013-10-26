class UIView
  def firstResponder
    if isFirstResponder then
      return self
    end

    subviews.each do |subview|
      responder = subview.firstResponder
      if responder then
        return responder
      end
    end
    
    nil
  end
end