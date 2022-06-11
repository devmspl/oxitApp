//
//  DeviceCategoryDataSource.swift
//  AATA
//
//  Created by Uday Patel on 25/10/21.
//

import UIKit

///
protocol DeviceCategoryDelegate {
    ///
    func didSelect(_ index: Int, category: String)
}

///
class DeviceCategoryDataSource: NSObject {
    // MARK: - Variables
    var delegate: DeviceCategoryDelegate?
    ///
    fileprivate let interItemsPedding: CGFloat = 2.0
    ///
    var reuseIdentifier: String {
        return "WeatherCategoryCell"
    }
    ///
    var nibName: String {
        return "WeatherCategoryCell"
    }
    ///
    var cellWidth: CGFloat = 0
    ///
    var cellHeight: CGFloat = 50.0
    ///
    var collectionView: UICollectionView?
    ///
    var weatherCategory: [String] = [Weather.soilMoisture.rawValue, Weather.temperature.rawValue, Weather.precipitation.rawValue, Weather.wind.rawValue/*, Weather.voltageDetector.rawValue*/]
    ///
    var selectedIndex: Int = 0
    
    // MARK: - Initializing methods
    ///
    convenience init(_ collectionView: UICollectionView) {
        self.init()
        self.collectionView = collectionView
        let nib = UINib(nibName: nibName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        DispatchQueue.main.async {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            guard let selectedIndex = self.selectedIndex as? Int else { return }
            collectionView.scrollToItem(at: IndexPath(item: selectedIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
}

///
extension DeviceCategoryDataSource: UICollectionViewDataSource {
    ///
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherCategory.count
    }
    
    ///
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? WeatherCategoryCell {
            cell.backgroundColor = .clear
            cell.titleLabel.backgroundColor = indexPath.row == selectedIndex ? UIColor.init(named: "clr_bg") : .clear
            cell.titleLabel.layer.cornerRadius = 8.0
            cell.titleLabel.clipsToBounds = true
            cell.titleLabel.text = weatherCategory[indexPath.row]
            cell.baseIndicator.isHidden = indexPath.row == selectedIndex ? false : true
            cell.titleLabel.textColor = indexPath.row == selectedIndex ? UIColor.init(named: "clr_light_bg") : UIColor.darkGray
            return cell
        }
        return UICollectionViewCell()
    }
    
    ///
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
}

///
extension DeviceCategoryDataSource: UICollectionViewDelegate {
    ///
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(indexPath.row, category: weatherCategory[indexPath.row])
    }
}

///
extension DeviceCategoryDataSource: UICollectionViewDelegateFlowLayout {
    ///
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
    }
    
    ///
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let labelWidth = weatherCategory[indexPath.row].widthOfString(usingFont: UIFont.boldSystemFont(ofSize: 18.0)) + 40
        return CGSize(width: labelWidth, height: cellHeight)
    }
    
    ///
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interItemsPedding
    }
    
    ///
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemsPedding
    }
}

