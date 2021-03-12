//
//  FileDM.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 19/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import Foundation
import FirebaseStorage
class FileDM {
    let storage = Storage.storage()
    
    func recoverProfileImage(profilePic:String, completion: @escaping (UIImage?,Error?) ->()) {
        
        
        storage.reference().child("profilePic/\(profilePic)").downloadURL { (imageUrl, err) in
            if let err = err {
                print(err.localizedDescription)
                completion(nil,err)
            }else {
                do {
                    
                    let imageView = UIImageView()
                    
                    imageView.sd_setImage(with: imageUrl,
                                          placeholderImage: UIImage(named: "Crianças"),
                                          options: .highPriority,
                                          context: nil,
                                          progress: nil) { (image, error, cacheType, urlImage) in
                                            completion(image,nil)
                    }
                } catch {
                    print("erro na imagem")
                }
            }
        }
        
    }
    
    func recoverProfileImages(profilePics:[String], completion: @escaping ([UIImage?],Error?) ->())     {
        var images:[UIImage?] = []
        profilePics.forEach { (imagePic) in
            if imagePic != "padrao"{
                storage.reference().child("profilePic/\(imagePic)").downloadURL { (url, err) in
                    if let err = err {
                        print(err.localizedDescription)
                        completion(images,err)
                    }else {
                        do {
                            let image = try UIImage(data: Data(contentsOf: url!))
                            images.append(image)
                        } catch {
                            print("erro na imagem")
                        }
                    }
                }
            }else {
                images.append(UIImage(named: "user_placeholder"))
            }
        }
        completion(images,nil)
        
    }
    
}
