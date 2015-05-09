exception Failed

let interpret dir query suffixes =
  let collect query =
    let cmd =
      Printf.sprintf "cd %s; git grep -l -w %s -- %s" dir query suffixes in
    let (res,code) = Common.cmd_to_list_and_status cmd in
    if code = Unix.WEXITED 0
    then res
    else raise Failed in
  try
    match List.map collect query with
      [] -> failwith "not possible"
    | x::xs ->
	let res = List.fold_left Common.inter_set x xs in
	List.map (function x -> dir^"/"^x) res
  with Failed -> []
