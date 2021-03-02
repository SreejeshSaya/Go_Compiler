#include <bits/stdc++.h>
using namespace std;
#include "SymbolTable.h"

vector<Node> st;

Node::Node(string id, string type, int lineno, string value, int scope)
{
	this->id = id;
	this->type = type;
	this->lineno = lineno;
	this->value = value;
	this->scope = scope;
}

void insert(string id, string type, int lineno, string value, int scope)
{
	Node n = Node(id, type, lineno, value, scope);
	st.push_back(n);
}

int check_decl(string id, int new_scope)
{
	for(Node &n : st)
	{
		if(n.id == id and n.scope <= new_scope)
		{
			return n.lineno;
		}
	}
	return 0;
}

ostream& operator<<(ostream &o, const Node& n)
{
	// return o << n.id << "\t" << n.type << "\t" << n.lineno << "\t" << n.value << "\t" <<  n.scope << "\n";
	return o << n.id << "\t" << n.type << "\t" << n.lineno << "\t" <<  n.scope << "\n";
}



void disp()
{
	for (Node& n : st)
	{
		cout << n;
	}
}
