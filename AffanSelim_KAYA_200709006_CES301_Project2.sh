#!/bin/bash

# Affan Selim KAYA
# 200709006
# Computer Engineering (English)
# Shell Programming CES301
# 2022-2023 1st Somestr (2022-Fall)
# Project: 2
# Asst.Prof.Dr Deniz DAL


# Function that removes any punctuation etc. to make words understandable easily by code.
CheckWord() {
    local word="$1"
    local newWord

    # Eliminate punctuation and makes it new readable word by code.
    for (( i=0; i<${#word}; i++ )); do
        local currentChar="${word:$i:1}"
        if [[ "${currentChar}" =~ [a-z] ]]; then
            newWord+="${currentChar}"
        fi
    done

    echo "${newWord}"
}

# Function that sorts the string.
SortString() {
    # I used local variables to make them only avaliable in scope of this function.
    local word="$1"
    local i
    local j
    local temp
    for ((i=0; i<${#word}; i++)); do
        for ((j=i+1; j<${#word}; j++)); do
            if [[ "${word:i:1}" > "${word:j:1}" ]]; then
                temp="${word:i:1}"
                word="${word:0:i}${word:j:1}${word:i+1:j-i-1}${temp}${word:j+1}"
            fi
        done
    done
    echo "$word"
}

# Function that checks if a string is Isogram or not.
IsIsogram() {
    local sortedWord
    sortedWord=$(SortString "$1")
    local i
    for ((i=0; i<${#sortedWord}; i++)); do
        if [[ "${sortedWord:i:1}" == "${sortedWord:i+1:1}" ]]; then
            return 1
        fi
    done
    return 0
}

# Function that checks if a string is palindrome or not.
IsPalindrome() {
    local i
    for ((i=0; i<${#1}; i++)); do
        if [[ "${1:i:1}" != "${1:${#1}-i-1:1}" ]]; then
            return 1
        fi
    done
    return 0
}

# Checks if only 1 argument is passed or not.
if [[ $# -ne 1 ]]; then
    echo "Error! Usage of code  is: $0 <Desired String File>"
    exit 1
# Checks if the argument is a file or not.
elif [ ! -f "$1" ]; then
    echo "Error!: $1 is not a file"
    exit 1
# If all checks are passed, run the code.
else
    # Longest isogram/palindrome word.
    currentWord=""
    maxLen=0

    # Counters
    totalCount=0
    palindromeCount=0
    isogramCount=0

    # Read the file line by line as array.
    while read -ra line; do
        # For every line check every word.
        for word in "${line[@]}";
        do
            # Lower-casing every word because the uppercases and lowercases  (ex.E and e) are  not same to code.It makes easier to find palindrome words.
            word=${word,,}
            word=$(CheckWord "$word")

            if [[ ${#word} -gt 0 ]]; then
                ((totalCount++))
                palindromeStatus="no"
                isogramStatus="no"

                # Checks if the word is a palindrome.
                if IsPalindrome "$word"; then
		# If finds an palindrome word, add 1 to palindrome counter.
                    ((palindromeCount++))
                    palindromeStatus="yes"

                fi

                # Checks if the word is an isogram.
                if IsIsogram "$word"; then
		# If finds an isogram word, add 1 to isogram counter.
                    ((isogramCount++))
                    isogramStatus="yes"

                fi

                if [[ $palindromeStatus == "yes" || $isogramStatus == "yes" ]] && [[ ${#word} -gt $maxLen ]]; then
                    currentWord="$word"
                    maxLen=${#word}
                fi
            fi
        done;
    done < "$1"
    
    # Writes on terminal picked/lowercased and de-punctionized words/all given text words
    echo "Analysed total number of ${totalCount} out of all $(wc -w "$1" | cut -d ' ' -f 1) words"
    echo "Total number of palindromes is: $palindromeCount"
    echo "Total number of isograms is: $isogramCount"
    echo "Longest Palindrome/Isogram word is: $currentWord"
fi
