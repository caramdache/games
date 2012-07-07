class Player < NSManagedObject
  @sortKeys = ['name']
  @sectionKey = nil
  @searchKey = 'name'

  @attributes = [
    {:name => 'name', :type => NSStringAttributeType, :default => ''}
  ]

  @relationships = [
    {:name => 'game', :destination => 'Game', :inverse => 'players'},
  ]
end
