//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Tsz Chun Lai on 3/2/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
@import CoreData;
@interface BNRItemStore ()

@property (nonatomic) NSMutableArray* privateItems;
@property (nonatomic, strong) NSMutableArray *allAssetTypes;
@property (nonatomic, strong) NSManagedObjectContext *context;// who sets this?
@property (nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation BNRItemStore


#pragma mark - init
// If a programmer calls [[BNRItemStore alloc] init], let him
// know the error of his ways
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[BNRItemStore sharedStore]"
                                 userInfo:nil];
    return nil;
}
// Here is the read (secret initializer
- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
//        // set up NSManagedObjectContext and NSPersistentStoreCoordinator
//        // 1. NSPSC needs to know where the schema is and where to load
//        //    and store data
//        // 2. NSMOC specifies it use this NSPSC to save and load objects
//        
//        // Read in Homepwner.xcdatamodeld
//        _model = [NSManagedObjectModel mergedModelFromBundles:nil]; // search for schema
//        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:_model]; //init psc with schema
//        
//        // Where does the SQLite file go?
//        NSString *path = [self itemArchivePath];
//        NSURL *storeURL = [NSURL fileURLWithPath:path];
//        
//        NSError *error = nil;
//        
//        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
//                               configuration:nil
//                                         URL:storeURL
//                                     options:nil
//                                       error:&error]){
//            @throw [NSException exceptionWithName:@"OpenFailure"
//                                           reason:[error localizedDescription]
//                                         userInfo:nil];
        
        // read in Homepwner.xcdatamodeld
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc =
        [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        NSString *path = self.itemArchivePath;
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure"
                                           reason:[error localizedDescription]
                                         userInfo:nil];
        }
        
        // Create the managed object context
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
        
        [self loadAllItems];
    }
    
    return self;
}

#pragma  mark - UI Collection view
- (void)moveItemAtIndex:(NSUInteger)fromIndex
                toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    // Get pointer to object being moved so you can re-insert it
    BNRItem *item = self.privateItems[fromIndex];
    
    // Remove item from array
    [self.privateItems removeObjectAtIndex:fromIndex];
    
    // Insert item in array at new location
    [self.privateItems insertObject:item atIndex:toIndex];
    
    // Comput a new order value for the moved object
    double lowerBound = 0.0;
    
    // is there an object before it in the array?
    if (toIndex != 0) {
        lowerBound = [self.privateItems[(toIndex -1)] orderingValue];
    } else {
        lowerBound = [self.privateItems[1] orderingValue] -2.0;
    }
    
    double upperBound =0.0;
    // is ther an object after it in the array?
    if (toIndex != [self.privateItems count]-1) {
        upperBound = [self.privateItems[(toIndex +1)] orderingValue];
    } else {
        upperBound = [self.privateItems[(toIndex -1)] orderingValue] +2.0;//
    }
    
    double newOrderValue = (lowerBound + upperBound) / 2.0;
    
    NSLog(@"moving to order %f", newOrderValue);
    item.orderingValue = newOrderValue;
}
#pragma mark - other
- (NSArray *)allItems
{
    return [self.privateItems copy];
}

- (BNRItem *)createItem
{
//    BNRItem *item = [[BNRItem alloc] init];
    double order;
    if ([self.allItems count] == 0)
    {
        order = 1.0;
    } else {
        order = [[self.privateItems lastObject] orderingValue] + 1.0;
    }
    
    NSLog(@"Adding after %d items, order = %.2f", [self.privateItems count],order);
    BNRItem *item =
    [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem"
                                  inManagedObjectContext:self.context];
    
    item.orderingValue = order;
    
    [self.privateItems addObject:item];
    
    return item;
}
- (void)removeItem:(BNRItem *)item
{
    NSString *key = item.itemKey;
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    [self.context deleteObject:item];
    [self.privateItems removeObjectIdenticalTo:item];
}
- (NSString *)itemArchivePath
{
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories =

    // This function is borrowed from OS X.
    // The first argument is a constant that specifies the directory in the
    // sandbox you want the payh to. On iOS, the last two arguments are always
    // the same.
    // On iOS, there will only be one path that match the search criteria.
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString * documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

+ (instancetype) sharedStore
{
    static BNRItemStore *sharedStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}
- (BOOL)saveChanges
{
    // The archiveRootObject method takes care of saving every single BNRItem in
    // privateItems to the itemArchivePath. Yes, It is that simple.
    
    NSError *error;
    NSLog(@"%d",[[self.context insertedObjects] count]);
    BOOL successful = [self.context save:&error];
    NSLog(@"%d",[[self.context insertedObjects] count]);
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    self.privateItems = nil;
            [self loadAllItems];
    return successful;
}

- (void)loadAllItems
{
    if (!self.privateItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription
                                  entityForName:@"BNRItem"
                                  inManagedObjectContext:self.context];
        
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor
                                sortDescriptorWithKey:@"orderingValue"
                                ascending:YES];
        
        request.sortDescriptors = @[sd];
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request
                                                      error:&error];
        if (!result) {
            [NSException raise:@"Fetch"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

- (NSArray *)allAssetTypes
{
    if (!_allAssetTypes) {
        NSEntityDescription *e = [NSEntityDescription entityForName:@"BNRAssetType"
                                             inManagedObjectContext:self.context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = e;
        
        NSError *error = nil;
        NSArray *result = [self.context executeFetchRequest:request
                                                      error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        _allAssetTypes = [result mutableCopy];
    }
    // is this the first time the program is being run?
    if ([_allAssetTypes count] == 0) {
        NSError *error;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"BNRAssetType"];
        
        
        // Query for assetTypes
        NSArray *array =
        [[self context] executeFetchRequest:request
                                      error:&error];
        if (array.count != 0)
        {
            for ( NSManagedObject *type in array)
            {
                [_allAssetTypes addObject:type];
            }
        }

    }
    return _allAssetTypes;
}

- (void)addValue:(nonnull NSString *)value
                    forKey:(nonnull NSString *)key
                  toEntity:(nonnull NSString *)entity
{
    NSManagedObject *type;
    type = [NSEntityDescription insertNewObjectForEntityForName:entity
                                         inManagedObjectContext:self.context];
    [type setValue:value forKey:key];
    [_allAssetTypes addObject:type];
}
- (void)removeValue:(nonnull NSString *)value
                       forKey:(nonnull NSString *)key
                   fromEntity:(nonnull NSString *)entity
{
    NSManagedObject *type;
   
    // need a ref to the managed object..
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"%K = %@",key,value];
    NSError *error;

    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entity];
    [request setPredicate:predicate];

    
    NSArray *array =
    [[self context] executeFetchRequest:request
                                  error:&error];
    type = [array firstObject];
    // have a ref to managed object, remove it
    [_allAssetTypes removeObject:type]; //remove it from array
    [[self context] deleteObject:type]; //remove it from context
    NSLog(@"%d",[[[BNRItemStore sharedStore] allAssetTypes] count]);
    
}
- (NSSet *)itemsForAssetType:(NSString*)typeName
{
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"BNRAssetType"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K= %@", @"label", typeName];
    // forKey:@"label"
    //fromEntity:@"BNRAssetType"];
    [request setPredicate:predicate];
    
    NSArray* types =
    [[self context] executeFetchRequest:request
                                  error:&error];

    
    return [[types firstObject] items];
}

@end
