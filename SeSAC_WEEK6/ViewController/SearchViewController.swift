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
        
        tasks = localRealm.objects(UserDiary.self) //.filter("favorite == true")  //.sorted(byKeyPath: "diaryTitle", ascending: false)
        print("Realm is located at:", localRealm.configuration.fileURL!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SearchTableView.reloadData()
    }
    
    //도큐먼트 폴더 경로 -> 이미지 찾기 -> UIImage -> UIImageView
    func lodaImageFromDocumentDirectory(imageName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let directoryPath = path.first {
            let imageURL = URL(fileURLWithPath: directoryPath).appendingPathComponent(imageName)
            return UIImage(contentsOfFile: imageURL.path)
        }
        
        return nil
    }
    
    func deleteImageFromDocumentDirectory(imageName: String) {
        //1. 이미지 저장할 경로 설정: 도큐먼트 폴더, FileManager
        // Desktop/jack/ios/folder
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        //2. 이미지 파일 이름 & 최종 경로 설정
        // Desktop/jack/ios/folder/222.png
        let imageURL = documentDirectory.appendingPathComponent(imageName)
        
        //4. 이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우, 덮어쓰기
        //4-1. 이미지 경로 여부 확인
        if FileManager.default.fileExists(atPath: imageURL.path) {
            
            //4-2. 기존 경로에 있는 이미지 삭제
            do {
                try FileManager.default.removeItem(at: imageURL)
                print("이미지 삭제 완료")
            } catch {
                print("이미지를 삭제하지 못했습니다")
            }
        }
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
        
        cell.configureCell(row: tasks[indexPath.row])
        
        let row = tasks[indexPath.row]
//        cell.contentLabel.text = row.diaryContent
//        cell.titleLabel.text = row.diaryTitle
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM월-dd일"
//        
//        cell.dateLabel.text = dateFormatter.string(from: row.writeDate)
//        
        cell.summaryImageView.image = lodaImageFromDocumentDirectory(imageName: "\(row._id).png")
        return cell
    }
    
    //본래는 화면 전환 + 값 전달 후 새로운 화면에서 수정이 적합
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskToUpdate = tasks[indexPath.row]
        //1. 수정 - 레코드에 대한 값 수정
        try! localRealm.write {
            taskToUpdate.diaryTitle = "새롭게 수정해봅니다."
            taskToUpdate.diaryContent = "지금의 구조는 ViewController > TableView > TableViewCell > reportButtonAction 순으로 되어 있다. 여기서 그냥 self로만 구현하게 되면 reportButtonAction이 ViewController를 보유하게 되어 무한 싸이클이 돌게 되는 것이다."
            tableView.reloadData()
        }
        
        //2. 일괄 수정
//        try! localRealm.write {
//            tasks.setValue(Date(), forKey: "writeDate")
//            tasks.setValue("새롭게 일기 쓰기", forKey: "diaryTitle")
//            tableView.reloadData()
//        }
        
        //3. 수정: pk 기준으로 수정할 때 사용 but 권장되진 않음.
//        try! localRealm.write {
//            let update = UserDiary(value: [ "_id" : taskToUpdate._id, "diaryTitle": "얘만 바꾸고 싶어"])
//            localRealm.add(update, update: .modified)
//            tableView.reloadData()
//        }
        
        //4.
//        try! localRealm.write {
//            localRealm.create(UserDiary.self, value: [ "_id" : taskToUpdate._id, "diaryTitle": "얘만 바꾸고 싶어"], update: .modified)
//            tableView.reloadData()
//        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let row = tasks[indexPath.row]
        
        try! localRealm.write {
            deleteImageFromDocumentDirectory(imageName: "\(tasks[indexPath.row]._id).png")
            localRealm.delete(row)
            tableView.reloadData()
        }
    }
}
