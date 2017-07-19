//
//  ViewController.swift
//  DropDown
//
//  Created by meltem akpolat on 9.06.2017.
//  Copyright © 2017 meltem akpolat. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dropdown: UIPickerView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tabBar: UITabBarItem!
    
    var adresDizisi = [String]()
    var adresID = [Int]()
    var adresLats = [Float]()
    var adresLngs = [Float]()
    
    var adresIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adresleriGetir()
        
    }
    
    @IBAction func varsayilanYapButonu(_ sender: UIButton)
    {
        
        UserDefaults.standard.set(adresDizisi[adresIndex], forKey: "adres")
        
    }
    
    @IBAction func silButonu(_ sender: UIButton)
    {
       
    }
    
    
    // component sayısı kaç sütunlu picker ımız olacağını gösterir. 1 sütunlu olacak.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return adresDizisi.count
        
    }
    
    // word wrap
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var returnResult: String = ""
        if pickerView.tag == 1 {
            returnResult = adresDizisi[row].description
        } else if pickerView.tag == 2 {
            returnResult =  adresDizisi[row]
        } else if pickerView.tag == 3 {
            returnResult = adresDizisi[row]
        } else {
            returnResult = ""
        }
        print(returnResult)
        self.view.endEditing(true)
        return returnResult
    
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // secili olan adresin indexini bulma
        adresIndex = adresDizisi.index(of: "\(adresDizisi[row])")!
        
        UserDefaults.standard.set(adresDizisi[row], forKey: "adres")
        
        // Seçili adres harita üzerinde marker ile gösterilir
        self.adresMarkerEkle(lat: self.adresLats[adresIndex], lng: self.adresLngs[adresIndex], adres: self.adresDizisi[adresIndex])

    }
    
    // word wrap
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 375, height: 44))
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = adresDizisi[row]
        label.textAlignment = NSTextAlignment.center
        label.sizeToFit()
        return label
    
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 65
    }

    func adresleriGetir()
    {
        adresDizisi.append("Gazipaşa Mah. Taksim İş Merkezi")
        adresDizisi.append("Ayasofya Camisi")
        adresDizisi.append("Numune Hastanesi")
        adresDizisi.append("Haçkalıbaba Hastanesi")
        
        adresID.append(11)
        adresID.append(22)
        adresID.append(33)
        adresID.append(44)
        
        adresLats.append(41.004721)
        adresLats.append(41.003067)
        adresLats.append(41.005285)
        adresLats.append(41.016044)
        
        adresLngs.append(39.730893)
        adresLngs.append(39.696280)
        adresLngs.append(39.707363)
        adresLngs.append(39.594275)
        
        // Hafızadan en son kaydedilmiş olan default adres çekilir
        let defaultAdres = UserDefaults.standard.object(forKey: "adres") as? String
        
        // Şimdilik hafıza kısmı sıkıntılı olduğu için statik tanımlandı
        //defaultAdres = "Numune Hastanesi"
        
        // Default adresin index değeri çekilir
        let defaultAdresIndex = adresDizisi.index(of: defaultAdres!)
        
        // PickerView seçili verilerle yeniden yüklenir ve seçili adres setlenir
        self.dropdown.reloadAllComponents()
        self.dropdown?.selectRow(Int(defaultAdresIndex!), inComponent: 0, animated: true)
        
        // Seçili adrese ait marker harita üzerinde gösterilir
        self.adresMarkerEkle(lat: self.adresLats[defaultAdresIndex!], lng: self.adresLngs[defaultAdresIndex!], adres: self.adresDizisi[defaultAdresIndex!])
        
    }
    
    func adresMarkerEkle(lat: Float, lng: Float, adres: String) {
        
        let location = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(lng))
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(location, 200, 200), animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = adres
        annotation.subtitle = ""
        self.mapView.addAnnotation(annotation)

    }
  
}
