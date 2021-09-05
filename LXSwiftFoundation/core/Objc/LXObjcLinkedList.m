//
//  LXObjcLinkedList.m
//  LXSwiftFoundation
//
//  Created by 李响 on 2017/7/30.

/// 双向链表 数据结构

#import "LXObjcLinkedList.h"

@implementation LXLinkedMapNode

+ (LXLinkedMapNode *)nodeWithElement:(id)element prev:(LXLinkedMapNode *)prev next:(LXLinkedMapNode *)next {
    return [[self alloc] initWithElement:element prev:prev next:next];
}

- (instancetype)initWithElement:(id)element prev:(LXLinkedMapNode *)prev next:(LXLinkedMapNode *)next {
    if (self = [super init]) {
        self.element = element;
        self.prev = prev;
        self.next = next;
    }
    return self;
}

- (NSString *)description {
    
    NSMutableString *mStr = [NSMutableString string];
    if (self.prev != nil) {
        [mStr appendFormat:@"%@",self.prev.element];
    } else {
        [mStr appendString:@"nil"];
    }
    [mStr appendFormat:@"-%@-",self.element];

    if (self.next != nil) {
        [mStr appendFormat:@"%@",self.next.element];
    } else {
        [mStr appendString:@"nil"];
    }
    return mStr;
}

@end

@interface LXObjcLinkedList()

@property(nonatomic, strong) LXLinkedMapNode *first;
@property(nonatomic, strong) LXLinkedMapNode *last;
@property(nonatomic, assign) int totalCount;

@end

@implementation LXObjcLinkedList

/**添加元素到尾部*/
- (void)add:(id)element {
    [self insert:self.totalCount value:element];
}

/**在index位置插入一个元素*/
- (void)insert:(int)index value:(id)element {
    [self rangeCheckForAdd:index];

    // totalCount == 0
    // index == 0
    if (index == self.totalCount) { // 往最后面添加元素
        LXLinkedMapNode *oldLast = self.last;
        self.last = [LXLinkedMapNode nodeWithElement:element prev:oldLast next:nil];
        if (oldLast == nil) { // 这是链表添加的第一个元素
            self.first = self.last;
        } else {
            oldLast.next = self.last;
        }
    } else {
        LXLinkedMapNode *next = [self node:index];
        LXLinkedMapNode *prev = next.prev;
        LXLinkedMapNode *node = [LXLinkedMapNode nodeWithElement:element prev:prev next:next];
        next.prev = node;
        if (prev == nil) { // index == 0
            self.first = node;
        } else {
            prev.next = node;
        }
    }
    self.totalCount++;
}

/**设置index位置的元素*/
- (id)set:(int)index value:(id)element {
    LXLinkedMapNode *node = [self node:index];
    id old = node.element;
    node.element = element;
    return old;
}

/**获取index位置的元素*/
- (id)get:(int)index {
    return [self node:index].element;
}

/**查看元素的索引*/
- (int)indexOf:(id)element {
    if (element == nil) {
        LXLinkedMapNode *node = self.first;
        for (int i = 0; i < self.totalCount; i++) {
            if (node.element == nil) return i;
            node = node.next;
        }
    } else {
        LXLinkedMapNode * node = self.first;
        for (int i = 0; i < self.totalCount; i++) {
            if ([element isEqual:node.element]) return i;
            node = node.next;
        }
    }
    return ELEMENT_NOT_FOUND;
}

/**删除index位置的元素*/
- (id)remove:(int)index {
    [self rangeCheck:index];

    LXLinkedMapNode *node = [self node:index];
    LXLinkedMapNode *prev = node.prev;
    LXLinkedMapNode *next = node.next;
    
    if (prev == nil) { // index == 0
        self.first = next;
    } else {
        prev.next = next;
    }
    if (next == nil) { // index == totalCount - 1
        self.last = prev;
    } else {
        next.prev = prev;
    }
    
    self.totalCount--;
    return node.element;
}

- (id)removeOf:(id)element {
    int index = [self indexOf:element];
    return [self remove:index];
}

/**清除所有元素*/
- (void)clear {
    self.totalCount = 0;
    self.first = nil;
    self.last = nil;
}

/**元素的数量*/
- (int)size {
    return self.totalCount;
}

/**是否为空*/
- (BOOL)isEmpty {
    return self.totalCount == 0;
}

/**是否包含某个元素*/
- (BOOL)contains:(id)element {
    return [self indexOf:element] != ELEMENT_NOT_FOUND;
}

/**获取索引对应的LXLinkedMapNode*/
- (LXLinkedMapNode *)node:(int)index{
    [self rangeCheck:index];
            
    if (index < (self.totalCount >> 1)) {
        LXLinkedMapNode *node = self.first;
        for (int i = 0; i < index; i++) {
            node = node.next;
        }
        return node;
    } else {
        LXLinkedMapNode *node = self.last;
        for (int i = self.totalCount - 1; i > index; i--) {
            node = node.prev;
        }
        return node;
    }
}

- (NSString *)description{
    NSMutableString *mStr = [NSMutableString string];
    [mStr appendFormat:@"size=%d, [",self.totalCount];
    LXLinkedMapNode *node = self.first;
    for (int i = 0; i < self.totalCount; i++) {
        if (i != 0) {
            [mStr appendString:@", "];
        }
        [mStr appendFormat:@"%@",node];
        node = node.next;
    }
    [mStr appendString:@"]"];
    return mStr;
}

- (void)rangeCheck:(int)index {
  
    NSString *errorStr = [NSString stringWithFormat:@"索引越界 index=%d, totalCount=%d",index, self.totalCount];
    NSAssert(!(index < 0 || index >= self.totalCount), errorStr);
}

- (void)rangeCheckForAdd:(int)index {
    
    NSString *errorStr = [NSString stringWithFormat:@"索引越界 index=%d, totalCount=%d",index, self.totalCount];
    NSAssert(!(index < 0 || index > self.totalCount), errorStr);
}

@end
