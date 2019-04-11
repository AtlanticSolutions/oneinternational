//
//  Localisator.m
//  Lab360
//
//  Created by Rodrigo Baroni on 14/08/2018.
//

#import "Localisator.h"

static NSString * const kSaveLanguageDefaultKey = @"kSaveLanguageDefaultKey";


@interface Localisator()

@property NSDictionary * dicoLocalisation;
@property NSUserDefaults * defaults;

@end

@implementation Localisator


#pragma  mark - Singleton Method

+ (Localisator*)sharedInstance
{
    static Localisator *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[Localisator alloc] init];
    });
    return _sharedInstance;
}


#pragma mark - Init methods

- (id)init
{
    self = [super init];
    if (self)
    {
        _defaults                       = [NSUserDefaults standardUserDefaults];
        _availableLanguagesArray        = @[@"DeviceLanguageKey_Default", @"DeviceLanguageKey_en"/*,@"German_de",@"Spanish_es"*/, @"DeviceLanguageKey_pt-BR"]; //
        _dicoLocalisation               = nil;
        _currentLanguage                = @"DeviceLanguageKey_Default";
        
        NSString * languageSaved = [_defaults objectForKey:kSaveLanguageDefaultKey];
        
        if (languageSaved != nil && ![languageSaved isEqualToString:@"DeviceLanguageKey_Default"])
        {
            [self loadDictionaryForLanguage:languageSaved];
        }
    }
    return self;
}


#pragma mark - saveInIUserDefaults custom accesser/setter

-(BOOL)saveInUserDefaults
{
    return ([self.defaults objectForKey:kSaveLanguageDefaultKey] != nil);
}

-(void)setSaveInUserDefaults:(BOOL)saveInUserDefaults
{
    if (saveInUserDefaults)
    {
        [self.defaults setObject:_currentLanguage forKey:kSaveLanguageDefaultKey];
    }
    else
    {
        [self.defaults removeObjectForKey:kSaveLanguageDefaultKey];
    }
    [self.defaults synchronize];
}

#pragma mark - Private  Instance methods

-(BOOL)loadDictionaryForLanguage:(NSString *)newLanguage
{
    NSArray * arrayExt = [newLanguage componentsSeparatedByString:@"_"];
    
    __block BOOL languageFound = NO;
    
    [arrayExt enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        
        NSURL * urlPath = [[NSBundle bundleForClass:[self class]] URLForResource:@"Localizable" withExtension:@"strings" subdirectory:nil localization:obj];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:urlPath.path])
        {
            self.currentLanguage = [newLanguage copy];
            self.dicoLocalisation = [[NSDictionary dictionaryWithContentsOfFile:urlPath.path] copy];
            
            languageFound = YES;
            *stop = YES;
        }
    }];
    
    return languageFound;
}


#pragma mark - Public Instance methods

-(NSString *)localizedStringForKey:(NSString*)key
{
    if (self.dicoLocalisation == nil)
    {
        return NSLocalizedString(key, key);
    }
    else
    {
        NSString * localizedString = self.dicoLocalisation[key];
        if (localizedString == nil)
            localizedString = key;
        return localizedString;
    }
}

-(BOOL)setLanguage:(NSString *)newLanguage
{
    if (newLanguage == nil || [newLanguage isEqualToString:self.currentLanguage] || ![self.availableLanguagesArray containsObject:newLanguage])
        return NO;
    
    if ([newLanguage isEqualToString:@"DeviceLanguageKey_Default"])
    {
        self.currentLanguage = [newLanguage copy];
        self.dicoLocalisation = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLanguageChanged
                                                            object:nil];
        return YES;
    }
    else
    {
        BOOL isLoadingOk = [self loadDictionaryForLanguage:newLanguage];
        
        if (isLoadingOk)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLanguageChanged
                                                                object:nil];
            //if ([self saveInUserDefaults])
            //{
                [self.defaults setObject:_currentLanguage forKey:kSaveLanguageDefaultKey];
                [self.defaults synchronize];
            //}
        }
        return isLoadingOk;
    }
}


@end
