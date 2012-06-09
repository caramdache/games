CoreData relationship sample
=============================

This sample demonstrate how to create CoreData relationships in RubyMotion without using XCode and XCode data models. The sample is loosely based on https://github.com/HipByte/RubyMotionSamples/tree/master/Locations, but extents Locations as follows:

- relationships are demonstrated and not just attributes
- additional properties can be set: optional, indexed, transient
- attributes and relationships are specified declaratively and on a per object basis
- the store.rb is mostly independent from the objects
- some CoreData helper/extension classes are provided

Caveats
=======

The NSBooleanAttributeType is supported, but the RubyMotion compiler (v1.9) currently handles the attribute as an integer. Thus Ruby boolean operators cannot be used directly.

When accessing a isToMany relationship, you should not expect a standard Ruby array. Instead, the collection will likely be a CoreData fault when first accessed, like for example _NSFaultingMutableOrderedSet. You should use Obj-C collection methods instead, like for example count, objectAtIndex or allObjects. CoreData will transparently mutate the fault into a real collection, whose objects you can then handle in Ruby.

It looks like NSAttributeDescription attributes names cannot end with a digit currently. For example, 'player2' is not supported.