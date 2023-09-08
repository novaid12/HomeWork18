//
//  MainVCViewController.swift
//  HomeWork18
//
//  Created by  NovA on 6.09.23.
//

import UIKit

protocol ColorBGUpdateProtocol {
    func onColorUpdate(color: ColorModel)
}

class MainVC: UIViewController {
    var colorModel: ColorModel?
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    @IBAction func changedBGAction(_ sender: UIButton) {
        let stor = UIStoryboard(name: "Main", bundle: nil)
        guard let changedVC = stor.instantiateViewController(withIdentifier: "ChangedVC") as? ChangedVC else { return }
        changedVC.colorModel = colorModel
        changedVC.delegate = self
        changedVC.complitonHandler = { [weak self] colorModel in
            self?.colorModel = colorModel
            self?.view.backgroundColor = UIColor(red: colorModel.red, green: colorModel.green, blue: colorModel.blue, alpha: colorModel.alpha)
        }
        present(changedVC, animated: true)
    }
}

extension MainVC: ColorBGUpdateProtocol {
    func onColorUpdate(color: ColorModel) {
        colorModel = color
        view.backgroundColor = UIColor(red: color.red, green: color.green, blue: color.blue, alpha: color.alpha)
    }
}
