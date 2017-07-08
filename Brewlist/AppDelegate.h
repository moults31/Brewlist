//
//  AppDelegate.h
//  Brewlist
//
//  Created by Zac Moulton on 2017-07-07.
//  Copyright © 2017 Zac Moulton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

