//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Eslam on 9/02/18.
//  Copyright © 2018 EslamAtef. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/"
    let cryptoArray = ["BTC","ETH","BCH","LTC","DASH","XRP","XMR","MANA"]
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolArray = ["$", "R$", "$", "Â¥", "â‚¬", "Â£", "$", "Rp", "â‚ª", "â‚¹", "Â¥", "$", "kr", "$", "zÅ‚", "lei", "â‚½", "kr", "$", "$", "R"]
    
    var finalURL = ""
    var currencySelected = ""
    
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return cryptoArray.count
        }
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return cryptoArray[row]
        }
        return currencyArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + cryptoArray[pickerView.selectedRow(inComponent: 0)] + currencyArray[pickerView.selectedRow(inComponent: 1)]
        currencySelected = currencySymbolArray[pickerView.selectedRow(inComponent: 1)]
        getBitcoinData(url: finalURL)
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getBitcoinData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the Bitcoin data")
                    let bitcoinJSON : JSON = JSON(response.result.value!)

                    self.updateBitcoinData(json: bitcoinJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitcoinData(json : JSON) {
        
        if let bitcoinResult = json["ask"].double {
            bitcoinPriceLabel.text = currencySelected + String(bitcoinResult)
        } else {
            bitcoinPriceLabel.text = "Price Unavailable"
        }
    }
    




}

