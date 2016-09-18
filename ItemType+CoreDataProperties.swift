//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Norbert Czirjak on 01/09/16.
//  Copyright © 2016 Norbert Czirjak. All rights reserved.
//

import Foundation
import CoreData

extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType");
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
