//
//  DisplayHudProtocol.swift
//  CoronaVirusApp
//
//  Created by Dimitar on 9.4.21.
//

import Foundation
import  UIKit
import JGProgressHUD

protocol DisplayHudProtocol: AnyObject {
    var hud: JGProgressHUD? { get set }
    
    func displayHud(_ shouldDisplay: Bool)
}

extension DisplayHudProtocol where Self: UIViewController {
    func displayHud(_ shouldDisplay: Bool) {
        
        if shouldDisplay {
            if hud == nil {
                setDefaultHud()
            }
            hud?.show(in: view)
            
        } else {
            hud?.dismiss()
        }
        
    }
    
    private func setDefaultHud() {
        hud = JGProgressHUD(style: .dark)
    }
}
