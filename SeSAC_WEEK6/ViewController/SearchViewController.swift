//
//  SearchViewController.swift
//  SeSAC_WEEK6
//
//  Created by sungyeon kim on 2021/11/01.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var SearchTableView: UITableView!
    
    var tasks: Results<UserDiary>!
    
    let localRealm = try! Realm()
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
        
        tasks = localRealm.objects(UserDiary.self)
        print(tasks)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        SearchTableView.reloadData()
    }

}

extension SearchViewController: UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        let row = tasks[indexPath.row]
        cell.contentLabel.text = row.diaryContent
        cell.titleLabel.text = row.diaryTitle

        return cell
    }
}
