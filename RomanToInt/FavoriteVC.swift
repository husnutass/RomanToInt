//
//  DetailsVC.swift
//  RomanToInt
//
//  Created by Hüsnü Taş on 9.01.2022.
//

import UIKit
import CoreData

class FavoriteVC: UIViewController {
    
    var favoriteArray: [String] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.getData()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
    }
    
    
    private func getData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
                fetchRequest.returnsObjectsAsFaults = false
                
                do{
                    let results = try context.fetch(fetchRequest)
                    for result in results as! [NSManagedObject] {
                        guard let element = result.value(forKey: "element") as? String else{
                                  print("Get Data Guard Let Error")
                                  return
                        }
                        favoriteArray.append(element)
                        
                    }
                    tableView.reloadData()
                }catch{
                    print("Get Data Error")
                }
    }
    
}

extension FavoriteVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = favoriteArray[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    

    
    
}
