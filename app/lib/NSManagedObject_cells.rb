class NSManagedObject
  DeleteCellID = 'DeleteCellIdentifier'
  def to_cells(delegate)
    cells = {}
    tag = 1
    managedObjectClass.sections.each.map do |label, rows|
      rows.each_slice(3).map do |title, property, type|
        cells[property] = newCellWithTitle(title, property:property, type:type, tag:tag, delegate:delegate)
        tag += 1 if type == :text or type == :longtext
      end
    end

    cells
  end

  def update_cells(cells)
     cells.each do |property, cell|
      cell.value = valueForKey(property) if not cell.kind_of?(UITableViewTickCell) and not cell.kind_of?(UITableViewFixedValuesTextFieldCell) and not cell.kind_of?(UITableViewDeleteCell)
    end
  end   

  def toggle_from(property)
      newValue = valueForKey(property) == 1 ? 0 : 1
      setValue(newValue, forKey:property)
  end
  
  def from_cells(cells)
    cells.each do |property, cell|
      setValue(cell.value, forKey:property) if not cell.kind_of?(UITableViewTickCell) and not cell.kind_of?(UITableViewFixedValuesTextFieldCell) and not cell.kind_of?(UITableViewDeleteCell)
    end
  end

  def valid_from_cells?(cells)
    true
=begin
    managedObjectClass.sections.each.map do |label, rows|
      rows.each_slice(3).map do |title, property, type|
        cell = cells[property]
        if type == :text or type == :longtext then
          return false if cell.value == nil or cell.value.length == 0
        elsif type == :tick then
        end
      end
      true
    end
=end
  end
  
  CellID = 'CellIdentifier'
  def newCellWithTitle(title, property:property, type:type, tag:tag, delegate:delegate)
    case type
    when :text then
      UITableViewTextFieldCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'TextFieldCellID').tap do |c|
        c.textLabel.text = title
        c.textField.tap do |tf|
          tf.placeholder = property
          tf.returnKeyType = UIReturnKeyNext
          tf.tag = tag
          tf.delegate = delegate
        end
        c
      end
      
    when :longtext then
      UITableViewTextViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'TextViewCellID').tap do |c|
        c.textView.tap do |tv|
          tv.tag = tag
          tv.delegate = delegate
        end
        c
      end

    when :list then
      UITableViewFixedValuesTextFieldCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'FixedValuesTextFieldCellID').tap do |c|
        c.textLabel.text = title
        c.values = property.values[0]
        c.textField.text = c.values.first
        c
      end

    when :autocomplete then
      UITableViewAutoCompleteTextFieldCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'AutoCompleteTextFieldCellID').tap do |c|
        c.textLabel.text = title
        c.textField.tap do |tf|
          #tf.placeholder = property
          tf.returnKeyType = UIReturnKeyNext
          tf.tag = tag
          tf.delegate = delegate
        end
        c
      end

    when :autocomplete2 then
      UITableViewAutoCompleteTextFieldCell2.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'AutoCompleteTextFieldCellID2').tap do |c|
        c.textLabel.text = title
        c.textField.tap do |tf|
          #tf.placeholder = property
          tf.returnKeyType = UIReturnKeyNext
          tf.tag = tag
          tf.delegate = delegate
        end
        c
      end
      
    when :tick then
      UITableViewTickCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'TickCellID').tap do |c|
        c.textLabel.text = title
      end

    when :number then
      UITableViewNumberFieldCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'NumberFieldCellID').tap do |c|
        c.textLabel.text = title
        c.textField.tap do |tf|
          tf.placeholder = '0.00'
          tf.returnKeyType = UIReturnKeyNext
          tf.keyboardType = UIKeyboardTypeNumbersAndPunctuation   
          tf.tag = tag
          tf.delegate = delegate
        end
        c
      end

    when :date then
      UITableViewDateFieldCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'DateFieldCellID').tap do |c|
        c.textLabel.text = title
        c.textField.tap do |tf|
          tf.placeholder = 'dd-mm-yyyy'
          tf.returnKeyType = UIReturnKeyNext
          tf.keyboardType = UIKeyboardTypeNumbersAndPunctuation   
          tf.tag = tag
          tf.delegate = delegate
        end
        c
      end

    when :delete then
      UITableViewDeleteCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'DeleteCellID').tap do |c|
        c.textLabel.text = title
        c.textLabel.textAlignment = UITextAlignmentCenter
        c.textLabel.textColor = UIColor.whiteColor
        c.backgroundColor = UIColor.colorWithRed(0.792, green:0.197, blue:0.219, alpha:1.000)
        c
      end
    end
  end
end