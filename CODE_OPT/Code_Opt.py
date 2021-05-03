f = open("../ICG_QUAD/QUAD.txt","r")

lines = f.readlines()
f.close()

# Constant Folding and Propagation
var_values = dict()
CFList = []
print("---------------------------Quadruple form after Constant Folding and Propagation---------------------------")
for line in lines:
	line = line.strip("\n")
	op,a1,a2,res_var = line.split()
	if(op in ["+","-","*","/"]):
		if(a1.isdigit() and a2.isdigit()):
			res_varult = eval(a1+op+a2)
			var_values[res_var] = res_varult
			print("=",res_varult,"NULL",res_var)
			CFList.append(["=",res_varult,"NULL",res_var])
		elif(a1.isdigit()):
			if(a2 in var_values):
				res_varult = eval(a1+op+var_values[a2])
				var_values[res_var] = res_varult
				print("=",res_varult,"NULL",res_var)
				CFList.append(["=",res_varult,"NULL",res_var])
			else:
				print(op,a1,a2,res_var)
				CFList.append([op,a1,a2,res_var])
		elif(a2.isdigit()):
			if(a1 in var_values):
				res_varult = eval(var_values[a1]+op+a2)
				var_values[res_var] = res_varult
				print("=",res_varult,"NULL",res_var)
				CFList.append(["=",res_varult,"NULL",res_var])
			else:
				print(op,a1,a2,res_var)
				CFList.append([op,a1,a2,res_var])
		else:
			flag1=0
			flag2=0
			a1res_var = a1
			if(a1 in var_values):
				a1res_var = str(var_values[a1])
				flag1 = 1
			a2res_var = a2
			if(a2 in var_values):
				a2res_var = str(var_values[a2])
				flag2 = 1
			if(flag1==1 and flag2==1):
				res_varult = eval(a1res_var+op+a2res_var)
				var_values[res_var] = res_varult
				print("=",res_varult,"NULL",res_var) 
				CFList.append(["=",res_varult,"NULL",res_var])
			else:
				print(op,a1res_var,a2res_var,res_var)
				CFList.append([op,a1res_var,a2res_var,res_var])
			
	elif(op=="="):
		if(a1.isdigit()):
			var_values[res_var]=a1
			print("=",a1,"NULL",res_var)
			CFList.append(["=",a1,"NULL",res_var])
		else:
			if(a1 in var_values):
				print("=",var_values[a1],"NULL",res_var)
				var_values[res_var] = var_values[a1]
				CFList.append(["=",var_values[a1],"NULL",res_var])
			else:
				print("=",a1,"NULL",res_var)
				CFList.append(["=",a1,"NULL",res_var])
	
	elif(op == "Label"):
		print(op, "NULL", "NULL", res_var)
		CFList.append(["label", "NULL", "NULL", res_var])

	else:
		print(op,a1,a2,res_var)
		CFList.append([op,a1,a2,res_var])

# dead code elimination
quad_list = CFList[:]
res = 0
while(res == 0):
    #print("1---------\n")
    v = [] # Source operands
    r = [] # Destn operands
    if quad_list[len(quad_list)-1][0] != 'int':
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
        
        if quad_list[i][0] == 'int':
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

print()
print()
print("----------------------------------------Dead Code Elimination----------------------------------------")
for i in quad_list:
    print(i[0],i[1],i[2],i[3],sep = "\t")