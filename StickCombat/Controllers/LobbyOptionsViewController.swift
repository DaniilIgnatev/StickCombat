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
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil{
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
}
