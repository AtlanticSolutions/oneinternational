//
//  Contact.m
//  AHK-100anos
//
//  Created by Lucas Correia Granados Castro on 24/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "Contact.h"

#define CLASS_CONTACT_DEFAULT @"contact"
#define CLASS_CONTACT_KEY_NAME @"first_name"
#define CLASS_CONTACT_KEY_DEPARTMENT @"responsible_role"
#define CLASS_CONTACT_KEY_DEPARTMENT_DESCRIPTION @"description"
#define CLASS_CONTACT_KEY_PHONE @"phone"
#define CLASS_CONTACT_KEY_EMAIL @"email"
#define CLASS_CONTACT_KEY_ROLE @"job_role_name"
#define CLASS_CONTACT_KEY_PROFILE_IMAGE @"image"
#define CLASS_CONTACT_KEY_LINKEDIN @"linkedin_url"
#define CLASS_CONTACT_KEY_FACEBOOK @"facebook_url"
#define CLASS_CONTACT_KEY_TWITTER @"twitter_url"
#define CLASS_CONTACT_KEY_IMAGE_URL @"image_url"

@implementation Contact

@synthesize name, department, departmentDescription, phone, email, role, imgProfile,linkedin, facebook, twitter, urlProfileImage;

- (id)init
{
    self = [super init];
    if (self)
    {
        name = DOMP_OPD_STRING;
        departmentDescription = DOMP_OPD_STRING;
        email = DOMP_OPD_STRING;
        phone = DOMP_OPD_STRING;
        role = DOMP_OPD_STRING;
        facebook = DOMP_OPD_STRING;
        linkedin = DOMP_OPD_STRING;
        twitter = DOMP_OPD_STRING;
        department = DOMP_OPD_STRING;
        imgProfile = DOMP_OPD_IMAGE;
        urlProfileImage = DOMP_OPD_STRING;
    }
    return self;
}

+ (Contact*)newObject
{
    Contact* c = [Contact new];
    return c;
}
+ (NSString*)className
{
    return CLASS_CONTACT_DEFAULT;
}
+ (Contact*)createObjectFromDictionary:(NSDictionary*)dicData
{
    Contact *c = [Contact new];
    
    NSArray *keysList = [dicData allKeys];
    
    if (keysList.count > 0)
    {
        c.name = [keysList containsObject:CLASS_CONTACT_KEY_NAME] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_CONTACT_KEY_NAME]] : c.name;
        c.department = [keysList containsObject:CLASS_CONTACT_KEY_DEPARTMENT] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_CONTACT_KEY_DEPARTMENT]] : c.department;
        c.departmentDescription = [keysList containsObject:CLASS_CONTACT_KEY_DEPARTMENT_DESCRIPTION] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_CONTACT_KEY_DEPARTMENT_DESCRIPTION]] : c.departmentDescription;
        c.role = [keysList containsObject:CLASS_CONTACT_KEY_ROLE] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_CONTACT_KEY_ROLE]] : c.role;
        c.email = [keysList containsObject:CLASS_CONTACT_KEY_EMAIL] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_CONTACT_KEY_EMAIL]] : c.email;
        c.phone = [keysList containsObject:CLASS_CONTACT_KEY_PHONE] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_CONTACT_KEY_PHONE]] : c.phone;
        c.facebook = [keysList containsObject:CLASS_CONTACT_KEY_FACEBOOK] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_CONTACT_KEY_FACEBOOK]] : c.facebook;
        c.linkedin = [keysList containsObject:CLASS_CONTACT_KEY_LINKEDIN] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_CONTACT_KEY_LINKEDIN]] : c.linkedin;
        c.twitter = [keysList containsObject:CLASS_CONTACT_KEY_TWITTER] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_CONTACT_KEY_TWITTER]] : c.twitter;
        //c.imgProfile = [keysList containsObject:CLASS_CONTACT_KEY_PROFILE_IMAGE] ? [ToolBox graphicHelper_DecodeBase64ToImage:[NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_CONTACT_KEY_PROFILE_IMAGE]]]  : c.imgProfile;
        c.urlProfileImage = [keysList containsObject:CLASS_CONTACT_KEY_IMAGE_URL] ? [NSString stringWithFormat:@"%@", [dicData  valueForKey:CLASS_CONTACT_KEY_IMAGE_URL]] : c.urlProfileImage;
    }
    
    return c;
}
- (Contact*)copyObject
{
    Contact* c = [Contact new];
    
    c.name = [NSString stringWithFormat:@"%@", self.name];
    c.departmentDescription = [NSString stringWithFormat:@"%@", self.departmentDescription];
    c.department = [NSString stringWithFormat:@"%@", self.department];
    c.phone = [NSString stringWithFormat:@"%@", self.phone];
    c.email = [NSString stringWithFormat:@"%@", self.email];
    c.role = [NSString stringWithFormat:@"%@", self.role];
    c.urlProfileImage = [NSString stringWithFormat:@"%@", self.urlProfileImage];
    c.facebook = [NSString stringWithFormat:@"%@", self.facebook];
    c.twitter = [NSString stringWithFormat:@"%@", self.twitter];
    c.linkedin = [NSString stringWithFormat:@"%@", self.linkedin];
    //
    if (self.imgProfile){
        c.imgProfile = [UIImage imageWithData:UIImagePNGRepresentation(self.imgProfile)];
    }

    return c;
}
- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setValue:self.name forKey:CLASS_CONTACT_KEY_NAME];
    [dic setValue:self.email forKey:CLASS_CONTACT_KEY_EMAIL];
    [dic setValue:self.department forKey:CLASS_CONTACT_KEY_DEPARTMENT];
    [dic setValue:self.departmentDescription forKey:CLASS_CONTACT_KEY_DEPARTMENT_DESCRIPTION];
    [dic setValue:self.phone forKey:CLASS_CONTACT_KEY_PHONE];
    [dic setValue:self.role forKey:CLASS_CONTACT_KEY_ROLE];
    [dic setValue:self.facebook forKey:CLASS_CONTACT_KEY_FACEBOOK];
    [dic setValue:self.twitter forKey:CLASS_CONTACT_KEY_TWITTER];
    [dic setValue:self.linkedin forKey:CLASS_CONTACT_KEY_LINKEDIN];
    [dic setValue:self.urlProfileImage forKey:CLASS_CONTACT_KEY_IMAGE_URL];
    
    return dic;
}

@end
