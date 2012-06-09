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

  def self.fetchObjectsForEntityForName(entityName, withSectioKey:sectionKey, withSortKey:sortKey, ascending:aBoolean, inManagedObjectContext:context)
    # Fetch all entityName from the model, filtering by keyPath and sorting by sortKey
    request = self.alloc.init
    request.entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext:context)
    #request.predicate = NSPredicate.predicateWithFormat("#{keyPath} = %@", argumentArray:[value]) if keyPath
    request.sortDescriptors = [NSSortDescriptor.alloc.initWithKey(sortKey, ascending:aBoolean)]
    
    error_ptr = Pointer.new(:object)
    controller = NSFetchedResultsController.alloc.initWithFetchRequest(request, managedObjectContext:context, sectionNameKeyPath:sectionKey, cacheName:nil)      
    unless controller.performFetch(error_ptr)
      raise "Error when fetching data: #{error_ptr[0].description}"
    end
    
    controller
  end
end