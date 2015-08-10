//
//  NSDictionary+weather_package.h
//  WeatherTutorial
//
//  Created by Scott on 26/01/2013.
//  Updated by Joshua Greene 16/12/2013.
//
//  Copyright (c) 2013 Scott Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (weather_package)

-(NSDictionary *)currentCondition;
-(NSDictionary *)request;
-(NSArray *)upcomingWeather;

@end