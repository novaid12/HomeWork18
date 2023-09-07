//
//  ChangedVC.swift
//  HomeWork18
//
//  Created by  NovA on 6.09.23.
//

import UIKit

class ChangedVC: UIViewController {
    @IBOutlet var redColorSlider: UISlider!
    @IBOutlet var redColorTF: UITextField!

    @IBOutlet var greenColorSlider: UISlider!
    @IBOutlet var greenColorTF: UITextField!

    @IBOutlet var blueColorSlider: UISlider!
    @IBOutlet var blueColorTF: UITextField!

    @IBOutlet var hexColorTF: UITextField!

    @IBOutlet var opacitySlider: UISlider!
    @IBOutlet var opacityTF: UITextField!

    @IBOutlet var color: UIView!

    @IBOutlet weak var centerContraints: NSLayoutConstraint!
    
    
    
    var colorModel: ColorModel?
    var delegate: ColorBGUpdateProtocol?
    var complitonHandler: ((ColorModel) -> ())?

    override func viewDidLoad() {
        SetupUI()
    }

    func SetupUI() {
        hideKeyboardWhenTappedAround()
        startKeyboardObserver()
        redColorSlider.value = 1
        greenColorSlider.value = 1
        blueColorSlider.value = 1
        opacitySlider.value = 1
        redColorTF.text = Int(redColorSlider.value * 255).description
        greenColorTF.text = Int(greenColorSlider.value * 255).description
        blueColorTF.text = Int(blueColorSlider.value * 255).description
        opacityTF.text = Int(opacitySlider.value * 100).description
        hexColorTF.text = String(format: "%02X%02X%02X",
                                 Int(redColorSlider.value * 255),
                                 Int(greenColorSlider.value * 255),
                                 Int(blueColorSlider.value * 255))
    }
    
    private func startKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        centerContraints.constant -= keyboardSize.height / 4
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        centerContraints.constant = 0
    }

    override func viewWillAppear(_ animated: Bool) {
        guard let cM = colorModel else { return }
        redColorTF.text = Int(cM.red * 255).description
        redColorSlider.value = Float(cM.red)
        greenColorTF.text = Int(cM.green * 255).description
        greenColorSlider.value = Float(cM.green)
        blueColorTF.text = Int(cM.blue * 255).description
        blueColorSlider.value = Float(cM.blue)
        opacityTF.text = Int(cM.alpha * 100).description
        opacitySlider.value = Float(cM.alpha)
        hexColorTF.text = String(format: "%02X%02X%02X%02X", Int(cM.red * 255), Int(cM.green * 255),
                                 Int(cM.blue * 255), Int(cM.alpha * 255))
        color.backgroundColor = UIColor(red: cM.red, green: cM.green, blue: cM.blue, alpha: cM.alpha)
        view.backgroundColor = UIColor(red: cM.red, green: cM.green, blue: cM.blue, alpha: cM.alpha)
        print(cM)
    }

    private func updateColorSlider() {
        let cM = ColorModel(red: CGFloat(redColorSlider.value), green: CGFloat(greenColorSlider.value), blue: CGFloat(blueColorSlider.value), alpha: CGFloat(opacitySlider.value))
        redColorTF.text = Int(cM.red * 255).description
        greenColorTF.text = Int(cM.green * 255).description
        blueColorTF.text = Int(cM.blue * 255).description
        opacityTF.text = Int(cM.alpha * 100).description
        let hex = String(format: "%02X%02X%02X%02X", Int(cM.red * 255), Int(cM.green * 255),
                         Int(cM.blue * 255), Int(cM.alpha * 255))
        hexColorTF.text = hex.description
        color.backgroundColor = UIColor(red: cM.red, green: cM.green, blue: cM.blue, alpha: cM.alpha)
    }

    private func updateColorTF(value: String) -> Int? {
        if let number = Int(value),
           number <= 255,
           number >= 0,
           let red = redColorTF.text,
           let green = greenColorTF.text,
           let blue = blueColorTF.text,
           let alpha = opacityTF.text
        {
            guard let redColor = Float(red),
                  let greenColor = Float(green),
                  let blueColor = Float(blue),
                  let opacity = Float(alpha) else { return nil }
            let cM = ColorModel(red: CGFloat(redColor / 255.0),
                                green: CGFloat(greenColor / 255.0),
                                blue: CGFloat(blueColor / 255.0),
                                alpha: CGFloat(opacity / 100.0))
            hexColorTF.text = String(format: "%02X%02X%02X%02X", Int(cM.red * 255), Int(cM.green * 255),
                                     Int(cM.blue * 255), Int(cM.alpha * 255))
            redColorSlider.value = Float(cM.red)
            greenColorSlider.value = Float(cM.green)
            blueColorSlider.value = Float(cM.blue)
            opacitySlider.value = Float(cM.alpha)
            color.backgroundColor = UIColor(red: cM.red, green: cM.green, blue: cM.blue, alpha: cM.alpha)
            let val: Int? = number
            return val
        } else {
            return 255
        }
    }

    @IBAction func redColorAction(_ sender: UISlider) {
        updateColorSlider()
    }

    @IBAction func redColorTFAction(_ sender: UITextField) {
        guard let text = sender.text else { return }
        sender.text = updateColorTF(value: text)?.description
        if let number = updateColorTF(value: text), number <= 255 {
            redColorSlider.value = Float(number) / 255.0
        } else { redColorSlider.value = 1 }
    }

    @IBAction func greenColorAction(_ sender: UISlider) {
        updateColorSlider()
    }

    @IBAction func greenColorTFAction(_ sender: UITextField) {
        guard let text = sender.text else { return }
        sender.text = updateColorTF(value: text)?.description
        if let number = updateColorTF(value: text), number <= 255 {
            greenColorSlider.value = Float(number) / 255.0
        } else { greenColorSlider.value = 1 }
    }

    @IBAction func blueColorAction(_ sender: UISlider) {
        updateColorSlider()
    }

    @IBAction func blueColorTFAction(_ sender: UITextField) {
        guard let text = sender.text else { return }
        sender.text = updateColorTF(value: text)?.description
        if let number = updateColorTF(value: text), number <= 255 {
            blueColorSlider.value = Float(number) / 255.0
        } else { blueColorSlider.value = 1 }
    }

    @IBAction func opacityAction(_ sender: UISlider) {
        updateColorSlider()
    }

    @IBAction func opacityTFAction(_ sender: UITextField) {
        guard let text = sender.text else { return }
        sender.text = updateColorTF(value: text)?.description
        if let number = updateColorTF(value: text), number <= 100 {
            opacitySlider.value = Float(number) / 100.0
        } else { opacitySlider.value = 1 }
    }

    @IBAction func hexColorAction(_ sender: UITextField) {
        guard let text = sender.text else { return }
        guard let color = UIColor(hex: text),
              let red = color.cgColor.components?[0],
              let green = color.cgColor.components?[1],
              let blue = color.cgColor.components?[2],
              let alpha = color.cgColor.components?[3] else { return }
        redColorSlider.value = Float(red)
        greenColorSlider.value = Float(green)
        blueColorSlider.value = Float(blue)
        opacitySlider.value = Float(alpha)
        redColorTF.text = Int(red * 255).description
        greenColorTF.text = Int(green * 255).description
        blueColorTF.text = Int(blue * 255).description
        opacityTF.text = Int(alpha * 100).description
    }

    @IBAction func saveWithDelegates(_ sender: UIButton) {
        delegate?.onColorUpdate(color: ColorModel(red: CGFloat(redColorSlider.value), green: CGFloat(greenColorSlider.value), blue: CGFloat(blueColorSlider.value), alpha: CGFloat(opacitySlider.value)))
        navigationController?.popViewController(animated: true)
    }

    @IBAction func saveWithClouser(_ sender: UIButton) {
        guard let complitonHandler = complitonHandler else { return }
        complitonHandler(ColorModel(red: CGFloat(redColorSlider.value), green: CGFloat(greenColorSlider.value), blue: CGFloat(blueColorSlider.value), alpha: CGFloat(opacitySlider.value)))
        navigationController?.popViewController(animated: true)
    }
}
