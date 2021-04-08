'''
	Removes extra new lines in ICG.txt
'''

f = open('ICG.txt', 'r+')
lines = f.readlines()
cleaned_output = []
for line in lines:
	if line != '\n':
		cleaned_output.append(line)
cleaned_output = ''.join(cleaned_output)
f.seek(0)
f.truncate()
f.write(cleaned_output)
