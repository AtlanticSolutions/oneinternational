//
// GroupChat.h
// GS&MD
//
// Created by Lucas Correia on 2016/12/05 19:03:45 -0200.
// Copyright (c) Atlantic Solutions. All rights reserved.
//
// Note: Classe para representação do objeto de dados do Grupo de Chat do projeto GSMD.
//

#import "GroupChat.h"

@implementation GroupChat

@synthesize groupId, groupName;

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

+ (GroupChat*)newObject
{
	return [GroupChat new];
}

+ (NSString*)className
{
	return @"GroupChat";
}

+ (GroupChat*)createObjectFromDictionary:(NSDictionary*)dicData
{
	GroupChat* newGroupChat;

	NSArray* keysList = [dicData allKeys];

	if (keysList.count > 0)
	{
		newGroupChat = [GroupChat new];
		//
		newGroupChat.groupId = [keysList containsObject:@"id"] ? [[dicData valueForKey:@"id"] intValue] : 0;
		//
		newGroupChat.groupName = [keysList containsObject:@"name"] ? [NSString stringWithFormat:@"%@", [dicData valueForKey:@"name"]] : @"";
	}

	return newGroupChat;
}

- (NSDictionary*)dictionaryJSON
{
	NSMutableDictionary *dic = [NSMutableDictionary new];
	//
	[dic setValue:@(self.groupId) forKey:@"id"];
	//
	[dic setValue:self.groupName forKey:@"name"];
	//
	return dic;
}

- (GroupChat*)copyObject
{
	GroupChat* copyGroupChat = [GroupChat new];
	//
	copyGroupChat.groupId = self.groupId;
	//
	copyGroupChat.groupName = [NSString stringWithFormat:@"%@", self.groupName];
	//
	return copyGroupChat;
}

- (bool)isEqualToObject:(GroupChat*)object
{
	if(self.groupId != object.groupId){return false;}
	//
	if(![self.groupName isEqualToString:object.groupName]){return false;}
	//
	return true;
}

- (void)defaultObject
{
	groupId = 0;
	groupName = @"";
}

- (void)updateObjectFromJSON:(NSDictionary*)dicData reseting:(bool)reset
{
	NSArray* keysList = [dicData allKeys];

	if (keysList.count > 0)
	{
		//
		self.groupId = [keysList containsObject:@"id"] ? [[dicData valueForKey:@"id"] intValue] : (reset ? 0 : self.groupId);
		//
		self.groupName = [keysList containsObject:@"name"] ? [NSString stringWithFormat:@"%@", [dicData valueForKey:@"name"]] : (reset ? @"" : self.groupName);
	}
}

@end
