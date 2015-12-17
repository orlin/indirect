# Used by `ipkgs` to parse package lists.

# no empty lines
/^[:space:]*$/d

# delete comment lines
/^#.*/d

# erase comments
s/#.*//g

# up to the first comma (it could be a csv dat file)
s/,.*//

# can't seem to remove trailing whitespace
s/\s+$//g

# cannot split on space with sed?
# this could have allowed several packages per line
# s/[:space:]+/\n/g

# list to detect whitespace, etc.
# l
