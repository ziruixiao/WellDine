//
//  KeychainItemWrapper.h
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Modified by Felix Xiao on 12/22/2012
//
//  Copyright (C) 2010 by Apple
//

#import <UIKit/UIKit.h>

@interface KeychainItemWrapper : NSObject {
    NSMutableDictionary *keychainItemData;		// The actual keychain item data backing store.
    NSMutableDictionary *genericPasswordQuery;	// A placeholder for the generic keychain item query used to locate the item.
}

//properties
@property (nonatomic,retain) NSMutableDictionary *keychainItemData;
@property (nonatomic,retain) NSMutableDictionary *genericPasswordQuery;

//methods
- (id)initWithIdentifier:(NSString*)identifier accessGroup:(NSString*)accessGroup;
- (void)setObject:(id)inObject forKey:(id)key;
- (id)objectForKey:(id)key;
- (void)resetKeychainItem;
- (NSInteger)countNumber;

@end