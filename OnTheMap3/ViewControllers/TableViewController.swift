//
//  TableViewController.swift
//  OnTheMap3
//
//  Created by Raghad Mah on 09/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import SafariServices

class TableViewController: UITableViewController {
    
    
       @IBOutlet weak var usersTableView: UITableView!
    
    
    var usersDataArray = ModelDataArray.shared.userDataArray
    
    override func viewWillAppear(_ animated: Bool) {
        getAllUsersData()
    }

    
    //MARK: getAllUsersData
    func getAllUsersData(){
        usersDataArray.removeAll()
        ActivityIndicator.startAI(view: self.view)
        
        ParseRequests.sharedInstance().getDataFromUsers{(success, data, error) in
            
            if success {
                guard let newData = data else {return}
                
                self.usersDataArray = newData as! [Results]
                
                DispatchQueue.main.async {
                    ActivityIndicator.stopAI()
                    
                    //get all users info
                    self.usersTableView.reloadData()
                }
            }
            else {
                DispatchQueue.main.async {
                    ActivityIndicator.stopAI()
                }
                Alert.alert(vc: self, message: error!)
            }
        }
    }
    
 
    //MARK: addButton
    @IBAction func addButton(_ sender: Any) {
        ParseRequests.sharedInstance().getUserDataByUniqueKey{(success, data, error) in
            
            if success {
                if data != nil {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "addLocation", sender: nil)
                    }
                }
                else {
                    Alert.overwriteAlert(on: self, message: "User \(UdacityRequests.sharedInstance().nickname!) already exists. Do you want to overwrite location?", completionHandlerForAlert: {(action) in
                        
                        self.performSegue(withIdentifier: "addLocation", sender: nil)
                        
                    })
                }
            }
            else {
                Alert.alert(vc: self, message: error!)
            }
        }
    }
    
    //MARK: refreshButton
    @IBAction func refreshButton(_ sender: Any) {
        getAllUsersData()
    }
    
    //MARK: logoutButton
    @IBAction func logoutButton(_ sender: Any) {
        UdacityRequests.sharedInstance().deleteSession{(success, data, error) in
            
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    Alert.alert(vc: self, message: error!)
                }
            }
        }
    }
    

    // MARK: Table view functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return number of rows
        return usersDataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //use the customized tableCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersDataCell") as! TableViewCellSetup
        
        cell.fillCell(data: usersDataArray[indexPath.row] as! Results)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let array = usersDataArray as! [Results]
        
        if let urlString = array[indexPath.row].mediaURL, let url = URL(string: urlString) {
            
            //if url begins with http safari page will open
            if url.absoluteString.hasPrefix("http") {
                let svc = SFSafariViewController(url: url)
                present(svc, animated: true, completion: nil)
            }
            else {
                DispatchQueue.main.async {
                    Alert.alert(vc: self, message: "Invalid URL!")
                }
            }
        }
    }

}
