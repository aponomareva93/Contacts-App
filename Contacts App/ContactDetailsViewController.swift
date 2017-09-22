//
//  ContactDetaulsViewController.swift
//  Contacts App
//
//  Created by anna on 18.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Eureka
import ImageRow

protocol ContactDetailsViewControllerDelegate: class {
    func contactDetailsViewControllerDidTapClose(_ contactDetailsViewController: ContactDetailsViewController?)
}

class ContactDetailsViewController: FormViewController {
    
    lazy var cancelBarButtonItem: UIBarButtonItem = {
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        return cancelBarButtonItem
    }()
    
    lazy var saveBarButtonItem: UIBarButtonItem = {
        let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        return saveBarButtonItem
    }()
    
    lazy var inputToolbar: UIToolbar = {
        var toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        var doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneKeyPressed(key:)))
        var flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        var fixedSpaceButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        
        var nextButton = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(previousKeyPressed(key:)))
        nextButton.width = 50.0
        var previousButton = UIBarButtonItem(title: ">", style: .plain, target: self, action: #selector(nextKeyPressed(key:)))
        
        toolbar.setItems([fixedSpaceButton, nextButton, fixedSpaceButton, previousButton, flexibleSpaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }()
    
    func doneKeyPressed(key: UIBarButtonItem) {
        for row in form.rows {
            if let cell = row.baseCell as? _FieldCell<String>,
            cell.textField.isFirstResponder {
                cell.textField.resignFirstResponder()
            }
        }
    }
    
    func previousKeyPressed(key: UIBarButtonItem) {
        var previousRow: BaseRow?
        for row in form.rows {
            if let cell = row.baseCell as? _FieldCell<String>,
                cell.textField.isFirstResponder,
                let previousRow = previousRow,
                let previousCell = previousRow.baseCell as? _FieldCell<String>{
                previousCell.textField.becomeFirstResponder()
            }
            previousRow = row
        }
    }
    
    func nextKeyPressed(key: UIBarButtonItem) {
        var rowIsActive = false
        for row in form.rows {
            if let cell = row.baseCell as? _FieldCell<String>,
                cell.textField.isFirstResponder {
                rowIsActive = true
            }
            if rowIsActive,
                let nextCell = row.baseCell as? _FieldCell<String> {
                nextCell.textField.becomeFirstResponder()
            }
        }
    }
    
    var activeTetxField = UITextField()

    weak var delegate: ContactDetailsViewControllerDelegate?
    
    fileprivate var viewModel: ContactDetailsViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.rowHeight = Constants.contactDetailsTableRowHeight
    }
    
    init(viewModel: ContactDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = viewModel.viewTitle
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = saveBarButtonItem
        
        form +++ Section(Constants.contactDetailsTableTitle)
            
            <<< ImageRow() { row in
                row.tag = Constants.cellTags.imageRowTag
                row.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                row.clearAction = .yes(style: .destructive)
                row.value = viewModel.contactImage                
                row.onChange { [weak self] row in
                    if row.value == nil {
                        row.value = self?.viewModel.placeholderImage
                        self?.viewModel.contactHasImage = false
                    } else {
                        self?.viewModel.contactHasImage = true
                    }
                }
                }.cellUpdate { cell, row in
                    cell.accessoryView?.layer.cornerRadius = 17
                    cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
                    
            }
            <<< TextRow(){ row in
                row.title = Constants.nameRowTitle
                row.tag = Constants.cellTags.nameRowTag
                row.value = viewModel.contactName
                row.keyboardReturnType?.defaultKeyboardType = UIReturnKeyType.next
            }
            <<< TextRow(){ row in
                row.title = Constants.surnameRowTitle
                row.tag = Constants.cellTags.surnameRowTag
                row.value = viewModel.contactSurname
                row.keyboardReturnType?.defaultKeyboardType = UIReturnKeyType.next
            }
            <<< PhoneRow(){ row in
                row.title = Constants.phoneRowTitle
                row.tag = Constants.cellTags.phoneRowTag
                row.value = viewModel.contactPhone
                row.keyboardReturnType?.defaultKeyboardType = UIReturnKeyType.next
                }.cellUpdate { [weak self] cell, row in
                   //cell.textField.delegate = self
                    cell.textField.inputAccessoryView = self?.inputToolbar
            }
            <<< TextRow() {
                row in
                row.title = Constants.ringtoneRowTitle
                row.tag = Constants.cellTags.ringtoneRowTag
                row.value = viewModel.contactRingtone
                }.cellUpdate { cell, row in
                    let pickerView = UIPickerView()
                    pickerView.delegate = self
                    cell.textField.inputView = pickerView
            }
            <<< TextAreaRow(){ row in
                row.tag = Constants.cellTags.noteRowTag
                row.value = viewModel.contactNote
                row.placeholder = Constants.noteRowTitle
                }.cellUpdate{ cell, row in
                    cell.textView.returnKeyType = UIReturnKeyType.done
                    //cell.textView.delegate = self
        }
        if viewModel.isNewContact {
            form +++ ButtonRow() { button in
                button.title = Constants.seleteButtonTitle
                button.tag = Constants.cellTags.deleteButtonTag
                button.onCellSelection(deleteButtonTapped)
                }
                .cellUpdate { cell, row in
                    cell.textLabel?.textColor = .red
                }
        }
    }
    
    override func inputAccessoryView(for row: BaseRow) -> UIView? {
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cancelButtonTapped(sender: UIBarButtonItem) {
        delegate?.contactDetailsViewControllerDidTapClose(self)
    }
    
    func saveButtonTapped(sender: UIBarButtonItem) {
        do {
            try viewModel.saveContact(name: form.rowBy(tag: Constants.cellTags.nameRowTag)?.value,
                                      surname: form.rowBy(tag: Constants.cellTags.surnameRowTag)?.value,
                                      phone: form.rowBy(tag: Constants.cellTags.phoneRowTag)?.value,
                                      ringtone: form.rowBy(tag: Constants.cellTags.ringtoneRowTag)?.value,
                                      note: form.rowBy(tag: Constants.cellTags.noteRowTag)?.value,
                                      image: form.rowBy(tag: Constants.cellTags.imageRowTag)?.value)
            showAlert(withTitle: "Success", message: "Contact saved", okButtonTapped: { [weak self] in
                self?.delegate?.contactDetailsViewControllerDidTapClose(self)
            })
        } catch {
            showAlert(withTitle: "Error", message: error.localizedDescription)
        }
    }
    
    func deleteButtonTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        let alert = UIAlertController(title: "Delete contact", message: "Do you really want to delete this contact?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            self?.viewModel.deleteContact()
            self?.delegate?.contactDetailsViewControllerDidTapClose(self)
        }
        alert.addAction(yesAction)
        let noAction = UIAlertAction(title: "No", style: .default)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
}

extension ContactDetailsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTetxField = textField
    }
}

extension ContactDetailsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.ringtones.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.ringtones[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        (form.rowBy(tag: Constants.cellTags.ringtoneRowTag) as! TextRow).value = Constants.ringtones[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

/*extension ContactDetailsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //(form.rowBy(tag: Constants.cellTags.noteRowTag) as! TextAreaRow).value = textView.text
        if(text == "\n") {
            print(textView.text)
            //(form.rowBy(tag: Constants.cellTags.noteRowTag) as! TextAreaRow).value = textView.text
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}*/

extension UIViewController {
    func showAlert(withTitle title: String, message: String, okButtonTapped: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            okButtonTapped?()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension Constants {
    static let contactDetailsTableRowHeight: CGFloat = 45.0
    
    static let contactDetailsTableTitle = "Contact Details"
    static let cellTags = (
        imageRowTag: "ImageRow",
        nameRowTag: "NameRow",
        surnameRowTag: "SurnameRow",
        phoneRowTag: "PhoneRow",
        ringtoneRowTag: "RingtoneRow",
        noteRowTag: "NoteRow",
        deleteButtonTag: "DeleteButton"
    )
    
    static let nameRowTitle = "Name"
    static let surnameRowTitle = "Surname"
    static let phoneRowTitle = "Phone Number"
    static let ringtoneRowTitle = "Ringtone"
    static let seleteButtonTitle = "Delete Contact"
    static let noteRowTitle = "Note"
    
    static let ringtones = [
        "Ringtone 1",
        "Ringtone 2",
        "Ringtone 3",
        "Ringtone 4",
        "Ringtone 5"
    ]
}
