//
//  GallaryView.swift
//  MessangerApp
//
//  Created by Selvam on 10/24/17.
//  Copyright © 2017 SelvamCapillary. All rights reserved.
//

import UIKit
protocol GallaryView_Delegate {
    func downloadImage(sender: UIButton)
}

class GallaryView: UIView {
    
    @IBOutlet weak var collctView: UICollectionView!
    @IBOutlet weak var btnClose: UIButton!
    var delegate: GallaryView_Delegate!

    
    var arrImages = [String]()
    
    
    func loadGalleryWithImages()
    {
        self.collctView.register(UINib (nibName: "GalleryCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "GalleryCollectionViewCell")
        self.collctView.reloadData()
    }
    
    @IBAction func btnCloseAction(_ sender: UIButton)
    {
        self.removeFromSuperview()
    }
    @objc func downloadImage(sender : UIButton)
    {
        if delegate != nil{
            delegate.downloadImage(sender : sender)
        }

    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
extension GallaryView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize (width: ((self.window?.bounds.width)! - 65)/2 + 5, height: ((self.window?.bounds.width)!/2) - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
        let url = URL(string: arrImages[indexPath.item])
        cell.imgVw.kf.indicatorType = .activity
        cell.imgVw.kf.setImage(with: url)
        cell.btnDownload.tag = indexPath.item + 2000
        cell.btnDownload.addTarget(self, action: #selector(downloadImage(sender:)), for: .touchUpInside)
        return cell
    }
}
