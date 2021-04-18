//
//  CountriesTableViewCell.swift
//  CoronaVirusApp
//
//  Created by Dimitar on 8.4.21.
//

import UIKit

class CountriesTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCountriesCell(countries: Country) {
        lblCountry.text = countries.name
    }
    
}
