//
// Sponsor.h
// GS&MD
//
// Created by Lucas Correia on 2016/12/01 15:28:53 -0200.
// Copyright (c) Atlantic Solutions. All rights reserved.
//
// Note: Classe para representação do objeto de dados do Patrocinador do projeto GSMD.
//

#import "Sponsor.h"

@implementation Sponsor

@synthesize sponsorLink, image, imageUrl, name;

#pragma mark - Init

- (id)init
{
	self = [super init];
	if (self)
	{
		[self defaultObject];
	}
	return self;
}

#pragma mark - Protocol Methods

+ (Sponsor*)newObject
{
	return [Sponsor new];
}

+ (NSString*)className
{
	return @"Sponsor";
}

+ (Sponsor*)createObjectFromDictionary:(NSDictionary*)dicData
{
	Sponsor* newSponsor;

	NSArray* keysList = [dicData allKeys];

	if (keysList.count > 0)
	{
		newSponsor = [Sponsor new];
		//
		newSponsor.sponsorLink = [keysList containsObject:@"link"] ? [NSString stringWithFormat:@"%@", [dicData valueForKey:@"link"]] : @"";
		//
		newSponsor.imageUrl = [keysList containsObject:@"image_url"] ? [NSString stringWithFormat:@"%@", [dicData valueForKey:@"image_url"]] : @"";
        //
        newSponsor.name = [keysList containsObject:@"name"] ? [NSString stringWithFormat:@"%@", [dicData valueForKey:@"name"]] : @"";
	}

	return newSponsor;
}

- (NSDictionary*)dictionaryJSON
{
	NSMutableDictionary *dic = [NSMutableDictionary new];
	//
	[dic setValue:self.sponsorLink forKey:@"link"];
	//
	[dic setValue:self.imageUrl forKey:@"image_url"];
	//
    [dic setValue:self.name forKey:@"name"];
    //
	return dic;
}

- (Sponsor*)copyObject
{
	Sponsor* copySponsor = [Sponsor new];
	//
	copySponsor.sponsorLink = [NSString stringWithFormat:@"%@", self.sponsorLink];
	//
	copySponsor.image = [UIImage imageWithCGImage:self.image.CGImage];
	//
	copySponsor.imageUrl = [NSString stringWithFormat:@"%@", self.imageUrl];
	//
    copySponsor.name = [NSString stringWithFormat:@"%@", self.name];
    //
	return copySponsor;
}

- (bool)isEqualToObject:(Sponsor*)object
{
	if(![self.sponsorLink isEqualToString:object.sponsorLink]){return false;}
	//
	if(![self.imageUrl isEqualToString:object.imageUrl]){return false;}
	//
    if(![self.name isEqualToString:object.name]){return false;}
    //
	return true;
}

- (void)defaultObject
{
	sponsorLink = @"";
	image = nil;
	imageUrl = @"";
    name = @"";
}

- (void)updateObjectFromJSON:(NSDictionary*)dicData reseting:(bool)reset
{
	NSArray* keysList = [dicData allKeys];

	if (keysList.count > 0)
	{
		self.sponsorLink = [keysList containsObject:@"sponsorLink"] ? [NSString stringWithFormat:@"%@", [dicData valueForKey:@"sponsorLink"]] : (reset ? @"" : self.sponsorLink);
		//
		self.imageUrl = [keysList containsObject:@"image_url"] ? [NSString stringWithFormat:@"%@", [dicData valueForKey:@"image_url"]] : (reset ? @"" : self.imageUrl);
        //
        self.name = [keysList containsObject:@"name"] ? [NSString stringWithFormat:@"%@", [dicData valueForKey:@"name"]] : (reset ? @"" : self.imageUrl);
	}
}

@end
