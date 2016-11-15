# CCZSpreadButton
### 导语 (在介绍使用方法之前，我先讲讲实现这个控件的思路)
1. 先定一个弹出角度，可以叫做偏移角度变量，作为一个属性能够自行设置。(offsetAngle)
2. 每一个subItem都有自己的弹出角度(subItem就是弹出来的每一个小按钮或者其他视图)，以及弹射距离。
3. 特殊位置做特殊处理，及控件处于边角位置的时候。需要重新计算偏移角度和可用弹射角度。

### 使用
```Objective-C
    CCZSpreadButton *com  = [[CCZSpreadButton alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    com.itemsNum = 7;
    [self.view addSubview:com];
    self.com = com;
    com.normalImage = [UIImage imageNamed:@"plus_L"];
    com.selImage = [UIImage imageNamed:@"plus_F"];
    com.images = @[@"lock_F",@"lock_F",@"lock_F",@"lock_F",@"lock_F",@"lock_F",@"lock_F"];
    [com spreadButtonDidClickItemAtIndex:^(NSUInteger index) {
        NSLog(@"%ld",index);
    }];
```
> 上面的这段代码就是最简单的使用方法，itemsNum是设置弹出按钮的个数。

### CCZSpreadButton这个类只是对于基类CCZSpreadComponentry的继承和封装，主要功能还是需要看这边。
> 介绍下主要的四个属性
```Objective-C
@property (nonatomic, assign) BOOL spreadButtonOpenViscousity; /**< 开启粘滞功能 #YES*/
@property (nonatomic, assign) CGFloat offsetAngle; /**< 偏移角度，默认0。90度方向开始展开*/
@property (nonatomic, assign) BOOL autoAdjustToFitSubItemsPosition; /**< 自动适配subItems的位置 #NO*/
@property (nonatomic, assign) CGFloat spreadDis; /**< 弹开的距离 ；需要设置autoAdjustToFitSubItemsPosition = NO*/
```

**spreadButtonOpenViscousity**
这个应该好理解，就是类似于苹果AssistiveTouch那样的粘滞功能，在手放开的时候自动贴边。

**offsetAngle**
这个是初始偏移角度，默认是从顶部M_PI_2的地方开始t扩散的。

**spreadDis**
这个是摊开的距离，只有在属性autoAdjustToFitSubItemsPosition = NO;时才能设置，否则无效

**autoAdjustToFitSubItemsPosition**
最后来讲讲这个属性，虽然只是个布尔值。但是它的实现缺并不简单。因为涉及到循环作用。前面已经讲到，这个控件的关键就是偏移角和可用弹射角度。而这两个值却是通过弹出距离l来计算的。相反的，l的适配距离计算也需要这两个值。因此形成向我们在Block中经常会碰到的循环引用。在实现时通过递归的方式解决。
```Objective-C
/**
 自动调整弹出距离
 */
- (CGFloat)autoCalSpreadDisWithStartAngle:(CGFloat *)sAngle totalAngle:(CGFloat *)tAngle {
    BOOL on = [self calInitialAngleWithTotalAngle:tAngle offsetAngle:sAngle];
    CGFloat aAngle = *tAngle / (on? (self.subItems.count - 1) : self.subItems.count);
    
    if (_autoAdjustToFitSubItemsPosition) {
        CGFloat rl = 2 * M_SQRT2 * _radius + CCZAutoFitRadiousSpace;
        if (aAngle * _fixLength < rl) {
            _fixLength += CCZRadiusStep;
            *sAngle = _offsetAngle;
            *tAngle = M_PI * 2;
            return [self autoCalSpreadDisWithStartAngle:sAngle totalAngle:tAngle];
        }
    }
    return aAngle;
}
```
