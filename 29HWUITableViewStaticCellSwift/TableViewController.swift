//
//  TableViewController.swift
//  29HWUITableViewStaticCellSwift
//
//  Created by Сергей on 24.01.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {

    //MARK: Properties
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userStatusTextView: UITextView!
    
    @IBOutlet weak var infoDatePickerLabel: UILabel!
    @IBOutlet weak var infoSliderLabel: UILabel!
    @IBOutlet weak var dateOfBirtchLabel: UILabel!
    @IBOutlet weak var salaryInDollarsLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var userFloorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var userMaritalStatusSegmentedControl: UISegmentedControl!
    
    @IBOutlet var textFieldCollection: [UITextField]!
    @IBOutlet var labelCollection: [UILabel]!
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var salaryOfDollarsSlider: UISlider!
    
    @IBOutlet weak var randomPasswordSwitch: UISwitch!
    @IBOutlet weak var passwordHiddenSwitch: UISwitch!

    let securitySimbol = "🔒"
    
    var userDefaults = UserDefaults()
    let dateFormatter = DateFormatter()
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.userImage.image = UIImage(named: "inkognitoHW29")
        
        self.customizationUIElements()
        
        self.getData()
        
    }
    
    //MARK: Actions
    
    @IBAction func saveAndDeleteButtonAction(_ sender: UIButton) {
        
        if sender.tag == 0 {
            self.saveData()
        } else {
            self.deleteData()
        }
        
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        
        if sender.tag == 0 {
            self.userDefaults.set(sender.selectedSegmentIndex, forKey: UserDefaultsKey.floor.rawValue)
        } else {
            self.userDefaults.set(sender.selectedSegmentIndex, forKey: UserDefaultsKey.maritelStatus.rawValue)
        }
        
    }
    
    @IBAction func userDateOfBirchPicker(_ sender: UIDatePicker) {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let str = dateFormater.string(from: sender.date)
        self.dateOfBirtchLabel.animate(newText: str, characterDelay: 0.05)
        
        self.userDefaults.set(sender.date, forKey: UserDefaultsKey.dateOfBirtch.rawValue)
        
    }
    
    @IBAction func salaryInDollarsSliderAction(_ sender: UISlider) {
        
        let intSalary = Int(sender.value)
        self.salaryInDollarsLabel.text = String(format: "%@$", String(intSalary))
        
        self.userDefaults.set(sender.value, forKey: UserDefaultsKey.salaryInDollars.rawValue)
        
    }
    //1)if true then create random numbers and letters
    //2)mirror password labelPassword
    //3)if flase labelPassword = ""
    //4) when randomSwitch isOn ignoredUserEvent
    @IBAction func randomPasswordSwitch(_ sender: UISwitch) {
    
        if sender.isOn {
            
            self.randomPasswordSwitch.isUserInteractionEnabled = false
            self.passwordHiddenSwitch.isUserInteractionEnabled = false
            
            self.textFieldCollection[3].isUserInteractionEnabled = false
            
            var randomPassword = ""
            let maxLengthPass = 20
            var randomChar = ""
            let setChar: Set = ["A", "B", "C", "D","E", "F", "G", "H", "I",
                                "J", "K", "L", "M", "N", "O", "P", "Q", "R",
                                "S", "T", "U", "V", "W" , "X" , "Y", "Z","1",
                                "2", "3", "4", "5", "6", "7", "8", "9", "0",
                                "a", "b", "c", "d", "e", "f", "g", "h", "i",
                                "j", "k", "l", "m", "n", "o", "p", "q", "r",
                                "s", "t", "u", "v", "w", "x", "y", "z"]
                                    
                for _ in 0..<maxLengthPass {
                    randomChar = setChar.randomElement() ?? ""
                    randomPassword.append(randomChar)
                }
                
                self.textFieldCollection[3].text = randomPassword
            let text = self.passwordHiddenSwitch.isOn ? String(repeating: self.securitySimbol, count: randomPassword.count) : randomPassword
            
                self.labelCollection[3].animate(newText: text, characterDelay: 0.07)

                self.userDefaults.set(randomPassword, forKey: UserDefaultsKey.randomPassword.rawValue)
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.86) {
                    self.randomPasswordSwitch.isUserInteractionEnabled = true
                    self.passwordHiddenSwitch.isUserInteractionEnabled = true
                }
            
        } else {
            self.textFieldCollection[3].text = ""
            self.labelCollection[3].text = ""
            self.textFieldCollection[3].isUserInteractionEnabled = true
            
            self.userDefaults.set("", forKey: UserDefaultsKey.randomPassword.rawValue)
        }
        
        self.userDefaults.set(sender.isOn,
                              forKey: UserDefaultsKey.passwordSwitchState.rawValue)
    }
    
    
    @IBAction func passwordHiddenSwitchAction(_ sender: UISwitch) {
        
        let labelText = self.labelCollection[3].text ?? ""
        let countSimbols = labelText.count
        
        if sender.isOn {
            let str = String(repeating: self.securitySimbol, count: countSimbols)
            self.labelCollection[3].text = str
            self.userDefaults.set(str, forKey: UserDefaultsKey.password.rawValue)
        } else {
            self.labelCollection[3].text = self.textFieldCollection[3].text
        }
        
        self.userDefaults.set(sender.isOn,
                              forKey: UserDefaultsKey.passwordHidden.rawValue)
        
    }

    //MARK: UITextFieldDelegate
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        var result = false
        
        switch textField {
            case _ where textField.isEqual(self.textFieldCollection[0]):
            fallthrough
            case _ where textField.isEqual(self.textFieldCollection[1]):
            result = self.textEditingNameIn(textField,
                                            shouldChangeCharactersIn: range,
                                            replacementString: string)
            case _ where textField.isEqual(self.textFieldCollection[2]):
            result = self.editingLiginIn(textField,
                                         shouldChangeCharactersIn: range,
                                         replacementString: string)
            case _ where textField.isEqual(self.textFieldCollection[3]):
            result = self.textEditingPassword(textField,
                                              shouldChangeCharactersIn: range,
                                              replacementString: string)
            case _ where textField.isEqual(self.textFieldCollection[4]):
            result = self.textEditingAdressOfResidence(textField,
                                                       shouldChangeCharactersIn: range,
                                                       replacementString: string)
            case _ where textField.isEqual(self.textFieldCollection[5]):
            result = textEditingPhoneNumber(textField,
                                            shouldChangeCharactersIn: range,
                                            replacementString: string)
            case _ where textField.isEqual(self.textFieldCollection[6]):
            result = self.textEditingPostcode(textField,
                                              shouldChangeCharactersIn: range,
                                              replacementString: string)
            case _ where textField.isEqual(self.textFieldCollection[7]):
            result = self.textEditingEmail(in: textField,
                                           range: range,
                                           replacementString: string)
        default:
            break
        }
        
        return result
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let currentIndex = self.textFieldCollection.firstIndex(of:textField) ?? 0
        let nextIndex = currentIndex + 1
        
        if !textField.isEqual(self.textFieldCollection.last ?? UITextField()) {
            self.textFieldCollection[nextIndex].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    
    //MARK: UITextViewDelegate
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        var resultBool = false
        
        let maxLenghtStr = 200
        
        let str = ((textView.text ?? "") as NSString)
        let newString = str.replacingCharacters(in: range, with: text)
        
        if newString.count < maxLenghtStr {
            resultBool = true
        } else {
            resultBool = false
        }
        
        self.userDefaults.set(newString,
                              forKey: UserDefaultsKey.statusText.rawValue)
        
        return resultBool
    }
    
    
    //MARK: Editing Text In TextField
    
    func textEditingNameIn(_ textField: UITextField,
                           shouldChangeCharactersIn range: NSRange,
                           replacementString string: String) -> Bool {

        let additionChar = " "
        var resultBool = false
        let maxLenghtStr = 20

        
        var validSet = CharacterSet.letters.inverted
        validSet.remove(charactersIn: additionChar)
        let components = string.components(separatedBy: validSet)
        
        guard components.count < 2 else { return false }
        
        let text = ((textField.text ?? "") as NSString)
        let newString = text.replacingCharacters(in: range, with: string)
        
        if newString.count < maxLenghtStr {
            resultBool = true
        } else {
            resultBool = false
        }
        
        if textField.isEqual(self.textFieldCollection[0]) {
            self.userDefaults.set(newString, forKey: UserDefaultsKey.name.rawValue)
            self.labelCollection[0].text = newString
        } else {
            self.userDefaults.set(newString, forKey: UserDefaultsKey.surname.rawValue)
            self.labelCollection[1].text = newString
        }
        
        return resultBool
    }

    private func editingLiginIn(_ textField: UITextField,
                                shouldChangeCharactersIn range: NSRange,
                                replacementString string: String) -> Bool {
        var resultBool = false
        let maxLenght = 20
        
        let text = (textField.text ?? "") as NSString
        let newStr = text.replacingCharacters(in: range, with: string)
        
        let validSet: CharacterSet = [" ", "@"]
        let validArray = string.components(separatedBy: validSet)
        
        if validArray.count < 2 && newStr.count <= maxLenght {
            resultBool = true
            self.labelCollection[2].text = newStr
            self.userDefaults.set(newStr, forKey: UserDefaultsKey.login.rawValue)
        } else {
            resultBool = false
        }

        return resultBool
    }
  
    private func textEditingPassword(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 20
        
        let text = (textField.text ?? "") as NSString
        let newString = text.replacingCharacters(in: range, with: string)
        let validSet = CharacterSet.letters.union(CharacterSet.decimalDigits).inverted
        let components = string.components(separatedBy: validSet)

        if components.count < 2 && newString.count <= maxLength &&
        !self.randomPasswordSwitch.isOn  {
            
            self.labelCollection[3].text = self.passwordHiddenSwitch.isOn ? String(repeating: self.securitySimbol,
                                                                                   count: newString.count) : newString
            self.textFieldCollection[3].text = newString
            self.userDefaults.set(newString, forKey: UserDefaultsKey.password.rawValue)
            
        }

        return false
    }

    private func textEditingAdressOfResidence(_ textField: UITextField,
                                              shouldChangeCharactersIn range: NSRange,
                                              replacementString string: String) -> Bool {
        
        let maxCount = 40
        
        let text = (textField.text ?? "") as NSString
        let newStr = text.replacingCharacters(in: range, with: string)
        
        var validSet = CharacterSet.decimalDigits.union(CharacterSet.letters).inverted
        validSet.remove(charactersIn: " ,.")
        let components = string.components(separatedBy: validSet)
        
        if components.count < 2 && newStr.count <= maxCount {
            textField.text = newStr
            self.userDefaults.set(textField.text, forKey: UserDefaultsKey.addresOfResidence.rawValue)
        }
        
        return false
    }
    
    private func textEditingPhoneNumber(_ textField: UITextField,
                                        shouldChangeCharactersIn range: NSRange,
                                        replacementString string: String) -> Bool {
        var resultString = ""
        let text = (textField.text ?? "") as NSString
        var newString = NSMutableString(string: text.replacingCharacters(in: range, with: string))
        
        let validSet = CharacterSet.decimalDigits.inverted
        let components = string.components(separatedBy: validSet)
        
        let locationNumberLengthMax = 7
        let areaNumberLengthMax = 3
        let countryNumberLengthMax = 3
       
        guard components.count < 2 else {
            return false
        }
        
        let validationComponents = newString.components(separatedBy: validSet)
        newString = NSMutableString(string: validationComponents.joined())
        
        guard newString.length <= locationNumberLengthMax + areaNumberLengthMax + countryNumberLengthMax else {
            return false
        }
      
        let localNumberLength = min(locationNumberLengthMax, newString.length)
        
        if newString.length > 0 {
           
            var number = newString.substring(from: newString.length - localNumberLength)
         
            if number.count > 3 {
                let index = number.index(number.startIndex, offsetBy: 3)
                number.insert("-", at: index)
            }
            
            if number.count > 6 {
                let index = number.index(number.startIndex, offsetBy: 6)
                number.insert("-", at: index)
            }
           
            resultString.append(String(number))
          
        }
        
        if newString.length > locationNumberLengthMax {

            let areaNumberLenght = min(newString.length - locationNumberLengthMax, areaNumberLengthMax)
            
            var area = newString.substring(with: NSRange(location: newString.length - locationNumberLengthMax - areaNumberLenght,
                                                         length: areaNumberLenght))

            area = String(format: " (%@) ", area)

            resultString.insert(contentsOf: area, at: resultString.startIndex)

        }
        
        if newString.length > locationNumberLengthMax + areaNumberLengthMax {
            
            let countryCodeLigth = min(newString.length - locationNumberLengthMax - areaNumberLengthMax, countryNumberLengthMax)
    
            var countryCode = newString.substring(with: NSRange(location: 0, length: countryCodeLigth))
            countryCode = String(format: "+%@", countryCode)
            
            resultString.insert(contentsOf: countryCode, at: resultString.startIndex)
            
        }
        
        textField.text = resultString

        self.userDefaults.set(resultString, forKey: UserDefaultsKey.phoneNumber.rawValue)
        
        return false
    }
    //max count char = 6
    //only number
    //without space
    private func textEditingPostcode(_ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String) -> Bool {
        
        let maxCount = 6
        
        let text = (textField.text ?? "") as NSString
        let newString =  text.replacingCharacters(in: range, with: string)
        
        guard newString.count <= maxCount else {
            return false
        }
        
        let validSet = CharacterSet.decimalDigits.inverted
        let components = string.components(separatedBy: validSet)
        
        if components.count < 2 {
            textField.text = newString
            self.userDefaults.set(newString, forKey: UserDefaultsKey.postcode.rawValue)
        }
        
        return false
    }
    
    private func textEditingEmail(in textField: UITextField, range: NSRange, replacementString str: String) -> Bool {
    
    let text = NSString(string: textField.text ?? "")
    let newString = text.replacingCharacters(in: range, with: str)
        
    let maxLengthSimbol = 20
    
    let allowSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ@1234567890._-").inverted

    let validComponents = str.components(separatedBy: allowSet)
    
    if validComponents.count > 1 || newString.count >= maxLengthSimbol {
        return false
    }
    
    if text.contains("@") && str == "@" {
            return false
        }
    
    textField.text = newString
    self.userDefaults.set(newString, forKey: UserDefaultsKey.email.rawValue)
    
    return false
    }
    
    //MARK: UserDefaults
    
    private func saveData() {
        
        self.userDefaults.set(self.userStatusTextView.text,
                              forKey: UserDefaultsKey.statusText.rawValue)
        self.userDefaults.set(self.textFieldCollection[0].text ?? "",
                              forKey: UserDefaultsKey.name.rawValue)
        self.userDefaults.set(self.userFloorSegmentedControl.selectedSegmentIndex,
                              forKey: UserDefaultsKey.floor.rawValue)
        self.userDefaults.set(self.userMaritalStatusSegmentedControl.selectedSegmentIndex,
                              forKey: UserDefaultsKey.maritelStatus.rawValue)
        self.userDefaults.set(self.datePicker.date,
                              forKey: UserDefaultsKey.dateOfBirtch.rawValue)
        self.userDefaults.set(self.salaryOfDollarsSlider.value,
                              forKey: UserDefaultsKey.salaryInDollars.rawValue)
        self.userDefaults.set(self.textFieldCollection[2].text,
                              forKey: UserDefaultsKey.login.rawValue)
        self.userDefaults.set(self.randomPasswordSwitch.isOn,
                              forKey: UserDefaultsKey.passwordSwitchState.rawValue)
        self.userDefaults.set(self.labelCollection[3].text,
                              forKey: UserDefaultsKey.randomPassword.rawValue)
        self.userDefaults.set(self.textFieldCollection[3].text,
                              forKey: UserDefaultsKey.password.rawValue)
        self.userDefaults.set(self.passwordHiddenSwitch.isOn,
                              forKey: UserDefaultsKey.passwordHidden.rawValue)
        self.userDefaults.set(self.textFieldCollection[4].text,
                              forKey: UserDefaultsKey.addresOfResidence.rawValue)
        self.userDefaults.set(self.textFieldCollection[5].text,
                              forKey: UserDefaultsKey.phoneNumber.rawValue)
        self.userDefaults.set(self.textFieldCollection[6].text,
                              forKey: UserDefaultsKey.postcode.rawValue)
        self.userDefaults.set(self.textFieldCollection[7].text,
                              forKey: UserDefaultsKey.email.rawValue)
        
    }
    
    private func getData() {
       
        self.userStatusTextView.text = self.userDefaults.object(forKey:
                                            UserDefaultsKey.statusText.rawValue) as? String
        self.textFieldCollection[0].text = self.userDefaults.object(forKey:
                                                UserDefaultsKey.name.rawValue) as? String
        self.labelCollection[0].text = self.textFieldCollection[0].text
        self.textFieldCollection[1].text = self.userDefaults.object(forKey:
                                                UserDefaultsKey.surname.rawValue) as? String
        self.labelCollection[1].text = self.textFieldCollection[1].text
        self.userFloorSegmentedControl.selectedSegmentIndex = self.userDefaults.integer(forKey:
                                                                   UserDefaultsKey.floor.rawValue)
        self.userMaritalStatusSegmentedControl.selectedSegmentIndex = self.userDefaults.integer(forKey:
                                                                           UserDefaultsKey.maritelStatus.rawValue)
        self.datePicker.date = self.userDefaults.object(forKey:
                                    UserDefaultsKey.dateOfBirtch.rawValue) as? Date ?? Date()
        self.dateFormatter.dateFormat = "MM/dd/yyyy"
        self.dateOfBirtchLabel.text = self.dateFormatter.string(from: self.datePicker.date)
        self.salaryOfDollarsSlider.value = self.userDefaults.float(forKey:
                                               UserDefaultsKey.salaryInDollars.rawValue)
        self.textFieldCollection[2].text = self.userDefaults.object(forKey:
                                                UserDefaultsKey.login.rawValue) as? String
        self.labelCollection[2].text = self.textFieldCollection[2].text
        self.randomPasswordSwitch.isOn = self.userDefaults.bool(forKey:
                                              UserDefaultsKey.passwordSwitchState.rawValue)
        let userPassword = self.userDefaults.object(forKey:
                                UserDefaultsKey.password.rawValue) as? String
        let randomPassword = self.userDefaults.object(forKey:
                                  UserDefaultsKey.randomPassword.rawValue) as? String
        //here set password in dependent from position switches
        self.textFieldCollection[3].text = self.randomPasswordSwitch.isOn ? randomPassword : userPassword
        self.labelCollection[3].text = self.randomPasswordSwitch.isOn ? randomPassword : userPassword
        self.passwordHiddenSwitch.isOn = self.userDefaults.bool(forKey:
                                              UserDefaultsKey.passwordHidden.rawValue)
        let text = self.textFieldCollection[3].text ?? ""
        self.labelCollection[3].text = self.passwordHiddenSwitch.isOn ? String(repeating: self.securitySimbol,
                                                                               count: text.count) : text
        self.textFieldCollection[4].text = self.userDefaults.object(forKey:
                                                UserDefaultsKey.addresOfResidence.rawValue) as? String
        self.textFieldCollection[5].text = self.userDefaults.object(forKey:
                                                UserDefaultsKey.phoneNumber.rawValue) as? String
        self.textFieldCollection[6].text = self.userDefaults.object(forKey:
                                                UserDefaultsKey.postcode.rawValue) as? String
        self.textFieldCollection[7].text = self.userDefaults.object(forKey:
                                                UserDefaultsKey.email.rawValue) as? String
        
    }
    
    private func deleteData() {

        let dictionary = self.userDefaults.dictionaryRepresentation()
        
        self.userStatusTextView.text = ""
        self.dateOfBirtchLabel.text = ""
        self.salaryInDollarsLabel.text = ""
        self.randomPasswordSwitch.isOn = false
        self.userFloorSegmentedControl.selectedSegmentIndex = 0
        self.userMaritalStatusSegmentedControl.selectedSegmentIndex = 0
        self.datePicker.date = Date()
        
        for index in 0..<self.textFieldCollection.count {
            self.textFieldCollection[index].text = ""
            self.labelCollection[index].text = ""
        }
        
        dictionary.keys.forEach { (key) in
            self.userDefaults.removeObject(forKey: key)
        }
        
    }

    //MARK: Help Functions
    
    private func customizationUIElements() {
        let cornerRadius: CGFloat = 10
        
        
        
        for i in 0..<self.textFieldCollection.count {
            
            self.textFieldCollection[i].layer.cornerRadius = cornerRadius
            
            if i < 4 {
                self.buttons[i].layer.cornerRadius = cornerRadius
            }
            
        }
        
        self.datePicker.backgroundColor = .orange
        self.datePicker.layer.masksToBounds = true
        self.datePicker.layer.cornerRadius = cornerRadius
        self.datePicker.maximumDate = Date()
        
        self.salaryInDollarsLabel.text = String(format: "%@$", String(Int(self.salaryOfDollarsSlider.value)))
    }

}
