//
//  CountryPickerViewController.swift
//  CoronaVirusApp
//
//  Created by Dimitar on 7.4.21.
//

import UIKit
import JGProgressHUD
import SnapKit

protocol ReloadDataDelegate: AnyObject {
    func reloadCountriesData()
}

class CountryPickerViewController: UIViewController, DisplayHudProtocol, Alertable {
    
    @IBOutlet weak var searchHolderView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationHolderView: UIView!
    
    weak var delegate: ReloadDataDelegate?
    private var countries = [Country]()
    var hud: JGProgressHUD?
    
    private var searchController = UISearchController(searchResultsController: nil)
    
    var countriesDataSource: [Country] {
        if segmentControl.selectedSegmentIndex == 0 {
            guard let searchText = searchController.searchBar.text else {
                return countries
            }
            return countries.filter({ $0.name.lowercased().hasPrefix(searchText.lowercased())})
        } else {
            guard let searchText = searchController.searchBar.text else {
                return countries.filter { $0.isSelected }
            }
            return countries.filter({ $0.isSelected && $0.name.lowercased()
                                       .hasPrefix(searchText.lowercased())})
    }
}
   

    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationView()
        setupTableView()
        fetchCountries()
        configureSegmentControl()
        setupSearchController()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.becomeFirstResponder()
    }
    

    private func addNavigationView() {
        let navigationView = NavigationView(state: .backAndTitle, delegate: self, title: "Add Country")
        navigationHolderView.addSubview(navigationView)
        navigationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    private func fetchCountries() {
        displayHud(true)
        APIManager.shared.getAllCountries { [weak self] result in
            self?.displayHud(false)
                switch result {
            case .failure(let error):
                self?.showErrorAlert(error)
            case .success(let countries):
                    self?.countries = countries.sorted(by: {$0.name < $1.name})
                    self?.tableView.reloadData()
                        }
                    }
        }
    private func setupTableView() {
        tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: CountryTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.separatorColor = UIColor(hex: "EDEDED")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.rowHeight = 80
    }
    
    private func configureSegmentControl() {
        segmentControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .compact)
        
        segmentControl.backgroundColor = .clear
        segmentControl.tintColor = .clear
        
        segmentControl.setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
                NSAttributedString.Key.foregroundColor: UIColor.white],
                for: .selected)
        
        segmentControl.setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
                NSAttributedString.Key.foregroundColor: UIColor(hex: "3c3c3c")],
                for: .selected)
    }
    
    @IBAction func onSegmentChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    private func setupSearchController() {
        searchHolderView.layer.cornerRadius = 25
        searchHolderView.layer.masksToBounds = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Countries"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.extendedLayoutIncludesOpaqueBars = true
        searchController.definesPresentationContext = true
        if #available(iOS 13.0, *) {
            searchController.automaticallyShowsCancelButton = false
        } else {
            // Fallback on earlier versions
        }
        searchController.searchBar.sizeToFit()
        searchHolderView.addSubview(searchController.searchBar)
    }
    
}
//MARK: - Extension

extension CountryPickerViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        tableView.reloadData()
    }
}

extension CountryPickerViewController: NavigationViewDelegate {
    func didTapBack() {
        searchController.isActive = false
        navigationController?.popViewController(animated: true)
    }
}
extension CountryPickerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countriesDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.reuseIdentifier) as! CountryTableViewCell
        let country = countriesDataSource[indexPath.row]
        cell.delegate = self
        cell.setupCellData(country: country)
        return cell
    }
}
extension CountryPickerViewController: CountrySelectionDelegate {
    func didChangeValue(country: Country) {
        delegate?.reloadCountriesData()
        guard let index = countriesDataSource.firstIndex(where: { $0.isoCode == country.isoCode} ) else {
            return
        }
        tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .none)
    }
}

