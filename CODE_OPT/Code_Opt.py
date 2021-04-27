f = open("../ICG_QUAD/QUAD.txt","r")

list_of_lines = f.readlines()
f.close()
dictValues = dict()
constantFoldedList = []
print("Quadruple form after Constant Folding")
print("-------------------------------------")
for i in list_of_lines:
	i = i.strip("\n")
	op,arg1,arg2,res = i.split()
	if(op in ["+","-","*","/"]):
		if(arg1.isdigit() and arg2.isdigit()):
			result = eval(arg1+op+arg2)
			dictValues[res] = result
			print("=",result,"NULL",res)
			constantFoldedList.append(["=",result,"NULL",res])
		elif(arg1.isdigit()):
			if(arg2 in dictValues):
				result = eval(arg1+op+dictValues[arg2])
				dictValues[res] = result
				print("=",result,"NULL",res)
				constantFoldedList.append(["=",result,"NULL",res])
			else:
				print(op,arg1,arg2,res)
				constantFoldedList.append([op,arg1,arg2,res])
		elif(arg2.isdigit()):
			if(arg1 in dictValues):
				result = eval(dictValues[arg1]+op+arg2)
				dictValues[res] = result
				print("=",result,"NULL",res)
				constantFoldedList.append(["=",result,"NULL",res])
			else:
				print(op,arg1,arg2,res)
				constantFoldedList.append([op,arg1,arg2,res])
		else:
			flag1=0
			flag2=0
			arg1Res = arg1
			if(arg1 in dictValues):
				arg1Res = str(dictValues[arg1])
				flag1 = 1
			arg2Res = arg2
			if(arg2 in dictValues):
				arg2Res = str(dictValues[arg2])
				flag2 = 1
			if(flag1==1 and flag2==1):
				result = eval(arg1Res+op+arg2Res)
				dictValues[res] = result
				print("=",result,"NULL",res) 
				constantFoldedList.append(["=",result,"NULL",res])
			else:
				print(op,arg1Res,arg2Res,res)
				constantFoldedList.append([op,arg1Res,arg2Res,res])
			
	elif(op=="="):
		if(arg1.isdigit()):
			dictValues[res]=arg1
			print("=",arg1,"NULL",res)
			constantFoldedList.append(["=",arg1,"NULL",res])
		else:
			if(arg1 in dictValues):
				print("=",dictValues[arg1],"NULL",res)
				constantFoldedList.append(["=",dictValues[arg1],"NULL",res])
			else:
				print("=",arg1,"NULL",res)
				constantFoldedList.append(["=",arg1,"NULL",res])
	
	elif(op == "Label"):
		print(op, "NULL", "NULL", res)
		constantFoldedList.append(["label", "NULL", "NULL", res])

	else:
		print(op,arg1,arg2,res)
		constantFoldedList.append([op,arg1,arg2,res])

print("\n")
print("Constant folded expression - ")
print("--------------------")
for i in constantFoldedList:
	if(i[0]=="="):
		print(i[3],i[0],i[1])
	elif(i[0] in ["+","-","*","/","==","<=","<",">",">="]):
		print(i[3],"=",i[1],i[0],i[2])
	elif(i[0] in ["if","goto","label","not"]):
		if(i[0]=="if"):
			print(i[0],i[1],"goto",i[3])
		if(i[0]=="goto"):
			print(i[0],i[3])
		if(i[0]=="label"):
			print(i[3],":")
		if(i[0]=="not"):
			print(i[3],"=",i[0],i[1])


# print("\n")
# print("After dead code elimination - ")
# print("------------------------------")
# for i in constantFoldedList:
# 	if(i[0]=="="):
# 		pass
# 	elif(i[0] in ["+","-","*","/","==","<=","<",">",">="]):
# 		print(i[3],"=",i[1],i[0],i[2])
# 	elif(i[0] in ["if","goto","label","not"]):
# 		if(i[0]=="if"):
# 			print(i[0],i[1],"goto",i[3])
# 		if(i[0]=="goto"):
# 			print(i[0],i[3])
# 		if(i[0]=="label"):
# 			print(i[3],":")
# 		if(i[0]=="not"):
# 			print(i[3],"=",i[0],i[1])

# dead code elimination
quad_list = constantFoldedList[:]
res = 0
while(res == 0):
    #print("1---------\n")
    v = []
    r = []
    if quad_list[len(quad_list)-1][0] != 'var' and quad_list[len(quad_list)-1][0] != 'let' and quad_list[len(quad_list)-1][0] != 'const':
        #print("say heloooo")
        if quad_list[len(quad_list)-1][1] != "NULL":
            v.append(quad_list[len(quad_list)-1][1])
        if quad_list[len(quad_list)-1][2] != "NULL":
            v.append(quad_list[len(quad_list)-1][2])
        if quad_list[len(quad_list)-1][3] != "NULL":
            r.append(quad_list[len(quad_list)-1][3])
    else:
        quad_list.remove(quad_list[len(quad_list)-1])
    init = len(quad_list)
    i = len(quad_list)-2
    #print(i)
    while i >=0:
        #print("h--------------",quad_list[i][1],"\t",i,"\n")
        
        if quad_list[i][0] == 'var' or quad_list[i][0] == 'let' or quad_list[i][0] == 'const':
             #print("1 -- hello")
             if quad_list[i][1] not in r:
                quad_list.remove(quad_list[i])
        elif quad_list[i][0] != "Label" and quad_list[i][0] != "if" and quad_list[i][0] != "goto" and quad_list[i][0] != "iffalse" and quad_list[i][3] not in v:
            quad_list.remove(quad_list[i])
        else:
            if quad_list[i][1] != "NULL" and quad_list[i][1] not in v:
                v.append(quad_list[i][1])
                
            if quad_list[i][2] != "NULL" and quad_list[i][2] not in v:
                v.append(quad_list[i][2])
            if quad_list[i][3] != "NULL" and quad_list[i][3] not in r:
                r.append(quad_list[i][3])  
        
            #print("hi")
            #print(i,len(quad_list))
        i-=1
        #print(i)
    if len(quad_list) == init:
        res = 1

print("\n\n----------------------------------------\nDead Code Elimination\n")      
print('----------------------------------------')
for i in quad_list:
    print(i[0],i[1],i[2],i[3],sep = "\t")