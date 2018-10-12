//
//  ViewController.swift
//  ManagingData
//
//  Created by vit on 10/5/18.
//
// SOURCE ORIGINAL PROJECT -- https://github.com/sitepoint-editors/SQLiteApp



import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var contactsTabelView: UITableView!
    
    var contacts = [Contact]()
    var selectedContact: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        contacts = StephencelisDB.instance.getContacts()
    }
    
    @IBAction func addButtonClicked() {
        let name = nameTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        let address = addressTextField.text ?? ""
        
        if StephencelisDB.instance.addContact(cname: name, cphone: phone, caddress: address) != nil {
            let contact = Contact(id: 0, name: name, phone: phone, address: address)
            contacts.append(contact)
            let indexPath = IndexPath(row: contacts.count-1, section: 0)
            contactsTabelView.insertRows(at: [indexPath], with: .left)
        }
    }

    @IBAction func updateButtonClicked() {
        if selectedContact != nil {
                let id = contacts[selectedContact!].id!
                let contact = Contact(id: id, name: nameTextField.text ?? "", phone: phoneTextField.text ?? "", address: addressTextField.text ?? "")
                StephencelisDB.instance.updateContact(cid: id, newContact: contact)
                contacts.remove(at: selectedContact!)
                contacts.insert(contact, at: selectedContact!)
                contactsTabelView.reloadData()
        } else {
            print("No item selected")
        }
    }
    
    @IBAction func deleteButtonClicked() {
        if selectedContact != nil {
            StephencelisDB.instance.deleteContact(cid: contacts[selectedContact!].id!)
            contacts.remove(at: selectedContact!)
            let indexPath = IndexPath(row: selectedContact!, section: 0)
            contactsTabelView.deleteRows(at: [indexPath], with: .fade)
        } else {
            print("No item selected")
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nameTextField.text = contacts[indexPath.row].name
        phoneTextField.text = contacts[indexPath.row].phone
        addressTextField.text = contacts[indexPath.row].address
        
        selectedContact = indexPath.row
    }
    
    //MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        var label: UILabel
        label = cell.viewWithTag(1) as! UILabel // Name label
        label.text = contacts[indexPath.row].name
        label = cell.viewWithTag(2) as! UILabel // Phone label
        label.text = contacts[indexPath.row].phone
        return cell
    }
    

    
    
    
}

