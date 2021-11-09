//
//  HomeTableViewCell.swift
//  SeSAC_WEEK6
//
//  Created by sungyeon kim on 2021/11/08.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    static let identifier = "HomeTableViewCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var data: [String] = [] {
        didSet {
            collectionView.reloadData()
            categoryLabel.text = "\(data.count)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        categoryLabel.backgroundColor = .blue
        // 페이징 기능 추가
        collectionView.isPagingEnabled = true

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
//        if collectionView.tag == 0 {
//            cell.imageView.backgroundColor = .brown
//        } else {
//            cell.imageView.backgroundColor = .systemPink
//        }
        
        cell.imageView?.backgroundColor = .brown
        cell.contentLabel.text = data[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //테이블뷰 셀의 인덱스 패스를 어떻게 가지고 와야 할까?
        if collectionView.tag == 0 {
            return CGSize(width: UIScreen.main.bounds.width, height: 100)
        } else {
            return CGSize(width: 150, height: 100)
        }
     
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        }
    }
    
    // 셀과 셀 사이의 여백 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.tag == 0 ? 0 : 10
    }
    
    
}
