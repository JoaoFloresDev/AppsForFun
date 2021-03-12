//
//  JobsDataSource.swift
//  TudoNosso
//
//  Created by Joao Flores on 21/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import Foundation
import UIKit

class JobsDataSource {
    
    //MARK: - PROPERTIES
    var categorysList =
        ["Cultura e Arte" : CategoryEnum.cultureAndArt.rawValue,
         "Educação" : CategoryEnum.education.rawValue,
         "Idosos" : CategoryEnum.elderly.rawValue,
         "Crianças" : CategoryEnum.kids.rawValue,
         "Meio Ambiente" : CategoryEnum.environment.rawValue,
         "Proteção Animal" : CategoryEnum.animalProtection.rawValue,
         "Saúde" : CategoryEnum.health.rawValue,
         "Esportes" : CategoryEnum.sport.rawValue,
         "Refugiados" : CategoryEnum.refugees.rawValue,
         "LGBTQ+" : CategoryEnum.lgbtq.rawValue,
         "Combate à pobreza" : CategoryEnum.againstPoverty.rawValue,
         "Treinamento profissional" : CategoryEnum.professionalTraining.rawValue]
    
    var ongoingJobs : [Job] = []
    var jobs : [Job] = [] {
        didSet {
            self.sortJobs()
        }
    }
    
    //MARK: - METHODS
    func sortJobs(){
        for job in jobs {
            if job.status {
                ongoingJobs.append(job)
            }
        }
    }
    
    func loadDataJobs(key : String, view : UITableView) {
        let jobDM = JobDM()
        
        jobDM.find(inField: .categories, withValueEqual: self.nameKeyBD(key: key), completion: {
            (result, error) in
            guard let result = result else { return }
            self.jobs = result
            
            view.reloadData()
        })
    }
    
    func nameKeyBD (key : String) -> String{
        return categorysList[key] ?? ""
    }
}
