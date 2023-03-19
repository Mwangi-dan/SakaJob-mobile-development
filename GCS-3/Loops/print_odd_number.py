new_list = []

# prompt user to input integer
y = int(input("Enter an integer: "))

# For loop 
for i in range(1, y + 1):
    if i % 2 != 0:
        new_list.append(i)

print(new_list)