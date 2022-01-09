//
//  ViewController.swift
//  RomanToInt
//
//  Created by Hüsnü Taş on 9.01.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let romanMap: [String:Int] = ["I":1, "IV":4, "V":5, "IX":9, "X":10, "XL":40, "L":50, "XC":90, "C":100, "CD":400, "D":500, "CM":900, "M":1000, "INF": 99999]
    var sum = 0
    var correctString = ""
    
    
    @IBOutlet weak var romanTextField: UITextField!
    @IBOutlet weak var decimalTextField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteButton.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func convertAction(_ sender: Any) {
        guard let roman = romanTextField.text,!roman.isEmpty else {
            makeAlert(title: "Error", message: "The input cannot be empty")
            favoriteButton.isHidden = true
            resultLabel.text = "Result: -"
            return
        }
        
        for eleman in roman{
            guard let _ = romanMap[String(eleman)] else{
                makeAlert(title: "Error", message: "The input is incorrect")
                favoriteButton.isHidden = true
                resultLabel.text = "Result: -"
                return
            }
        }
        
        var c1 : String!
        var c2 : String!
        
        sum = 0
        var i = 0
        while i < roman.count{
            
            c1 = String(roman[roman.index(roman.startIndex, offsetBy: i)])
            
            if i+1 < roman.count{
                c2 = String(roman[roman.index(roman.startIndex, offsetBy: i+1)])
                if romanMap[c1]! < romanMap[c2]! {
                    sum += romanMap[c2]! - romanMap[c1]!
                    i += 1
                }else{
                    sum += romanMap[c1]!
                }
            }else{
                sum += romanMap[c1]!
            }
            i += 1
        }
        
 
        
        if sum >= 5000{
            makeAlert(title: "Error", message: "The input must be in range of 1 to 5000")
            favoriteButton.isHidden = true
            resultLabel.text = "Result: -"
        }else{
            controlNumbers(num: sum)
            if correctString == roman {
                resultLabel.text = "Result: \(sum)"
                favoriteButton.isHidden = false
            }else{
                makeAlert(title: "Error", message: "The input is incorrect")
                favoriteButton.isHidden = true
                resultLabel.text = "Result: -"
            }
            
        }
        
    }
    
    @IBAction func decimalClicked(_ sender: Any) {
        guard let decimal = decimalTextField.text, let number = Int(decimal), number < 5000 else{
            makeAlert(title: "Error", message: "The input must be in range of 1 to 5000")
            favoriteButton.isHidden = true
            resultLabel.text = "Result: -"
            return
        }
        controlNumbers(num: number)
        sum = number
        resultLabel.text = "Result: \(correctString)"
        favoriteButton.isHidden = false
    }
    
    
    
    @IBAction func favoriteAction(_ sender: Any) {
        let data = "\(correctString) - \(sum)"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newData = NSEntityDescription.insertNewObject(forEntityName: "Favorites", into: context)
        newData.setValue(data, forKey: "element")
        
        do {
            try context.save()
            makeAlert(title: "Saved", message: "Successfully")
            self.resultLabel.text = "Result: -"
            self.romanTextField.text = ""
            self.decimalTextField.text = ""
            self.favoriteButton.isHidden = true
        } catch {
            print("ERROR")
        }
    }
    
    
    @IBAction func seeFavoritesAction(_ sender: Any) {
        performSegue(withIdentifier: "toFavoriteVC", sender: nil)
    }
    
    
    private func controlNumbers(num: Int) {
        correctString = ""
        var toplam = num
        
        var digitArray : [Int] = []
        var y = 1
        var max = romanMap.randomElement()
      
        while toplam >= 1{
            let x = toplam % 10
            toplam = toplam / 10
            digitArray.append(x*y)
            y = y * 10
        }
        
        for digit in digitArray.reversed() {
            if digit > 0 {
                for element in (Array(romanMap).sorted {$0.1 < $1.1}) {
                    if element.value < digit{
                        max = element
                    }
                    if digit == element.value{
                        correctString += element.key
                        break
                    }else if digit < element.value{
                        let howMany = digit / Int(max!.value)
                        for _ in 0..<howMany{
                            correctString += max!.key
                        }
                        break
                    }
                    
                }
            }
        }
        
    }
    
    private func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(closeButton)
        present(alert, animated: true, completion: nil)
    }
    
}

