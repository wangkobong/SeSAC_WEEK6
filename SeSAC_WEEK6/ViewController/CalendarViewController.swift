//
//  CalendarViewController.swift
//  SeSAC_WEEK6
//
//  Created by sungyeon kim on 2021/11/01.
//

import UIKit
import FSCalendar
import RealmSwift

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var allCountLabel: UILabel!
    
    let localRealm = try! Realm()
    var tasks: Results<UserDiary>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calendarView.delegate = self
        calendarView.dataSource = self
        
        tasks = localRealm.objects(UserDiary.self)
        
//        let allCount = localRealm.objects(UserDiary.self).count
        let allCount = getAllDiaryCountFromUserDiary()
        allCountLabel.text = "총 \(allCount)개를 썼다"
//        
//        let recent = localRealm.objects(UserDiary.self).sorted(byKeyPath: "writeDate", ascending: false).first?.diaryTitle
//        print("recent: \(recent)")
//        
//        let full = localRealm.objects(UserDiary.self).filter("content != nil").count
//        print("recent: \(full)")
//        let favorite = localRealm.objects(UserDiary.self).filter("favorite = false").count
//        print("recent: \(favorite)")
//        
        //String -> 검색할 때는 '' 필요, AND / OR 조건으로 다중조건 설정 가능
        let search = localRealm.objects(UserDiary.self).filter("diaryTitle CONTAINS[c] '일기' AND content = '살아와'")
        print("recent: \(search)")
    }
    
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//
//    }
//
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//        <#code#>
//    }
//
//    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//        return UIImage(systemName: "star")
//    }
    
    //Date: 시분초까지 모두 동일해야 함.
    //1. 영국 표준시 기준으로 표기
    //2. 데이트 포맷터
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
//        let format = DateFormatter()
//        format.dateFormat = "yyyyMMdd"
//        let test = "20211103"
//
//        if format.date(from: test) == date {
//            return 3
//        } else {
//            return 1
//        }
        
        // 11월 2일에 3개의 일기라면, 점 3개를 or 일기를 쓰지 않았다면 X, 1개면 점 1개
//          var count = 0
//        for i in tasks {
//            if i.writeDate == date {
//              count += 1
//            }
//        }
//        return count
        return tasks.filter("writeDate == %@", date).count
    }
    
}
