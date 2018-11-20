//
//  ViewController.swift
//  FirebaseDBDemo
//
//  Created by Jeplin on 29/10/18.
//  Copyright © 2018 Jeplin. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var lblDisplay: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    
    var myFireBase:DatabaseReference!
    var userList=[Users]()
    
    @IBAction func btnAddUser(_ sender: Any) {
        addUserFunction()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate=self
        myTableView.dataSource=self
        
        
        myFireBase=Database.database().reference().child("Users")
        getUserFunction()
    }
    
    func addUserFunction(){
        let key = myFireBase.childByAutoId().key
        
        let user=["id":key,"name":txtName.text! as String,"message":txtMessage.text! as String]
        
        myFireBase.child(key!).setValue(user)
        
        lblDisplay.text="User Added"
        myTableView.reloadData()
    }
    
    func getUserFunction(){
        myFireBase.observe(DataEventType.value, with: {(data) in
            if data.childrenCount>0{
                self.userList.removeAll()
                
                for item in data.children.allObjects as! [DataSnapshot]{
                    let itemObject=item.value as? [String:AnyObject]
                    let name=itemObject?["name"]
                    let message=itemObject?["message"]
                    let id=itemObject?["id"]
                    
                    let users=Users(id: id as! String?, name: name as! String?, message: message as! String?)
                    
                    self.userList.append(users)
                    
                }
//                print("All Data - \(self.userList.count)")
                self.myTableView.reloadData()
            }
            
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier="cellId"
        
        let userObj:Users
        
        userObj=userList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
        
        cell.textLabel?.text=userObj.name
        cell.detailTextLabel?.text=userObj.message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let users=userList[indexPath.row]
        let alertController = UIAlertController(title: "Example", message: "Example Message", preferredStyle: .alert)
        let update=UIAlertAction(title: "Update", style: .default) { (_) in
            let id=users.id
            let name=alertController.textFields![0].text
            let message=alertController.textFields![1].text
            
            self.updateUsers(id: id!, name: name!, message: message!)
        }
        
        let delete=UIAlertAction(title: "Delete", style: .default) { (_) in
            self.deleteUser(id:users.id)
        }
        alertController.addTextField { (textField) in
            textField.text=users.name
        }
        alertController.addTextField { (textField) in
            textField.text=users.message
        }
        
        alertController.addAction(update)
        alertController.addAction(delete)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func updateUsers(id:String,name:String,message:String){
        let userData=["id":id,"name":name,"message":message]
        
        myFireBase.child(id).setValue(userData)
        lblDisplay.text="User Update"
    }
    
    func deleteUser(id:String){
        myFireBase.child(id).setValue(nil)
    }

}

