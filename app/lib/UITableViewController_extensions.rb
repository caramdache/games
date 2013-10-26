class UITableViewController
  def viewDidLoad
     NSNotificationCenter.defaultCenter.addObserver(self, selector:'keyboardDidShow:', name:UIKeyboardDidShowNotification, object:nil)
     NSNotificationCenter.defaultCenter.addObserver(self, selector:'keyboardWillHide:', name:UIKeyboardWillHideNotification, object:nil)
  end
    
  def viewDidUnload
    NSNotificationCenter.defaultCenter.removeObserver(self)
  end
  
  def keyboardDidShow(notification)
    kbSize = notification.userInfo[UIKeyboardFrameBeginUserInfoKey].CGRectValue.size
    kbHeight = UIDevice.portrait? ? kbSize.height : kbSize.width
 
=begin
    contentInsets = UIEdgeInsetsMake(0, 0, kbHeight, 0)
    tableView.contentInset = contentInsets
    tableView.scrollIndicatorInsets = contentInsets
=end

    # on iOS7, .top is no longer 0
    contentInsets = tableView.contentInset
    contentInsets.bottom = kbHeight
    tableView.contentInset = contentInsets

    contentInsets = tableView.scrollIndicatorInsets
    contentInsets.bottom = kbHeight
    tableView.scrollIndicatorInsets = contentInsets

   
=begin
    if firstResponder = self.tableView.firstResponder then
      indexPaths = tableView.indexPathsForRowsInRect(firstResponder.frame)
      if indexPaths[0] then
        tableView.selectRowAtIndexPath(indexPaths[0], animated:false, scrollPosition:UITableViewScrollPositionNone)
        tableView.scrollToRowAtIndexPath(indexPaths[0], atScrollPosition:UITableViewScrollPositionNone, animated:true)
        tableView.scrollRectToVisible(tableView.firstResponder.frame, animated:true)
      end
    end
=end
  end

  def keyboardWillHide(notification)
=begin
    contentInsets = UIEdgeInsetsZero
    tableView.contentInset = contentInsets
    tableView.scrollIndicatorInsets = contentInsets
=end

    kbSize = notification.userInfo[UIKeyboardFrameBeginUserInfoKey].CGRectValue.size
    kbHeight = UIDevice.portrait? ? kbSize.height : kbSize.width

    # on iOS7, .top is no longer 0
    contentInsets = tableView.contentInset
    contentInsets.bottom = 0
    tableView.contentInset = contentInsets

    contentInsets = tableView.scrollIndicatorInsets
    contentInsets.bottom = 0
    tableView.scrollIndicatorInsets = contentInsets
  end
end