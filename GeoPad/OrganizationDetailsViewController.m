// Copyright 2012 ESRI
//
// All rights reserved under the copyright laws of the United States
// and applicable international laws, treaties, and conventions.
//
// You may freely redistribute and use this sample code, with or
// without modification, provided you include the original copyright
// notice and use restrictions.
//
// See the use restrictions at http://help.arcgis.com/en/sdk/10.0/usageRestrictions.htm
//

#import "OrganizationDetailsViewController.h"
#import "UserGroupsViewController.h"
#import "UserContentViewController.h"
#import "PortalExplorer.h"


#define kDefaultStyleString @"<style media=\"screen\" type=\"text/css\">html { -webkit-text-size-adjust: none; }</style>"

#define kSectionCount  1;


@interface OrganizationDetailsViewController()

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIWebView *descriptionWebView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, strong) AGSPortalInfo *portalInfo;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) AGSPortal *portal;
@property (nonatomic,strong) AGSCredential *credential;



- (void)addShadowToThumbnailImageView;

@end


@implementation OrganizationDetailsViewController

@synthesize nameLabel = _nameLabel;
@synthesize descriptionWebView = _descriptionWebView;
@synthesize scrollView = _scrollView;
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize portalInfo = _portalInfo;
@synthesize credential = _credential;
@synthesize tableView = _tableView;
@synthesize portal= _portal;

- (id)initWithPortalInfo:(AGSPortalInfo *)portalInfo andportal:(AGSPortal *)portal andcredential:(AGSCredential *)credential
{
    self = [super initWithNibName:@"OrganizationDetailsViewController" bundle:nil];
    if (self) {
        self.portalInfo = portalInfo;
        self.portal = portal;
        self.credential = credential;
    
    }
    return self;
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[AGSDevice currentDevice] isIPad]){ //ipad   
    
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    
        }
    
    

    
    
    //Use the organization's name if we connected to an organization subscription
    //else, use the portal's name
    self.nameLabel.text = self.portalInfo.organizationId ? self.portalInfo.organizationName : self.portalInfo.portalName; 
    
    //start loading thumbnail
    if (self.portalInfo.organizationThumbnail)
    {
        self.thumbnailImageView.image = self.portalInfo.organizationThumbnail;
    }        
    else if(self.portalInfo.portalThumbnail)
    {
        self.thumbnailImageView.image = self.portalInfo.portalThumbnail;
    }    
    else
    {
        self.thumbnailImageView.image = [UIImage imageNamed:@"defaultOrganization.png"];
    } 
    //add shadow to the thumbnail image. 
    [self addShadowToThumbnailImageView];

    
    //prepare the description
    self.descriptionWebView.hidden = NO; 
    if (self.portalInfo.organizationDescription && [self.portalInfo.organizationDescription length] > 0)
    {
        NSString *styleString = kDefaultStyleString;
        NSString *descriptionWithStyle = [styleString stringByAppendingString:self.portalInfo.organizationDescription];
        
      //  NSLog(@"%@", descriptionWithStyle);
        [self.descriptionWebView loadHTMLString:descriptionWithStyle baseURL:[NSURL URLWithString:@""]];       
       
    }
    
    else {
        self.descriptionWebView.hidden = YES;
    }    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Helper

- (void)addShadowToThumbnailImageView
{
    if([self.thumbnailImageView.layer respondsToSelector:@selector(setShadowColor:)])
    {
        self.thumbnailImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.thumbnailImageView.layer.shadowOpacity = 0.8;
        self.thumbnailImageView.layer.shadowRadius = 5;
        self.thumbnailImageView.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

-(CGSize)contentSizeForViewInPopover
{
    return self.view.bounds.size;
}



#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return kSectionCount;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return self.tableView.rowHeight;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger nRowCount = 2;

    return nRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
   
        
    
    
    //static cell identifiers.
    static NSString *mymapsCellIdentifier = @"mymapsCell";
    // static NSString *groupsAndContentsCellIdentifier = @"GroupsAndContentsCell";
    static NSString *mygroupsCellIdentifier = @"mygroupsCell";
 
    
    UITableViewCell *cell = nil;
    
    if(self.credential)
    {
        if(indexPath.row == 0)
        {
            
       cell = [tableView dequeueReusableCellWithIdentifier:mymapsCellIdentifier];
            if (cell == nil)
            
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mymapsCellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                cell.textLabel.text = @"My Maps";
                cell.imageView.image = [UIImage imageNamed:@"myContent.png"];
                
                
            }
            
        }
        else{
            cell = [tableView dequeueReusableCellWithIdentifier:mygroupsCellIdentifier];
            if (cell == nil)
                
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mygroupsCellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                cell.textLabel.text = @"My Groups";
                cell.imageView.image = [UIImage imageNamed:@"myGroups.png"];
                
                
            }
            
            
            
            
        }
    
        //set the acessory type
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:mygroupsCellIdentifier];
        if (cell == nil)
            
        {
            
            
            cell = [[UITableViewCell alloc] init];
                    //:UITableViewCellStyleDefault reuseIdentifier:mygroupsCellIdentifier];
    
               cell.textLabel.text = @"";
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

              cell.contentView.backgroundColor = [UIColor clearColor];

        
        }
    }
    
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //deselect the row
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController* nextViewController = nil;

    if(self.credential)
    {
        
        
    
    //show the ogranization details.
    if (indexPath.row == 0)
    {
        
        
        
        UserContentViewController *userContentsVC = [[UserContentViewController alloc] initWithPortal:self.portal];
        [userContentsVC setTitle:@"User Content"];
        nextViewController = userContentsVC;
        
        
    }
    
    else if (indexPath.row == 1)
    {
        UserGroupsViewController *userGroupsVC = [[UserGroupsViewController alloc] initWithPortal:self.portal];
        [userGroupsVC setTitle:@"User Groups"];
        nextViewController = userGroupsVC;
        
        
    }
    
    
    
    
    // Navigation logic may go here. Push another view controller.
    [self.navigationController pushViewController:nextViewController animated:YES];
        
        
    }
    
    
    
    else{
        
        
    }
}




@end
