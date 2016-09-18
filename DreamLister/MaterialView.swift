//
//  MaterialView.swift
//  DreamLister
//
//  Created by Norbert Czirjak on 04/09/16.
//  Copyright © 2016 Norbert Czirjak. All rights reserved.
//

import UIKit

private var materialKey = false

//ezzel tovabbi stilusokat adhatunk az UIViewhoz
extension UIView {

    //kiegeszitjuk a storyboardon kivalaszthato dolgokat, a view menuben megfog jelenni a materialviews menupont
    @IBInspectable var materialDesign: Bool {
        
        get{
            return materialKey
        }
        
        set{
            //if they select the materialview
            materialKey = newValue
            
            if materialKey {
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.9
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
                
            } else {
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
            }
        }
    }

}
