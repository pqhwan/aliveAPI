//
//  MainViewController.swift
//  aliveApi
//
//  Created by Pete Kim on 2/12/15.
//  Copyright (c) 2015 Pete Kim. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var endpoints = [HTTPEndPoint]()
    //var apiController: APIController = APIController()
    let cellReuseIdentifier = "apiEndpointCell"
    //var endpoints =  ["HTTP POST /signup", "HTTP POST /login", "HTTP POST /room"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create endpoints
        self.endpoints.append(HTTPEndPoint(title: "Login", message: nil, verb: "post", route: "/login",
            textFields: ["login":false,"password":true], completionHandler: nil))
        self.endpoints.append(HTTPEndPoint(title: "Signup", message: nil, verb: "post", route: "/signup", textFields: ["login":false, "password":true], completionHandler: nil))
        self.endpoints.append(HTTPEndPoint(title: "Create room", message: nil, verb: "post", route: "/room",
            textFields: ["roomName":false], completionHandler: nil))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // number of cells (api endpoints in this case)
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endpoints.count
    }
    
    // return a cell that makes corresponding HTTP/Websocket requests when clicked
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell
        let endpoint: HTTPEndPoint! = self.endpoints[indexPath.row]
        
        cell.textLabel?.text = endpoint.title
        if let m = endpoint.message as String? {
            cell.detailTextLabel?.text = m
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let endpoint: HTTPEndPoint! = endpoints[indexPath.row]
        let alert: UIAlertController! = UIAlertController(title: endpoint.title, message: endpoint.message, preferredStyle: .Alert)
        
        let cancelAction: UIAlertAction! = UIAlertAction(title: "cancel", style: .Cancel, handler: { (action) in
            dispatch_async(dispatch_get_main_queue(), {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            })
        })
        alert.addAction(cancelAction)
        
        let goAction: UIAlertAction! = UIAlertAction(title: "go", style: UIAlertActionStyle.Default , handler: {
            (action) in
            let loginTextField = alert.textFields![0] as UITextField
            let passwordTextField = alert.textFields![1] as UITextField
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        })
        alert.addAction(goAction)
        
        if let t = endpoint.textFields as [String:Bool]? {
            for (placeHolder, secure) in t {
                alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                    textField.placeholder = placeHolder
                    textField.secureTextEntry = secure
                })
                
            }
        }
        
        // present alert controller
        self.presentViewController(alert, animated: true, completion: {() in})
    }

}

