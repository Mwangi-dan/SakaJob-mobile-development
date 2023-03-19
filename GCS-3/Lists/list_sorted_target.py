"""Function takes list, sorts it and checks which index 
the target nuber would fit

Args:
    my_list (list):
    target (int):

"""

def sorted_list_target(my_list, target):
    my_list.sort()
    for i in range(len(my_list)):
        if my_list[i] < target:
            my_list.insert(i, target)
    
    return my_list.index(target)

test_list = [1, 3, 5, 6]
t = 4
print(sorted_list_target(test_list, t))