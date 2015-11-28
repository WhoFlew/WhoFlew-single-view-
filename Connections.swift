//
//  Connections.swift
//  WhoFlew
//
//  Created by Austin Matese on 9/12/15.
//  Copyright (c) 2015 atomm. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class Connections: NSManagedObject {

    @NSManaged var codeName: String
    @NSManaged var codeId: String
    @NSManaged var endAt: NSDate
    @NSManaged var shouldDelete: NSNumber
    @NSManaged var userOrder: Int32
    @NSManaged var lastRead: NSDate

}
