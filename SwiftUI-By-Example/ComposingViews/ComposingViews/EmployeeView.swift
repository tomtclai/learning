//
//  EmployeeView.swift
//  ComposingViews
//
//  Created by Tom Lai on 4/19/25.
//

import SwiftUI

struct EmployeeView: View {
    let employee: Employee
    var body: some View {
        HStack{
            ProfilePicture(imageName: nil)
            EmployeeDetails(employee: employee)
        }
    }
}

#Preview {
    let e = Employee(name: "First last", jobTitle: "Job", emailAddress: "a@b.com", profilePicture: "NA")
    EmployeeView(employee: e)
}
