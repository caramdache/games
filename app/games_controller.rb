class GamesController < UITableViewController
  def viewDidLoad
    view.dataSource = view.delegate = self
  end

  def viewWillAppear(animated)
    self.title = 'Games'
    
    navigationItem.leftBarButtonItem = editButtonItem
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'addGame')
   end
  
  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown
  end

  def addGame
    Game.add do |game|
      game.timestamp = NSDate.date
      game.name = "game#{rand(100)}"
    end
    view.reloadData
  end
  
  def editGame(game)
  end
  
  def deleteEditing
    view.reloadData
  end
    
  def cancelEditing
    view.reloadData
  end
  
  def doneEditing
    view.reloadData
  end
  
  def numberOfSectionsInTableView(tableView)
    1
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    Game.objects.size
  end

  CellID = 'CellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellID).tap do |c|
      c.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    end
    
    cell.textLabel.text = Game.objects[indexPath.row].name
    cell
  end

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    Game.objects[indexPath.row].remove
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade)
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated:true)
    
    @gameController ||= GameController.alloc.initWithStyle(UITableViewStylePlain)
    @gameController.game = Game.objects[indexPath.row]
    navigationController.pushViewController(@gameController, animated:true)
  end
end

