class UITableViewTextViewCell < UITableViewCell
  def textView
    @textView
  end
  
  def value
    @textView.text
  end
  
  def value=(newValue)
    @textView.text = newValue
  end
  
  def clear
    @textView.text = nil
  end
  
  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    if super then
      @textView = UITextView.alloc.initWithFrame(self.bounds).tap do |t|
        t.font = UITableViewCell.alloc.init.textLabel.font
        t.textColor = UIColor.blackColor
        t.backgroundColor = UIColor.clearColor
        t.autocorrectionType = UITextAutocorrectionTypeNo
        t.autocapitalizationType = UITextAutocapitalizationTypeNone
        t.textAlignment = UITextAlignmentLeft
        t.enabled = true
        t
      end
      addSubview(@textView)
  
      selectionStyle = UITableViewCellSelectionStyleNone
      accessoryType = UITableViewCellAccessoryNone
    end
    
    self
  end

  def layoutSubviews
    super

    frame = @textView.frame
    frame.size.height = self.height + 10.0 # add some padding
    @textView.frame = CGRectZero #to avoid text clipping
    @textView.frame = frame
  end

  def height
    #height = textView.contentSize.height #set too late in iOS7
    textViewWidth = textView.frame.size.width
    size = textView.sizeThatFits(CGSizeMake(textViewWidth, Float::MAX))
    size.height
  end  
end