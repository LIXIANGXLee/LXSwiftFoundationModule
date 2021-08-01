//
//  LXObjcLinkedList.h
//  LXSwiftFoundation
//
//  Created by 李响 on 2017/7/30.

/// 双向链表

#import <Foundation/Foundation.h>

#define ELEMENT_NOT_FOUND -1

NS_ASSUME_NONNULL_BEGIN

/// 节点类
@interface LXLinkedMapNode : NSObject
@property(nonatomic, strong) LXLinkedMapNode *prev;
@property(nonatomic, strong) LXLinkedMapNode *next;
@property(nonatomic, strong) id element;

+ (LXLinkedMapNode *)nodeWithElement:(id)element
                                prev:(LXLinkedMapNode * __nullable)prev
                                next:(LXLinkedMapNode * __nullable)next;
- (instancetype)initWithElement:(id)element
                        prev:(LXLinkedMapNode * __nullable)prev
                        next:(LXLinkedMapNode * __nullable)next;
@end

@interface LXObjcLinkedList : NSObject

/// 添加元素到尾部
- (void)add:(id)element;

/// 在index位置插入一个元素
- (void)insert:(int)index value:(id)element;

/// 设置index位置的元素
- (id)set:(int)index value:(id)element;

/// 获取index位置的元素
- (id)get:(int)index;

/// 查看元素的索引
- (int)indexOf:(id)element;

/// 删除index位置的元素
- (id)remove:(int)index;

/// 删除element的元素
- (id)removeOf:(id)element;

/// 清除所有元素
- (void)clear;

/// 元素的数量
- (int)size;

/// 是否为空
- (BOOL)isEmpty;

///是否包含某个元素
- (BOOL)contains:(id)element;

@end

NS_ASSUME_NONNULL_END
