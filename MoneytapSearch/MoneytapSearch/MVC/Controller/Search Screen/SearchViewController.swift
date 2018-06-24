//
//  SearchViewController.swift
//  MoneytapSearch
//
//  Created by Arunprasat Selvaraj on 6/22/18.
//  Copyright © 2018 Arunprasat Selvaraj. All rights reserved.
//

import UIKit

class SearchListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gSearchTitleLabel: UILabel!
    @IBOutlet weak var gSearchDetailLabel: UILabel!
    @IBOutlet weak var gSearchImageView: UIImageView!
    
}
class SearchViewController: UIViewController {
    
    @IBOutlet weak var myAlertLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!

    //Model
    var myInfoArray = [SearchList]()
    var gSearchString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI() {
        
        setNavigationBar()
        myTableView.separatorInset = UIEdgeInsetsMake(0, 2, 0, 2)
        myTableView.tableFooterView = UIView()
        showAlert()
    }
    
    func setUpModel() {
        
        if myInfoArray.count != 0 {
            
            hideAlert()
            DispatchQueue.main.async {
           
                self.myTableView.reloadData()
            }
        }
        else {
            
            showAlert()
        }
    }
    
    //MARK: Helper
    
    func setNavigationBar() {
        
        let searchBar:UISearchBar = UISearchBar.init(frame: CGRect.init(x: 10, y: 0, width: self.view.frame.width - 20, height: 30))
        searchBar.placeholder = SEARCH_PLACEHOLDER
        searchBar.showsCancelButton = true
        searchBar.tintColor = UIColor.black
        searchBar.delegate = self
        searchBar.text = (gSearchString.count != 0) ? gSearchString : ""
        searchBar.becomeFirstResponder()
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
    }
    
     func cancelButtonTapped() {
        
        UIAlertController().showAlertViewWithButtonTitle(self, title: "", message: ALERT_SEARCH_CANCEL, okButtonBlock: { (_ action: UIAlertAction) in
            
            self.dismiss(animated: false, completion: {
                HELPER.postNotificationForViewController(viewcontroller: self, name: NOTIFICATION_DISMISS_TO_RECENT_SEARCH)
            })
            
        }) { (_ action: UIAlertAction) in
            
        }
    }
    
    func showAlert() {
        
        DispatchQueue.main.async {
            
            self.myAlertLabel.isHidden = false
            self.myTableView.isHidden = true
        }
    }
    
    func hideAlert() {
        
        
            self.myAlertLabel.isHidden = true
            self.myTableView.isHidden = false
    }
    
    func filterFunction(searchText: String) {
     
        if APIMANAGER.isNetworkReachable() == false {
        
            UIAlertController().showAlertViewWithOkAction(self, title: "", message: ALERT_NO_INTERNET, okButtonBlock: { (_ action: UIAlertAction) in
                
                
            })
            return
        }
       
        APIMANAGER.callSearchService(searchString: searchText) { (_ aSearchList: [SearchList]) in
         
            if aSearchList.count != 0 {
                
                self.myInfoArray = aSearchList
            }
            else {
                
            }
            DispatchQueue.main.async {
            
                self.setUpModel()
            }
        }
    }
}

//MARK: SEARCH BAR DELEGATE
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        //Show Cancel
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.tintColor = .black
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //Filter function
        self.filterFunction(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchBar.resignFirstResponder()
        
        //Filter function
        self.filterFunction(searchText: searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.cancelButtonTapped()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    //UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var aCell: SearchListTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "SearchListTableViewCell") as? SearchListTableViewCell
        
        if aCell == nil {
            
            aCell = UITableViewCell.init(style: .default, reuseIdentifier: "SearchListTableViewCell") as? SearchListTableViewCell
        }
        
        HELPER.roundCorner(for: (aCell?.gSearchImageView)!, radius: 5, borderColor: .clear)
        let aSearch = self.myInfoArray[indexPath.row]
        aCell?.gSearchTitleLabel.text = aSearch.title
        aCell?.gSearchDetailLabel.text = aSearch.details
        aCell?.gSearchImageView.downloadedFrom(link: aSearch.imageUrl!)
        
        return aCell!
    }
    
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let aRecentSearch = self.myInfoArray[indexPath.row]
        var isUpdateRequired = false
        let aInfoArray = COREDATA.getRecentSearch()
        
        for aPastSearch in aInfoArray {
            
            if aRecentSearch.title == aPastSearch.title {
                isUpdateRequired = true
            }
        }
        
        if isUpdateRequired != true {
            COREDATA.addRecentSearch(searchName: aRecentSearch.title!)
        }
            
        
        let aViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchDetailViewController") as? SearchDetailViewController
        aViewController?.gWebUrl = aRecentSearch.title! // To set the title and to form the wikipedia url
        let aNavigatioController = UINavigationController.init(rootViewController: aViewController!)
        self.present(aNavigatioController, animated: false) {
        
        }
    }
}
