//
//  MyNotesDataSource.swift
//  AATA
//
//  Created by Uday Patel on 20/10/21.
//

import UIKit

///
protocol MyNotesDelegate: class {
    ///
    func didSelect(_ note: Notes)
}
///
class MyNotesDataSource: NSObject {
    // MARK: - Variables
    weak var delegate: MyNotesDelegate?
    ///
    var reuseIdentifier: String {
        return "MyNoteCell"
    }
    ///
    var nibName: String {
        return "MyNoteCell"
    }
    ///
    var notesList: [Notes] = []
    ///
    var colorList: [UIColor] = [UIColor.init(red: 255/255, green: 239/255, blue: 209/255, alpha: 1), UIColor.init(red: 221/255, green: 239/255, blue: 247/255, alpha: 1), UIColor.init(red: 228/255, green: 251/255, blue: 211/255, alpha: 1), UIColor.init(red: 255/255, green: 233/255, blue: 244/255, alpha: 1), UIColor.init(red: 222/255, green: 230/255, blue: 255/255, alpha: 1), UIColor.init(red: 255/255, green: 226/255, blue: 214/255, alpha: 1)]
    ///
    var collectionView: UICollectionView?
    // background: rgba(255, 239, 209, 1);
    // background: rgba(221, 239, 247, 1);
    // background: rgba(228, 251, 211, 1);
    // background: rgba(255, 233, 244, 1);
    // background: rgba(222, 230, 255, 1);
    // background: rgba(255, 226, 214, 1);
    
    
    // MARK: - Initializing methods
    ///
    convenience init(_ collectionView: UICollectionView) {
        self.init()
        self.collectionView = collectionView
        let layout = PinterestLayout()
        layout.delegate = self
        let nib = UINib(nibName: nibName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
    }
}

///
extension MyNotesDataSource: UICollectionViewDataSource {
    ///
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notesList.count
    }
    
    ///
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MyNoteCell {
            cell.titleLabel.text = notesList[indexPath.row].title
            cell.detailLabel.text = notesList[indexPath.row].content
            
            cell.dateLabel.text = (notesList[indexPath.row].createdAt ?? Date()).dateToString("MM/dd/yyyy")
            if let random = colorList.randomElement() {
                cell.baseView.backgroundColor = random
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

///
extension MyNotesDataSource: UICollectionViewDelegate {
    ///
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(notesList[indexPath.row])
    }
}

extension MyNotesDataSource : PinterestLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        let textHeight1 = requiredHeight(text: (notesList[indexPath.row].createdAt ?? Date()).dateToString("MM/dd/yyyy"), font: Font.init(Font.FontType.installed(.sfProDisplayRegular), size: Font.FontSize.standard(.size14)), cellWidth: (cellWidth - 20))
        let textHeight2 = requiredHeight(text: notesList[indexPath.row].title, font: Font.init(Font.FontType.installed(.sfProDisplayBold), size: Font.FontSize.standard(.size16)), cellWidth: (cellWidth - 20))
        let textHeight3 = requiredHeight(text: notesList[indexPath.row].content, font: Font.init(Font.FontType.installed(.sfProDisplayRegular), size: Font.FontSize.standard(.size14)), cellWidth: (cellWidth - 20))
        
        return (textHeight1 + textHeight2 + textHeight3 + 60)
    }
    
    ///
    func requiredHeight(text: String, font: Font, cellWidth: CGFloat) -> CGFloat {
        let font = font.instance
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: cellWidth, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}
