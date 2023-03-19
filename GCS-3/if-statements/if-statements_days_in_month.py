month = input("Enter month: ").lower()

if month == 'september' or \
    month == 'april' or \
    month == 'june' or \
    month == 'november':
    print("30 days")
elif month == 'february':
    print("28 or 29 days")
else:
    print("31 days")
