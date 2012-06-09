class Store
  DB = 'store.sqlite'
  ManagedObjectClasses = [Game, Player]
  
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

  private 
  
  def initialize
    # Create the model programmatically. The data will be stored in a SQLite database, inside the application's Documents folder.
    model = NSManagedObjectModel.alloc.init
    model.entities = ManagedObjectClasses.collect {|c| c.entity}
    model.entities.each {|entity| entity.wireRelationships}

    store = NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(model)
    store_url = NSURL.fileURLWithPath(File.join(NSHomeDirectory(), 'Documents', DB))
    error_ptr = Pointer.new(:object)
    unless store.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL:store_url, options:nil, error:error_ptr)
      raise "Can't add persistent SQLite store: #{error_ptr[0].description}"
    end

    context = NSManagedObjectContext.alloc.init
    context.persistentStoreCoordinator = store
    @context = context
  end
end
