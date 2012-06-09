class Player < NSManagedObject
  @sortKey ||= 'name'
  @sectionKey ||= nil

  @attributes ||= [
    #name, type, default, optional, transient, indexed
    ['name', NSStringAttributeType, '', false, false, false]
  ]

  @relationships ||= [
    #name, destination, inverse, optional, indexed, ordered, min_count, max_count, delete_rule
    ['game', 'Game', 'players', false, false, false, 1, 1, NSNullifyDeleteRule],
  ]
end
