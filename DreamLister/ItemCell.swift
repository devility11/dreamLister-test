//
//  ItemCell.swift
//  DreamLister
//
//  Created by Norbert Czirjak on 04/09/16.
//  Copyright © 2016 Norbert Czirjak. All rights reserved.
//

import UIKit



class ItemCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    //itt azert detailst hasznalunk, mert a description az egy rendszer altal lefoglalt kifejezes
    @IBOutlet weak var details: UILabel!

    
    func configureCell(item: Item) {
        
        title.text = item.title
        price.text = "$\(item.price)"
        details.text = item.details
        thumb.image = item.toImage?.image as? UIImage
    }
    
}
