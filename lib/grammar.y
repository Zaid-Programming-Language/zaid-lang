class Parser
  token AND
  token CLASS
  token CONSTANT
  token DEDENT
  token ELSE
  token FALSE
  token FLOAT
  token IDENTIFIER
  token IF
  token IS
  token IT_IS
  token INDENT
  token METHOD
  token NEWLINE
  token NIL
  token NUMBER
  token RECEIVE
  token STRING
  token THEN
  token TRUE
  token WHILE

  prechigh
    left '.'
    right '!'
    left '*' '/'
    left '+' '-'
    left '>' '>=' '<' '<='
    left '==' '!='
    left '&&'
    left '||'
    right '='
    left '،'
  preclow

  rule
    Program:
      /* nothing */ { result = NodeList.new([]) }
    | Expressions   { result = val[0] }
    ;

    Expressions:
      Expression                        { result = Nodes::NodeList.new(val) }
    | Expressions Terminator Expression { result = val[0] << val[2] }
    | Expressions Terminator            { result = val[0] }
    | Terminator                        { result = Nodes::NodeList.new([]) }
    ;

    Expression:
      Literal
    | Call
    | Operator
    | GetConstant
    | SetConstant
    | GetLocal
    | SetLocal
    | Method
    | Class
    | If
    | While
    | '(' Expression ')' { result = val[1] }
    ;

    Terminator:
      NEWLINE
    | ';'
    ;

    Literal:
      NUMBER { result = Nodes::NumberNode.new(val[0]) }
    | FLOAT  { result = Nodes::FloatNode.new(val[0]) }
    | STRING { result = Nodes::StringNode.new(val[0]) }
    | TRUE   { result = Nodes::TrueNode.new }
    | FALSE  { result = Nodes::FalseNode.new }
    | NIL    { result = Nodes::NilNode.new }
    ;

    Call:
      IDENTIFIER Arguments                { result = Nodes::CallNode.new(nil, val[0], val[1]) }
    | Expression '.' IDENTIFIER Arguments { result = Nodes::CallNode.new(val[0], val[2], val[3]) }
    | Expression '.' IDENTIFIER           { result = Nodes::CallNode.new(val[0], val[2], []) }
    ;

    Arguments:
      "(" ")"         { result = [] }
    | "(" ArgList ")" { result = val[1] }
    ;

    ArgList:
      Expression             { result = val }
    | ArgList '،' Expression { result = val[0] << val[2] }
    ;

    Operator:
      Expression '||' Expression { result = Nodes::CallNode.new(val[0], val[1], [val[2]]) }
    | Expression '&&' Expression { result = Nodes::CallNode.new(val[0], val[1], [val[2]]) }
    | Expression '==' Expression { result = Nodes::CallNode.new(val[0], val[1], [val[2]]) }
    | Expression '!=' Expression { result = Nodes::CallNode.new(val[0], val[1], [val[2]]) }
    | Expression '<'  Expression { result = Nodes::CallNode.new(val[0], val[1], [val[2]]) }
    | Expression '>'  Expression { result = Nodes::CallNode.new(val[0], val[1], [val[2]]) }
    | Expression '<=' Expression { result = Nodes::CallNode.new(val[0], val[1], [val[2]]) }
    | Expression '>=' Expression { result = Nodes::CallNode.new(val[0], val[1], [val[2]]) }
    | Expression '+'  Expression { result = Nodes::CallNode.new(val[0], val[1], [val[2]]) }
    | Expression '-'  Expression { result = Nodes::CallNode.new(val[0], val[1], [val[2]]) }
    | Expression '*'  Expression { result = Nodes::CallNode.new(val[0], val[1], [val[2]]) }
    | Expression '/'  Expression { result = Nodes::CallNode.new(val[0], val[1], [val[2]]) }
    | '!' Expression             { result = Nodes::CallNode.new(val[1], val[0], []) }
    ;

    GetConstant:
      CONSTANT { result = Nodes::GetConstantNode.new(val[0]) }
    ;

    SetConstant:
      CONSTANT '=' Expression { result = Nodes::SetConstantNode.new(val[0], val[2]) }
    ;

    GetLocal:
      IDENTIFIER { result = Nodes::GetLocalNode.new(val[0]) }
    ;

    SetLocal:
      IDENTIFIER '=' Expression { result = Nodes::SetLocalNode.new(val[0], val[2]) }
    ;

    Block:
      INDENT Expressions DEDENT { result = val[1] }
    ;

    Method:
      METHOD IDENTIFIER IT_IS Block                   { result = Nodes::MethodNode.new(val[1], [], val[3]) }
    | METHOD IDENTIFIER RECEIVE ParamList IT_IS Block { result = Nodes::MethodNode.new(val[1], val[3], val[5]) }
    ;

    ParamList:
      /* nothing */            { result = [] }
    | IDENTIFIER               { result = val }
    | ParamList AND IDENTIFIER { result = val[0] << val[2] }
    ;

    Class:
      CLASS CONSTANT IS Block { result = Nodes::ClassNode.new(val[1], val[3]) }
    ;

    If:
      IF Expression THEN Block { result = Nodes::IfNode.new(val[1], val[3], nil) }
    | IF Expression THEN Block ELSE Block { result = Nodes::IfNode.new(val[1], val[3], val[5]) }
    ;

    While:
      WHILE Expression THEN Block { result = Nodes::WhileNode.new(val[1], val[3]) }
    ;
end


---- header
  require_relative 'nodes'
  require_relative 'lexer'


---- inner
  def initialize
    @lexer = Lexer.new
  end

  def parse(code, show_tokens: false)
    @tokens = @lexer.tokenize(code)

    puts @tokens.inspect if show_tokens

    do_parse
  end

  def next_token
    @tokens.shift
  end
