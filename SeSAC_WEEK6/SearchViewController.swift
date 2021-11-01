//
//  SearchViewController.swift
//  SeSAC_WEEK6
//
//  Created by sungyeon kim on 2021/11/01.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var SearchTableView: UITableView!
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        SearchTableView.delegate = self
        SearchTableView.dataSource = self
        self.title = "검색"
    }

}

extension SearchViewController: UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}
