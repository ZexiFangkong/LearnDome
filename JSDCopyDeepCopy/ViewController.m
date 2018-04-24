//
//  ViewController.m
//  JSDCopyDeepCopy
//
//  Created by jersey on 20/4/18.
//  Copyright © 2018年 JerseyCoffee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, weak) NSString *weakName;
@property (nonatomic, retain) NSString *strongName;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //分析字符串 深浅拷贝
//    [self analyzeString];
    //分析可变字符串 深浅拷贝
//    [self analyzeMutableString];
//使用字符串分析 copy与Strong与Weak 对其set方法有何影响
//    [self analyzeCopyandStrongWithString];
//使用可变字符串分析 copy与Strong 对其set方法有何影响
    [self analyzeCopyandStrongWithMutableString];
}
// 测试 copy strong weak 对引用计数器的影响，
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 正常
    NSLog(@"测试weak引用是否成功释放%@",self.weakName);
    // self.weaskName = nil, 由于self.strongName 制空, 不在对 string 对其引用。此时 string 引用计数器为0 , self.weakName由于也没有对其引用,所以直接释放掉了。
    self.strongName = nil;
    self.name = nil;
    NSLog(@"测试weak引用是否成功释放%@",self.weakName);
}
/*
 深拷贝: 深拷贝则是对一份内容进行了拷贝， 可以这样理解，有了内容 还要有一份新的内存地址，去指向这份内容。
 所以深拷贝出来的对象， 其内存地址也是独立的。 其指向的内容是拷贝出来的内容。

 浅拷贝: 浅拷贝则是对一份指针进行了拷贝， 所以其指针是一样的。 指向的内容也是同一个地方。

 */

/*
 Strong: 在没有引入 ARC之前管理引用计数器 MRC使用的是 retain。 在引用了ARC之后才用 strong来代表。
         其原理还是一样的，在 set方法对变量进行 retain， 使其引用计数器 ＋1。
 Copy:   其表示在 set方法对变量进行 copy方法。 其深浅拷贝由具体对象来决定，从深浅拷贝的原理可以分析出，不管其是深拷贝还是浅拷贝，
         其对象要么生成一份 独立内存地址 ---> 深拷贝、  要么就是拷贝同一个指针，指向拷贝出来的同一份内容 ---> 浅拷贝。 而其都不会像 strong 一样。
         对当前指针进行多一份引用，使其引用计数器 ＋1。  所以可以总结得出 Copy 不会对引用计数器造成变化。
         说到 Copy, 可以顺便讲一下 Weak和 Assign。  Assign 与 Weak是类似的功能，其永远不会改变引用计数器， 因为其只是在 Set方法里面坐了简单的赋值, 但是其是用于 非 OC对象的赋值。 类似 int Float C语言定义的非对象数据类型。
         Weak，也是在 Set方法里面做了简单的赋值而已，其主要是用于针对 OC对象。
 */


//分析字符串 深浅拷贝
- (void)analyzeString
{
    NSString* string = @"StringJerseyCafe";
    // 浅拷贝、未生成新地址、只是对指针进行了一份拷贝、指向同一份内容。
    NSString* copyString = [string copy];
    // 深拷贝、生成了新的内存地址、对内容也进行了一份拷贝、使用新的内存地址指向新的内容。
    NSString* mutableCopyString = [string mutableCopy];
    
    NSLog(@"String = %@-%p --- copyString = %@-%p ---- mutableCopyString = %@-%p/n", string, string, copyString, copyString, mutableCopyString, mutableCopyString);
    // 证明浅拷贝和深拷贝原理。
    string = @"Jersey";
    // 直接改变 string、  其实相当于将 string 原本指向的内存进行了修改使其指向一份新的内存地址、 并且这份内存地址也指向 Jersey 这份内容。
    // 从copyString 可以看出、 因为其对 String 的内容进行了一份拷贝。 然后使用其同样的内存地址，但是指向的内容并不是同一份。  所以当 string 改变了之后、 并没有影响到自己。
    // mutableCopyString 更加不可能影响，其拷贝了一份内容，然后生成另一份内存地址。 指向拷贝出来的这份内容。
    NSLog(@"String = %@-%p --- copyString = %@-%p ---- mutableCopyString = %@-%p/n", string, string, copyString, copyString, mutableCopyString, mutableCopyString);
    // 结论：
}

//分析可变字符串 深浅拷贝
- (void)analyzeMutableString
{
    NSMutableString* mutableString = [NSMutableString stringWithString:@"MutableStringJerseyCafe"];
    // 可变字符串copy、 拷贝其内容，生成一份新地址 指向这份内容。 得到不可变字符串。
    NSMutableString* copyMutableString = [mutableString copy];
    NSMutableString* mutableCopyMutableString = [mutableString mutableCopy];
    
    NSLog(@"mutableString = %@-%p --- copyMutableString = %@-%p ---- mutableCopyMutableString = %@-%p/n", mutableString, mutableString, copyMutableString, copyMutableString, mutableCopyMutableString, mutableCopyMutableString);
    // 验证 mutableString copy 生成对象。 使用其拼接字符串、  直接导致崩溃、 其属于字符串而非可变字符串。
//    [copyMutableString appendFormat:@"TestcopyMutableString"];
    // 验证 mutableString mutableCopy 生成对象。 使用其拼接字符串、  返回结果正常、 其属于可变字符串而非字符串。
    [mutableCopyMutableString appendFormat:@"TestmutableCopyMutableString"];
    
    NSLog(@"mutableCopyMutableString = %@-%p/n", mutableCopyMutableString, mutableCopyMutableString);
    //结论：
}

//使用字符串分析 copy与Strong与Weak 对其set方法有何影响
- (void)analyzeCopyandStrongWithString
{
    NSString *string = @"StringJerseyCafe";
    // copy 修饰的字符串， 在进行 set 方法时, 只是对 当前 string copy，所以结果就跟浅拷贝一样。 复制指针指向同一份内容。并不会对其引用计数器改变。 返回一个 不可变字符串。
    self.name = string;
    // Strong 修饰的字符串， 在进行 set 方法时, 对当前 string retain, 使 string 引用计数器加1, 返回一个不可变字符串。该返回的对象指向 string 的内存地址。
    self.strongName = string;
    // weak 修饰的字符串， 在进行 set 方法时, 只是简单的赋值到当前 属性上。所以 string 引用计数器不变。 self.weakName 使用着 string内存地址，但是不会使 引用计数器加1。
    self.weakName = string;
    //  由输出结果可以得出、
    NSLog(@"string = %@-%p --- Name = %@-%p ---- StrongName = %@-%p ---- weakName = %@-%p", string, string, self.name, self.name, self.strongName, self.strongName, self.weakName, self.weakName);
    
    string = @"对String内存地址指向内容做修改";
    NSLog(@"string = %@-%p --- Name = %@-%p ---- StrongName = %@-%p ---- weakName = %@-%p", string, string, self.name, self.name, self.strongName, self.strongName, self.weakName, self.weakName);
    string = [NSString stringWithFormat:@"对String重新分配内存地址"];
    NSLog(@"string = %@-%p --- Name = %@-%p ---- StrongName = %@-%p ---- weakName = %@-%p", string, string, self.name, self.name, self.strongName, self.strongName, self.weakName, self.weakName);
    string = nil; // 直接将String 的指向nil;
    //  由输出结果推理 Strong
    NSLog(@"string = %@-%p --- Name = %@-%p ---- StrongName = %@-%p ---- weakName = %@-%p", string, string, self.name, self.name, self.strongName, self.strongName, self.weakName, self.weakName);
    //  使用三种不同的 引用计数器修饰关键字, 然后对 原有 string 进行内容修改, 指针地址修改, 销毁。 都不会影响到原有属性的指针或者内容,这里具体原因 我没有完全研究明白。 并且很奇怪的是此 字符串 在只有 weakName 使用的情况下，此时出了 string 作用域，正常应该是已经消耗的。 但是我再 - (void)viewDidAppear:(BOOL)animated 函数 进行测试，发现此 字符串并未释放。 但是如果使用下面可变字符串的话 则会释放掉。  这个以后有时间在好好研究, 希望大神看到这块可以指点一下。
}
//使用可变字符串分析 copy与Strong 对其set方法有何影响
- (void)analyzeCopyandStrongWithMutableString
{
    NSMutableString *mutableString = [NSMutableString stringWithFormat:@"StringJerseyCafe"];
    // copy 修饰的字符串， 在进行 set 方法时, 只是对 当前 string copy，所以结果就跟浅拷贝一样。 复制指针指向同一份内容。并不会对其引用计数器改变。 返回一个 不可变字符串。
    self.name = mutableString;
    // Strong 修饰的字符串， 在进行 set 方法时, 对当前 string retain, 使 string 引用计数器加1, 返回一个不可变字符串。该返回的对象指向 string 的内存地址。
//    self.strongName = mutableString;
    // weak 修饰的字符串， 在进行 set 方法时, 只是简单的赋值到当前 属性上。所以 string 引用计数器不变。 self.weakName 使用着 string内存地址，但是不会使 引用计数器加1。
    self.weakName = mutableString;
    //  由输出结果可以得出、 使用Strong 和 weak 修饰的属性,其指针地址都是跟mutableString一致。 因为其都是使用了mutableString 的指针地址 指向同一块内容,只是Strong 会对 其内存增加一份引用计数器,而weak 不变而已。 在过来看 copy。 由于其是可变字符串 copy、 其是深拷贝, 所以肯定会生成一份新地址, 然后指向其拷贝出来的相同的一份内容。 所以其地址已经改变了。得到的是一个不可变的字符串。  所以又这点也证明了为什么我们在写 @property 针对 NSString NSArray NSDictionary 时都要使用 copy 来进行修饰的原因, 这样就成功了确保了 不过你使用 可变对象还是不可变对象 赋值到这个属性的时候 最终结果都是只会得到 不可变的对象。 符合我们的预期结果。
    NSLog(@"string = %@-%p --- Name = %@-%p ---- StrongName = %@-%p ---- weakName = %@-%p", mutableString, mutableString, self.name, self.name, self.strongName, self.strongName, self.weakName, self.weakName);
    [mutableString appendFormat:@"对String 内存地址所指向内容进行修改"];
    // 由输出结果可以得出, 由于使用 Strong 和 weak 修饰的属性,其都是在使用 mutableString 地址, 所以当 mutableString 的内容发生改变时, 两个属性同样也是指向这一份改变后的内容的。 但是 Copy 修饰的就不一样了。  由于其是深拷贝出来的, 内存地址完全是独立的,其内容也不可能会发生改变。
    NSLog(@"string = %@-%p --- Name = %@-%p ---- StrongName = %@-%p ---- weakName = %@-%p", mutableString, mutableString, self.name, self.name, self.strongName, self.strongName, self.weakName, self.weakName);
    mutableString = [NSMutableString stringWithFormat:@"对String重新分配一份内存地址"];
    // 我们对 mutableString 重新
    NSLog(@"string = %@-%p --- Name = %@-%p ---- StrongName = %@-%p ---- weakName = %@-%p", mutableString, mutableString, self.name, self.name, self.strongName, self.strongName, self.weakName, self.weakName);
    mutableString = nil; // 直接将String 的指向nil;
    //  由输出结果推理 Strong
    NSLog(@"string = %@-%p --- Name = %@-%p ---- StrongName = %@-%p ---- weakName = %@-%p", mutableString, mutableString, self.name, self.name, self.strongName, self.strongName, self.weakName, self.weakName);
}


@end
