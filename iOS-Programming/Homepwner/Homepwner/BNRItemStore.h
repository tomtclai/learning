/**
 *  BNRItemStore.h
 *  Homepwner
 *
 *  BNRItemStore will be a singleton. This means there will only be one instance
 *  of this type in the application; if you try to create another instnace, the 
 *  class will quietly return the existing instance instead.
 *
 *  Created by Tsz Chun Lai on 3/2/15.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class BNRItem;
@interface BNRItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;

// Notice that this is a class method and prefixed with a + instead of a -
+ (instancetype)sharedStore;
- (BNRItem *)createItem;
- (void)removeItem:(BNRItem *)item;
- (void)moveItemAtIndex:(NSUInteger)fromIndex
                toIndex:(NSUInteger)toIndex;
- (BOOL)saveChanges;
- (NSArray*)allAssetTypes;
- (void)removeValue:(nonnull NSString *)value
             forKey:(nonnull NSString *)key
         fromEntity:(nonnull NSString *)entity;
- (void)addValue:(nonnull NSString *)value
          forKey:(nonnull NSString *)key
        toEntity:(nonnull NSString *)entity;
- (NSSet *)itemsForAssetType:(NSString*)typeName;
@end
