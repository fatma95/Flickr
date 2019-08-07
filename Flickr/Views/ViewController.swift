//
//  ViewController.swift
//  Flickr
//
//  Copyright © 2019 FatmaMohamed. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBarView: UISearchBar!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var totalGroups: Double?
    var totalPhotos: Double?
    var searchType: SearchTarget = .groups
    var photosURLs = [String]() {
        didSet {
            photosCollectionView.reloadData()
        }
    }
    
    var groupsNames = [String]() {
        didSet {
            photosCollectionView.reloadData()
        }
    }
    
    var iconURLs = [String]()
    
    fileprivate func getGroups(searchText: String) {
        self.searchType = .groups
        SearchGroupViewModel().getGroupsList(searchText: searchText, success: { (groupsNames, iconURLs,totalGroups) in
            self.groupsNames = groupsNames
            self.totalGroups = totalGroups
            self.iconURLs = iconURLs
            self.stopLoader()
        }) { (error) in
            self.showToast(message: error.localizedDescription)
            self.stopLoader()
        }
    }
    
    fileprivate func stopLoader() {
        self.loadingIndicator.isHidden = true
        self.loadingIndicator.stopAnimating()
    }
    
    fileprivate func getPhotos(searchText: String) {
        SearchPhotoViewModel().getPhotosList(searchText: searchText, success: { (photosURLs, totalPhotos) in
            self.searchType = .photos
            self.photosURLs = photosURLs
            self.totalPhotos = totalPhotos
            self.stopLoader()
        }) { (error) in
            self.showToast(message: error.localizedDescription)
            self.stopLoader()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("View did load", log: OSLog.cycle, type: .info)
        registerCells()
    }
    
    fileprivate func startLoader() {
        self.loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    fileprivate func resizeImage(image: UIImage, size: CGFloat) -> UIImage {
        os_log("Image Resize %{Image}@  %{Size}@" , log: OSLog.data, type: .info, image, size)
        let rect = CGRect(x: 0.0, y: 0.0, width: size / 2, height: size / 2)
        let newSize = CGSize(width: size / 2, height: size / 2)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in:rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    
    @IBAction func searchPhotos(_ sender: Any) {
        if !Validator().validateSearchText(text: searchBarView.text ?? "") {
            self.showToast(message: "Please enter text for search")
        } else {
            startLoader()
            getPhotos(searchText: searchBarView.text ?? "")
        }
    }
    
    @IBAction func searchGroups(_ sender: Any) {
        if !Validator().validateSearchText(text: searchBarView.text ?? "") {
            self.showToast(message: "Please enter text for search")
        } else {
            startLoader()
            getGroups(searchText: searchBarView.text ?? "")
        }
    }
    
   fileprivate func registerCells() {
        let photoCell = UINib(nibName: "GroupCollectionViewCell", bundle: nil)
        self.photosCollectionView.register(photoCell, forCellWithReuseIdentifier: "GroupCollectionCell")
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let sectionInsets = UIEdgeInsets(top: 50.0,
                                                 left: 10.0,
                                                 bottom: 50.0,
                                                 right: 10.0)
        let paddingSpace = sectionInsets.left * (3)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = (availableWidth / 2)
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch searchType {
        case .photos:
            guard self.photosURLs.count != 0 else { return 0 }
            return self.photosURLs.count
        case .groups:
            guard self.groupsNames.count != 0 else { return 0 }
            return self.groupsNames.count
        }
    }
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch searchType {
        case .photos:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath) as! PhotoCollectionViewCell
            let url = self.photosURLs[indexPath.row]
            ImageCaching.loadImage(url: url) { (image) in
                let newImage = self.resizeImage(image: image!, size: collectionView.frame.width)
                ImageCaching.cacheImage(url: url, image: image!)
                cell.searchResultPhoto.image = newImage
            }
            if indexPath.row == photosURLs.count - 1  {
                if totalPhotos ?? 0 > Double(photosURLs.count) {
                    SearchPhotoViewModel().getNextPage(searchText: searchBarView.text ?? "", completion: {(list, photosCount) in
                        self.photosURLs += list
                        self.totalPhotos = photosCount
                    })
                }
            }
            return cell
        case .groups:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCollectionCell", for: indexPath) as! GroupCollectionViewCell
            let url = self.iconURLs[indexPath.row]
            let name = groupsNames[indexPath.row]
            ImageCaching.loadImage(url: url) { (image) in
                let newImage = self.resizeImage(image: image!, size: collectionView.frame.width)
                ImageCaching.cacheImage(url: url, image: image!)
                cell.groupPhoto.image = newImage
            }
            
            cell.groupName.text = name
            if indexPath.row == groupsNames.count - 1  {
                if totalGroups ?? 0 > Double(groupsNames.count) {
                    SearchGroupViewModel().getNextPage(searchText: searchBarView.text ?? "", completion: {(list,iconsURLs, groupsCount) in
                        self.groupsNames += list
                        self.iconURLs += iconsURLs
                        self.totalGroups = groupsCount
                    })
                }
            }
            return cell
        }
    }
}
