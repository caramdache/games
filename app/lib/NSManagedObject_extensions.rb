class NSManagedObject
  def self.entity
    @entity ||= NSEntityDescription.newEntityDescriptionWithName(name, attributes:@attributes, relationships:@relationships)
  end

  def self.objects
    @objects ||= NSFetchRequest.fetchObjectsForEntityForName(name, withSortKey:@sortKey, ascending:false, inManagedObjectContext:Store.shared.context)
  end
  
  def self.reset
    @objects = nil
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