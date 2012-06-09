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
      game.timestamp, game.year = NSDate.date, NSDate.date.year
      game.name = "game#{rand(100)}"
    end
    view.reloadData
  end
  
  def numberOfSectionsInTableView(tableView)
    Game.controller.sections.size
  end

  def tableView(tableView, titleForHeaderInSection:section)
    Game.controller.sections[section].name
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    Game.controller.sections[section].numberOfObjects
  end

  CellID = 'CellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellID).tap do |c|
      c.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    end
    
    cell.textLabel.text = Game.controller.objectAtIndexPath(indexPath).name
    cell
  end

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    Game.controller.objectAtIndexPath(indexPath).remove
    tableView.updates do
      if tableView.numberOfRowsInSection(indexPath.section) == 1
        tableView.deleteSections(NSIndexSet.indexSetWithIndex(indexPath.section), withRowAnimation:UITableViewRowAnimationFade)
      end
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade)
    end
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated:true)
    
    @gameController ||= GameController.alloc.initWithStyle(UITableViewStylePlain)
    @gameController.game = Game.controller.objectAtIndexPath(indexPath)
    navigationController.pushViewController(@gameController, animated:true)
  end
end

