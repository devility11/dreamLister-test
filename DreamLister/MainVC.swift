//
//  MainVC.swift
//  DreamLister
//
//  Created by Norbert Czirjak on 01/09/16.
//  Copyright © 2016 Norbert Czirjak. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    //az NSFetchedResultsControllerDelegate a CoreData es Tableviewwal dolgozik egyutt, hogy a fetchrequestek soran konnyen kezelheto adatokat adjon vissza. pl: a numberofsectionshoz, stb...
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    // deklaraljuk a fetchresult controllert es a <> kozott megadjuk, hogy melyik data classt fetcheljuk
    var controller: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ezek azert kellenek mert felul hozzaadtuk oket es hivatkozni kell rajuk
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //generateTestData()
        
        //lekeri az adatokat a db-bol
        attemptFetch()
        
        
    }

    // tableviewdelegate es tableviewdataSourece hoz szukseges funkciok -  START
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // itt adjuk hozza a cell adatokat
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
    }
    
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
        
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
     
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    // tableviewdelegate es tableviewdataSourece hoz szukseges funkciok -  END
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsVC {
                // castoljuk Itemkent
                if let item = sender as? Item {
                    // itt pedig beallitjuk az ItemDetailsVC-nek az itemToEdit valtozojat 
                    // es az erteke az item lesz
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    
    // ha a tableview barmelyik elemere kattintanak akkor ez a funckio fog lefutni
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // a , az where -t jelent de swift 3 ban mar csak egy vesszo van helyette
        // megnezzuk h a fetchedResultControllerben vannak e objektumok
        if let objs = controller.fetchedObjects , objs.count > 0 {
            //the specific item in the list
            let item = objs[indexPath.row]
            // itt pedig a segue kerul beallitasra, gogy melyik viewcontrollert kell meghivni es milyen id val
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
        
    }
    
    
    
    
    
    // ezzel kerjuk le az adatokat az adatbazisbol
    func attemptFetch() {
        //fetch valtozot csinaltunk, amibe megadjuk, hogy mit akarunk lefetchelni es elinditjuk a fetcht.
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        // a timestamp (created) alapjan csinalunk egy sort-ot
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        
        //megnezzuk, hogy melyik segmented controll van kivalasztva es az alapjan a megfelelo
        // listazast toltjuk be
        if segment.selectedSegmentIndex == 0 {
            // itt pedig a fetchbe betoltjuk egy tombbe, mivel tobb, mint egy talalat lehet a lekerdezes soran
            fetchRequest.sortDescriptors = [dateSort]
        } else if segment.selectedSegmentIndex == 1{
            fetchRequest.sortDescriptors = [priceSort]
        } else if segment.selectedSegmentIndex == 2 {
            fetchRequest.sortDescriptors = [titleSort]
        }
    
        
        //sectionnamekeypath azt jeloli, h mit akarunk visszakapni, nil mindent visszaad
        // a context amit itt meghivunk azaz appdeleagteben az aljan amit deklaraltunk
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        // a frissitesi metodusoknal el kell mondani h honnan figyeljek az uzeneteket/frissiteseket
        //pl ha ez nincs megadva akkor a tableviewot nem fogja automatan updatelni
        controller.delegate =  self
        
        // a fent deklaralt controller az a folyamaton kivul van ezert itt atkell adni a folyamaton belülre
           self.controller = controller
        //do an actual fetch, a fenti fetch fail-t is dobhat ezert kell egy do-t csinalni
        
        do {
            
            try controller.performFetch()
            
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
    }
    
    // a segmented controll valtozasait figyeljuk itt
    @IBAction func segmentChange(_ sender: AnyObject) {
        attemptFetch()
        tableView.reloadData()        
    }
    
    
    //a tableViewnak az ujratoltse
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
        
    }
    //ujra toltes befejezese
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    //ez fogja figyelni a valtozasokat, pl: modositas, torles, uj
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type)
        {
        case.insert:
            // uj elem beszurasa a "with" pedig animaciot jelent itt
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        
        case.update:
            if let indexPath = indexPath {
                // as utan azt adjuk meg, h mikent castoljuk
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                //update the cell data.
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
        
    }
    
    
    func generateTestData(){
        
        let item = Item(context: context)
        
        item.title = "Macbook pro"
        item.price = 1800
        item.details = "i cant wait it until september"
        
        let item2 = Item(context: context)
        
        item2.title = "Macbook pro2"
        item2.price = 1800
        item2.details = "i cant wait it until september"
        
        let item3 = Item(context: context)
        
        item3.title = "Macbook pro3"
        item3.price = 1800
        item3.details = "i cant wait it until september"
        
        let item4 = Item(context: context)
        
        item4.title = "Macbook pro4"
        item4.price = 1800
        item4.details = "i cant wait it until september"
        
        //elmentjuk a fenti adatokat, mert amig nem mentjuk el addig csak a memoriaban vannak
        ad.saveContext()
    }
    
    
    


}

















