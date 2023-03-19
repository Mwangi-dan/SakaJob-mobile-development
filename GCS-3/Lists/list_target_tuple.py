"""Function that takes a list of integers and a target number
returns indices of two numbers in list that add up to target

Args:
    my_list (list): 
    target_no (int)

Returns:
    t_indices (tuple):

"""

def list_target_tuple(my_list, target_no):
    for i in range(len(my_list)):
        for j in range(i+1, len(my_list)):
            if my_list[i] + my_list[j] == target_no:
                return (i, j)
    return None


"""
test_list = [1, 4, 5, 6]
t = 11

print(list_target_tuple(liist, t))
"""