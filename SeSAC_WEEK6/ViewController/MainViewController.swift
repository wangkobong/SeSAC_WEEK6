//
//  ViewController.swift
//  SeSAC_WEEK6
//
//  Created by sungyeon kim on 2021/11/01.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let array = [
        Array(repeating: "a", count: 20),
        Array(repeating: "b", count: 20),
        Array(repeating: "c", count: 20),
        Array(repeating: "d", count: 20),
        Array(repeating: "e", count: 20),
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        /*
         ----> GmarketSansMedium
         ----> GmarketSansLight
         ----> GmarketSansBold
         welcomeLabel.text = LocalizableStrings.welcome_text.localized
         
         //11 ~ 20 폰트사이즈가 적당함
         welcomeLabel.font = UIFont().mainBlack
         
         //
         backupLabel.text = LocalizableStrings.data_backup.localizedSetting

         */
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonPressed))
 
        title = "HOME"
  
    }

    @objc func addButtonPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: AddViewController.identifier) as! AddViewController
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }

    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else { return UITableViewCell()
            
        }
        
        cell.data = array[indexPath.row]
 

        cell.collectionView.backgroundColor = .lightGray
        //하나의 섹션일때 유효함
        cell.collectionView.tag = indexPath.row


        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 1 ? 300 : 170
    }
    
    
}


