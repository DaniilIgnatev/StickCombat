//
//  GameModeViewController.swift
//  StickCombat
//
//  Created by Даниил on 20/05/2019.
//  Copyright © 2019 CoderUl. All rights reserved.
//

import Foundation
import UIKit

class GameModeViewController: UIViewController{
    
    @IBOutlet weak var ipTextBox: UITextField!
    @IBOutlet weak var portTextBox: UITextField!
    @IBOutlet weak var textBoxesView: UIView!
    
    @IBAction func createLobbyButton(_ sender: Any) {
        transitionBetweenViews(playerID: FighterID.first)
    }
    @IBAction func joinButton(_ sender: Any) {
        transitionBetweenViews(playerID: FighterID.second)
    }
    
    //MARK: Функция перехода на вью в зависимости от нажатой кнопки
    func transitionBetweenViews(playerID: FighterID){
        if ipTextBox.text != "", portTextBox.text != ""{
            let menuStoryboard = UIStoryboard(name: "Menu", bundle: Bundle.main)
            guard let destinationViewController = menuStoryboard.instantiateViewController(withIdentifier: "LobbyOptionsViewController") as? LobbyOptionsViewController else{
                return
            }
            //destinationViewController.Mode = GameMode.pvpNet(playerID: playerID, adress: URL(string: "ws://\(ipTextBox.text!):\(portTextBox.text!)")!, lobbyName: "test", lobbyPassword: "228")
            
            destinationViewController.ip = ipTextBox.text ?? ""
            destinationViewController.password = portTextBox.text ?? ""
            destinationViewController.playerID = playerID
            destinationViewController.modalTransitionStyle = .crossDissolve
            present(destinationViewController, animated: true, completion: nil)
        }else{
            ipTextBox.text = nil
            portTextBox.text = nil
            portTextBox.attributedPlaceholder = NSAttributedString(string:"Заполните", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            ipTextBox.attributedPlaceholder = NSAttributedString(string:"Заполните", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                if ipTextBox.isEditing{
                    self.view.frame.origin.y -= abs(keyboardSize.height - ipTextBox.frame.origin.y - textBoxesView.frame.origin.y)
                }else if portTextBox.isEditing{
                    self.view.frame.origin.y -= abs(keyboardSize.height - portTextBox.frame.origin.y - textBoxesView.frame.origin.y)
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
