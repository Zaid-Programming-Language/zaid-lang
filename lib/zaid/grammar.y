class Parser
  token AND
  token BREAK
  token CLASS
  token COMMENT
  token CONSTANT
  token CONTINUE
  token DEDENT
  token ELSE
  token ELSE_IF
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
    left '['
  preclow

  rule
    Program:
      /* nothing */ { result = NodeList.new([]) }
    | Expressions   { result = val[0] }
    ;

    Expressions:
      Expression                        { result = NodeList.new(val) }
    | Expressions Terminator Expression { result = val[0] << val[2] }
    | Expressions Terminator            { result = val[0] }
    | Terminator                        { result = NodeList.new([]) }
    ;

    Expression:
      Literal
    | Break
    | Call
    | Continue
    | Operator
    | GetConstant
    | SetConstant
    | GetLocal
    | SetLocal
    | Method
    | Class
    | If
    | While
    | ArrayLiteral
    | ArrayAccess
    | ArrayAssignment
    | '(' Expression ')' { result = val[1] }
    ;

    Terminator:
      NEWLINE
    | ';'
    ;

    Literal:
      NUMBER { result = NumberNode.new(val[0]) }
    | FLOAT  { result = FloatNode.new(val[0]) }
    | STRING { result = StringNode.new(val[0]) }
    | TRUE   { result = TrueNode.new }
    | FALSE  { result = FalseNode.new }
    | NIL    { result = NilNode.new }
    ;

    Break:
      BREAK { result = BreakNode.new }
    ;

    Call:
      IDENTIFIER Arguments                { result = CallNode.new(nil, val[0], val[1]) }
    | Expression '.' IDENTIFIER Arguments { result = CallNode.new(val[0], val[2], val[3]) }
    | Expression '.' IDENTIFIER           { result = CallNode.new(val[0], val[2], []) }
    ;

    Continue:
      CONTINUE { result = ContinueNode.new }
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
      Expression '||' Expression { result = CallNode.new(val[0], val[1], [val[2]]) }
    | Expression '&&' Expression { result = CallNode.new(val[0], val[1], [val[2]]) }
    | Expression '==' Expression { result = CallNode.new(val[0], val[1], [val[2]]) }
    | Expression '!=' Expression { result = CallNode.new(val[0], val[1], [val[2]]) }
    | Expression '<'  Expression { result = CallNode.new(val[0], val[1], [val[2]]) }
    | Expression '>'  Expression { result = CallNode.new(val[0], val[1], [val[2]]) }
    | Expression '<=' Expression { result = CallNode.new(val[0], val[1], [val[2]]) }
    | Expression '>=' Expression { result = CallNode.new(val[0], val[1], [val[2]]) }
    | Expression '+'  Expression { result = CallNode.new(val[0], val[1], [val[2]]) }
    | Expression '-'  Expression { result = CallNode.new(val[0], val[1], [val[2]]) }
    | Expression '*'  Expression { result = CallNode.new(val[0], val[1], [val[2]]) }
    | Expression '/'  Expression { result = CallNode.new(val[0], val[1], [val[2]]) }
    | '!' Expression             { result = CallNode.new(val[1], val[0], []) }
    ;

    GetConstant:
      CONSTANT { result = GetConstantNode.new(val[0]) }
    ;

    SetConstant:
      CONSTANT '=' Expression { result = SetConstantNode.new(val[0], val[2]) }
    ;

    GetLocal:
      IDENTIFIER { result = GetLocalNode.new(val[0]) }
    ;

    SetLocal:
      IDENTIFIER '=' Expression { result = SetLocalNode.new(val[0], val[2]) }
    ;

    Block:
      INDENT Expressions DEDENT { result = val[1] }
    ;

    Method:
      METHOD IDENTIFIER IT_IS Block                   { result = MethodNode.new(val[1], [], val[3]) }
    | METHOD IDENTIFIER RECEIVE ParamList IT_IS Block { result = MethodNode.new(val[1], val[3], val[5]) }
    ;

    ParamList:
      /* nothing */            { result = [] }
    | IDENTIFIER               { result = val }
    | ParamList AND IDENTIFIER { result = val[0] << val[2] }
    ;

    Class:
      CLASS CONSTANT IS Block { result = ClassNode.new(val[1], val[3]) }
    ;

    If:
      IF Expression THEN Block ElseIf { result = IfNode.new(val[1], val[3], val[4]) }
    ;

    ElseIf:
      /* nothing */                        { result = nil }
    | ELSE Block                           { result = val[1] }
    | ELSE_IF Expression THEN Block ElseIf { result = IfNode.new(val[1], val[3], val[4]) }
    ;

    While:
      WHILE Expression THEN Block { result = WhileNode.new(val[1], val[3]) }
    ;

    ArrayLiteral:
      '[' ']'             { result = ArrayNode.new([]) }
    | '[' ElementList ']' { result = ArrayNode.new(val[1]) }
    ;

    ElementList:
      Expression                 { result = [val[0]] }
    | ElementList '،' Expression { result = val[0] << val[2] }
    ;

    ArrayAccess:
      Expression '[' Expression ']' { result = ArrayAccessNode.new(val[0], val[2]) }
    ;

    ArrayAssignment:
      Expression '[' Expression ']' '=' Expression { result = ArrayAssignmentNode.new(val[0], val[2], val[5]) }
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
    token = @tokens.shift

    return token unless token && token[0] == :COMMENT

    next_token
  end
