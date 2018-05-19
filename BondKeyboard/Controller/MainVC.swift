//
//  MainVC.swift
//  BondKeyboard
//
//  Created by Leela Prasad on 30/04/18.
//  Copyright © 2018 Leela Prasad. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    var dataArray1 = ["Prasad","Praveen","Ram","Dipesh","Abhishek","Gourav"]
    var dataArray2 = ["Name1","Name2","Name3","Name4","Name5","Name6"]
    
    
    lazy var segmntedContrl: UISegmentedControl = {
        let sgContrl = UISegmentedControl.init(items: ["Contacts","Wallet IDs"])
        sgContrl.tintColor = .orange
        sgContrl.selectedSegmentIndex = 0
        return sgContrl
    }()
    
    let cellId = "cellId"
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createSegmentedControl()
        self.createTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.removeViewControllerAsChildViewController(childViewController: self)
        
    }
    
    
    func createSegmentedControl() {
        self.segmntedContrl.addTarget(self, action: #selector(onChangeOfSegments(segmntedControl:)), for: .valueChanged)
        self.view.addSubview(segmntedContrl)
        self.view.addConstraintsWithFormatString(formate: "H:|[v0]|", views: segmntedContrl)
        self.view.addConstraintsWithFormatString(formate: "V:|[v0(35)]", views: segmntedContrl)
    }
    
    @objc func onChangeOfSegments(segmntedControl: UISegmentedControl) {
        self.tableView.reloadData()
    }
    
    func createTableView() {
        
        self.view.addSubview(tableView)
        
        self.view.addConstraintsWithFormatString(formate: "H:|[v0]|", views: tableView)
        self.view.addConstraintsWithFormatString(formate: "V:|-35.5-[v0]|", views: tableView)
        
    }
    
    private func addViewControllerAsChildViewController(childViewController: UIViewController) {
        
        addChildViewController(childViewController)
        view.addSubview(childViewController.view)
        childViewController.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childViewController.didMove(toParentViewController: self)
        
    }
    
    private func removeViewControllerAsChildViewController(childViewController: UIViewController) {
        
        childViewController.willMove(toParentViewController: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParentViewController()
        
    }
    
    

}



extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmntedContrl.selectedSegmentIndex == 0 {
            return dataArray1.count
        } else {
            return dataArray2.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if segmntedContrl.selectedSegmentIndex == 0 {
            cell.textLabel?.text = dataArray1[indexPath.row]
        } else {
            cell.textLabel?.text = dataArray2[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc1 = ProcessVC()
        self.view.addSubview(vc1.view)
        self.addViewControllerAsChildViewController(childViewController: vc1)
        
    }
    
}
