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
    
    @IBAction func createLobbyButton(_ sender: Any) {
        transitionBetweenViews(playerID: FighterID.first)
    }
    @IBAction func joinButton(_ sender: Any) {
        transitionBetweenViews(playerID: FighterID.second)
    }
    
    //MARK: Функция перехода на вью в зависимости от нажатой кнопки
    func transitionBetweenViews(playerID: FighterID){
        let menuStoryboard = UIStoryboard(name: "Menu", bundle: Bundle.main)
        guard let destinationViewController = menuStoryboard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else{
            return
        }
        destinationViewController.Mode = GameMode.pvpNet(playerID: playerID, adress: URL(string: "ws://\(ipTextBox.text!):\(portTextBox.text!)")!, lobbyName: "test", lobbyPassword: "228")
        
        destinationViewController.modalTransitionStyle = .crossDissolve
        present(destinationViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil{
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
}
