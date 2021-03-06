//
//  FileDelete.swift
//  Deshazo
//
//  Created by Raiden Honda on 7/6/16.
//  Copyright © 2016 Beloved Robot. All rights reserved.
//

import Foundation

class FileDelete : StashObject {
    // The data will be used by the API to associate the upload with the right document.
    var docType : String = "fileDelete";
    var fileUrl : String = "";
    
    required init() {
        super.init()
        self.id = NSUUID().uuidString
    }
    
    init(fileUrl : String) {
        super.init()
        self.id = NSUUID().uuidString
        
        self.fileUrl = fileUrl
    }
}
