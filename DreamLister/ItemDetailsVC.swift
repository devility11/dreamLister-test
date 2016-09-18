//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Norbert Czirjak on 05/09/16.
//  Copyright © 2016 Norbert Czirjak. All rights reserved.
//

import UIKit
import CoreData

//amikor a does not conform to protocol hiba van vmire akkor az alapertekeit bekell allitani. pl: a tableviewnek a rowkat meg ilyenek
class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var PriceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var thumgImg: UIImageView!
    
    
    var stores = [Store]()
    // a details viewhez egy opcionalis Item tipusu valtozo
    var itemToEdit: Item?
    //tipus megadas
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        // a fenti delegatek megadasa miatt engedelyezni kell oket a viewdidloadban
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        
        /*
        let store = Store(context: context)
        store.name = "best Buy"
        
        let store2 = Store(context: context)
        store2.name = "best Buy2"
        
        let store3 = Store(context: context)
        store3.name = "best Buy3"
        
        let store4 = Store(context: context)
        store4.name = "best Buy4"
        
        let store5 = Store(context: context)
        store5.name = "best Buy5"
        
        ad.saveContext()
        */
        
        getStores()
        
        
        //ha sa detail viewban vagyunk akkor betoltjuk az adott elem tartalmat a nezetre a DB bol
        if itemToEdit != nil {
            loadItemData()
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //update when selected
    }
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            //handle the error
        }
        
    }
    
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        //let item = Item(context: context)
        var item: Item!
        
        //inserting new image entity to ncmanagementcontext
        let picture = Image(context: context)
        //hozzatarsitjuk a kamerrollbol a kepet
        picture.image = thumgImg.image
        
        // itt csekkoljuk, h uj elemet viszunk fel vgay pedig egy regit modositunk
        if itemToEdit == nil {
            item = Item(context: context)
        } else {
            // itt ugye akkor az itemToEdit-ben benne van  mar a modositando itemnek az osszes adata
            item = itemToEdit
        }
        
        // entityhez entityt rendelunk
        item.toImage = picture
        
        // a guin felvitt mezoket ellenorizzuk, h ha van benne adat akkor
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = PriceField.text {
            
            // at kell alakitani double alkuva, mert a DB-ben doublekent taroljuk el
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsField.text {
            item.details = details
        }
        // itt a DB ben megadott relationshipet kell megadni,
        // a storenal a toStore-al hivatkoztunk a store tablara
        // ezaze kell mert abban vannak eltarolva az adatok a storeokrol
        // a storepickernel pedig azert 0-t adunk meg, mert csak 1 oszlopa van a store pickernek es onnan akarjuk
        // kinyerni az aktualis erteket
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        // a mentesi muveletet meghivjuk
        ad.saveContext()
        
        //mentes utan visszairanyitjuk a fooldalra
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    // itt fogjuk a details viewbe betolteni az adatokat
    func loadItemData() {
        
        if let item = itemToEdit {
            titleField.text = item.title
            PriceField.text = "\(item.price)"
            detailsField.text = item.details
            //uiimagekent castoljuk es ugy mentjuk el
            thumgImg.image = item.toImage?.image as? UIImage
            
            // a picker view erteke arrayben van
            if let store = item.toStore {
                
                var index = 0
                
                
                repeat {
                    
                    
                    let s = stores[index]
                    
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    
                    // index ertekenek a novelese ahhoz h vegig menjen a tombon a while loop
                    index += 1
                } while (index < stores.count)
            }
        }
        
    }
    
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        // vissza a fooldalra
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addImage(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumgImg.image = img
        }
        //eltuntetjuk a kep valaszto feluletet
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
    
   
}
