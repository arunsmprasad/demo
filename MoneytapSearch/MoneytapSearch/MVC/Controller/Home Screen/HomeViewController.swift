//
//  HomeViewController.swift
//  MoneytapSearch
//
//  Created by Arunprasat Selvaraj on 6/22/18.
//  Copyright © 2018 Arunprasat Selvaraj. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
   
    @IBOutlet weak var myAlertLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    
    //Model
    var myInfoArray = [RecentSearch]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpModel()
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
        
        // Added to refesh list while move from wikiedia screen
        NotificationCenter.default.addObserver(self, selector: #selector(setUpModel), name: NSNotification.Name(rawValue: NOTIFICATION_DISMISS_TO_RECENT_SEARCH), object: nil)

    }
    
    @objc func setUpModel() {
        
        //Get Recent Search list from Coredata
        myInfoArray = COREDATA.getRecentSearch()
        
        if myInfoArray.count != 0 {
            
            hideAlert()
            myTableView.reloadData()
        }
        else {
            
            showAlert()
        }

    }
    
    //MARK: Helper
    
    func setNavigationBar() {
        
        UINavigationController().setNavigationBarTitle(title: SCREEN_TITLE_WIKI, viewController: self)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .search , target: self, action: #selector(rightBarButtonTapped))

    }

    @objc func rightBarButtonTapped() {
        
        let aViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        aViewController?.gSearchString = ""
        let aNavigatioController = UINavigationController.init(rootViewController: aViewController!)
        self.present(aNavigatioController, animated: false) {
            
        }
    }
    func showAlert() {
        
        UIView.animate(withDuration: 0.2) {
            
            self.myAlertLabel.isHidden = false
            self.myTableView.isHidden = true
        }
    }
    
    func hideAlert() {
       
        UIView.animate(withDuration: 0.2) {
            
            self.myAlertLabel.isHidden = true
            self.myTableView.isHidden = false
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    //UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myInfoArray.count
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let aLabel = UILabel()
        aLabel.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 40)
        aLabel.text = HELPER.addSpaceToLabel(aText: "RECENT SEARCH", space: 4)
        aLabel.font = UIFont.systemFont(ofSize: 14)
        aLabel.textColor = UIColor.gray
        
        return aLabel
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var aCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "aCell")
        
        if aCell == nil {
            
            aCell = UITableViewCell.init(style: .default, reuseIdentifier: "aCell")
        }
        
        let aRecentSearch = self.myInfoArray[indexPath.row]
        aCell?.textLabel?.text = aRecentSearch.title
        return aCell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            //Delete the particular data from the list and refresh the data.
            let aRecentSearch = self.myInfoArray[indexPath.row]
            self.myInfoArray.remove(at: indexPath.row)
            self.myTableView.deleteRows(at: [indexPath], with: .left)
            
            if self.myInfoArray.count == 0 {// to show alert while no data found
                self.showAlert()
            }
            
            COREDATA.deleteRecentSearch(searchName: aRecentSearch.title!)
        }
    }
    
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
       
        let aRecentSearch = self.myInfoArray[indexPath.row]

        let aViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        aViewController?.gSearchString = aRecentSearch.title // send to looad the value for which u have already searched.
        
        let aNavigatioController = UINavigationController.init(rootViewController: aViewController!)
        self.present(aNavigatioController, animated: false) {
            
        }
    }
}
