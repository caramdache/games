class UITableViewControllerForNSManagedObject < UITableViewController
  attr_accessor :object, :is_update
  
  def viewDidLoad
    super # get keyboard notifications
    view.dataSource = view.delegate = self
  end

  def viewWillAppear(animated)
    if @object != nil then # ipad
      @cells ||= @object.to_cells(self)
      @object.update_cells(@cells)
    end
    self.tableView.reloadData
  end
  
  def updateObject
    if @object != nil then # ipad
      @object.from_cells(@cells)
      @object.update
    end
  end

  def validUpdate?
    if object != nil then # ipad
      @object.from_cells(@cells) # editing may still be in progress
      @object.valid_from_cells?(@cells)
    else
      true
    end
  end
  
  def sections
    @object.managedObjectClass.sections
  end

  def numberOfSectionsInTableView(tableView)
    if @object != nil then # ipad
      sections.size
    else 
      0
    end
  end

  def tableView(tableView, titleForHeaderInSection:section)
    sections[section][0]
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    sections[section][1].size / 3
  end
  
  def tableView(tableView, shouldIndentWhileEditingRowAtIndexPath:indexPath)
    false
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    cell = self.tableView(tableView, cellForRowAtIndexPath:indexPath)
    if cell.kind_of?(UITableViewTextViewCell) then
      return cell.height
    end

    self.tableView.rowHeight
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    property = sections[indexPath.section][1][indexPath.row*3 + 1]
    cell = @cells[property]
    cell.tick(@object.valueForKey(property)) if cell.kind_of?(UITableViewTickCell)
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    property = sections[indexPath.section][1][indexPath.row*3 + 1]
    cell = @cells[property]

    if cell.kind_of?(UITableViewFixedValuesTextFieldCell) then
      @controller ||= UITableViewFixedValuesController.alloc.initWithStyle(UITableViewStyleGrouped)
      @controller.text_field = cell.textField
      @controller.values = cell.values
      navigationController.pushViewController(@controller, animated:true)
    end
        
    @object.toggle_from(property) if cell.kind_of?(UITableViewTickCell)
    presentingViewController.topViewController.deleteEditing if cell.kind_of?(UITableViewDeleteCell)

    tableView.reloadData
  end

  def textViewDidChange(textView)
    self.tableView.beginUpdates
    self.tableView.endUpdates
  end

  def textFieldShouldReturn(textField)
    @numTextFields ||= sections.flatten.select{|x| x == :text or x == :longtext}.size
    
    if textField.tag == @numTextFields then
     textField.resignFirstResponder
     return true
    end

    view.viewWithTag(textField.tag + 1).becomeFirstResponder

    #nextIndexPath = [0, textField.tag].to_ip
    #tableView.selectRowAtIndexPath(nextIndexPath, animated:false, scrollPosition:UITableViewScrollPositionNone)
    #tableView.scrollToRowAtIndexPath(nextIndexPath, atScrollPosition:UITableViewScrollPositionNone, animated:true)

    false
  end
end