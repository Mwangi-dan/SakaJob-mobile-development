user_string = input("Enter a user_string: ").lower()

# vowel list
vowels = ['a', 'e', 'i', 'o', 'u']

# initialize the index variable
i = 0

# loop through the user_string
while i < len(user_string):
    if user_string[i] not in vowels and user_string[i] != 'y':
        print(user_string[i], end=", ")
    i += 1