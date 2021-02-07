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
        
        contactStore.requestAccess(for: .contacts) { (success, error) in
            if success {
                print("Authorization Successfull")
            }
        }
        
        fetchContacts()
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
    
        
        func fetchContacts() {
            
            let key = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
            let request = CNContactFetchRequest(keysToFetch: key)
            try! contactStore.enumerateContacts(with: request) { (contact, stoppingPointer) in
                
                let name = contact.givenName
                let familyName = contact.familyName
                let number = contact.phoneNumbers.first?.value.stringValue
                
                if (number == nil){
                    let contactToAppend = ContactStruct(givenName: name, familyName: familyName, number: "番号未登録")
                    self.contacts.append(contactToAppend)
                    
                } else {
                    
                let contactToAppend = ContactStruct(givenName: name, familyName: familyName, number: number!)
                    self.contacts.append(contactToAppend)
                }
                 
        
            }
            tableView.reloadData()
        }


}

