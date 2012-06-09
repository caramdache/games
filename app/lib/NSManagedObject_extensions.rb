class NSManagedObject
  def self.entity
    @entity ||= NSEntityDescription.newEntityDescriptionWithName(name, attributes:@attributes, relationships:@relationships)
  end

  def self.objects
    # Use if you do not want any section in your table view
    @objects ||= NSFetchRequest.fetchObjectsForEntityForName(name, withSortKey:@sortKey, ascending:false, inManagedObjectContext:Store.shared.context)
  end

  def self.controller
    # Use if you require sections in your table view
    @controller ||= NSFetchRequest.fetchObjectsForEntityForName(name, withSectioKey:@sectionKey, withSortKey:@sortKey, ascending:false, inManagedObjectContext:Store.shared.context)
  end
  
  def self.reset
    @objects = @controller = nil
  end

  def self.add
    yield NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext:Store.shared.context)
    Store.shared.save
  end
  
  def update
    Store.shared.save
  end

  def remove
    Store.shared.context.deleteObject(self)
    Store.shared.save
  end
end