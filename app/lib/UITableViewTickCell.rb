class UITableViewTickCell < UITableViewCell
  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
	super

    selectionStyle = UITableViewCellSelectionStyleNone
    accessoryType = UITableViewCellAccessoryNone
    
    self
  end
end