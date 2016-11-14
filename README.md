# LWScrollView
A cyclic scroll view with just two pages and special effects.

# Example
![image](https://github.com/levicn/LWScrollView/blob/master/example.gif?raw=true)

# How to use

```
NSArray *images = @[@"1.jpg",@"2.jpg",@"3.jpg"];
LWScrollView *scroll = [[LWScrollView alloc] initWithFrame:frame images:images];
[self.view addSubview:scroll];
```