//
//  LoginDM.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 14/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth


class LoginDM{
    let db = Firestore.firestore()
    let TABLENAME = "login"
    let auth = Auth.auth()
    
    func save(login: Login) {
        let loginId = Base64Converter.encodeStringAsBase64(login.email)
        db.collection(TABLENAME).document(loginId).setData(login.representation)
    }
    
    func signIn(email: String, pass:String, completion: @escaping ([String : Any]?,Error?) ->()){
        self.auth.signIn(withEmail: email, password: pass) { (fireUser, err) in
            if err != nil {
                completion(nil,err)
            }else{
                self.find(ByEmail: email) { (login, error) in
                    self.handleLogin(login: login, error: error, completion: completion)
                }
                
                //self.find(ByEmail: email, completion: self.handleLogin(completion: completion))
            }
        }
    }
    
    func signUp(email: String, pass:String, kind:LoginKinds,newUserData: NSDictionary, completion: @escaping (Login?,Error?) ->()){
        print("registrando")
        self.auth.createUser(withEmail: email, password: pass) { (fireUser, err) in
            if let err = err {
                completion(nil,err)
            }else {
                let login = Login(email: email, kind: kind)
                self.save(login: login)
                switch kind {
                case .ONG:
                    
                    if let ong = Organization(snapshot: newUserData){
                        OrganizationDM().save(ong: ong)
                        completion(login,nil)
                    }
                    break
                case .volunteer:
                    if let volunteer = Volunteer(snapshot: newUserData){
                        VolunteerDM().save(volunteer: volunteer)
                        completion(login,nil)
                    }
                }
            }
        }
    }
    
    private func handleLogin(completion:@escaping ([String : Any]?,Error?) ->()) -> (Login?, Error?) -> () {
        return { (login, error) -> () in
            self.handleLogin(login: login, error: error, completion: completion)
        }
    }
    
    fileprivate func convertLoginToOrganizationOrVolunteer(_ id: String, _ kind:LoginKinds, _ completion: @escaping ([String : Any]?, Error?) -> ()) {
        switch kind {
        case .ONG:
            OrganizationDM().find(ById: id) { (ong, err) in
                if err == nil {
                    completion(ong?.representation,nil)
                }else {
                    completion(nil,err)
                }
            }
            break
        case .volunteer:
            VolunteerDM().find(ById: id) { (volunter, err) in
                if err == nil{
                    completion(volunter?.representation,nil)
                }else{
                    completion(nil,err)
                }
            }
        }
    }
    
    private func handleLogin(login: Login?,
                             error: Error?,
                             completion: @escaping ([String : Any]?,Error?) ->()) {
        
        if error == nil {
            guard let login = login else {return}
            convertLoginToOrganizationOrVolunteer(login.id!, login.kind, completion)
            
        }else {
            completion(nil, error)
        }
        
    }
    
    func recoverUser(ById id: String, onKind kind:LoginKinds, completion: @escaping ([String : Any]?,Error?) ->()) {
        self.convertLoginToOrganizationOrVolunteer(id, kind, completion)
    }
    
    func find(ByEmail email: String, completion: @escaping (Login? ,Error?) -> ()){
        let userID = Base64Converter.encodeStringAsBase64(email)
        db.collection(TABLENAME).document(userID).getDocument { (snapshot, err) in
            if let err = err {
                completion(nil,err)
            }else {
                if let snapshot = snapshot {
                    if let data = snapshot.data(),
                        let login = Login(id: snapshot.documentID, snapshot: data as NSDictionary){
                        completion(login,nil)
                    }
                }
            }
        }
    }

}
