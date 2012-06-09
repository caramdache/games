class Game < NSManagedObject
  @sortKey ||= 'timestamp'
  @sectionKey ||= 'year'

  @attributes ||= [
    #name, type, default, optional, transient, indexed
    ['name', NSStringAttributeType, '', false, false, false],
    ['timestamp', NSDateAttributeType, nil, false, false, false],
    ['year', NSInteger16AttributeType, 0, false, false, false],
  ]

  @relationships ||= [
    #name, destination, inverse, optional, indexed, ordered, min_count, max_count, delete_rule
    ['players', 'Player', 'game', true, false, true, 0, NSIntegerMax, NSCascadeDeleteRule],
  ]
end
