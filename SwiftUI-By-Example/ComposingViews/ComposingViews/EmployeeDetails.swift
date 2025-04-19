//
//  EmployeeDetails.swift
//  ComposingViews
//
//  Created by Tom Lai on 4/19/25.
//

import SwiftUI

struct EmployeeDetails: View {
    let employee: Employee
    var body: some View {
        VStack(alignment: .leading) {
            Text(employee.name)
                .font(.largeTitle)
                .foregroundStyle(.primary)
            Text(employee.jobTitle)
                .foregroundStyle(.secondary)
            EmailAddress(address: employee.emailAddress)
        }
    }
}

#Preview {
    let emp = Employee(name: "Name", jobTitle: "Job", emailAddress: "abc@cde.com", profilePicture: "NA")
    EmployeeDetails(employee: emp)
}
