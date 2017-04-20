open Ocamlbuild_plugin

let () =
  dispatch begin function
  | After_rules ->
     ocaml_lib "src/SystemVerilog";
  | _ -> ()
  end
