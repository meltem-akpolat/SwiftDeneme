//
//  ViewController.swift
//  httpPost
//
//  Created by easistem on 17.07.2017.
//  Copyright © 2017 easistem. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var hataMesaji : String = ""
    var token : String = ""
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ViewController.tokenaGoreAdresleriGetir), userInfo: nil, repeats: true)
    }
    
    // tokenPostEtmeIslemi fonksiyonu adresBilgileriGetİslemi fonksiyonundan sonra token urettigi icin tokenaGoreAdresleriGetir fonksiyonunu yazarak 
    // timer icinde bu fonksiyonun kontrolunu yaptık. Bu sayede token degiskeninin ici bossa timer bekleyecek,
    // ici doldugu anda adresleri getir fonksiyonundan musteri adres bilgilerini getirecektir.
    func tokenaGoreAdresleriGetir()
    {
        if token.isEmpty == true
        {
            print("if")
            tokenPostEtmeIslemi()
        }else
        {
            print("else")
            timer.invalidate()
            adresBilgileriGetIslemi()
        }
    }

    // Token linkine istek gönderip access token alındı..
    func tokenPostEtmeIslemi ()
    {
        var istek = URLRequest(url: URL(string: "http://www.supersiparis.net/service/token")!)
        istek.httpMethod = "POST"
        let postString = "grant_type=password&username=05432557339&password=123456"
        istek.httpBody = postString.data(using: .utf8)
        let gorev = URLSession.shared.dataTask(with: istek) { data, response, error in
            
            // Temel network hatasını kontrol et
            guard let data = data, error == nil else {
                self.hataMesaji = "Hata=\(String(describing: error))"
                return
            }
            do {
                
                var cevapDizisi = String(data: data, encoding: .utf8)
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                cevapDizisi = json["access_token"] as? String
                self.token = cevapDizisi!
            }
                
            // Diger hatalar (http)
            catch let error as NSError {
                print(error)
            }
            
        }
        gorev.resume()
    }
    
    func adresBilgileriGetIslemi ()
    {
        var istek = URLRequest(url: URL(string: "http://www.supersiparis.net/service/api/musteri/adres")!)
        istek.httpMethod = "GET"
        istek.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        //let getString = "Bearer \(self.token)"
        
        let getString = ""
        
        istek.httpBody = getString.data(using: .utf8)
        let gorev = URLSession.shared.dataTask(with: istek) { data, response, error in
            
            // Temel network hatasını kontrol et
            guard let data = data, error == nil else {
                self.hataMesaji = "Hata=\(String(describing: error))"
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            
        }
        gorev.resume()
 
    }
}
