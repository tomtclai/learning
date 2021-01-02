//
//  main.swift
//  MachOSegments
//
//  Created by Lai, Tom on 1/2/21.
//  Copyright © 2021 Lai, Tom. All rights reserved.
//

import Foundation
import MachO

func convertIntTupleToString(name: Any) -> String {
    var returnString = ""
    let mirror = Mirror(reflecting: name)
    for child in mirror.children {
        guard let val = child.value as? Int8, val != 0 else { break }
        returnString.append(Character(UnicodeScalar(UInt8(val))))
    }
    return returnString
}
for i in 0..<_dyld_image_count() {
    let imagePath = String(validatingUTF8: _dyld_get_image_name(i))!
    let imageName = (imagePath as NSString).lastPathComponent
    let header = _dyld_get_image_header(i)!
    print("\(i) \(imageName) \(header)")

    var curLoadCommandIterator = Int(bitPattern: header) + MemoryLayout<mach_header_64>.size

    for _ in 0..<header.pointee.ncmds {
        let loadCommand = UnsafePointer<load_command>(bitPattern: curLoadCommandIterator)!.pointee

        if loadCommand.cmd == LC_SEGMENT_64 {
            let segmentCommand = UnsafePointer<segment_command_64>(bitPattern:  curLoadCommandIterator)!.pointee

            let segName = convertIntTupleToString(name: segmentCommand.segname)
            print("\t\(segName)")

            for j in 0..<segmentCommand.nsects {
                let sectionOffset = curLoadCommandIterator + MemoryLayout<segment_command_64>.size
                let offset = MemoryLayout<section_64>.size * Int(j)
                let sectionCommand = UnsafePointer<section_64>(bitPattern: sectionOffset + offset)!.pointee

                let sectionName = convertIntTupleToString(name: sectionCommand.sectname)

                print("\t\t\(sectionName)")
            }
        }
        curLoadCommandIterator += Int(loadCommand.cmdsize)
    }
}



CFRunLoopRun()
