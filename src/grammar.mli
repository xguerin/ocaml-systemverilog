module Literal : sig
  type t =
    | Int of int
    | String of string
    | Hex of string
    | Dec of string
    | Bin of string
    | Oct of string
  val to_s : t -> string
end

module Signing : sig
  type t =
    | Signed
    | Unsigned
  val to_s : t -> string
end

module IntegerVectorType : sig
  type t =
    | Bit
    | Logic
    | Reg
  val to_s : t -> string
end

module IntegerAtomType : sig
  type t =
    | Byte
    | Shortint
    | Int
    | Longint
    | Integer
    | Time
  val to_s : t -> string
end

module DataType : sig
  type t =
    | IntegerVectorType of IntegerVectorType.t * Signing.t option
    | IntegerAtomType of IntegerAtomType.t * Signing.t option
  val to_s : t -> string
end

module ParamAssignment : sig
  type t = string * Literal.t option
  val to_s : t -> string
end

module LocalParam : sig
  type t =
    | Implicit of ParamAssignment.t list
    | Typed of DataType.t * ParamAssignment.t list
  val to_s : t -> string
end

module PackageItem : sig
  type t =
    | Localparam of LocalParam.t
  val print : t -> unit
end

module Description : sig
  type t =
    | Package of string * PackageItem.t list
  val print : t -> unit
end
