class GameController < UITableViewController
  attr_accessor :game, :popoverViewController

  def viewDidLoad
    self.title = 'Game'

    @playerController ||= UITableViewControllerForNSManagedObject.alloc.initWithStyle(UITableViewStyleGrouped)
    @navPlayerController ||= UINavigationControllerDoneCancel.withRootViewController(@playerController, target:self, done:'doneEditing', cancel:'cancelEditing')
    
    navigationItem.rightBarButtonItem = UIBarButtonItemAdd.withTarget(self, action:'addPlayer')

    view.dataSource = view.delegate = self
  end

  def viewWillAppear(animated)    
    Player.reset
    navigationItem.rightBarButtonItem.enabled = (game != nil)
    self.tableView.reloadData
  end
  
  def splitViewController(svc, willHideViewController:vc, withBarButtonItem:barButtonItem, forPopoverController:pc)
    barButtonItem.title = 'Games'
    self.navigationItem.setLeftBarButtonItem(barButtonItem)
    self.popoverViewController = pc
  end
  
  def splitViewController(svc, willShowViewController:avc, invalidatingBarButtonItem:barButtonItem) 
    self.navigationItem.setLeftBarButtonItems([], animated:false)
    self.popoverViewController = nil
  end
  
  def openGame(game)
    Player.reset
    self.game = game
    
    if game != nil then
      self.title = game.name
    end

    self.tableView.reloadData
    self.navigationItem.rightBarButtonItem.enabled = (game != nil)
    self.popoverViewController.dismissPopoverAnimated(true) unless self.popoverViewController == nil
  end

  def addPlayer
    player = Player.add do |player|
      player.name = "John#{rand(100)}"
      player.game = game
    end
    editPlayer(player, false)
  end
  
  def editPlayer(player, is_update=true)
    @playerController.object = player
    @playerController.is_update = is_update
    self.tableView.reloadData
    navigationController.presentModalViewController(@navPlayerController, animated:true)
  end
  
  def deleteEditing
    # Remove the player, the user selected 'Remove this player'
    @playerController.object.remove
    @playerController.dismissModalViewControllerAnimated(true)
    self.tableView.reloadData
  end
    
  def cancelEditing
    # Remove the player, the user selected 'Cancel'
    @playerController.object.remove unless @playerController.is_update
    @playerController.dismissModalViewControllerAnimated(true)
    self.tableView.reloadData
  end
  
  def doneEditing
    # Save the player, the user selected 'Done'
    if @playerController.validUpdate? then
      @playerController.updateObject
      @playerController.dismissModalViewControllerAnimated(true)
      self.tableView.reloadData
    end
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection:section)
    if game != nil then game.players.count else 0 end
  end

  CellID = 'CellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellID).tap do |c|
      c.accessoryType = UITableViewCellAccessoryNone
    end

    cell.textLabel.text = game.players.objectAtIndex(indexPath.row).name
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated:true)

    editPlayer(game.players.objectAtIndex(indexPath.row))
  end
end