//
//  SearchDetailViewController.swift
//  MoneytapSearch
//
//  Created by Arunprasat Selvaraj on 6/22/18.
//  Copyright © 2018 Arunprasat Selvaraj. All rights reserved.
//

import UIKit
import WebKit

class SearchDetailViewController: UIViewController {

    @IBOutlet weak var myWebView: WKWebView!
    var myActivityIndicator: UIActivityIndicatorView!
    
    //Model
    var gWebUrl: String!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpUI()
        setUpModel()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI() {
        
        setNavigationBar()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

//        myActivityIndicator = UIActivityIndicatorView()
//        myActivityIndicator.center = self.view.center
//        myActivityIndicator.hidesWhenStopped = true
//        myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
//        myActivityIndicator.color = UIColor.black
//        view.addSubview(myActivityIndicator)
//        showOrHideActivityIndicator(show: true)
    }
    
    func setUpModel() {
        
        myWebView = WKWebView()
        myWebView.navigationDelegate = self
        view = myWebView
        
        let aUrlString = HELPER.getWikipediaLinkForSearch(aSearch: gWebUrl)
        let url = URL(string: aUrlString)!
        myWebView.load(URLRequest(url: url))
        myWebView.allowsBackForwardNavigationGestures = true
    }
    
    //MARK: Helper
    
    func showOrHideActivityIndicator(show: Bool) {
      
        if show {
            
            myActivityIndicator.startAnimating()
            self.view.bringSubview(toFront: myActivityIndicator)
        }
        else {
            
            myActivityIndicator.stopAnimating()
        }
    }
    
    func setNavigationBar() {
        
        UINavigationController().setNavigationBarTitle(title: gWebUrl, viewController: self)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .stop , target: self, action: #selector(leftBarButtonTapped))
    }
    
    @objc func leftBarButtonTapped() {
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: {
            
            HELPER.postNotificationForViewController(viewcontroller: self, name: NOTIFICATION_DISMISS_TO_RECENT_SEARCH)
        })
    }
    
}

extension SearchDetailViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        UIApplication.shared.isNetworkActivityIndicatorVisible = false

       // showOrHideActivityIndicator(show: false)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {

        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
