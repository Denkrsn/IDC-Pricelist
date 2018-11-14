//
//  ViewController.swift
//  PL_V2
//
//  Created by Denis Ganevitch on 15/11/2017.
//  Copyright © 2017 Denis Ganevitch. All rights reserved.
//
import UIKit
//import Firebase
import MessageUI

class ViewController: UIViewController {
    
    var pers = false
    var emb = false
    var foil = false
    var mf = false
    var em = false
    var mag = false
    var price = 0.0
    var RA_price = 0.0
    var silver_face = false
    var silver_back = false
    var arg = 0
    
    
    @IBOutlet weak var agBackImage: UIImageView!
    @IBOutlet weak var agFaceImage: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var mfImage: UIImageView!
    @IBOutlet weak var emImage: UIImageView!
    @IBOutlet weak var persButton: UIButton!
    @IBOutlet weak var embButton: UIButton!
    @IBOutlet weak var foilButton: UIButton!
    @IBOutlet weak var mfButton: UIButton!
    @IBOutlet weak var emButton: UIButton!
    @IBOutlet weak var magButton: UIButton!
    @IBOutlet weak var foilImage: UIImageView!
    @IBOutlet weak var embImage: UIImageView!
    @IBOutlet weak var magImage: UIImageView!
    @IBOutlet weak var persImage: UIImageView!
    
    //  стоимость по прайс листу !
    private func pricecalc (vol:Double,mag:Bool,pers:Bool,chip_MF:Bool,chip_EM:Bool,foil:Bool,emboss:Bool,arg:Int,RA:Bool )->Double
    {
        var prc = 0.0
        var ppers = 0.0
        var pmag  = 0.0
        var pfoil = 0.0
        let pEMchip = 10.0
        let pMFchip = 15.0
        
        var pemb = 0.0
        
        // задаем базовую стоимость
        
        if vol<100 { prc = 21.0 ; ppers = 5 ;pmag = 5 ; pfoil = 5 ; pemb = 5 }
        if vol<250 && vol>=100 { prc = 18; ppers = 3.5 ;pmag = 3.5 ; pfoil = 5 ; pemb = 5 }
        if vol<500 && vol>=250 { prc = 16.5 ; ppers = 2 ;pmag = 2.5 ; pfoil = 4 ; pemb = 4 }
        if vol<1000 && vol>=500{ prc = 15.5 ; ppers = 1.5 ;pmag = 2 ; pfoil = 4 ; pemb = 4 }
        if vol<2000 && vol>=1000 { prc = 14.5 ; ppers = 1 ;pmag = 1.7 ; pfoil = 3.5 ; pemb = 3.5 }
        if vol<3500 && vol>=2000 { prc = 13.0 ; ppers = 1 ;pmag = 1.5 ; pfoil = 3.5 ; pemb = 3.5 }
        if vol<=5000 && vol>=3500 { prc = 11; ppers = 0.5 ;pmag = 1 ; pfoil = 3.5 ; pemb = 3.5 }
        
        //добавляем персонализацию
        if pers==true
        {
            prc=prc+ppers
        }
        
        //добавляем mag stripe
        
        if mag==true
        {
            prc=prc+pmag
        }
        
        
        //добавляем emboss
        
        
        if emboss==true
        {
            prc=prc+pemb
        }
        
        
        //добавляем foil
        
        
        if foil==true
        {
            prc=prc+pfoil
        }
        
        //добавляем EMmarine
        
        if chip_EM==true
            
        {
            prc=prc+pEMchip
        }
        
        
        //добавляем Mifare
        
        
        if chip_MF==true
        {
            prc=prc+pMFchip
        }
        
        // ДЕЛАЕМ скидку РА
        
        if RA==true {prc=prc*0.85}
        
        return prc + Double(arg)
        
    }
    
    func priceUpdate(){
        price = pricecalc(vol: stepper.value, mag: mag, pers: pers, chip_MF: mf, chip_EM: em, foil: foil, emboss: emb,arg: arg, RA: false)
        
        RA_price = pricecalc(vol: stepper.value, mag: mag, pers: pers, chip_MF: mf, chip_EM: em, foil: foil, emboss: emb,arg: arg ,RA: true)
        
        priceLabel.text="Цена по прайсу \(price) рублей, для рекламных агенств \(round1(RA_price,place: 2)) руб. "
    }
    
    func round1(_ value: Double, place: Int) -> Double {
        let divisor = pow(10.0,Double(place))
        return round(value * divisor) / divisor
    }
    
    @IBAction func mailPressed(_ sender: UIButton) {
        
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {showMailError()}
        
    }
    
    @IBAction func agPressed(_ sender: UIButton)
    {
        switch  arg != 0 {
            
            
        //  алгоритм из кейсов или свитчей нужно найти
        case true:
            if arg == 1 {
                arg = arg+1
                agBackImage.alpha = 100
                priceUpdate()
                return
            }
            if arg == 2 {
                arg = 0
                agBackImage.alpha = 0
                agFaceImage.alpha = 0
                priceUpdate()
            }
        case false:
            arg = arg+1
            agFaceImage.alpha = 100
            priceUpdate()
        }
        
        
        
    }
    
    
    @IBAction func volumeChanged(_ sender: UIStepper) {
        
        // обязательно разобраться как  можно динамически поменять шаг в степпере
        volumeLabel.text=String(NSInteger(stepper.value))
        priceUpdate()
        
        
        
    }
    
    
    
    @IBAction func emPressed(_ sender: UIButton) {
        if em == false {
            em = true
            emButton.backgroundColor = UIColor.green
            emImage.alpha = 100
            mf = false
            mfButton.backgroundColor = UIColor.clear
            mfImage.alpha = 0
            emb = false
            embButton.backgroundColor = UIColor.clear
            embImage.alpha = 0
            priceUpdate()
            
        }   else {
            em = false
            emButton.backgroundColor = UIColor.clear
            emImage.alpha = 0
            priceUpdate()
        }
    }
    
    @IBAction func mfPressed(_ sender: UIButton) {
        if mf == false {
            mf = true
            mfButton.backgroundColor = UIColor.green
            mfImage.alpha = 100
            em = false
            emButton.backgroundColor = UIColor.clear
            emImage.alpha = 0
            emb = false
            embButton.backgroundColor = UIColor.clear
            embImage.alpha = 0
            priceUpdate()
            
        }   else {
            mf = false
            mfButton.backgroundColor = UIColor.clear
            mfImage.alpha = 0
            priceUpdate()
        }
    }
 
    
    
    
    
    
    @IBAction func magPressed(_ sender: Any) {
    
        if mag == false {
            mag = true
            
            magButton.backgroundColor = UIColor.green
            magImage.alpha = 100
            priceUpdate()
        }   else {
            mag = false
            magButton.backgroundColor = UIColor.clear
            magImage.alpha = 0
            priceUpdate()
        }
    
    }
    
    
    
    
    
 
    
    
    @IBAction func embPressed(_ sender: UIButton) {
        
        if emb == false {
            emb = true
            embButton.backgroundColor = UIColor.green
            embImage.alpha = 100
            em = false
            mfButton.backgroundColor = UIColor.clear
            emImage.alpha = 0
            mf = false
            emButton.backgroundColor = UIColor.clear
            mfImage.alpha = 0
            priceUpdate()
            
        }   else {
            emb = false
            embButton.backgroundColor = UIColor.clear
            embImage.alpha = 0
            priceUpdate()
        }
        
        
    }
    @IBAction func persPressed(_ sender: UIButton) {
        if pers == false {
            pers = true
            
            persButton.backgroundColor = UIColor.green
            persImage.alpha = 100
            priceUpdate()
        }   else {
            pers = false
            persButton.backgroundColor = UIColor.clear
            persImage.alpha = 0
            priceUpdate()
        }
    }
    
    @IBAction func foilPressed(_ sender: UIButton) {
        if foil == false {
            foil = true
            
            foilButton.backgroundColor = UIColor.green
            foilImage.alpha = 100
            priceUpdate()
        }   else {
            foil = false
            foilButton.backgroundColor = UIColor.clear
            foilImage.alpha = 0
            priceUpdate()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        priceUpdate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureMailController ()->MFMailComposeViewController{
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
        mailComposerVC.setToRecipients(["idcards@mail.ru"])
        mailComposerVC.setSubject("IDC PriceList Calculation")
        mailComposerVC.setMessageBody("""
            
            По расчету на изготовление пластиковых карт для  ______  получилась  стоимость  \(price) руб.
            При условии  что тираж равен \(String(describing: volumeLabel.text)) на карте  используются:
            
            магнитная полоса                    \(mag ? " Да ✅" : "Нет 🚫" )
            персонализация                      \(pers ? "Да ✅" : "Нет 🚫"  )
            эмбоссирование                      \(emb ? "Да ✅" : "Нет 🚫"  )
            фольга                              \(foil ? "Да ✅" : "Нет 🚫"  )
            чип Mifire                          \(mf ? "Да ✅" : "Нет 🚫"  )
            чип EM_Marine                       \(em ? "Да ✅" : "Нет 🚫"  )
            серебрянный пластик  плюсом \(arg) руб.
            
            
            * Стоимость для РА  \(RA_price) руб.
            
            
            
            """, isHTML: false)
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController (title: "Не получилось отправить почту", message: "Ваше устройство не можетотправить емайл.", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert ,animated :true ,completion: nil)
        
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

