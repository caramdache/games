class Player < NSManagedObject
  @sortKeys = ['name']
  @sectionKey = nil
  @searchKey = 'name'

  @attributes = [
    {:name => 'name', :type => NSStringAttributeType, :default => ''},
    {:name => 'single', :type => NSBooleanAttributeType, :optional => true}
  ]

  @relationships = [
    {:name => 'game', :destination => 'Game', :inverse => 'players'},
  ]
  
  @sections = [
    [nil, ['Name', 'name', :text]],
    ['Details', ['Single', 'single', :tick,]]
  ]
  
  def self.sections
    @sections
  end
end
