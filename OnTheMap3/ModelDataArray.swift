//
//  ModelDataArray.swift
//  OnTheMap3
//
//  Created by Raghad Mah on 08/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

class ModelDataArray {
    static let shared = ModelDataArray()
    var userDataArray = [Any?]()
    private init(){}
}
