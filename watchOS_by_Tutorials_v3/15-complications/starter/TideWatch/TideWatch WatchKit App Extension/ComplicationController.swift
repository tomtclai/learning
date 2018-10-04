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
      smallFlat.imageProvider = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: "tide_high"))
      handler(smallFlat)
    case .utilitarianLarge:
      let largeFlat = CLKComplicationTemplateUtilitarianLargeFlat()
      largeFlat.textProvider = CLKSimpleTextProvider(text: "Rising, +2.6m", shortText: "+2.6m")
      largeFlat.imageProvider = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: "tide_high"))
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
    let conditions = TideConditions.loadConditions()
    guard let waterLevels = conditions.currentWaterLevel else {
      handler(nil)
      return
    }
    var tideImage: UIImage
    switch waterLevels.situation {
    case .High: tideImage = #imageLiteral(resourceName: "tide_high")
    case .Low: tideImage = #imageLiteral(resourceName: "tide_low")
    case .Rising: tideImage = #imageLiteral(resourceName: "tide_rising")
    case .Falling: tideImage = #imageLiteral(resourceName: "tide_falling")
    case .Unknown: tideImage = #imageLiteral(resourceName: "tide_high")
    }

    if complication.family == .utilitarianSmall {
      let smallFlat = CLKComplicationTemplateUtilitarianSmallFlat()
      smallFlat.textProvider = CLKSimpleTextProvider(text: waterLevels.shortTextForComplication)
      smallFlat.imageProvider = CLKImageProvider(onePieceImage: tideImage)
      handler(CLKComplicationTimelineEntry(date: waterLevels.date, complicationTemplate: smallFlat))
    } else if complication.family == .utilitarianLarge {
      let largeFlat = CLKComplicationTemplateUtilitarianLargeFlat()
      largeFlat.textProvider = CLKSimpleTextProvider(text: waterLevels.longTextForComplication)
      largeFlat.imageProvider = CLKImageProvider(onePieceImage: tideImage)
      handler(CLKComplicationTimelineEntry(date: waterLevels.date, complicationTemplate: largeFlat))
    } else if complication.family == .modularSmall {
      let smallFlat = CLKComplicationTemplateModularSmallSimpleImage()
      smallFlat.imageProvider = CLKImageProvider(onePieceImage: tideImage)
      handler(CLKComplicationTimelineEntry(date: waterLevels.date, complicationTemplate: smallFlat))
    } else if complication.family == .modularLarge {
      let big = CLKComplicationTemplateModularLargeStandardBody()
//      big.headerImageProvider = CLKImageProvider(onePieceImage: tideImage)
//      big.body1TextProvider = CLKTimeTextProvider(date: Date(), waterLevels.longTextForComplication
     }
  }

  func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
    // What entries do you have after a specific point in time?
  }
}
