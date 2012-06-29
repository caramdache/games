class Player < NSManagedObject
  @sortKeys = ['name']
  @sectionKey = nil

  @attributes = [
    {:name => 'name'}
  ]

  @relationships = [
    {:name => 'game', :destination => 'Game', :inverse => 'players'},
  ]
end
