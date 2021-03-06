class UITableViewTextFieldCell < UITableViewCell
  def textField
    @textField
  end
  
  def value
    @textField.text
  end
  
  def value=(newValue)
    @textField.text = newValue
  end
  
  def clear
    @textField.text = nil
  end
  
  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    if super then
      @textField = UITextField.alloc.initWithFrame(self.bounds).tap do |t|
        t.adjustsFontSizeToFitWidth = true
        t.textColor = UIColor.blackColor
        t.backgroundColor = UIColor.clearColor
        t.autocorrectionType = UITextAutocorrectionTypeNo
        t.autocapitalizationType = UITextAutocapitalizationTypeNone
        t.textAlignment = NSTextAlignmentRight
        t.clearButtonMode = UITextFieldViewModeNever
        t.clearsOnBeginEditing = true
        t.enabled = true
        t.returnKeyType = UIReturnKeyDone
        t.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter
        t
      end
      addSubview(@textField)
  
      selectionStyle = UITableViewCellSelectionStyleNone
      accessoryType = UITableViewCellAccessoryNone
    end
    
    self
  end

  def layoutSubviews
    super
    
    labelSize = textLabel.text.sizeWithFont(textLabel.font)
    labelSize.width = (labelSize.width / 5).ceil * 5 # Round to upper 5

    x = labelSize.width + (UIDevice.ipad? ? 50 : 30)
    y = 0.0
    w = self.frame.size.width - x - (UIDevice.ipad? ? 50 : 20)
    h = self.frame.size.height

    @textField.frame = CGRectMake(x, y, w, h)
  end
end