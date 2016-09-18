//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Norbert Czirjak on 01/09/16.
//  Copyright © 2016 Norbert Czirjak. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {

    //when you create this item from the entity this function will be called
    public override func awakeFromInsert() {
        
        // ez azt jelenti, hogy amikor ez meghivasra kerul, tehat egy uj elem kerul be 
        // akkor automatikusan a created attributehoz adja az aktualis datumot
        super.awakeFromInsert()
        
        self.created = NSDate()
        
    }
    
    
    
}
