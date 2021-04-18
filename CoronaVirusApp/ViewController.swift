//
//  ViewController.swift
//  CoronaVirusApp
//
//  Created by Dimitar on 6.4.21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lblTotalCases: UILabel!
    @IBOutlet weak var lblRecoveredCases: UILabel!
    @IBOutlet weak var lblTotalDeaths: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSummaryCases()
    }

    @IBAction func onCountry(_ sender: UIButton) {
    
    }
    
    func getSummaryCases() {
        APIManager.shared.getSummary { (global, error) in
            if let error = error {
                print(error)
                return
            }
            if let global = global {
                self.lblTotalDeaths.text = "\(global.globalCases?.TotalDeaths)"
                self.lblRecoveredCases.text = "\(global.globalCases?.TotalRecovered)"
                self.lblTotalCases.text = "\(global.globalCases?.TotalConfirmed)"
                
        }
      }
    }
  }
