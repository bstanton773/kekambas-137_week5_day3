# Your team is writing a fancy new text editor and you've been tasked with implementing the line numbering.

# Write a function which takes a list of strings and returns each line prepended by the correct number.

# The numbering starts at 1. The format is n: string. Notice the colon and space in between.

# Examples: 
# ["a", "b", "c"] --> ["1: a", "2: b", "3: c"]
# ["the","quick","brown","fox"] --> ["1: the","2: quick","3: brown","4: fox"]

# def solution(list_of_strings):
#     return [f"{i+1}: {list_of_strings[i]}" for i in range(len(list_of_strings))]

def solution1(list_of_strings):
    output = []
    for i in range(len(list_of_strings)):
        output.append(f"{i+1}: {list_of_strings[i]}")
    return output

# in-place
def solution2(strings):
    for i in range(len(strings)):
        strings[i] = f"{i+1}: {strings[i]}"
    return strings


test_list = ["Hello", "how", "are", "you", "doing", "today"]

print('Solution 1:')
print('Before:', test_list)
print('Function return:', solution1(test_list))
print('After:', test_list)
print()
print('Solution 2:')
print('Before:', test_list)
print('Function return:', solution2(test_list))
print('After:', test_list)