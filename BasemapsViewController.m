//
//  BasemapsViewController.m
//  
//
//  Created by GeoTouch on 1/2/13.
//
//

#import "BasemapsViewController.h"
#import "RootViewController.h"

@interface BasemapsViewController() {
    NSMutableArray *firstSection;
    
    //


}
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;



@end

@implementation BasemapsViewController

@synthesize basemaplayout =_basemaplayout;
@synthesize delegate1 =_delegate1;
@synthesize collectionView=_collectionView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        // Custom initialization
     firstSection   = [[NSMutableArray alloc] init];
        
        
        }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view. // Create data for collection views
  //  NSMutableArray *secondSection = [[NSMutableArray alloc] init];
    
    
    
    
    for (int i=1; i<=9; i++) {
        [firstSection addObject:[NSString stringWithFormat:@"Cell %d", i]];
      //  [secondSection addObject:[NSString stringWithFormat:@"item %d", i]];
    }
    
  //  NSArray *hello = [@[@"1",@"2",@"3"]mutableCopy];
   // [firstSection addObjectsFromArray:hello];
    
    
    self.dataArray = [[NSArray alloc] initWithObjects:firstSection, nil];
    
    /* Uncomment this block to use nib-based cells */
    UINib *cellNib = [UINib nibWithNibName:@"NibCell" bundle:nil];
    
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cvCell"];
    /* end of nib-based cells block */
    
    /* uncomment this block to use subclassed cells */
    //[self.collectionView registerClass:[CVCell class] forCellWithReuseIdentifier:@"cvCell"];
    /* end of subclass-based cells block */
    
    // Configure layout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
   
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.dataArray count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSMutableArray *sectionArray = [self.dataArray objectAtIndex:section];
    return [sectionArray count];
    
}
//
//

//
//-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
//    
// //   static NSString *cellIdentifier = @"cvCell";
//    
//    
//    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
//    /*  Uncomment this block to use nib-based cells */
//  //  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//    
//    
//    UIImageView *basemapimage = (UIImageView *)[cell viewWithTag:10];
//    UIImage *basemapi = nil; //put an image of not available here
//    
//    
//    switch (indexPath.row) {
//        case 0:
//            basemapi=[UIImage imageNamed:@"ESRI_Physical_s.png"];
//            [basemapimage setImage:basemapi];
//            break;
//        case 1:
//            basemapi=[UIImage imageNamed:@"Esri_Ocean_s.png"];
//            [basemapimage setImage:basemapi];
//            break;
//        case 2:
//            basemapi=[UIImage imageNamed:@"ESRI_ShadedRelief_s.png"];
//            [basemapimage setImage:basemapi];
//            break;
//        case 3:
//            basemapi=[UIImage imageNamed:@"ESRI_Street_s.png"];
//            [basemapimage setImage:basemapi];
//            break;
//        case 4:
//            basemapi=[UIImage imageNamed:@"BingHybrid_s.png"];
//            [basemapimage setImage:basemapi];
//            break;
//        case 5:
//            basemapi=[UIImage imageNamed:@"BingStreet_s.png"];
//            [basemapimage setImage:basemapi];
//            break;
//        case 6:
//            basemapi=[UIImage imageNamed:@"BingAerial_s.png"];
//            [basemapimage setImage:basemapi];
//            break;
//        case 7:
//            basemapi=[UIImage imageNamed:@"OSM_Mapnik_s.png"];
//            [basemapimage setImage:basemapi];
//            break;
//        case 8:
//            basemapi=[UIImage imageNamed:@"NatGeo_s.png"];
//            [basemapimage setImage:basemapi];
//            break;
//            
//        default:
//            break;
//    }
//}
//
//


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //   static NSString *cellIdentifier = @"cvCell";
    
    
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    /*  Uncomment this block to use nib-based cells */
    //  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    UIImageView *basemapimage = (UIImageView *)[cell viewWithTag:10];
    UIImage *basemapi = nil; //put an image of not available here
    
    
    switch (indexPath.row) {
        case 0:
            basemapi=[UIImage imageNamed:@"ESRI_Physical.png"];
            [basemapimage setImage:basemapi];
            break;
        case 1:
            basemapi=[UIImage imageNamed:@"Esri_Ocean.png"];
            [basemapimage setImage:basemapi];
            break;
        case 2:
            basemapi=[UIImage imageNamed:@"ESRI_ShadedRelief.png"];
            [basemapimage setImage:basemapi];
            break;
        case 3:
            basemapi=[UIImage imageNamed:@"ESRI_Street.png"];
            [basemapimage setImage:basemapi];
            break;
        case 4:
            basemapi=[UIImage imageNamed:@"BingHybrid.png"];
            [basemapimage setImage:basemapi];
            break;
        case 5:
            basemapi=[UIImage imageNamed:@"BingStreet.png"];
            [basemapimage setImage:basemapi];
            break;
        case 6:
            basemapi=[UIImage imageNamed:@"BingAerial.png"];
            [basemapimage setImage:basemapi];
            break;
        case 7:
            basemapi=[UIImage imageNamed:@"OSM_Mapnik.png"];
            [basemapimage setImage:basemapi];
            break;
        case 8:
            basemapi=[UIImage imageNamed:@"NatGeo.png"];
            [basemapimage setImage:basemapi];
            break;
            
        default:
            break;
    }
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    // Setup cell identifier
    static NSString *cellIdentifier = @"cvCell";
    
    /*  Uncomment this block to use nib-based cells */
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
   UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
   // NSMutableArray *data = [self.dataArray objectAtIndex:indexPath.section];
    
    UIImageView *basemapimage = (UIImageView *)[cell viewWithTag:10];
    UIImage *basemapi = nil; //put an image of not available here
    
    NSString *cellData = @"";
    switch (indexPath.row) {
        case 0:
          cellData = @"ESRI Physical";
            basemapi=[UIImage imageNamed:@"ESRI_Physical.png"];
            [basemapimage setImage:basemapi];
            break;
        case 1:
            cellData = @"ESRI Ocean";
            basemapi=[UIImage imageNamed:@"Esri_Ocean.png"];
            [basemapimage setImage:basemapi];
            break;
        case 2:
            cellData = @"Shaded Relief";
            basemapi=[UIImage imageNamed:@"ESRI_ShadedRelief.png"];
            [basemapimage setImage:basemapi];
            break;
        case 3:
            cellData = @"ESRI Street";
            basemapi=[UIImage imageNamed:@"ESRI_Street.png"];
            [basemapimage setImage:basemapi];
            break;
        case 4:
            cellData = @"Bing Hybrid";
            basemapi=[UIImage imageNamed:@"BingHybrid.png"];
            [basemapimage setImage:basemapi];
            break;
        case 5:
            cellData = @"Bing Street";
            basemapi=[UIImage imageNamed:@"BingStreet.png"];
            [basemapimage setImage:basemapi];
            break;
        case 6:
            cellData = @"Bing Aerial";
            basemapi=[UIImage imageNamed:@"BingAerial.png"];
            [basemapimage setImage:basemapi];
            break;
        case 7:
            cellData = @"OSM Mapnik";
            basemapi=[UIImage imageNamed:@"OSM_Mapnik.png"];
            [basemapimage setImage:basemapi];
            break;
        case 8:
            cellData = @"Default Map";
            basemapi=[UIImage imageNamed:@"NatGeo.png"];
            [basemapimage setImage:basemapi];
            break;
            
        default:
            break;
    }
    
 
    [titleLabel setText:cellData];
    /* end of nib-based cell block */
    
    /* Uncomment this block to use subclass-based cells */
    //    CVCell *cell = (CVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    //    NSMutableArray *data = [self.dataArray objectAtIndex:indexPath.section];
    //    NSString *cellData = [data objectAtIndex:indexPath.row];
    //    [cell.titleLabel setText:cellData];
    /* end of subclass-based cells block */
    
    // Return the cell
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
   // static NSString *cellIdentifier = @"cvCell";
    
    /*  Uncomment this block to use nib-based cells */
    
    NSInteger rownum = indexPath.row;
    switch (rownum) {
        case 0:

            [self.delegate1 zeromap:@"http://services.arcgisonline.com/ArcGIS/rest/services/World_Physical_Map/MapServer"];
        
        break;
            
        case 1:

            [self.delegate1 zeromap:@"http://services.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer"];
            
            break;
        case 2:
            
            [self.delegate1 zeromap:@"http://services.arcgisonline.com/ArcGIS/rest/services/World_Shaded_Relief/MapServer"];
            
            break;
            
        case 3:
            
            [self.delegate1 zeromap:@"http://services.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer"];
            
            break;
            
            
        case 4:
            
            [self.delegate1 zeromap:@"hybrid bing"];
            
            break;
            
        case 5:
            
            [self.delegate1 zeromap:@"street bing"];
            
            break;
            
        case 6:
            
            [self.delegate1 zeromap:@"aerial bing"];
            
            break;
            
            
            
        case 7:
            
            [self.delegate1 zeromap:@"OSM mapnik"];
            
            break;
            
        case 8:
            
            [self.delegate1 zeromap:@"default map"];
            
            break;
    
            
        default:
            break;
    }


}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
        NSLog(@"Received memory warning bm");
}

@end
