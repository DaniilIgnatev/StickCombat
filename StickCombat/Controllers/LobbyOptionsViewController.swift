//
//  LobbyOptionsViewController.swift
//  StickCombat
//
//  Created by Даниил on 20/05/2019.
//  Copyright © 2019 CoderUl. All rights reserved.
//

import Foundation
import UIKit

class LobbyOptionsViewController: UIViewController{
    
    var ip: String = ""
    var password: String = ""
    var playerID: FighterID? = nil
    
    @IBOutlet weak var passwordTextBox: UITextField!
    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var nicknameTextBox: UITextField!
    @IBOutlet weak var textBoxesView: UIView!
    
    @IBAction func createLobbyButton(_ sender: Any) {
        if passwordTextBox.text != "", nameTextBox.text != ""{
            let menuStoryboard = UIStoryboard(name: "Menu", bundle: Bundle.main)
            guard let destinationViewController = menuStoryboard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else{
                return
            }
            
            guard let adress = URL(string: "ws://\(ip):\(password)")else {
                let menuViewController = menuStoryboard.instantiateViewController(withIdentifier: "MenuViewController")
                
                present(menuViewController, animated: true, completion: nil)
                return
            }
            
            destinationViewController.modalTransitionStyle = .crossDissolve
            present(destinationViewController, animated: true, completion: {
                destinationViewController.Mode = GameMode.pvpNet(playerID: self.playerID!, nickname: self.nicknameTextBox.text!, adress: adress, lobbyName: self.nameTextBox.text!, lobbyPassword: self.passwordTextBox.text!)
            })
        }else{
            passwordTextBox.text = nil
            nameTextBox.text = nil
            passwordTextBox.attributedPlaceholder = NSAttributedString(string:"Заполните", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            nameTextBox.attributedPlaceholder = NSAttributedString(string:"Заполните", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            nicknameTextBox.attributedPlaceholder = NSAttributedString(string:"Заполните", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                if passwordTextBox.isEditing{
                    let shiftTFV = view.frame.height - textBoxesView.frame.origin.y - textBoxesView.frame.height
                    let shiftTF = textBoxesView.frame.height - passwordTextBox.frame.origin.y - passwordTextBox.frame.height
                    let shift = shiftTF + shiftTFV
                    if(keyboardSize.height - shift) > 0{
                        self.view.frame.origin.y -= keyboardSize.height - shift
                    }
                }else if nameTextBox.isEditing{
                    let shiftTFV = view.frame.height - textBoxesView.frame.origin.y - textBoxesView.frame.height
                    let shiftTF = textBoxesView.frame.height - nameTextBox.frame.origin.y - nameTextBox.frame.height
                    let shift = shiftTF + shiftTFV
                    if(keyboardSize.height - shift) > 0{
                        self.view.frame.origin.y -= keyboardSize.height - shift
                    }
                }else if nicknameTextBox.isEditing{
                    let shiftTFV = view.frame.height - textBoxesView.frame.origin.y - textBoxesView.frame.height
                    let shiftTF = textBoxesView.frame.height - nicknameTextBox.frame.origin.y - nicknameTextBox.frame.height
                    let shift = shiftTF + shiftTFV
                    if(keyboardSize.height - shift) > 0{
                        self.view.frame.origin.y -= keyboardSize.height - shift
                    }
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil{
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
}
