//
//  KeychainItemWrapper.m
//  WellDine
//  Copyright (C) 2013 by Felix Xiao
//  Modified by Felix Xiao on 12/22/2012
//
//  Copyright (C) 2010 by Apple
//

#import "KeychainItemWrapper.h"
#import <Security/Security.h>

@interface KeychainItemWrapper (PrivateMethods)
- (NSMutableDictionary*)secItemFormatToDictionary:(NSDictionary*)dictionaryToConvert;
- (NSMutableDictionary*)dictionaryToSecItemFormat:(NSDictionary*)dictionaryToConvert;
- (void)writeToKeychain;
@end


@implementation KeychainItemWrapper

//synthesize properties
@synthesize keychainItemData, genericPasswordQuery;

//methods
- (id)initWithIdentifier:(NSString*)identifier accessGroup:(NSString*) accessGroup;
{
    if (self = [super init]) {
        genericPasswordQuery = [[NSMutableDictionary alloc] init];
		[genericPasswordQuery setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
        [genericPasswordQuery setObject:identifier forKey:(id)kSecAttrGeneric];
		
		if (accessGroup != nil) {
#if TARGET_IPHONE_SIMULATOR
            
#else			
			[genericPasswordQuery setObject:accessGroup forKey:(id)kSecAttrAccessGroup];
#endif
		}
		
        [genericPasswordQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
        [genericPasswordQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
        
        NSDictionary *tempQuery = [NSDictionary dictionaryWithDictionary:genericPasswordQuery];
        NSMutableDictionary *outDictionary = nil;
        
        if (! SecItemCopyMatching((CFDictionaryRef)tempQuery,(CFTypeRef*)&outDictionary) == noErr) {
            [self resetKeychainItem];
			[keychainItemData setObject:identifier forKey:(id)kSecAttrGeneric];
			if (accessGroup != nil) {
#if TARGET_IPHONE_SIMULATOR

#else			
				[keychainItemData setObject:accessGroup forKey:(id)kSecAttrAccessGroup];
#endif
			}
		}
        else {
            self.keychainItemData = [self secItemFormatToDictionary:outDictionary];
        }
		[outDictionary release];
    }
	return self;
}

- (void)dealloc
{
    [keychainItemData release];
    [genericPasswordQuery release];
	[super dealloc];
}

- (NSInteger)countNumber
{
    return keychainItemData.count;
}

- (void)setObject:(id)inObject forKey:(id)key 
{
    if (inObject == nil) return;
    id currentObject = [keychainItemData objectForKey:key];
    if (![currentObject isEqual:inObject]) {
        [keychainItemData setObject:inObject forKey:key];
        [self writeToKeychain];
    }
}

- (id)objectForKey:(id)key
{
    return [keychainItemData objectForKey:key];
}

- (void)resetKeychainItem
{
	OSStatus junk = noErr;
    if (!keychainItemData)  {
        self.keychainItemData = [[NSMutableDictionary alloc] init];
    } else if (keychainItemData) {
        NSMutableDictionary *tempDictionary = [self dictionaryToSecItemFormat:keychainItemData];
		junk = SecItemDelete((CFDictionaryRef)tempDictionary);
        NSAssert( junk == noErr || junk == errSecItemNotFound,@"Problem deleting current dictionary.");
    }
    
    // Default attributes for keychain item.
    [keychainItemData setObject:@"" forKey:(id)kSecAttrAccount];
    [keychainItemData setObject:@"" forKey:(id)kSecAttrLabel];
    [keychainItemData setObject:@"" forKey:(id)kSecAttrDescription];
    
	// Default data for keychain item.
    [keychainItemData setObject:@"" forKey:(id)kSecValueData];
}

- (NSMutableDictionary*)dictionaryToSecItemFormat:(NSDictionary*)dictionaryToConvert
{
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    [returnDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];

    NSString *passwordString = [dictionaryToConvert objectForKey:(id)kSecValueData];
    [returnDictionary setObject:[passwordString dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
    
    return returnDictionary;
}

- (NSMutableDictionary*)secItemFormatToDictionary:(NSDictionary*)dictionaryToConvert
{
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    [returnDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [returnDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
    NSData *passwordData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)returnDictionary,(CFTypeRef*)&passwordData) == noErr) {
        [returnDictionary removeObjectForKey:(id)kSecReturnData];
        
        // Add the password to the dictionary, converting from NSData to NSString.
        NSString *password = [[[NSString alloc] initWithBytes:[passwordData bytes] length:[passwordData length] 
                                                     encoding:NSUTF8StringEncoding] autorelease];
        [returnDictionary setObject:password forKey:(id)kSecValueData];
    } else {
        NSAssert(NO, @"Serious error, no matching item found in the keychain.\n");
    }
    
    [passwordData release];
	return returnDictionary;
}

- (void)writeToKeychain
{
    NSDictionary *attributes = NULL;
    NSMutableDictionary *updateItem = NULL;
	OSStatus result;
    
    if (SecItemCopyMatching((CFDictionaryRef)genericPasswordQuery,(CFTypeRef*)&attributes) == noErr) {
        updateItem = [NSMutableDictionary dictionaryWithDictionary:attributes];
        [updateItem setObject:[genericPasswordQuery objectForKey:(id)kSecClass] forKey:(id)kSecClass];
        NSMutableDictionary *tempCheck = [self dictionaryToSecItemFormat:keychainItemData];
        [tempCheck removeObjectForKey:(id)kSecClass];
#if TARGET_IPHONE_SIMULATOR
		[tempCheck removeObjectForKey:(id)kSecAttrAccessGroup];
#endif
        result = SecItemUpdate((CFDictionaryRef)updateItem,(CFDictionaryRef)tempCheck);
		NSAssert( result == noErr, @"Couldn't update the Keychain Item." );
    }
    else {
        result = SecItemAdd((CFDictionaryRef)[self dictionaryToSecItemFormat:keychainItemData],NULL);
		NSAssert( result == noErr, @"Couldn't add the Keychain Item." );
    }
}

@end
