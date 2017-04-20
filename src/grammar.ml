module Literal = struct
  type t = [%import: Grammar.Literal.t]

  let to_s = function
    | Int (d)    -> string_of_int d
    | String (s) -> s
    | Hex (h)    -> h
    | Dec (d)    -> d
    | Bin (b)    -> b
    | Oct (o)    -> o
end

module Signing = struct
  type t = [%import: Grammar.Signing.t]

  let to_s = function
    | Signed   -> "signed"
    | Unsigned -> "unsigned"
end

module IntegerVectorType = struct
  type t = [%import: Grammar.IntegerVectorType.t]

  let to_s = function
    | Bit   -> "bit"
    | Logic -> "logic"
    | Reg   -> "reg"
end

module IntegerAtomType = struct
  type t = [%import: Grammar.IntegerAtomType.t]

  let to_s = function
    | Byte     -> "byte"
    | Shortint -> "shortint"
    | Int      -> "int"
    | Longint  -> "longint"
    | Integer  -> "integer"
    | Time     -> "time"
end

module DataType = struct
  type t = [%import: Grammar.DataType.t]

  let to_s = function
    | IntegerVectorType (t, None)   -> IntegerVectorType.to_s t
    | IntegerVectorType (t, Some s) -> (IntegerVectorType.to_s t) ^ " " ^ (Signing.to_s s)
    | IntegerAtomType (t, None)     -> IntegerAtomType.to_s t
    | IntegerAtomType (t, Some s)   -> (IntegerAtomType.to_s t) ^ " " ^ (Signing.to_s s)
end

module ParamAssignment = struct
  type t = [%import: Grammar.ParamAssignment.t]

  let to_s = function
    | s, None   -> s
    | s, Some l -> s ^ " = " ^ (Literal.to_s l)
end

module LocalParam = struct
  type t = [%import: Grammar.LocalParam.t]

  let rec param_assignments_s = function
    | [] -> ""
    | [ e ] -> ParamAssignment.to_s e
    | hd :: tl -> (ParamAssignment.to_s hd) ^ ", " ^ (param_assignments_s tl)

  let to_s = function
    | Implicit (l) -> param_assignments_s l
    | Typed (t, l) -> (DataType.to_s t) ^ " " ^ (param_assignments_s l)
end

module PackageItem = struct
  type t = [%import: Grammar.PackageItem.t]

  let print = function
    | Localparam (l) ->
      Printf.printf "- LP: %s" (LocalParam.to_s l);
      print_newline ()
end

module Description = struct
  type t = [%import: Grammar.Description.t]

  let rec print_package_items = function
    | [] -> ()
    | hd :: tl -> PackageItem.print hd; print_package_items tl

  let print = function
    | Package (s, l) -> Printf.printf "Package: %s\n" s; print_package_items l
end

