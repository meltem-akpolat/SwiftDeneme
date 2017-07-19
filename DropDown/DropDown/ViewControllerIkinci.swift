//
//  ViewControllerIkinci.swift
//  DropDown
//
//  Created by easistem on 13.07.2017.
//  Copyright © 2017 meltem akpolat. All rights reserved.
//

import UIKit

class ViewControllerIkinci: UIViewController, UITextFieldDelegate {

    @IBOutlet var adresGirisi: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func ileriButonu(_ sender: UIButton)
    {
        if adresGirisi.text != "" {
            
            let sayfa:UIViewController = (storyboard?.instantiateViewController(withIdentifier: "VCHarita"))! as UIViewController
            self.present(sayfa, animated: true, completion: nil)
            
        }else {
            
            let alertController = UIAlertController(title: "Uyarı", message: "Lütfen açık adresinizi giriniz!", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "TAMAM", style: .default) { action in }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true) {
                
            }
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        adresGirisi.resignFirstResponder()
        return true
    }

}
