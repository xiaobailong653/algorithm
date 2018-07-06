#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
题目描述：
在一个二维数组中，每一行都按照从左到右递增的顺序排序，每一列都按照从上到下递增的顺序排序。
请完成一个函数，输入这样的一个二维数组和一个整数，判断数组中是否含有该整数。
'''


# 方法一
class Solution:
    # array 二维列表
    def Find(self, target, array):
        for item in array:
            try:
                index = item.index(target)
                return True
            except:
                continue

        return False

# 结果评估
'''
运行时间：352ms

占用内存：5712k
'''


# 方法二
class Solution:
    # array 二维列表
    def Find(self, target, array):
        for item in array:
            if target in item:
                return True

        return False

# 结果评估
'''
运行时间：312ms

占用内存：5732k
'''


# 方法三
class Solution:
    # array 二维列表
    def Find(self, target, array):
        for item in array:
            if item.count(target) > 0:
                return True

        return False

# 结果评估
'''
运行时间：423ms

占用内存：5728k
'''