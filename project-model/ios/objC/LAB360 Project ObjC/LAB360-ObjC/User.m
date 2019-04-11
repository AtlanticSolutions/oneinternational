//
//  User.m
//  AHK-100anos
//
//  Created by Erico GT on 10/5/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "User.h"
#import "ConstantsManager.h"

#define CLASS_USER_DEFAULT @"app_user"
#define CLASS_USER_KEY_ID @"id"
#define CLASS_USER_KEY_ACCOUNT_ID @"account_id"
#define CLASS_USER_KEY_NAME @"first_name"
#define CLASS_USER_KEY_CATEGORY @"interest_areas"
#define CLASS_USER_KEY_SECTOR_ID @"sector_id"
#define CLASS_USER_KEY_SECTOR_NAME @"sector"
#define CLASS_USER_KEY_PHONE @"phone"
#define CLASS_USER_KEY_CPF @"cpf"
#define CLASS_USER_KEY_RG @"rg"
#define CLASS_USER_KEY_GENDER @"gender"
#define CLASS_USER_KEY_EMAIL @"email"
#define CLASS_USER_KEY_PASSWORD @"password"
#define CLASS_USER_KEY_CITY @"city"
#define CLASS_USER_KEY_STATE @"state"
#define CLASS_USER_KEY_COUNTRY @"country"
#define CLASS_USER_KEY_CNPJ @"company_tax_number"
#define CLASS_USER_KEY_COMPANY @"company_name"
#define CLASS_USER_KEY_ZIPCODE @"zipcode"
#define CLASS_USER_KEY_ADDRESS @"address"
#define CLASS_USER_KEY_POSITION @"company_position"
#define CLASS_USER_KEY_JOB_ROLE @"job_role_id"
#define CLASS_USER_KEY_ROLE_DESCRIPTION @"job_role" //EricoGT: antes era 'role_description', mas o servidor não devolve mais este nome
#define CLASS_USER_KEY_ROLE @"role"
#define CLASS_USER_KEY_IMAGE @"base64_profile_image"
#define CLASS_USER_KEY_URL_IMAGE @"profile_image"
#define CLASS_USER_KEY_CHAT_BLOCKED @"bloqueado"
#define CLASS_USER_KEY_CHAT_NOT_READ @"not_read"
#define CLASS_USER_KEY_BIRTHDATE @"birthdate"
#define CLASS_USER_KEY_COMPLEMENT @"complement"
#define CLASS_USER_KEY_DISTRICT @"district"
#define CLASS_USER_KEY_ADDRESS_NUMBER @"number"
#define CLASS_USER_KEY_MOBILE_PHONE @"cell_phone"
#define CLASS_USER_KEY_MOBILE_PHONE_DDD @"ddd_cell_phone"
#define CLASS_USER_KEY_PHONE_DDD @"ddd_phone"

@implementation User

@synthesize userID, accountID, notReadCount, name, email, phone, password, CPF, RG, gender, company, CNPJ, address, zipCode, city, country, state, role, jobRole, jobRoleDescription, profilePic, urlProfilePic, sectorID, sectorName, category, chatBlocked, birthdate, complement, district, addressNumber, mobilePhone, mobilePhoneDDD, phoneDDD;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        userID = DOMP_OPD_INT;
        accountID = APP_ACCOUNT_ID;
        name = DOMP_OPD_STRING;
        email = DOMP_OPD_STRING;
        CPF = DOMP_OPD_STRING;
        RG = DOMP_OPD_STRING;
        gender = DOMP_OPD_STRING;
        password = DOMP_OPD_STRING;
        phone = DOMP_OPD_STRING;
        zipCode = DOMP_OPD_STRING;
        city = DOMP_OPD_STRING;
        country = DOMP_OPD_STRING;
        state = DOMP_OPD_STRING;
        address = DOMP_OPD_STRING;
        CNPJ = DOMP_OPD_STRING;
        company = DOMP_OPD_STRING;
		jobRoleDescription = DOMP_OPD_STRING;
        jobRole = DOMP_OPD_NUMBER;
		role = DOMP_OPD_STRING;
        profilePic = DOMP_OPD_IMAGE;
        urlProfilePic = DOMP_OPD_STRING;
        sectorName = DOMP_OPD_STRING;
        sectorID = DOMP_OPD_INT;
        category = [NSMutableArray new];
        chatBlocked = DOMP_OPD_BOOLEAN;
		notReadCount = DOMP_OPD_INT;
        birthdate = DOMP_OPD_DATE;
        addressNumber = DOMP_OPD_STRING;
        complement = DOMP_OPD_STRING;
        district = DOMP_OPD_STRING;
        mobilePhone = DOMP_OPD_STRING;
        mobilePhoneDDD = DOMP_OPD_STRING;
        phoneDDD = DOMP_OPD_STRING;
    }
    
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - DefaultObjectModelProtocol
//-------------------------------------------------------------------------------------------------------------
+(User*)newObject
{
    User *u = [User new];
    return u;
}

+(NSString*)className
{
    return CLASS_USER_DEFAULT;
}

+(User*)createObjectFromDictionary:(NSDictionary*)dicData
{
    User *u = [User new];
    
    //NSDictionary *dic = [dicData valueForKey:[User className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        u.userID = [keysList containsObject:CLASS_USER_KEY_ID] ? [[neoDic  valueForKey:CLASS_USER_KEY_ID] intValue] : u.userID;
        //u.accountID = [keysList containsObject:CLASS_USER_KEY_ACCOUNT_ID] ? [[neoDic  valueForKey:CLASS_USER_KEY_ACCOUNT_ID] intValue] : u.accountID;
        u.name = [keysList containsObject:CLASS_USER_KEY_NAME] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_NAME]] : u.name;
        u.sectorName = [keysList containsObject:CLASS_USER_KEY_SECTOR_NAME] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_SECTOR_NAME]] : u.sectorName;
        u.CPF = [keysList containsObject:CLASS_USER_KEY_CPF] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_CPF]] : u.CPF;
        u.RG = [keysList containsObject:CLASS_USER_KEY_RG] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_RG]] : u.RG;
        
        NSString *gender = [keysList containsObject:CLASS_USER_KEY_GENDER] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_GENDER]] : u.gender;
        if ([[gender uppercaseString] isEqualToString:@"MALE"]) {
            u.gender = [NSString stringWithFormat:@"%@", NSLocalizedString(@"PLACEHOLDER_GENDER_MALE", @"")];
        } else if ([[gender uppercaseString] isEqualToString:@"FEMALE"]) {
            u.gender = [NSString stringWithFormat:@"%@", NSLocalizedString(@"PLACEHOLDER_GENDER_FEMALE", @"")];
        }
      
        u.phone = [keysList containsObject:CLASS_USER_KEY_PHONE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_PHONE]] : u.phone;
        u.password = [keysList containsObject:CLASS_USER_KEY_PASSWORD] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_PASSWORD]] : u.password;
        u.email = [keysList containsObject:CLASS_USER_KEY_EMAIL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_EMAIL]] : u.email;
        u.address = [keysList containsObject:CLASS_USER_KEY_ADDRESS] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_ADDRESS]] : u.address;
        u.city = [keysList containsObject:CLASS_USER_KEY_CITY] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_CITY]] : u.city;
        u.state = [keysList containsObject:CLASS_USER_KEY_STATE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_STATE]] : u.state;
        u.country = [keysList containsObject:CLASS_USER_KEY_COUNTRY] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_COUNTRY]] : u.country;
        u.company = [keysList containsObject:CLASS_USER_KEY_COMPANY] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_COMPANY]] : u.company;
        u.CNPJ = [keysList containsObject:CLASS_USER_KEY_CNPJ] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_CNPJ]] : u.CNPJ;
        u.zipCode = [keysList containsObject:CLASS_USER_KEY_ZIPCODE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_ZIPCODE]] : u.zipCode;
		
		if([keysList containsObject:CLASS_USER_KEY_JOB_ROLE]){
			id value = [neoDic objectForKey:CLASS_USER_KEY_JOB_ROLE];
			
			if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNull class]]) {
				u.jobRole = @0;
			}
			else if(value){
				u.jobRole = [neoDic  valueForKey:CLASS_USER_KEY_JOB_ROLE];
			}
		}
		u.jobRoleDescription = [keysList containsObject:CLASS_USER_KEY_ROLE_DESCRIPTION] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_ROLE_DESCRIPTION]] : u.jobRoleDescription;
		u.role = [keysList containsObject:CLASS_USER_KEY_ROLE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_ROLE]] : u.role;
        u.profilePic = [keysList containsObject:CLASS_USER_KEY_IMAGE] ? [ToolBox graphicHelper_DecodeBase64ToImage:[NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_IMAGE]]]  : u.profilePic;
        u.urlProfilePic = [keysList containsObject:CLASS_USER_KEY_URL_IMAGE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_URL_IMAGE]] : u.urlProfilePic;
        u.sectorID = [keysList containsObject:CLASS_USER_KEY_SECTOR_ID] ? [[neoDic  valueForKey:CLASS_USER_KEY_SECTOR_ID] intValue] : u.sectorID;
        u.chatBlocked = [keysList containsObject:CLASS_USER_KEY_CHAT_BLOCKED] ? [[neoDic  valueForKey:CLASS_USER_KEY_CHAT_BLOCKED] boolValue] : u.chatBlocked;
        
        if([keysList containsObject:CLASS_USER_KEY_CATEGORY])
        {
           u.category = [[NSMutableArray alloc] initWithArray:[neoDic valueForKey:CLASS_USER_KEY_CATEGORY]];
        }
		
		u.notReadCount = [keysList containsObject:CLASS_USER_KEY_CHAT_NOT_READ] ? [[neoDic  valueForKey:CLASS_USER_KEY_CHAT_NOT_READ] intValue] : u.notReadCount;
        u.birthdate = [keysList containsObject:CLASS_USER_KEY_BIRTHDATE] ? [ToolBox dateHelper_DateFromString:[NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_BIRTHDATE]] withFormat:TOOLBOX_DATA_HIFEN_CURTA_INVERTIDA] : u.birthdate;
        u.complement = [keysList containsObject:CLASS_USER_KEY_COMPLEMENT] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_COMPLEMENT]] : u.complement;
        u.district = [keysList containsObject:CLASS_USER_KEY_DISTRICT] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_DISTRICT]] : u.district;
        u.addressNumber = [keysList containsObject:CLASS_USER_KEY_ADDRESS_NUMBER] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_ADDRESS_NUMBER]] : u.addressNumber;
        u.mobilePhone = [keysList containsObject:CLASS_USER_KEY_MOBILE_PHONE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_MOBILE_PHONE]] : u.phone;
        u.mobilePhoneDDD = [keysList containsObject:CLASS_USER_KEY_MOBILE_PHONE_DDD] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_MOBILE_PHONE_DDD]] : u.mobilePhoneDDD;
        u.phoneDDD = [keysList containsObject:CLASS_USER_KEY_PHONE_DDD] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_USER_KEY_PHONE_DDD]] : u.phoneDDD;
    }
    
    return u;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    [dicData  setValue:@(self.userID) forKey:CLASS_USER_KEY_ID];
    //[dicData  setValue:@(self.accountID) forKey:CLASS_USER_KEY_ACCOUNT_ID];
    [dicData  setValue:@(self.sectorID) forKey:CLASS_USER_KEY_SECTOR_ID];
    [dicData  setValue:self.name forKey:CLASS_USER_KEY_NAME];
    [dicData  setValue:self.sectorName forKey:CLASS_USER_KEY_SECTOR_NAME];
    [dicData  setValue:self.password forKey:CLASS_USER_KEY_PASSWORD];
    [dicData  setValue:self.email forKey:CLASS_USER_KEY_EMAIL];
    [dicData  setValue:self.CPF forKey:CLASS_USER_KEY_CPF];
    [dicData  setValue:self.RG forKey:CLASS_USER_KEY_RG];
    
    if ([self.gender isEqualToString:[NSString stringWithFormat:@"%@", NSLocalizedString(@"PLACEHOLDER_GENDER_MALE", @"")]]) {
        [dicData setValue:@"male" forKey:CLASS_USER_KEY_GENDER];
    } else if ([self.gender isEqualToString:[NSString stringWithFormat:@"%@", NSLocalizedString(@"PLACEHOLDER_GENDER_FEMALE", @"")]]) {
        [dicData setValue:@"female" forKey:CLASS_USER_KEY_GENDER];
    }else{
        [dicData setValue:@"" forKey:CLASS_USER_KEY_GENDER];
    }
    
    [dicData  setValue:self.phone forKey:CLASS_USER_KEY_PHONE];
    [dicData  setValue:self.company forKey:CLASS_USER_KEY_COMPANY];
    [dicData  setValue:self.CNPJ forKey:CLASS_USER_KEY_CNPJ];
	if ([self.jobRole integerValue] != 0) {
		[dicData  setValue:self.jobRole forKey:CLASS_USER_KEY_JOB_ROLE];
	}
	[dicData  setValue:self.jobRoleDescription forKey:CLASS_USER_KEY_ROLE_DESCRIPTION];
	[dicData  setValue:self.role forKey:CLASS_USER_KEY_ROLE];
    [dicData  setValue:self.address forKey:CLASS_USER_KEY_ADDRESS];
    [dicData  setValue:self.zipCode forKey:CLASS_USER_KEY_ZIPCODE];
    [dicData  setValue:self.city forKey:CLASS_USER_KEY_CITY];
    [dicData  setValue:self.state forKey:CLASS_USER_KEY_STATE];
    [dicData  setValue:self.country forKey:CLASS_USER_KEY_COUNTRY];
    [dicData  setValue:self.category forKey:CLASS_USER_KEY_CATEGORY];
    NSString *base64 = [ToolBox graphicHelper_EncodeToBase64String:self.profilePic];
    [dicData  setValue: (base64 ? base64 : @"") forKey:CLASS_USER_KEY_IMAGE];
    [dicData  setValue:self.urlProfilePic forKey:CLASS_USER_KEY_URL_IMAGE];
    [dicData  setValue:@(self.chatBlocked) forKey:CLASS_USER_KEY_CHAT_BLOCKED];
	[dicData  setValue:@(self.notReadCount) forKey:CLASS_USER_KEY_CHAT_NOT_READ];
    [dicData  setValue:(self.birthdate != nil ? [ToolBox dateHelper_StringFromDate:self.birthdate withFormat:TOOLBOX_DATA_HIFEN_CURTA_INVERTIDA] : @"")   forKey:CLASS_USER_KEY_BIRTHDATE];
    [dicData  setValue:self.complement forKey:CLASS_USER_KEY_COMPLEMENT];
    [dicData  setValue:self.district forKey:CLASS_USER_KEY_DISTRICT];
    [dicData  setValue:self.addressNumber forKey:CLASS_USER_KEY_ADDRESS_NUMBER];
    [dicData  setValue:self.mobilePhone forKey:CLASS_USER_KEY_MOBILE_PHONE];
    [dicData  setValue:self.mobilePhoneDDD forKey:CLASS_USER_KEY_MOBILE_PHONE_DDD];
    [dicData  setValue:self.phoneDDD forKey:CLASS_USER_KEY_PHONE_DDD];
    //
    NSMutableDictionary *dicFinal = [NSMutableDictionary new];
    [dicFinal setValue:dicData forKey:[User className]];
    return dicFinal;
}

- (NSDictionary*)dictionaryJSON_NoImage
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    [dicData  setValue:@(self.userID) forKey:CLASS_USER_KEY_ID];
    //[dicData  setValue:@(self.accountID) forKey:CLASS_USER_KEY_ACCOUNT_ID];
    [dicData  setValue:@(self.sectorID) forKey:CLASS_USER_KEY_SECTOR_ID];
    [dicData  setValue:self.name forKey:CLASS_USER_KEY_NAME];
    [dicData  setValue:self.sectorName forKey:CLASS_USER_KEY_SECTOR_NAME];
    [dicData  setValue:self.password forKey:CLASS_USER_KEY_PASSWORD];
    [dicData  setValue:self.email forKey:CLASS_USER_KEY_EMAIL];
    [dicData  setValue:self.CPF forKey:CLASS_USER_KEY_CPF];
    [dicData  setValue:self.RG forKey:CLASS_USER_KEY_RG];
    
    if ([self.gender isEqualToString:[NSString stringWithFormat:@"%@", NSLocalizedString(@"PLACEHOLDER_GENDER_MALE", @"")]]) {
        [dicData setValue:@"male" forKey:CLASS_USER_KEY_GENDER];
    } else if ([self.gender isEqualToString:[NSString stringWithFormat:@"%@", NSLocalizedString(@"PLACEHOLDER_GENDER_FEMALE", @"")]]) {
        [dicData setValue:@"female" forKey:CLASS_USER_KEY_GENDER];
    }else{
        [dicData setValue:@"" forKey:CLASS_USER_KEY_GENDER];
    }
    
    [dicData  setValue:self.phone forKey:CLASS_USER_KEY_PHONE];
    [dicData  setValue:self.company forKey:CLASS_USER_KEY_COMPANY];
    [dicData  setValue:self.CNPJ forKey:CLASS_USER_KEY_CNPJ];
	if ([self.jobRole integerValue] != 0) {
		[dicData  setValue:self.jobRole forKey:CLASS_USER_KEY_JOB_ROLE];
	
	[dicData  setValue:self.jobRoleDescription forKey:CLASS_USER_KEY_ROLE_DESCRIPTION];
	}
	[dicData  setValue:self.role forKey:CLASS_USER_KEY_ROLE];
    [dicData  setValue:self.address forKey:CLASS_USER_KEY_ADDRESS];
    [dicData  setValue:self.zipCode forKey:CLASS_USER_KEY_ZIPCODE];
    [dicData  setValue:self.city forKey:CLASS_USER_KEY_CITY];
    [dicData  setValue:self.state forKey:CLASS_USER_KEY_STATE];
    [dicData  setValue:self.country forKey:CLASS_USER_KEY_COUNTRY];
    [dicData  setValue:self.category forKey:CLASS_USER_KEY_CATEGORY];
    //NSString *base64 = [ToolBox graphicHelper_EncodeToBase64String:self.profilePic];
    //[dicData  setValue: (base64 ? base64 : @"") forKey:CLASS_USER_KEY_IMAGE];
    //[dicData  setValue:self.urlProfilePic forKey:CLASS_USER_KEY_URL_IMAGE];
    [dicData setValue:@(self.chatBlocked) forKey:CLASS_USER_KEY_CHAT_BLOCKED];
	[dicData  setValue:@(self.notReadCount) forKey:CLASS_USER_KEY_CHAT_NOT_READ];
    //[dicData  setValue:self.authorizedEventsList forKey:CLASS_USER_KEY_AUTHORIZED_EVENTS];
    //                                              forKey:CLASS_USER_KEY_PARTICULAR_DATA];
    [dicData  setValue:(self.birthdate != nil ? [ToolBox dateHelper_StringFromDate:self.birthdate withFormat:TOOLBOX_DATA_HIFEN_CURTA_INVERTIDA] : @"")   forKey:CLASS_USER_KEY_BIRTHDATE];
    [dicData  setValue:self.complement forKey:CLASS_USER_KEY_COMPLEMENT];
    [dicData  setValue:self.district forKey:CLASS_USER_KEY_DISTRICT];
    [dicData  setValue:self.addressNumber forKey:CLASS_USER_KEY_ADDRESS_NUMBER];
    [dicData  setValue:self.mobilePhone forKey:CLASS_USER_KEY_MOBILE_PHONE];
    [dicData  setValue:self.mobilePhoneDDD forKey:CLASS_USER_KEY_MOBILE_PHONE_DDD];
    [dicData  setValue:self.phoneDDD forKey:CLASS_USER_KEY_PHONE_DDD];
    //
    NSMutableDictionary *dicFinal = [NSMutableDictionary new];
    [dicFinal setValue:dicData forKey:[User className]];
    return dicFinal;
}

- (User *) copyObject
{
    User *u = [User new];
    u.userID = self.userID;
    u.accountID = self.accountID;
    u.sectorID = self.sectorID;
	u.notReadCount = self.notReadCount;
    u.sectorName = [NSString stringWithFormat:@"%@", self.sectorName];
    u.category = [[NSMutableArray alloc] initWithArray:self.category];
    u.name = [NSString stringWithFormat:@"%@", self.name];
    u.CPF = [NSString stringWithFormat:@"%@", self.CPF];
    u.RG = [NSString stringWithFormat:@"%@", self.RG];
    u.gender = [NSString stringWithFormat:@"%@", self.gender];
    u.country = [NSString stringWithFormat:@"%@", self.country];;
    u.state = [NSString stringWithFormat:@"%@", self.state];
    u.company = [NSString stringWithFormat:@"%@", self.company];
    u.city = [NSString stringWithFormat:@"%@", self.city];
    u.zipCode = [NSString stringWithFormat:@"%@", self.zipCode];
    u.email = [NSString stringWithFormat:@"%@", self.email];
    u.CNPJ = [NSString stringWithFormat:@"%@", self.CNPJ];
    u.jobRole = self.jobRole;
	u.jobRoleDescription = [NSString stringWithFormat:@"%@", self.jobRoleDescription];
	u.role = [NSString stringWithFormat:@"%@", self.role];
    u.address = [NSString stringWithFormat:@"%@", self.address];
    u.profilePic = [UIImage imageWithCGImage:self.profilePic.CGImage];
    u.password = [NSString stringWithFormat:@"%@", self.password];
    u.phone = [NSString stringWithFormat:@"%@", self.phone];
    u.urlProfilePic = [NSString stringWithFormat:@"%@", self.urlProfilePic];
    u.chatBlocked = self.chatBlocked;
    u.birthdate = (self.birthdate==nil) ? nil : [[NSDate alloc] initWithTimeInterval:0 sinceDate:self.birthdate];
    u.complement = [NSString stringWithFormat:@"%@", self.complement];
    u.district = [NSString stringWithFormat:@"%@", self.district];
    u.addressNumber = [NSString stringWithFormat:@"%@", self.addressNumber];
    u.mobilePhone = [NSString stringWithFormat:@"%@", self.mobilePhone];
    u.mobilePhoneDDD = [NSString stringWithFormat:@"%@", self.mobilePhoneDDD];
    u.phoneDDD = [NSString stringWithFormat:@"%@", self.phoneDDD];
    //
    //u.authorizedEventsList = [[NSMutableArray alloc]initWithArray:authorizedEventsList];
    
    return u;
}

-(bool)isEqualToObject:(User *)object;
{
    if(self.userID != object.userID)
    {
        return false;
    }
//    else if(self.accountID != object.accountID)
//    {
//        return false;
//    }
    else if(self.sectorID != object.sectorID)
    {
        return false;
    }
    else if(![self.name isEqualToString:object.name])
    {
        return false;
    }
    else if(![self.sectorName isEqualToString:object.sectorName])
    {
        return false;
    }
    else if(![self.CPF isEqualToString:object.CPF])
    {
        return false;
    }
    else if(![self.RG isEqualToString:object.RG])
    {
        return false;
    }
    else if(![self.gender isEqualToString:object.gender])
    {
        return false;
    }
    else if(![self.CNPJ isEqualToString:object.CNPJ])
    {
        return false;
    }
    else if(![self.country isEqualToString:object.country])
    {
        return false;
    }
    else if(![self.state isEqualToString:object.state])
    {
        return false;
    }
    else if(![self.city isEqualToString:object.city])
    {
        return false;
    }
    else if(![self.zipCode isEqualToString:object.zipCode])
    {
        return false;
    }
    else if(![self.company isEqualToString:object.company])
    {
        return false;
    }
    else if(![self.jobRole isEqualToNumber:object.jobRole])
    {
        return false;
    }
	else if(![self.jobRoleDescription isEqualToString:object.jobRoleDescription])
	{
		return false;
	}
	else if(![self.role isEqualToString:object.role])
	{
		return false;
	}
	else if(![self.urlProfilePic isEqualToString:object.urlProfilePic])
    {
        return false;
    }
    else if(![self.phone isEqualToString:object.phone])
    {
        return false;
    }
    else if(![self.email isEqualToString:object.email])
    {
        return false;
    }
    else if(![self.address isEqualToString:object.address])
    {
        return false;
    }else if(self.chatBlocked != object.chatBlocked){
        return false;
    }
    else if (![self.birthdate isEqualToDate: object.birthdate]) {
        return false;
    }
    else if (![self.complement isEqualToString: object.complement]) {
        return false;
    }
    else if (![self.district isEqualToString: object.district]) {
        return false;
    }
    else if (![self.addressNumber isEqualToString: object.addressNumber]) {
        return false;
    }
    else if(![self.mobilePhone isEqualToString:object.mobilePhone])
    {
        return false;
    }
    else if(![self.mobilePhoneDDD isEqualToString:object.mobilePhoneDDD])
    {
        return false;
    }
    else if(![self.phoneDDD isEqualToString:object.phoneDDD])
    {
        return false;
    }
	
	if(self.notReadCount != object.notReadCount)
	{
		return false;
	}

	
    for (NSNumber *i in self.category) {
        if(![object.category containsObject:i])
        {
            return false;
        }
    }
    return true;
}

@end
