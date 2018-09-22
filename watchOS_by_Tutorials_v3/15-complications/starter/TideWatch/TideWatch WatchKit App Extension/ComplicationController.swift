//
//  ComplicationController.swift
//  TideWatch WatchKit App Extension
//
//  Created by Tom Lai on 9/21/18.
//  Copyright © 2018 razeware. All rights reserved.
//

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {

  func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
    switch complication.family {
    case .modularSmall: //square shaped small
      let modularSmall = CLKComplicationTemplateModularSmallStackText()
      modularSmall.line1TextProvider = CLKDateTextProvider(date: Date(), units: [.era, .hour])
      modularSmall.line2TextProvider = CLKSimpleTextProvider(text: "1")
      handler(modularSmall)
    case .modularLarge:
      let modularLarge = CLKComplicationTemplateModularLargeTable()
      modularLarge.row1Column1TextProvider = CLKSimpleTextProvider(text: "2")
      modularLarge.row1Column2TextProvider = CLKSimpleTextProvider(text: "3")
      modularLarge.row2Column1TextProvider = CLKSimpleTextProvider(text: "4")
      modularLarge.row2Column2TextProvider = CLKSimpleTextProvider(text: "5")
    case .utilitarianSmall, .utilitarianSmallFlat:
      let smallFlat = CLKComplicationTemplateUtilitarianSmallFlat()
      smallFlat.textProvider = CLKSimpleTextProvider(text: "Rising, +2.6m", shortText: "+2.6m")
      smallFlat.imageProvider = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: "tide_rising"))
      handler(smallFlat)
    case .utilitarianLarge:
      let largeFlat = CLKComplicationTemplateUtilitarianLargeFlat()
      largeFlat.textProvider = CLKSimpleTextProvider(text: "Rising, +2.6m", shortText: "+2.6m")
      largeFlat.imageProvider = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: "tide_rising"))
      handler(largeFlat)
    case .circularSmall:
      let textProvider = CLKSimpleTextProvider(text: "6")
      let circularSmall = CLKComplicationTemplateCircularSmallRingText()
      circularSmall.textProvider = textProvider
      handler(circularSmall)
    case .extraLarge:
      let textProvider = CLKSimpleTextProvider(text: "7")
      let extraLarge = CLKComplicationTemplateExtraLargeSimpleText()
      extraLarge.textProvider = textProvider
      handler(extraLarge)
    case .graphicCorner:
      print("not handled")
    case .graphicBezel:
      print("not handled")
    case .graphicCircular:
      print("not handled")
    case .graphicRectangular:
      print("not handled")
    }
  }

  func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
    handler([])
  }

  func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
    handler(nil)

  }

  func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
    // What entries do you have after a specific point in time?
  }
}
