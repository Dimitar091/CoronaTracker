//
//  DashboardViewController.swift
//  CoronaVirusApp
//
//  Created by Dimitar on 7.4.21.
//

import UIKit
import SnapKit
import JGProgressHUD

class DashboardViewController: UIViewController, DisplayHudProtocol, Alertable {

    @IBOutlet weak var colectionView: UICollectionView!
    @IBOutlet weak var lblLastUpdate: UILabel!
    @IBOutlet weak var btnRetry: UIButton!
    @IBOutlet weak var lblRecovered: UILabel!
    @IBOutlet weak var lblDeaths: UILabel!
    @IBOutlet weak var lblConfirmed: UILabel!
    @IBOutlet weak var globalHolderView: UIView!
    @IBOutlet weak var navigationHolderView: UIView!
    @IBOutlet weak var btnAddCountry: UIButton!
    
    var hud: JGProgressHUD?
    private var selectedCountries = [Country]()
    private(set) var allCountries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationView()
        setupGlobalHolderView()
        setupGlobalHolder()
        getGlobalData()
        colectionView.dataSource = self
        fetchCountries()

        // Do any additional setup after loading the view.
    }
    
    private func addNavigationView() {
        let navigationView = NavigationView(state: .onlyTitle, delegate: self, title: "Dashboard")
        navigationHolderView.addSubview(navigationView)
        navigationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupGlobalHolderView() {
        let navigationView = NavigationView(state: .onlyTitle, delegate: nil, title: "Dashboard")
        navigationHolderView.addSubview(navigationView)
        navigationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupGlobalHolder() {
        globalHolderView.layer.cornerRadius = 8
        globalHolderView.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        globalHolderView.layer.shadowOpacity = 1.0
        globalHolderView.layer.shadowRadius = 10
        globalHolderView.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    private func getGlobalData() {
        displayHud(true)
        APIManager.shared.getGlobalInfo { result in
        self.displayHud(false)
            switch result {
        case .failure(let error):
            self.btnRetry.isHidden = false
            self.showErrorAlert(error)
        case .success(let global):
            self.btnRetry.isHidden = true
            self.setGlobalData(global: global)
        }
    }
}
    
    private func setFormatedLastUpdate() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy, h:mm a"
        let formatedDate = dateFormatter.string(from: date)
        let updated = "Last Updated on " + formatedDate
        let text = "Confirmed Cases\n" + updated
        let atributed = NSMutableAttributedString(string: text)
        atributed.addAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .bold),.foregroundColor: UIColor(hex: "3C3C3C") ], range: (text as NSString).range(of: text))
        atributed.addAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .regular),.foregroundColor: UIColor(hex: "707070")], range: (text as NSString).range(of: updated))
        lblLastUpdate.attributedText = atributed
    }
    
    private func setGlobalData(global: Global) {
        lblDeaths.text = global.deaths.getFormatedNumber()
        lblRecovered.text = global.recovered.getFormatedNumber()
        lblConfirmed.text = global.confirmed.getFormatedNumber()
        self.setFormatedLastUpdate()
    }
    
    @IBAction func onAddCountry(_ sender: UIButton) {
        performSegue(withIdentifier: "countriesSegue", sender: nil)
    }
    @IBAction func onRetry(_ sender: UIButton) {
        getGlobalData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "countriesSegue" {
            let controller = segue.destination as! CountryPickerViewController
            controller.delegate = self
        }
    }
    
    private func fetchCountries() {
        APIManager.shared.getAllCountries { [weak self] result in
                switch result {
            case .failure(let error):
                    print(error.localizedDescription)
            case .success(let countries):
                self?.allCountries = countries
                self?.reloadCountriesData()
            }
          }
        }

}

extension DashboardViewController: ReloadDataDelegate {
    func reloadCountriesData() {
        selectedCountries = allCountries.filter( { $0.isSelected })
        colectionView.reloadData()
    }
}

extension DashboardViewController: NavigationViewDelegate {
    func didTapBack() {
    }
}
extension DashboardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedCountries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "countryCell", for: indexPath) as! CountryCollectionCell
           let country = selectedCountries[indexPath.row]
           cell.setCountryData(country)
           cell.shadowHolderView.layer.cornerRadius = 8
           cell.shadowHolderView.layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
           cell.shadowHolderView.layer.shadowOpacity = 1.0
           cell.shadowHolderView.layer.shadowRadius = 8
           cell.shadowHolderView.layer.shadowOffset = CGSize(width: 0, height: 2)
           cell.contentView.layer.cornerRadius = 8
           cell.contentView.layer.masksToBounds = true
           return cell
       }
}
