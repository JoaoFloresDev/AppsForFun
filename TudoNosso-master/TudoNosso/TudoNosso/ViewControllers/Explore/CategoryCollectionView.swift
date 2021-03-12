//
//  CategoryRow.swift
//  TwoDirectionalScroller
//
//  Created by Robert Chen on 7/11/15.
//  Copyright (c) 2015 Thorn Technologies. All rights reserved.
//

import UIKit

protocol CategoryCollectionViewDelegate: NSObjectProtocol {
    func causeSelected(_ view: CategoryCollectionView, causeTitle: String?, OrganizationEmail: String?, tagCollection: Int )
}


class CategoryCollectionView : UITableViewCell {
    
    //MARK: - OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - PROPERTIES
    var categorysList = ["Combate à pobreza","Crianças","Cultura e Arte","Educação","Esportes","Idosos","LGBTQ+","Meio Ambiente","Proteção Animal","Refugiados","Saúde","Treinamento profissional"]
    let ongDM = OrganizationDM()
    var organizationsList : [Organization] = []
    var ongs : [Organization] = [] {
        didSet {
            self.sortOrganizations()
        }
    }
    
    //MARK: - METHODS
    func sortOrganizations(){
        organizationsList = ongs
    }
    
    weak var delegate: CategoryCollectionViewDelegate!
    
    var backgroundQueue: OperationQueue {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        return queue
    }
}

//MARK: - EXTENSION
extension CategoryCollectionView : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var numElem = 12
        // tag 0 is Cause collection
        // tag 1 is Organization collection
        if(collectionView.tag == 1) {
            numElem = organizationsList.count
        }
        
        return numElem
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCasesOrganizations", for: indexPath) as! CellCasesOrganizations
        
        cell.imageView.layer.borderWidth = 1.0
        cell.imageView.layer.masksToBounds = false
        cell.imageView.layer.borderColor = UIColor.white.cgColor
        cell.imageView.layer.cornerRadius = cell.imageView.frame.size.height/8
        cell.imageView.clipsToBounds = true
        cell.imageView.tag = indexPath.row
        cell.delegate = self
        
        if(collectionView.tag == 0) {
            cell.titleLabel.text = categorysList[indexPath.row]
            cell.imageView.image = UIImage(named: categorysList[indexPath.row]) ?? UIImage(named: "ong-img_job")!
        } else {
            cell.titleLabel.text = organizationsList[indexPath.row].name
            cell.email = organizationsList[indexPath.row].email
            
            let imageDownloadOperation = BlockOperation {
                
                if let avatar = self.organizationsList[indexPath.row].avatar {
                    FileDM().recoverProfileImage(profilePic: avatar) { (image, error) in
                        guard let image = image else {return}
                        OperationQueue.main.addOperation {
                            cell.imageView.image = image
                        }
                    }
                } else {
                    let image = UIImage(named: "ong-img_job")!
                    
                    OperationQueue.main.addOperation {
                        cell.imageView.image = image
                    }
                }
            }
            self.backgroundQueue.addOperation(imageDownloadOperation)
        }
        cell.titleLabel.font = UIFont(name:"Nunito-Bold", size: 14.0)
        return cell
    }
    
    func cropToBounds(image: UIImage, portraitOrientation: Bool) -> UIImage {
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = 0
        var cgheight: CGFloat = 0
        
        if (portraitOrientation) { // if portrate
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
        } else { // if landscape
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
        }
        
        cgwidth = 3000
        cgheight = 3000
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: 1, orientation: image.imageOrientation)
        return image
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemHeight = collectionView.bounds.height - 10
        
        return CGSize(width: itemHeight, height: itemHeight)
    }
    
    func loadDataOrganizations() {
        let orgDM = OrganizationDM()
        
        orgDM.listAll {
            (result, error) in
            guard let result = result else { return }
            self.ongs = result
            
            self.reloadInputViews()
            self.collectionView.reloadData()
        }
    }
}


extension CategoryCollectionView : CellCasesOrganizationsDelegate {
    func causeSelected(_ cell: CellCasesOrganizations) {
        
        if let delegate = self.delegate {
            delegate.causeSelected(self, causeTitle: cell.titleLabel.text, OrganizationEmail: cell.email, tagCollection: self.tag)
        }
    }
    
    
}
