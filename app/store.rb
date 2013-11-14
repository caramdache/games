class Store
  ManagedObjectClasses = [Game, Player]
  
  # NO NEED TO CHANGE ANYTHING BELOW THIS LINE
  
  def self.shared
    # Our store is a singleton object.
    @shared ||= Store.new
  end
  
  def context
    @context
  end

  def save
    error_ptr = Pointer.new(:object)
    unless @context.save(error_ptr)
      raise "Error when saving the model: #{error_ptr[0].description}"
    end
    
    # Clear caches, they will be reloaded on demand
    ManagedObjectClasses.each {|c| c.reset}
  end

  def clear
    @store.persistentStores.each do |st|
      unless @store.removePersistentStore(st, error:nil)
        raise "Can't remove persistent SQLite store: #{error_ptr[0].description}"
      end

      unless NSFileManager.defaultManager.removeItemAtPath(st.URL.path, error:nil)
        raise "Can't remove persistent SQLite file: #{error_ptr[0].description}"
      end
    end

    initialize
  end

  private 
  
  def initialize
    # Create the model programmatically. The data will be stored in a SQLite database, inside the application's Documents folder.
    @model ||= NSManagedObjectModel.alloc.init.tap do |m|
      m.entities = ManagedObjectClasses.collect {|c| c.entity}
      m.entities.each {|entity| entity.wireRelationships}
    end

    @store = NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(@model)
    @store_url = NSURL.fileURLWithPath(File.join(NSHomeDirectory(), 'Documents', 'store.sqlite'))

    @context = NSManagedObjectContext.alloc.initWithConcurrencyType(NSMainQueueConcurrencyType).tap do |c|
      c.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
      c.persistentStoreCoordinator = @store
    end

    NSNotificationCenter.defaultCenter.tap do |c|
      c.addObserver(self, selector:'storesWillChange:', name:NSPersistentStoreCoordinatorStoresWillChangeNotification, object:@store)
      c.addObserver(self, selector:'storesDidChange:', name:NSPersistentStoreCoordinatorStoresDidChangeNotification, object:@store)
      c.addObserver(self, selector:'persistentStoreDidImportUbiquitousContentChanges:', name:NSPersistentStoreDidImportUbiquitousContentChangesNotification, object:@store)
    end

    error_ptr = Pointer.new(:object)

    options ||= { NSPersistentStoreUbiquitousContentNameKey => 'iCloudStore' }
    unless @store.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL:@store_url, options:options, error:error_ptr)
      raise "Can't add persistent SQLite store: #{error_ptr[0].description}"
    end
  end
    
  def persistentStoreDidImportUbiquitousContentChanges(notification)
    NSLog "import: #{notification}"
     
    @context.perform(lambda do
      @context.mergeChangesFromContextDidSaveNotification(notification)
       
      # example of processing
      changes = notification.userInfo
      allChanges = NSMutableSet.new
      allChanges.unionSet(changes[NSInsertedObjectsKey])
      allChanges.unionSet(changes[NSUpdatedObjectsKey])
      allChanges.unionSet(changes[NSDeletedObjectsKey])
       
      allChanges.each do|objID|
        obj = @context.objectWithID(objID)
      end
    end)
  end
  
  def storesWillChange(notification)
    NSLog "will change: #{notification}"

    @context.performBlockAndWait(lambda do
      error_ptr = Pointer.new(:object)
      @context.save(error_ptr) if @context.hasChanges
      @context.reset
    end)
    
    # reset user interface
  end
  
  def storesDidChange(notification)
    NSLog "did change: #{notification}"

    # refresh user interface
  end
end
