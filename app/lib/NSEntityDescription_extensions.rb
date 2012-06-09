class NSEntityDescription
  def self.newEntityDescriptionWithName(name, attributes:attributes, relationships:relationships)
    entity = self.alloc.init
    entity.name = name
    entity.managedObjectClassName = name
    
    attributes = attributes.each.map do |name, type, default, optional, transient, indexed|
      property = NSAttributeDescription.alloc.init
      property.name = name
      property.attributeType = type
      property.defaultValue = default if default != nil
      property.optional = optional
      property.transient = transient
      property.indexed = indexed
      property
    end
 
    relationships = relationships.each.map do |name, destination, inverse, optional, indexed, ordered, min_count, max_count, delete_rule|
      property = NSRelationshipDescription.alloc.init
      property.name = name
      property.destinationEntityName = destination
      property.inverseRelationshipName = inverse
      property.optional = optional
      #property.transient = transient
      property.indexed = indexed
      property.ordered = ordered
      property.minCount = min_count
      property.maxCount = max_count # NSIntegerMax
      property.deleteRule = delete_rule # NSNoActionDeleteRule NSNullifyDeleteRule NSCascadeDeleteRule NSDenyDeleteRule
      property
    end
    
    entity.properties = attributes + relationships
    entity
  end
  
  def wireRelationships
    entities = self.managedObjectModel.entitiesByName
    
    self.relationshipsByName.values.flatten.each do |property|
      property.destinationEntity = entities[property.destinationEntityName]
      property.inverseRelationship = property.destinationEntity.relationshipsByName[property.inverseRelationshipName]
    end
  end
end
