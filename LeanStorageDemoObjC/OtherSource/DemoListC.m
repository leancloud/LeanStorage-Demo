
#import "DemoListC.h"
#import "SourceViewController.h"

@interface DemoListC ()

@end

@implementation DemoListC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.demo) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看源码"
                                                                                style:UIBarButtonItemStyleBordered
                                                                               target:self action:@selector(showSource)];
    }
}

-(void)showSource{
    SourceViewController *vc = [[SourceViewController alloc] init];
    vc.filePath = self.demo.sourcePath;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == Nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *info = self.contents[indexPath.row];
    
    cell.textLabel.text = info[@"name"];
    cell.detailTextLabel.text = info[@"detail"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *info = self.contents[indexPath.row];
    NSString *method = info[@"method"];
    
    UIViewController *vc = nil;
    
    if (method) {
        DemoRunC *rc = [[DemoRunC alloc] init];
        rc.demo = self.demo;
        
        rc.methodName = method;
        vc = rc;
    } else {
        NSString *className = info[@"class"];
        if (className) {
            Demo *demo= [[NSClassFromString(className) alloc] init];
            DemoListC *listC = [[DemoListC alloc] init];
            
            listC.demo = demo;
            listC.contents = [demo allDemoMethod];
            vc = listC;
            
        }
    }
    
    if (vc) {
        vc.title = info[@"name"];
        if (self.navigationController) {
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self.tabBarController.navigationController pushViewController:vc animated:YES];
        }
    }
    
}


@end
