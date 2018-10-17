  enum NodeType
{
    Undefined,LINE, BLOCK, STATEMENT_LIST, IF_ELSE_STATEMENT,
    TYPE, IF_STATEMENT, ASSIGNMENT_STATEMENT,NAME_State,
	 OPERATOR, WRITE_STATEMENT, NEWLINE_STATEMENT,term,
    CONDITIONAL, CONDITION, EXPRESSION, VALUE, COMPARATOR, CONSTANT,ADD,SUBTRACK,MULT,DIVIDE GT,LT,
    GTE,LTE, EQUAL, NOT_EQUAL
};

class Node{
  public:

   NodeType Type;
   int      Value;
   Node*    Left;
   Node*    Right;

   Node()
   {
      Type = Undefined;
      Value = 0;
      Left = NULL;
      Right = NULL;
   }
   ~Node()
   {
      delete Left;
      delete Right;
   }
};