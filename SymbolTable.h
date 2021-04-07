class Node
{
	private:
	string id;
	string type;
	int lineno;
	string value;
	int scope;
	public:
	Node(string, string, int, double, int);
	friend int check_decl(string, int);
	friend ostream& operator<<(ostream &o, const Node& n);
};

void insert(string, string, int, double, int);
int check_decl(string, int);

ostream& operator<<(ostream &o, const Node& n);
void disp();
