//
//  Config.h
//  Braingle
//
//  Created by ocs on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define CATEGORYTYPE_URL(category,udid)  [NSString stringWithFormat:@"http://www.braingle.com/iphone/bt/list.php?cat=%@&udid=%@",category,udid]

#define DETAILVIEW_URL(id,udid)          [NSString stringWithFormat:@"http://www.braingle.com/iphone/bt/teaser_web.php?id=%@&udid=%@",id,udid]

#define FEATURED_URL(udid)              [NSString stringWithFormat:@"http://www.braingle.com/iphone/bt/featured.php?udid=%@",udid]

