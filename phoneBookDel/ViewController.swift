//
//  ViewController.swift
//  phoneBookDel
//
//  Created by 久米田晋太郎 on 2021/02/04.
//

import UIKit
import Contacts

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet var tableView: UITableView!
    
    var contactStore = CNContactStore()
    var contacts = [ContactStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    
        self.navigationItem.title = "電話帳削除アプリ"
        tableView.allowsMultipleSelectionDuringEditing = true
        navigationItem.rightBarButtonItem = editButtonItem
        
        contactStore.requestAccess(for: .contacts) { (success, error) in
            if success {
                print("Authorization Successfull")
            }
        }
        fetchContacts()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
            super.setEditing(editing, animated: animated)
            tableView.isEditing = editing

            print(editing)
        }
    
    
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let cell = tableView.dequeueReusableCell(withIdentifier: "phoneBookCell", for: indexPath as IndexPath)
        let contactToDisplay = contacts[indexPath.row]
        
        let labelName = cell.viewWithTag(1) as! UILabel
        labelName.text = contactToDisplay.givenName + " " + contactToDisplay.familyName
        
        let labelPhoneNumber = cell.viewWithTag(2) as! UILabel
        labelPhoneNumber.text = contactToDisplay.number
        
//        cell.textLabel?.text = contactToDisplay.givenName + " " + contactToDisplay.familyName
//        cell.detailTextLabel?.text = contactToDisplay.number
        return cell        
    }
    
    // 選択時のデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 選択した行番号が出力される
        print(indexPath.row)
        print(contacts[indexPath.row].contact)
        
        
       
        // 連絡先削除
        var arrayOfContactsRequests : [CNSaveRequest] = []
        let saveRequest = CNSaveRequest()
        let mutableContact = contacts[indexPath.row].contact.mutableCopy() as! CNMutableContact
        saveRequest.delete(mutableContact)
        arrayOfContactsRequests.append(saveRequest)
        
        do{
            try self.contactStore.execute(saveRequest)
        }
        catch let err {
            print("error:", err)
        }
        
//                do{
//                  try store.executeSaveRequest(req)
//                  print("Successfully deleted the user")
//
//                } catch let e{
//                  print("Error = \(e)")
//                }
        
        
        
    }
   
    // 選択解除時のデリゲートメソッド
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // 選択した解除した行番号が出力される
        print(indexPath.row)
    }
    
        
        func fetchContacts() {
            
            let key = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
            let request = CNContactFetchRequest(keysToFetch: key)
            try! contactStore.enumerateContacts(with: request) { (contact, stoppingPointer) in
                
                let name = contact.givenName
                let familyName = contact.familyName
                let number = contact.phoneNumbers.first?.value.stringValue
                print("contact",contact)
                if (number == nil){
                    let contactToAppend = ContactStruct(givenName: name, familyName: familyName, number: "番号未登録",contact: contact)
                    self.contacts.append(contactToAppend)
                    
                } else {
                    
                let contactToAppend = ContactStruct(givenName: name, familyName: familyName, number: number! ,contact: contact)
                    self.contacts.append(contactToAppend)
                }
            }
            tableView.reloadData()
        }
}

