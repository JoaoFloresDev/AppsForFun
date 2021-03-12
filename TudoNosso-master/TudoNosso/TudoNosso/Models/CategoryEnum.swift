//
//  CategoryEnum.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 06/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import Foundation


enum CategoryEnum : String{
    case education = "education"
    case cultureAndArt = "cultureAndArt"
    case kids = "kids"
    case elderly = "elderly"
    case environment = "environment"
    case animalProtection = "animalProtection"
    case health = "health"
    case sport = "sport"
    case refugees = "refugees"
    case lgbtq = "lgbtq"
    case againstPoverty = "againstPoverty"
    case professionalTraining = "professionalTraining"
    
    
    func description() -> String{
        return self.rawValue
    }
}
