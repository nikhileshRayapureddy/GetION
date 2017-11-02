//
//  PublishDetailsViewController.swift
//  GetION
//
//  Created by Kiran Kumar on 31/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit

class PublishDetailsViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var txtViewMessage: UITextView!
    @IBOutlet weak var collctView: UICollectionView!
    @IBOutlet weak var constrtImgVwHeight: NSLayoutConstraint!
    @IBOutlet weak var btnSendComment: UIButton!

    var arrImageUrls = [String]()
    var imagePicker = UIImagePickerController()
    var arrImages = [UIImage]()
    var currentImage = 0
    var arrQueries = [QueriesBO]()
    var vwGalleryView : GallaryView!
    override func viewDidLoad() {
        super.viewDidLoad()

        viewTop.layer.cornerRadius = 10.0
        viewTop.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func removeImageAction(sender : UIButton)
    {
        let tag = sender.tag - 2000
        arrImages.remove(at: tag)
        if arrImages.count == 0
        {
            constrtImgVwHeight.constant = 0
        }
        
        self.collctView.reloadData()
    }

    @objc func showGallary(sender:UIButton)
    {
        let tag = sender.tag - 3000
        
        if let vwGallery = Bundle.main.loadNibNamed("GallaryView", owner: nil, options: nil)![0] as? GallaryView
        {
            vwGallery.frame = CGRect (x: 0, y: 20, width: (self.view.window?.bounds.width)!, height: (self.view.window?.bounds.height)! - 20)
            vwGallery.arrImages.append(contentsOf: arrQueries[tag].arrImages)
            vwGallery.loadGalleryWithImages()
            vwGallery.delegate = self
            vwGalleryView = vwGallery
            self.view.window?.addSubview(vwGallery)
        }
    }

}

extension PublishDetailsViewController : GallaryView_Delegate
{
    func downloadImage(sender : UIButton)
    {
        let cell = vwGalleryView.collctView.cellForItem(at: IndexPath(item: sender.tag - 2000, section: 0)) as! GalleryCollectionViewCell
        UIImageWriteToSavedPhotosAlbum(cell.imgVw.image! , self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
}

extension PublishDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Images Array Count : \(arrImages.count)")
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        print("Images Array Count : \(arrImages.count) : IndexPath \(indexPath.row) ")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageAttachmentCollectionCell", for: indexPath) as! ImageAttachmentCollectionCell
        cell.imgVw.image = arrImages[indexPath.item]
        cell.btnClose.tag = indexPath.item + 2000
        cell.btnClose.addTarget(self, action: #selector(removeImageAction(sender:)), for: .touchUpInside)
        return cell
    }
}

extension PublishDetailsViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrQueries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let queryDetailBO = arrQueries[indexPath.row]
        //        queryDetailBO.content = queryDetailBO.content.removingPercentEncoding!
        if queryDetailBO.user_id == "0"
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FROMMESSAGE", for: indexPath) as! FromMessageCustomCell
            cell.lblName.text = queryDetailBO.poster_name
            cell.lblTime.text = queryDetailBO.display_time
            cell.lblQueryMessage.text = queryDetailBO.content
            cell.viewBackground.layer.cornerRadius = 10.0
            cell.viewBackground.clipsToBounds = true
            cell.btnShowGallery.tag = indexPath.row + 3000
            cell.btnShowGallery.addTarget(self, action: #selector(showGallary(sender:)), for: .touchUpInside)
            
            if queryDetailBO.arrImages.count == 1
            {
                cell.constrtVwImagesHeight.constant = 76
                cell.img1.isHidden = false
                cell.img1.kf.indicatorType = .activity
                
                let url = URL(string: queryDetailBO.arrImages[0])
                cell.img1.kf.setImage(with: url)
                cell.img2.isHidden = true
                cell.img3.isHidden = true
                cell.btn4thImage.isHidden = true
            }
            else if queryDetailBO.arrImages.count == 2
            {
                cell.constrtVwImagesHeight.constant = 76
                cell.img1.isHidden = false
                cell.img2.isHidden = false
                cell.img1.kf.indicatorType = .activity
                cell.img2.kf.indicatorType = .activity
                
                let url = URL(string: queryDetailBO.arrImages[0])
                cell.img1.kf.setImage(with: url)
                let url1 = URL(string: queryDetailBO.arrImages[1])
                cell.img2.kf.setImage(with: url1)
                cell.img3.isHidden = true
                cell.btn4thImage.isHidden = true
            }
            else if queryDetailBO.arrImages.count == 3
            {
                cell.constrtVwImagesHeight.constant = 76
                cell.img1.isHidden = false
                cell.img2.isHidden = false
                cell.img3.isHidden = false
                cell.img1.kf.indicatorType = .activity
                cell.img2.kf.indicatorType = .activity
                cell.img3.kf.indicatorType = .activity
                
                let url = URL(string: queryDetailBO.arrImages[0])
                cell.img1.kf.setImage(with: url)
                let url1 = URL(string: queryDetailBO.arrImages[1])
                cell.img2.kf.setImage(with: url1)
                let url2 = URL(string: queryDetailBO.arrImages[2])
                cell.img3.kf.setImage(with: url2)
                cell.btn4thImage.isHidden = true
            }
            else if queryDetailBO.arrImages.count > 3
            {
                cell.constrtVwImagesHeight.constant = 76
                cell.img1.isHidden = false
                cell.img2.isHidden = false
                cell.img3.isHidden = false
                cell.img1.kf.indicatorType = .activity
                cell.img2.kf.indicatorType = .activity
                cell.img3.kf.indicatorType = .activity
                
                cell.btn4thImage.isHidden = false
                let url = URL(string: queryDetailBO.arrImages[0])
                cell.img1.kf.setImage(with: url)
                let url1 = URL(string: queryDetailBO.arrImages[1])
                cell.img2.kf.setImage(with: url1)
                let url2 = URL(string: queryDetailBO.arrImages[2])
                cell.img3.kf.setImage(with: url2)
                cell.btn4thImage.setTitle("+\( queryDetailBO.arrImages.count - 3) More", for: .normal)
                
            }
            else
            {
                cell.constrtVwImagesHeight.constant = 0
                cell.img1.isHidden = true
                cell.img2.isHidden = true
                cell.img3.isHidden = true
                cell.btn4thImage.isHidden = true
            }
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TOMESSAGE", for: indexPath) as! ToMessageCustomCell
            cell.lblName.text = queryDetailBO.poster_name
            cell.lblTime.text = queryDetailBO.display_time
            cell.lblQueryMessage.text = queryDetailBO.content
            cell.viewBackground.layer.cornerRadius = 10.0
            cell.viewBackground.clipsToBounds = true
            cell.btnShowGallery.tag = indexPath.row + 3000
            cell.btnShowGallery.addTarget(self, action: #selector(showGallary(sender:)), for: .touchUpInside)
            
            if queryDetailBO.arrImages.count == 1
            {
                cell.constrtVwImagesHeight.constant = 76
                cell.img1.isHidden = false
                cell.img1.kf.indicatorType = .activity
                
                let url = URL(string: queryDetailBO.arrImages[0])
                cell.img1.kf.setImage(with: url)
                cell.img2.isHidden = true
                cell.img3.isHidden = true
                cell.btn4thImage.isHidden = true
            }
            else if queryDetailBO.arrImages.count == 2
            {
                cell.constrtVwImagesHeight.constant = 76
                cell.img1.isHidden = false
                cell.img2.isHidden = false
                cell.img1.kf.indicatorType = .activity
                cell.img2.kf.indicatorType = .activity
                
                let url = URL(string: queryDetailBO.arrImages[0])
                cell.img1.kf.setImage(with: url)
                let url1 = URL(string: queryDetailBO.arrImages[1])
                cell.img2.kf.setImage(with: url1)
                cell.img3.isHidden = true
                cell.btn4thImage.isHidden = true
            }
            else if queryDetailBO.arrImages.count == 3
            {
                cell.constrtVwImagesHeight.constant = 76
                cell.img1.isHidden = false
                cell.img2.isHidden = false
                cell.img3.isHidden = false
                cell.img1.kf.indicatorType = .activity
                cell.img2.kf.indicatorType = .activity
                cell.img3.kf.indicatorType = .activity
                
                let url = URL(string: queryDetailBO.arrImages[0])
                cell.img1.kf.setImage(with: url)
                let url1 = URL(string: queryDetailBO.arrImages[1])
                cell.img2.kf.setImage(with: url1)
                let url2 = URL(string: queryDetailBO.arrImages[0])
                cell.img3.kf.setImage(with: url2)
                cell.btn4thImage.isHidden = true
            }
            else if queryDetailBO.arrImages.count > 3
            {
                cell.constrtVwImagesHeight.constant = 76
                cell.img1.isHidden = false
                cell.img2.isHidden = false
                cell.img3.isHidden = false
                cell.btn4thImage.isHidden = false
                
                cell.img1.kf.indicatorType = .activity
                cell.img2.kf.indicatorType = .activity
                cell.img3.kf.indicatorType = .activity
                let url = URL(string: queryDetailBO.arrImages[0])
                cell.img1.kf.setImage(with: url)
                let url1 = URL(string: queryDetailBO.arrImages[1])
                cell.img2.kf.setImage(with: url1)
                let url2 = URL(string: queryDetailBO.arrImages[0])
                cell.img3.kf.setImage(with: url2)
                cell.btn4thImage.setTitle("+\( queryDetailBO.arrImages.count - 3) More", for: .normal)
                
            }
            else
            {
                cell.constrtVwImagesHeight.constant = 0
                cell.img1.isHidden = true
                cell.img2.isHidden = true
                cell.img3.isHidden = true
                cell.btn4thImage.isHidden = true
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let queryDetailBO = arrQueries[indexPath.row]
        var height = 0
        if queryDetailBO.content.contains("</")
        {
            let attrDescription = try! NSMutableAttributedString(
                data: queryDetailBO.content.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil)
            
            height = Int(queryDetailBO.content.heightForHtmlString(attrDescription, font: UIFont.myridFontOfSize(size: 17), labelWidth: self.view.frame.size.width - 45))
            height = height + 50
        }
        else
        {
            height = Int(queryDetailBO.content.height(withConstrainedWidth: self.view.frame.size.width - 45, font: UIFont.myridFontOfSize(size: 17)))
            height = height + 60
        }
        
        if queryDetailBO.arrImages.count != 0
        {
            return CGFloat(height + 76)
        }
        return CGFloat(height)
        
    }
    
    
    
}
