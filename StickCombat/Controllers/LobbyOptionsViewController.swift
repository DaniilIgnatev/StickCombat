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
    @IBAction func createLobbyButton(_ sender: Any) {
        if passwordTextBox.text != "", nameTextBox.text != ""{
            let menuStoryboard = UIStoryboard(name: "Menu", bundle: Bundle.main)
            guard let destinationViewController = menuStoryboard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else{
                return
            }
            destinationViewController.Mode = GameMode.pvpNet(playerID: playerID!, adress: URL(string: "ws://\(ip):\(password)")!, lobbyName: nameTextBox.text!, lobbyPassword: passwordTextBox.text!)
            
            destinationViewController.modalTransitionStyle = .crossDissolve
            present(destinationViewController, animated: true, completion: nil)
        }else{
            passwordTextBox.text = nil
            nameTextBox.text = nil
            passwordTextBox.attributedPlaceholder = NSAttributedString(string:"Please enter the password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            nameTextBox.attributedPlaceholder = NSAttributedString(string:"Please enter the name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}