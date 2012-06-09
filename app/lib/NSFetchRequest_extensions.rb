class NSFetchRequest
  def self.fetchObjectsForEntityForName(entityName, withSortKey:sortKey, ascending:aBoolean, inManagedObjectContext:context)
    # Fetch all entityName from the model, filtering by keyPath and sorting by sortKey
    request = self.alloc.init
    request.entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext:context)
    #request.predicate = NSPredicate.predicateWithFormat("#{keyPath} = %@", argumentArray:[value]) if keyPath
    request.sortDescriptors = [NSSortDescriptor.alloc.initWithKey(sortKey, ascending:aBoolean)]
    
    error_ptr = Pointer.new(:object)
    data = context.executeFetchRequest(request, error:error_ptr)
    if data == nil
      raise "Error when fetching data: #{error_ptr[0].description}"
    end
    data
  end
end