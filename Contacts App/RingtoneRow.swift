//
//  RingtoneRow.swift
//  Contacts App
//
//  Created by anna on 20.09.17.
//  Copyright © 2017 anna. All rights reserved.
//

import Eureka

final class RingtoneRow: Row<RingtoneCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<RingtoneCell>(nibName: "RingtoneCell")
    }
}
