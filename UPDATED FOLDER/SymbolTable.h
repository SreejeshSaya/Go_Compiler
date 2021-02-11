class Node
{
	private:
	string id;
	string type;
	int lineno;
	string value;
	int scope;
	public:
	Node(string, string, int, string, int);
	friend bool check_decl(string, int);
	friend ostream& operator<<(ostream &o, const Node& n);
};

void insert(string, string, int, string, int);
bool check_decl(string, int);

ostream& operator<<(ostream &o, const Node& n);
void disp();
