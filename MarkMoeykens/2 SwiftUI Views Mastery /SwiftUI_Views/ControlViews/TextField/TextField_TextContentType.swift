// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
// Helps offer relevant suggestions above the keyboard

struct TextField_TextContentType: View {
    @State private var text = ""
    
    var body: some View {
        Form {
            TextField("name", text: $text)
                .textContentType(.name)
            
            TextField("city", text: $text)
                .textContentType(.addressCity)
            
            TextField("state", text: $text)
                .textContentType(.addressState)
            
            TextField("email address", text: $text)
                .textContentType(.emailAddress)
            
            TextField("credit card number", text: $text)
                .textContentType(.creditCardNumber)
            
            TextField("URL", text: $text)
                .textContentType(.URL)
            
            TextField("telephone number", text: $text)
                .textContentType(.telephoneNumber)
            
            TextField("code from text message", text: $text)
                .textContentType(.oneTimeCode)
        }
        .font(.title)
    }
}

#Preview {
    TextField_TextContentType()
}

/*
 Text Content Types
 
 @available(iOS 10.0, *)
 name
 namePrefix
 givenName
 middleName
 familyName
 nameSuffix
 nickname
 jobTitle
 organizationName
 location
 fullStreetAddress
 streetAddressLine1
 streetAddressLine2
 addressCity
 addressState
 addressCityAndState
 sublocality
 countryName
 postalCode
 telephoneNumber
 emailAddress
 URL
 creditCardNumber
 username
 password
 newPassword
 oneTimeCode
 
 @available(iOS 15.0, *)
 /// Parcel tracking numbers such as "FedEx 8602 9191 3550", "1Z50T0536891664106", and "729445720428778".
 shipmentTrackingNumber
 /// Airline flight numbers such as "CZ # 1234", "AA212", and "SW Flight 573".
 @available(iOS 15.0, *)
 flightNumber
 /// Dates, times, or durations such as "7-3-2021" or "This Saturday", "12:30", and "10-11am", respectively.
 dateTime
 
 @available(iOS 17.0, *)
 birthdate
 birthdateDay
 birthdateMonth
 birthdateYear
 creditCardSecurityCode
 creditCardName
 creditCardGivenName
 creditCardMiddleName
 creditCardFamilyName
 creditCardExpiration
 creditCardExpirationMonth
 creditCardExpirationYear
 creditCardType
 */
