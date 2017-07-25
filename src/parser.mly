%token <string> ID
%token <int>    L_INT
%token <string> L_STRING
%token <string> L_HEX
%token <string> L_DEC
%token <string> L_BIN
%token <string> L_OCT
%token          PACKAGE
%token          ENDPACKAGE
%token          LOCALPARAM
%token          BIT
%token          LOGIC
%token          REG
%token          BYTE
%token          SHORTINT
%token          INT
%token          LONGINT
%token          INTEGER
%token          TIME
%token          SIGNED
%token          UNSIGNED
%token          EQUAL
%token          SEMICOLON
%token          COMMA
%token          EOF

%start <Grammar.Description.t option>  sv
%type  <Grammar.PackageItem.t>         package_item 
%type  <Grammar.LocalParam.t>          localparam
%type  <Grammar.ParamAssignment.t>     param_assignment
%type  <Grammar.DataType.t>            data_type
%type  <Grammar.IntegerVectorType.t>   integer_vector_type
%type  <Grammar.IntegerAtomType.t>     integer_atom_type
%type  <Grammar.Signing.t>             signing
%type  <Grammar.Literal.t>             literal
%%

sv:
  | p = package { Some p }
  | EOF { None}

package:
  | PACKAGE; id = ID; SEMICOLON; items = package_items; ENDPACKAGE { Grammar.Description.Package (id, items) }

package_items: e = rev_package_items { List.rev e };

rev_package_items:
  | (* empty *) { [] }
  | e = rev_package_items; p = package_item; SEMICOLON { p :: e }

package_item:
  | LOCALPARAM; p = localparam { Localparam p }

localparam:
  | p = param_assignments { Implicit p }
  | d = data_type; p = param_assignments { Typed (d, p) }

param_assignments: e = rev_param_assignments { List.rev e };

rev_param_assignments:
  | a = param_assignment { [ a ] }
  | e = rev_param_assignments; COMMA; a = param_assignment { a :: e }

param_assignment:
  | id = ID                     { (id, None)   }
  | id = ID; EQUAL; v = literal { (id, Some v) }

data_type:
  | i = integer_vector_type              { IntegerVectorType (i, None)   }
  | i = integer_vector_type; s = signing { IntegerVectorType (i, Some s) }
  | i = integer_atom_type                { IntegerAtomType (i, None)     }
  | i = integer_atom_type; s = signing   { IntegerAtomType (i, Some s)   }

integer_vector_type:
  | BIT   { Bit }
  | LOGIC { Logic }
  | REG   { Reg }

integer_atom_type:
  | BYTE     { Byte     }
  | SHORTINT { Shortint }
  | INT      { Int      }
  | LONGINT  { Longint  }
  | INTEGER  { Integer  }
  | TIME     { Time     }

signing:
  | SIGNED   { Signed   }
  | UNSIGNED { Unsigned }

literal:
  | i = L_INT    { Int i    }
  | s = L_STRING { String s }
  | h = L_HEX    { Hex h    }
  | d = L_DEC    { Dec d    }
  | b = L_BIN    { Bin b    }
  | o = L_OCT    { Oct o    }

