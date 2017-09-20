//
//  ringtoneCell.swift
//  Contacts App
//
//  Created by anna on 20.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Eureka

let ringtones = ["Ringtone1", "Ringtone2", "Ringtone3", "Ringtone4", "Ringtone5"]

class RingtoneCell: Cell<String>, CellType, UIPickerViewDelegate {
    @IBOutlet weak var pickerTextField: UITextField!
    
    override func setup() {
        super.setup()
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerTextField?.inputView = pickerView
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ringtones.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ringtones[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = ringtones[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
